exports.merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs

tap = (o, fn) -> fn(o); o


exports.filter = (table, keep) ->
  filtered = {}
  for key, value of table
    if key in keep then filtered[key] = value
  return filtered
