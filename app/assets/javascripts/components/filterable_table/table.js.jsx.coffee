{div, table, thead, tbody, th, tr, td} = React.DOM

Table = React.createClass
  mixins: [Backbone.React.Component.mixin]

  headings: ->
    @props.records[0]
    some: "heading", another: "column"

  render: ->
    attributes = @props.records.attributes

    table className: 'table table-bordered table-hover table-striped table-condensed',
      thead {},
        tr {},
          _.map attributes, (attribute) =>
            th key: attribute, attribute

      tbody {},
        _.map @props.records.models, (model) =>
          tr key: model.get('id'), _.map attributes, (attribute) ->
            td {}, model.attributes[attribute]

AccountLayer.Views.Table = React.createFactory Table
