#include <stdio.h>
#include <yaml.h>

#ifdef DEBUG
  #define DEBUG_PRINT(...) do { fprintf(stderr, __VA_ARGS__); } while (0)
#else
  #define DEBUG_PRINT(...)
#endif

#ifdef DEBUG
static void print_event(yaml_event_t *event) {
  switch (event->type) {
    case YAML_NO_EVENT:
      DEBUG_PRINT("No Event!\n");
      break;
    case YAML_STREAM_START_EVENT:
      DEBUG_PRINT("STREAM START: Encoding: %d\n", event->data.stream_start.encoding);
      break;
    case YAML_STREAM_END_EVENT:
      DEBUG_PRINT("STREAM END\n");
      break;
    case YAML_DOCUMENT_START_EVENT:
      DEBUG_PRINT("Start Document");
      if (event->data.document_start.version_directive) {
        DEBUG_PRINT(": Version: %d.%d",
          event->data.document_start.version_directive->major,
          event->data.document_start.version_directive->minor);
      }
      DEBUG_PRINT("\n");
      break;
    case YAML_DOCUMENT_END_EVENT:
      DEBUG_PRINT("End Document\n");
      break;
    case YAML_SEQUENCE_START_EVENT:
      DEBUG_PRINT("Start Sequence: Style: %d\n", event->data.sequence_start.style);
      break;
    case YAML_SEQUENCE_END_EVENT:
      DEBUG_PRINT("End Sequence\n");
      break;
    case YAML_MAPPING_START_EVENT:
      DEBUG_PRINT("Start Mapping Style: %d\n", event->data.mapping_start.style);
      break;
    case YAML_MAPPING_END_EVENT:
      DEBUG_PRINT("End Mapping\n");
      break;
    case YAML_ALIAS_EVENT:
      DEBUG_PRINT("Alias\n");
      break;
    case YAML_SCALAR_EVENT:
      DEBUG_PRINT("Scalar: Style: %d, Value: %s\n",
        event->data.scalar.style, event->data.scalar.value);
      break;
  }
}
#endif

#define STATE_SEQ 1
#define STATE_MAP 1<<1
#define STATE_VAL 1<<2

#define SEPARATOR '_'

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
    if (src[i] == '\n') {
      if (i != (strlen(src) -1)) {
        buf[j++] = '\\';
        buf[j++] = 'n';
      }
    } else if (src[i] == '"') {
      buf[j++] = '\\';
      buf[j++] = '"';
    } else if (src[i] == '\\') {
      buf[j++] = '\\';
      buf[j++] = '\\';
      buf[j++] = '\\';
      buf[j++] = '\\';
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
    printf("--------------------\n");
    printf("STATE = [");
    if (state & STATE_SEQ) {
      printf("SEQ ");
    }
    if (state & STATE_MAP) {
      printf("MAP ");
    }
    if (state & STATE_VAL) {
      printf("VAL ");
    }
    printf("], PREFIX = %s, KEY = %s, SEQ = %d\n", prefix, key, sequence);
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

int main(int argc, char **argv) {
  FILE *fh = NULL;
  char prefix[1024];
  yaml_parser_t parser;

  if (argc > 1) {
    if (argv[1][0] == '-') {
      fh = stdin;
    } else {
      fh = fopen(argv[1], "r");
      if (fh == NULL) {
        fprintf(stderr, "Failed to open file: %s\n", argv[1]);
        return 1;
      }
    }
  } else {
    fprintf(stderr, "Usage: %s (<filename>|-) [<prefix>]\n", argv[0]);
    return 1;
  }
  if (argc > 2) {
    sprintf(prefix, "%s", argv[2]);
  } else {
    sprintf(prefix, "YAML");
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
