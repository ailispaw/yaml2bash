# yaml2bash

Converts YAML to Bash variables

## Usage

### yaml2bash binary

```
Usage: yaml2bash [-m] [-p <prefix>] [<filename>] [-v] [-h]

Options:
    -m          : handle as a file contains multiple documents
    -p <prefix> : specify a prefix for variables, or "Y2B" by default
    <filename>  : specify a YAML file to parse, or it will wait for stdin
    -v          : show the current version and exit
    -h          : show this help message and exit
```

At a console;

```bash
$ yaml2bash ./test/test.yaml
$ cat ./test/test.yaml | yaml2bash
$ yaml2bash -p PREFIX < ./test/test.yaml
```

In a script;

```bash
#!/usr/bin/env bash
set -e

eval $(yaml2bash ./test/test.yaml)
declare -p Y2B >/dev/null

# To refer an individual variable
echo $Y2B_hostname
echo $Y2B_users_1_name
```

### yaml2bash.bash library

In a script;

```bash
#!/usr/bin/env bash
set -e

source ./lib/yaml2bash.bash

eval $(yaml2bash -m ./test/test.yaml)
declare -p Y2B >/dev/null

# To traverse Y2B structure
traverse Y2B

# To count chidren of an individual variable
count Y2B
count Y2B_0
count Y2B_0_users
```

## Docker

You can use Docker to execute yaml2bash as well.

```bash
$ docker run -i --rm ailispaw/yaml2bash < ./test/test.yaml
```

https://hub.docker.com/r/ailispaw/yaml2bash

## Caveats

- The converted variables work only with Bash version 4.
- It doesn't support YAML's Alias, Tag and Complex Mapping Key. ([#1](https://github.com/ailispaw/yaml2bash/issues/1))

## Special Thanks to

It's inspired by the following projects.

- https://github.com/clearlinux/micro-config-drive
- https://johnlane.ie/yay-use-yaml-in-bash-scripts.html

## License

Copyright (c) 2017 A.I. &lt;ailis@paw.zone&gt;

Licensed under the GNU General Public License, version 2 (GPL-2.0)  
http://opensource.org/licenses/GPL-2.0
