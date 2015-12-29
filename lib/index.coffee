class Combiner
  _relation:
    'env': process.env

  # generate merge series
  constructor: (src = []) ->
    @_rules = []
    @_map = new Map
    @lst = for item in src
      switch
        when item of @_relation then @_relation[item]
        when typeof item is 'object' then item
        else continue

  # merge options in priority
  # O(mn)
  merge: (opt = [{}], priori) ->
    lst = if priori then opt.concat @lst else @lst.concat opt

    # O(n)
    lst = lst.reduceRight (base, prioriEntry) =>
      Object.assign base, prioriEntry
    , {}

    # O(mn)
    @_applyRule lst, rule for rule in @_rules
    lst

  defineMapping: (relationship) ->
    Object.assign @_relation, newMapping for newMapping in relationship
    @_relation

  defineRule: (@_rules = []) ->
    this

  # apply rules in priority
  # e.g.
  # rule => ['MYSQL_URL', 'DATABASE_URL', 'database.mysql.host']
  # if 'MYSQL_URL' exist, then 'DATABASE_URL' and 'database.mysql.host' will be ignored.
  # O(nm) → O(n)
  _applyRule: (opts, rule) ->
    rule.reduceRight (field, prioriField) =>
      if ret = @_parseRule prioriField, opts
        # use map cache to reduce the key-query-phrase in revoking.
        @_map.set prioriField, ret
        @_revokeRule field, opts
        prioriField
      else
        field

  # e.g. 'database.mysql.host' => { database: { mysql: { host } } }
  # e.g. 'url' => 'url'
  # O(m) → O(1)
  _parseRule: (field, opts, revoke = off, seperator = '.') =>
    idx = field.indexOf seperator
    if ~idx
      token = field[...idx]
      if token of opts
        @_parseRule field[idx + 1..], opts[token], revoke, seperator
    else if field of opts
      delete opts[field] if revoke
      [opts, field]

  _revokeRule: (field, opts) =>
    if ref = @_map.get field
      delete ref[0][ref[1]]
      @_map.delete field
    else
      @_parseRule field, opts, on, '.'

module.exports = (src) ->
  new Combiner src
