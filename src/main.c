#include <stdio.h>
#include <unistd.h>
#include <yaml.h>

#include "version.h"

#ifdef DEBUG
  #define DEBUG_PRINT(...) do { fprintf(stderr, __VA_ARGS__); } while (0)
#else
  #define DEBUG_PRINT(...)
#endif

#ifdef DEBUG
static void print_event(yaml_event_t *event) {
  switch (event->type) {
    case YAML_NO_EVENT:
      DEBUG_PRINT("NO EVENT!\n");
      break;
    case YAML_STREAM_START_EVENT:
      DEBUG_PRINT("STREAM START: Encoding: %d\n", event->data.stream_start.encoding);
      break;
    case YAML_STREAM_END_EVENT:
      DEBUG_PRINT("STREAM END:\n");
      break;
    case YAML_DOCUMENT_START_EVENT:
      DEBUG_PRINT("DOCUMENT START:");
      if (event->data.document_start.version_directive) {
        DEBUG_PRINT("Version: %d.%d",
          event->data.document_start.version_directive->major,
          event->data.document_start.version_directive->minor);
      }
      DEBUG_PRINT("\n");
      break;
    case YAML_DOCUMENT_END_EVENT:
      DEBUG_PRINT("DOCUMENT END:\n");
      break;
    case YAML_SEQUENCE_START_EVENT:
      DEBUG_PRINT("SEQUENCE START: Style: %d\n", event->data.sequence_start.style);
      break;
    case YAML_SEQUENCE_END_EVENT:
      DEBUG_PRINT("SEQUENCE END:\n");
      break;
    case YAML_MAPPING_START_EVENT:
      DEBUG_PRINT("MAPPING START: Style: %d\n", event->data.mapping_start.style);
      break;
    case YAML_MAPPING_END_EVENT:
      DEBUG_PRINT("MAPPING END:\n");
      break;
    case YAML_ALIAS_EVENT:
      DEBUG_PRINT("ALIAS:\n");
      break;
    case YAML_SCALAR_EVENT:
      DEBUG_PRINT("SCALAR: Style: %d, Value: %s\n",
        event->data.scalar.style, event->data.scalar.value);
      break;
  }
}
#endif

#define STATE_SEQ 1
#define STATE_MAP 1<<1
#define STATE_VAL 1<<2

#define SEPARATOR '_'

static int flag_multiple_douments = 0;

static void yaml2bash_key(char *src, char **result) {
  int i, j;
  char *buf = (char *)malloc(sizeof(char) * strlen(src) + 1);
  for (i = 0, j = 0; i < strlen(src); i++) {
    if (src[i] == ' ') {
      buf[j++] = '_';
    } else if (src[i] == '-') {
      buf[j++] = '_';
    } else {
      buf[j++] = src[i];
    }
  }
  buf[j++] = '\0';
  *result = buf;
}

static void yaml2bash_value(char *src, char **result) {
  int i, j;
  char *buf = (char *)malloc(sizeof(char) * strlen(src) * 4 + 1);
  for (i = 0, j = 0; i < strlen(src); i++) {
    if (src[i] == '\a') {
      buf[j++] = '\\';
      buf[j++] = 'a';
    } else if (src[i] == '\b') {
      buf[j++] = '\\';
      buf[j++] = 'b';
    } else if (src[i] == '\t') {
      buf[j++] = '\\';
      buf[j++] = 't';
    } else if (src[i] == '\n') {
      buf[j++] = '\\';
      buf[j++] = 'n';
    } else if (src[i] == '\v') {
      buf[j++] = '\\';
      buf[j++] = 'v';
    } else if (src[i] == '\f') {
      buf[j++] = '\\';
      buf[j++] = 'f';
    } else if (src[i] == '\r') {
      buf[j++] = '\\';
      buf[j++] = 'r';
    } else if (src[i] == '\e') {
      buf[j++] = '\\';
      buf[j++] = 'e';
    } else if ((unsigned int)src[i] < 0x20) {
      buf[j++] = '\\';
      buf[j++] = 'x';
      sprintf(&buf[j++], "%02x", src[i]);
      j++;
    } else if (src[i] == '"') {
      buf[j++] = '\\';
      buf[j++] = src[i];
    } else if (src[i] == '$') {
      buf[j++] = '\\';
      buf[j++] = src[i];
    } else if (src[i] == '`') {
      buf[j++] = '\\';
      buf[j++] = src[i];
    } else if (src[i] == '\\') {
      buf[j++] = '\\';
      buf[j++] = '\\';
      buf[j++] = '\\';
      buf[j++] = src[i];
    } else {
      buf[j++] = src[i];
    }
  }
  buf[j++] = '\0';
  *result = buf;
}

static int yaml2bash_parse(yaml_parser_t *parser, char *prefix, int state) {
  yaml_event_t event;

  int finished = 0;
  int sequence = 0;

  char key[1024];
  char *value;

  if (state & STATE_SEQ) {
    sprintf(key, "%s%c%d", prefix, SEPARATOR, sequence);
  } else {
    sprintf(key, "%s", prefix);
  }

  while (!finished) {
    if (!yaml_parser_parse(parser, &event)) {
      fprintf(stderr, "An error occurred while the yaml file was parsed.\n");
      return 0;
    }

#ifdef DEBUG
    DEBUG_PRINT("--------------------\n");
    DEBUG_PRINT("STATE = [");
    if (state & STATE_SEQ) {
      DEBUG_PRINT("SEQ ");
    }
    if (state & STATE_MAP) {
      DEBUG_PRINT("MAP ");
    }
    if (state & STATE_VAL) {
      DEBUG_PRINT("VAL ");
    }
    DEBUG_PRINT("], PREFIX = %s, KEY = %s, SEQ = %d\n", prefix, key, sequence);
    print_event(&event);
#endif

    switch (event.type) {
      case YAML_NO_EVENT:
        yaml_event_delete(&event);
        return 0;
        break;
      case YAML_STREAM_START_EVENT:
        break;
      case YAML_STREAM_END_EVENT:
        finished = 1;
        break;
      case YAML_DOCUMENT_START_EVENT:
        if (flag_multiple_douments) {
          sprintf(key, "%s%c%d", prefix, SEPARATOR, sequence);
          printf("declare -A %s; %s[KEYS]+=\" %d\";\n", prefix, prefix, sequence);
          sequence++;
          if (!yaml2bash_parse(parser, key, 0)) {
            yaml_event_delete(&event);
            return 0;
          }
        }
        break;
      case YAML_DOCUMENT_END_EVENT:
        finished = 1;
        break;
      case YAML_SEQUENCE_START_EVENT:
        if (state & STATE_MAP) {
          state ^= STATE_VAL;
        }
        if (state & STATE_SEQ) {
          printf("declare -A %s; %s[KEYS]+=\" %d\";\n", prefix, prefix, sequence);
          sprintf(key, "%s%c%d", prefix, SEPARATOR, sequence);
          sequence++;
        }
        if (!yaml2bash_parse(parser, key, STATE_SEQ)) {
          yaml_event_delete(&event);
          return 0;
        }
        break;
      case YAML_SEQUENCE_END_EVENT:
        finished = 1;
        break;
      case YAML_MAPPING_START_EVENT:
        if (state & STATE_MAP) {
          state ^= STATE_VAL;
        }
        if (state & STATE_SEQ) {
          printf("declare -A %s; %s[KEYS]+=\" %d\";\n", prefix, prefix, sequence);
          sprintf(key, "%s%c%d", prefix, SEPARATOR, sequence);
          sequence++;
        }
        if (!yaml2bash_parse(parser, key, STATE_MAP)) {
          yaml_event_delete(&event);
          return 0;
        }
        break;
      case YAML_MAPPING_END_EVENT:
        finished = 1;
        break;
      case YAML_ALIAS_EVENT:
        if (state & STATE_MAP) {
          state ^= STATE_VAL;
        }
        if (state & STATE_SEQ) {
          printf("declare -A %s; %s[KEYS]+=\" %d\";\n", prefix, prefix, sequence);
          sequence++;
        }
        break;
      case YAML_SCALAR_EVENT:
        if ((state == 0) || (state & STATE_VAL)) {
          yaml2bash_value((char *)event.data.scalar.value, &value);
          printf("%s=\"%s\";\n", key, value);
          state ^= STATE_VAL;
        }
        else if (state & STATE_SEQ) {
          yaml2bash_value((char *)event.data.scalar.value, &value);
          printf("declare -A %s; %s[KEYS]+=\" %d\";\n", prefix, prefix, sequence);
          printf("%s_%d=\"%s\";\n", prefix, sequence, value);
          sequence++;
        } else {
          yaml2bash_key((char *)event.data.scalar.value, &value);
          printf("declare -A %s; %s[KEYS]+=\" %s\";\n", prefix, prefix, value);
          sprintf(key, "%s%c%s", prefix, SEPARATOR, value);
          state |= STATE_VAL;
        }

        free(value);
        break;
    }

    yaml_event_delete(&event);
  }

  return finished;
}

static void print_help(char **argv) {
  fprintf(stderr,
    "yaml2bash v%s\n"
    "\n"
    "Usage: %s [-m] [-p <prefix>] [<filename>] [-v] [-h]\n"
    "\n"
    "Options:\n"
    "    -m          : handle as a file contains multiple documents\n"
    "    -p <prefix> : specify a prefix for variables, or \"YAML\" by default\n"
    "    <filename>  : specify a YAML file to parse, or it will wait for stdin\n"
    "    -v          : show the current version and exit\n"
    "    -h          : show this help message and exit\n"
    ,
    VERSION, argv[0]);
}

int main(int argc, char **argv) {
  FILE *fh = NULL;
  char prefix[1024];
  yaml_parser_t parser;

  sprintf(prefix, "YAML");

  int opt;
  while ((opt = getopt(argc, argv, "vhmp:")) != -1) {
    switch (opt) {
      case 'v':
        fprintf(stderr, "yaml2bash v%s\n", VERSION);
        return 0;
      case 'h':
        print_help(argv);
        return 0;
      case 'm':
        flag_multiple_douments = 1;
        break;
      case 'p':
        sprintf(prefix, "%s", optarg);
        break;
      default:
        print_help(argv);
        return 1;
    }
  }

  if (argc > optind) {
    fh = fopen(argv[optind], "r");
    if (fh == NULL) {
      fprintf(stderr, "Failed to open a file: %s\n", argv[optind]);
      return 1;
    }
  } else {
    fh = stdin;
  }

  yaml_parser_initialize(&parser);

  yaml_parser_set_input_file(&parser, fh);

  if (!yaml2bash_parse(&parser, prefix, 0)) {
    yaml_parser_delete(&parser);
    fclose(fh);
    return 1;
  }

  yaml_parser_delete(&parser);
  fclose(fh);
  return 0;
}
