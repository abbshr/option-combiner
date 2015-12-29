class Combiner
  map: 
    'env': process.env
    
  constructor: (src = []) ->
    @lst = for item in src
      switch
        when item of @map then @map[item]
        when typeof item is 'object' then item
        else continue
  
  merge: (opt = [{}], priori = yes) ->
    lst = if priori then opt.concat @lst else @lst.concat opt
    
    lst.reduceRight (base, prioriEntry) ->
      Object.assign base, prioriEntry
    , {}

module.exports = (src) ->
  new Combiner src