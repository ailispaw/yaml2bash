# yaml2bash

Converts YAML to Bash variables

## Build

```bash
$ vagrant up
$ docker run --rm -v /vagrant/lib:/src yaml2bash make
```

## Usage

### yaml2bash binary

```bash
Usage: yaml2bash [-m] [-p <prefix>] [<filename>] [-v] [-h]

Options:
    -m          : handle as a file contains mutiple docuemtns
    -p <prefix> : specify a prefix for variables, or "YAML" by default
    <filename>  : specify a YAML file to parse, or it will wait for stdin
    -v          : show the current version and exit
    -h          : show this help message and exit
```

At a console;

```bash
$ ./lib/yaml2bash ./examples/test.yaml
$ cat ./examples/test.yaml | ./lib/yaml2bash
$ ./lib/yaml2bash -p PREFIX < ./examples/test.yaml
```

In a script;

```bash
#!/usr/bin/env bash

eval $(./lib/yaml2bash ./examples/test.yaml)

# To refer an individual variable
echo $YAML_hostname
echo $YAML_users_1_name
```

### yaml2bash.bash library

In a script;

```bash
#!/usr/bin/env bash

source ./lib/yaml2bash.bash

eval $(./lib/yaml2bash -m ./examples/test.yaml)

# To traverse YAML structure
traverse YAML
traverse YAML_0
traverse YAML_0_users

# To count chidren of an individual variable
count YAML
count YAML_0
count YAML_0_users
```
