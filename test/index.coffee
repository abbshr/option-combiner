combiner = require '../'

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

# console.log combiner([src_b, src_a, src_c]).merge()

ret = combiner [src_c, src_b, src_a]
ret.defineRule [
  ['b', 'e.e1.e11.e111', 'e.e1.e2.e3']
  ['d', 'g.g1']
]
# ret.merge()
console.log ret.merge()
