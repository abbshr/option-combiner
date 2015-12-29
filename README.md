option-combiner
---------------

auto-merge options.

Usage
-----

```coffee
combiner = require 'option-combiner'
configFile = require './conf/config'

combiner ['env', github: 'abbshr', gitlab: 'Lorem Ipsum', configFile]
.merge [PWD: '/root'], no

# => { ... }

combiner().merge()

# => {}
```

API
---

```coffee
# generate a combiner by a given list
combiner optionsList
```

+ `optionsList`: {Array}, default to be an empty array. Item can be object, alias (which pre-defined in `combiner.map`).
  
### Priority
options combined in series of how they have been defined.

```coffee
combiner.merge optionsList, priori
```

+ `optionsList`: {Array}, default to be an empty array. Item must be object.
+ `priori`: {Boolean}, means whether overriding the option by this optionsList or not. Default to be `true`.
