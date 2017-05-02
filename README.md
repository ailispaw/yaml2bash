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
$ yaml2bash (<filename>]|-) [<prefix>]
```

At a console;

```bash
$ ./lib/yaml2bash ./examples/test.yaml
$ cat ./examples/test.yaml | ./lib/yaml2bash -
$ ./lib/yaml2bash - PREFIX < ./examples/test.yaml
```

In a script;

```bash
#!/usr/bin/env bash

eval $(./lib/yaml2bash ./examples/test.yaml)

# To refarence an individual variable
echo $YAML_hostname
echo $YAML_users_1_name
```

### yaml2bash.bash library

In a bash script;

```bash
#!/usr/bin/env bash

source ./lib/yaml2bash.bash

eval $(./lib/yaml2bash ./examples/test.yaml)

# To traverse YAML structure
traverse YAML
traverse YAML_users

# To count chidren of an individual variable
count YAML
count YAML_users
```
