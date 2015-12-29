class Combiner
  _map: 
    'env': process.env
  
  # generate merge series
  constructor: (src = []) ->
    @lst = for item in src
      switch
        when item of @_map then @_map[item]
        when typeof item is 'object' then item
        else continue
  
  # merge options in priority
  merge: (opt = [{}], priori) ->
    lst = if priori then opt.concat @lst else @lst.concat opt
    
    lst.reduceRight (base, prioriEntry) =>
      Object.assign base, prioriEntry
    , {}
    
    @_applyRule lst, rule for rule in @_rules
      
  defineMapping: (relationship) ->
    Object.assign @_map, newMapping for newMapping in relationship
    
  defineRule: (@_rules = []) ->
    this
  
  # apply rules in priority
  # e.g.
  # rule => ['MYSQL_URL', 'DATABASE_URL', 'database.mysql.host']
  # if 'MYSQL_URL' exist, then 'DATABASE_URL' and 'database.mysql.host' will be ignored.
  _applyRule: (opts, rule) ->
    rule.reduceRight (field, prioriField) =>
      if prioriField? and prioriField = @_parseRule prioriField, opts
        delete opts[field]
        prioriField
      else
        field
  
  # e.g. 'database.mysql.host' => { database: { mysql: { host } } }
  # e.g. 'url' => 'url'
  _parseRule: (field, opts, seperator = '.') =>
    if i = ~field.indexOf seperator
      token = field[..i]
      
      if token in opts
        if @_parseRule field[i + 1..], opts[token], seperator
          token
    else if field in opts
      field
    
      
module.exports = (src) ->
  new Combiner src