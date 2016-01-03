class Rule

  constructor: (args) ->
    @_rules = {}
    @_map = new Map

  # apply rules in priority
  # e.g.
  # rule => ['MYSQL_URL', 'DATABASE_URL', 'database.mysql.host']
  # if 'MYSQL_URL' exist, then 'DATABASE_URL' and 'database.mysql.host' will be ignored.
  # O(nm) → O(n)
  applyRule: (opts, alias, rule) ->
    field = rule.reduceRight (field, prioriField) =>
      if ret = @parseRule prioriField, opts
        # use map cache to reduce the key-query-phrase in revoking.
        @_map.set prioriField, ret
        @revokeRule field, opts
        prioriField
      else
        field

    if ref = @retrieveRef field, opts
      val = ref[0][ref[1]]
      @revokeRule field, opts
      @makeAlias alias, val, opts

  makeAlias: (alias, val, opts, seperator = '.') =>
    idx = alias.indexOf seperator
    if ~idx
      token = alias[...idx]
      opts[token] = {} unless typeof opts[token] is 'object'

      @makeAlias alias[idx + 1..], val, opts[token], seperator
    else
      opts[alias] = val

  # e.g. 'database.mysql.host' => { database: { mysql: { host } } }
  # e.g. 'url' => 'url'
  # O(m) → O(1)
  parseRule: (field, opts, seperator = '.') =>
    idx = field.indexOf seperator
    if ~idx
      token = field[...idx]
      if token of opts
        @parseRule field[idx + 1..], opts[token], seperator
    else if field of opts
      # delete opts[field] if revoke
      [opts, field]

  retrieveRef: (field, opts) ->
    @_map.get(field) ? @parseRule field, opts

  revokeRule: (field, opts) ->
    if ref = @retrieveRef field, opts
      delete ref[0][ref[1]]
      @_map.delete field

module.exports = Rule
