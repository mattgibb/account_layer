{div} = React.DOM

FilterableTable = React.createClass
  mixins: [Backbone.React.Component.mixin]

  getInitialState: ->
    filterText: ''

  render: ->
    div {},
      AccountLayer.Views.Table records: @props.records,
      AccountLayer.Views.FilterBox filterText: @state.filterText, onUserInput: @handleUserInput

  handleUserInput: (filterText) ->
    @setState filterText: filterText

AccountLayer.Views.FilterableTable = React.createFactory FilterableTable
