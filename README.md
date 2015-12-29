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

src_a =
  a: 1
  b: 2
  c: 3
  d: 4

src_b =
  a: 3
  b: 4
  c: 5
  d: 6

src_c =
  e:
    e1:
      e11:
        e111: 6
      e12: 5
    e2: 8
  f: 'gg'
  g:
    g1: 'tt'
    g2: 'xx'

combiner [src_c, src_b, src_a]
.defineRule
  'three': ['b', 'e.e1.e11.e111', 'e.e1.e2.e3']
  'two': ['d', 'g.g1']

.merge()
# =>
# { a: 3,
#   c: 5,
#   e: { e1: { e11: {}, e12: 5 }, e2: 8 },
#   f: 'gg',
#   g: { g2: 'xx' },
#   three: 4,
#   two: 6 }
```

API
---

Class: `combiner`
-----------------

```coffee
# generate a combiner by a given list
combiner optionsList
```

+ `optionsList`: {Array(String|Object)}, default to be an empty array. Item can be object, alias (which pre-defined in `combiner.map`).

#### Priority
options combined in series of how they have been defined.

Basic Operation: `defineMapping`
--------------------------------

```coffee
combiner.defineMapping relationship
```

+ `relationship`: {Array(Object)}, extend mapping.

```coffee
relationship = [
  map_a: src1
  map_b: src2
]
```

Basic Operation: `merge`
------------------------

```coffee
combiner.merge optionsList, priori
```

+ `optionsList`: {Array(Object)}, default to be an empty array. Item must be object.
+ `priori`: {Boolean}, means whether overriding the option by this optionsList or not. Default to be `false`.

Advanced Operation: `defineRule`
--------------------------------

```coffee
combiner.defineRule rules
```

+ `rules`: {Object {alias: Array(String)}}, define the map set to tell how combiner recognize the fields.

#### Rules
Rules consist of lists which filter by groups. Groups are treated in the same priority. Each group contains the rules that have familiar semantic.

```coffee
rules =
  alias1: ['MYSQL_URL', 'database.mysql.host'] # group one
  alias2: ['MEMCACHED_PORT', 'cache.port'] # group two
  alias3: ['ADDRESS', 'URL', 'appUrl'] # group three
```
