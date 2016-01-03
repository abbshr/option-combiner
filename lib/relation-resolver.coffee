{join} = require 'path'
dirname = __dirname

exports.resolve = (srcs) =>
  for item in srcs
    switch
      when item of @relation then @relation[item]
      when typeof item is 'object' then item
      else
        try
          require join dirname, item
        catch
          continue

exports.relation =
  'env': process.env

exports.setDirname = (dir = __dirname) ->
  dirname = dir
