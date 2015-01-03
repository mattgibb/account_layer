{div, table, thead, tbody, th, tr, td} = React.DOM

FilterableTable = React.createClass
  mixins: [Backbone.React.Component.mixin]

  getInitialState: ->
    filterText: ''

  render: ->
    table className: 'table table-bordered table-hover table-striped',
      thead {},
        _.map @props.sortTypes, (sortTitle, sortKey) =>
          th key: sortKey, sortTitle

      tbody {},
        _.map @getCollection(), (model) =>
          tr key: model.get('id'),
            @f
  render: ->
    div {},
      Table records: @props.records,
      FilterBox filterText: @state.filterText, onUserInput: @handleUserInput

  handleUserInput: (filterText) ->
    @setState filterText: filterText

@FilterableTable = React.createFactory FilterableTable
