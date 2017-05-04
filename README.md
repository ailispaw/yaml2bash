# yaml2bash

Converts YAML to Bash variables

## Usage

### yaml2bash binary

```bash
Usage: yaml2bash [-m] [-p <prefix>] [<filename>] [-v] [-h]

Options:
    -m          : handle as a file contains mutiple documents
    -p <prefix> : specify a prefix for variables, or "YAML" by default
    <filename>  : specify a YAML file to parse, or it will wait for stdin
    -v          : show the current version and exit
    -h          : show this help message and exit
```

At a console;

```bash
$ yaml2bash ./examples/test.yaml
$ cat ./examples/test.yaml | yaml2bash
$ yaml2bash -p PREFIX < ./examples/test.yaml
```

In a script;

```bash
#!/usr/bin/env bash
set -e

eval $(yaml2bash ./examples/test.yaml)
declare -p YAML >/dev/null

# To refer an individual variable
echo $YAML_hostname
echo $YAML_users_1_name
```

### yaml2bash.bash library

In a script;

```bash
#!/usr/bin/env bash
set -e

source ./lib/yaml2bash.bash

eval $(yaml2bash -m ./examples/test.yaml)
declare -p YAML >/dev/null

# To traverse YAML structure
traverse YAML

# To count chidren of an individual variable
count YAML
count YAML_0
count YAML_0_users
```

## Docker

You can use Docker to execute yaml2bash as well.

```bash
$ docker run -i --rm ailispaw/yaml2bash < ./examples/test.yaml
```

https://hub.docker.com/r/ailispaw/yaml2bash

## Caveats

- The converted variables work only with Bash version 4.
- It doesn't support YAML's Alias, Tag and Complex Mapping Key. ([#1](https://github.com/ailispaw/yaml2bash/issues/1))

## License

Copyright (c) 2017 A.I. &lt;ailis@paw.zone&gt;

Licensed under the GNU General Public License, version 2 (GPL-2.0)  
http://opensource.org/licenses/GPL-2.0
