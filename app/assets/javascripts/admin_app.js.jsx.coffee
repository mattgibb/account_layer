{div, p, h1} = React.DOM

AdminApp = React.createClass
  mixins: [Backbone.React.Component.mixin]

  getInitialState: ->
    page: 'Home'

  content: ->
    records = @getCollection()[@state.page]

    div {},
      h1 {}, "The page is #{@state.page}"
      AccountLayer.Views.FilterableTable records: records if records
      2 if @state.page is 'BankStatement'

  setPage: (newPage) ->
    @getCollection()[newPage]?.fetch()
    @setState page: newPage

  render: ->
    div {},
      AccountLayer.Views.NavBar adminName: @props.adminName, page: @state.page, setPage: @setPage
      div className: 'container', @content()

AccountLayer.Views.AdminApp = React.createFactory AdminApp
