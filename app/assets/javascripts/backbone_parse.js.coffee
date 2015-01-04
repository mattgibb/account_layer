Backbone.Collection.prototype.parse = (resp, options) ->
  @attributes = resp.attributes
  resp.models
