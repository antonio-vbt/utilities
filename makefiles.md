# Makefiles

## Variables

### Lazy set

    VARIABLE = value

Other variables that are mentioned inside *value* are only expanded recursively when *VARIABLE* is actually used.

E.g.
```
FOO = foo
VARIABLE = $(FOO)
FOO = bar

all:
# Output: bar
	@ echo $(VARIABLE)
```


### Immediate set

    VARIABLE := value

Variables that are mentioned inside *value* are expanded recursively the moment *VARIABLE* is set.

E.g.
```
FOO = foo
VARIABLE := $(FOO)
FOO = bar

all:
# Output: foo
	@ echo $(VARIABLE)
```


### Lazy set if absent

    VARIABLE ?= value

*VARIABLE* is set only if it doesn't have a value already. *VARIABLE* will be expanded only when it is used.

E.g.
```
VARIABLE_1 = foo

VARIABLE_1 ?= bar
VARIABLE_2 ?= bar

all:
# Output: foo
	@ echo $(VARIABLE_1)
# Output: bar
	@ echo $(VARIABLE_2)
```


### Append

    VARIABLE += value

Appends *value* to *VARIABLE* if it already has a value. Set it if it is empty.

E.g.
```
VARIABLE += foo
VARIABLE += bar

all:
# Output: foo bar
	@ echo $(VARIABLE)
```
