Rule = require './rule'
{resolve, relation} = require './src-resolver'

class Combiner extends Rule

  # generate merge series
  constructor: (srcs = []) ->
    super srcs
    @lst = resolve srcs

  # merge options in priority
  # O(mn)
  merge: (opt = [{}], priori) ->
    lst = if priori then opt.concat @lst else @lst.concat opt

    # O(n)
    lst = lst.reduceRight (base, prioriEntry) =>
      Object.assign base, prioriEntry
    , {}

    # O(mn)
    @applyRule lst, alias, ruleSet for alias, ruleSet of @_rules
    lst

  defineMapping: (relationship) ->
    Object.assign relation, newMapping for newMapping in relationship
    relation

  defineRule: (@_rules = {}) ->
    this

module.exports = (srcs) ->
  new Combiner srcs
