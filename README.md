# yaml2bash

Converts YAML into Bash Script

## Usage

```
Usage: yaml2bash [-m] [-p <prefix>] [<filename>] [-v] [-h]

Options:
    -m          : handle as a file contains multiple documents
    -p <prefix> : specify a prefix for variables, or "Y2B" by default
    <filename>  : specify a YAML file to parse, or it will wait for stdin
    -v          : show the current version and exit
    -h          : show this help message and exit
```

In a bash script;

```bash
#!/usr/bin/env bash
set -e

eval $(yaml2bash ./test/test.yaml)
declare -p Y2B >/dev/null

# To refer an individual variable
echo $Y2B_hostname
y2b_value Y2B[hostname]
echo $Y2B_users_1_name
y2b_value Y2B[users][1][name]

# To traverse YAML structure
y2b_traverse Y2B

# To count chidren of an individual variable
y2b_count Y2B
y2b_count Y2B[users]

# To retrieve indexes of an array or keys of a mapping
y2b_keys Y2B
y2b_keys Y2B[users]

# In addition,
# To convert YAML into JSON
y2b_json Y2B
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
