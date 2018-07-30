

exports.filter = (table, keep) ->
  filtered = {}
  for key, value of table
    if key in keep then filtered[key] = value
  return filtered

exports.round = (v,n) ->
  d = Math.pow(10,n)
  Math.round(v*d)/d

exports.merge = merge = (basic, update) ->
  combined = merge_shallow basic, update
  for k, v of combined
    if typeof v == "object" and basic[k]? and update[k]?
      combined[k] = merge(basic[k], update[k])
  return combined
merge_shallow = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs
tap = (o, fn) -> fn(o); o
