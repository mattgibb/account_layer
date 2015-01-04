{div, table, thead, tbody, th, tr, td} = React.DOM

Table = React.createClass
  mixins: [Backbone.React.Component.mixin]

  headings: ->
    @props.records[0]
    some: "heading", another: "column"

  render: ->
    window.a = @props.records
    table className: 'table table-bordered table-hover table-striped',
      thead {},
        _.map @headings, (sortTitle, sortKey) =>
          th key: sortKey, sortTitle

      tbody {},
        _.map @props.records.models, (model) =>
          tr key: model.get('id'),
            td {}, "hello"

AccountLayer.Views.Table = React.createFactory Table
