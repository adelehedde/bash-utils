# Bash-Utils
> Bash utility functions

## Overview

Bash is a powerful command language.  
It is a great tool for automatizing processes out of the box by creating a script.  
This project intents to make your scripts more readable by providing you useful utility functions.
  
Let's say you want to read a property file many times in your script.  
You could pipe each time many commands like `grep` or `sed` to get what you are looking for. It would make your script a bit cumbersome.  
You could use this function instead :  
```
property=$(property::get "property-key" "file.properties") 
```

##### Bash Exit Codes

As you probably know, your script does not necessarily stop when your command fails.  
That's problematic because it can falsely report successful executions and/or it can trigger actions that are not supposed to be triggered in case of failure ...   

You could use the **Bash Strict Mode** as mentioned here : [Unofficial Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)  
However I personally find that there is always a case that is not working as expected.
That is why functions of this project generally return an exit code in case of failure. It is up to you to handle them ... 

## How to use

##### Import functions in your script
```
#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/properties/properties.sh

logger::info "Running my awesome script"
property=$(properties::get "property-key" "/<path>/script.properties") || { 
  logger::error "Error while reading property"
  exit 1
}

exit 0
```

##### Run it
```
# By setting BASH_UTILS_HOME environment variable 
BASH_UTILS_HOME=<path_to_bash_utils_project> bash <script.sh>
# Using Launcher
bash bash_utils/launcher.sh <script.sh>
# Using Launcher with debug mode
XTRACE=true bash bash_utils/launcher.sh <script.sh>
```

## Unit testing

Here is a proposal for unit testing in Bash.  
Like most famous libraries, you are able to set a context before and/or after each test.

```
#!/bin/bash

source "$BASH_UTILS_HOME"/test/unit_test.sh

# Set up your tests
# unit_test::before_all
# unit_test::after_all
# unit_test::before_each
# unit_test::after_each

unit_test::before_all() {
  echo "Some data" > data.txt
}

# test::<test_name>
test::should_print_data_txt() {
  cat data.txt
}

# Execute your tests
unit_test::run
```

## Docker

```
docker build -t bash-utils .

# Run your script
docker run -it --rm -v <local_script_directory>/my_dir:/opt/my_dir bash-utils bash
BASH_UTILS_HOME=/opt/bash-utils bash my_dir/my_script.sh 
# Unit Testing
docker run -it --rm -v <local_project_path>/bash-utils/test:/opt/bash-utils/test bash-utils bash
BASH_UTILS_HOME=/opt/bash-utils bash test/<script.sh>
```

# Links

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck Script Analysis Tool](https://www.shellcheck.net/)
 