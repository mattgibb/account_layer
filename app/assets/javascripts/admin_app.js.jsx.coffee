{div, p, h1} = React.DOM

AdminApp = React.createClass
  mixins: [Backbone.React.Component.mixin]

  getInitialState: ->
    page: 'Home'

  setPage: (page) ->
    @setState page: page

  componentDidMount: ->
    transactions = new AccountLayer.Collections.Transactions
    transactions.fetch().done ->
      setState

  render: ->
    div {},
      NavBar adminName: @props.adminName, page: @state.page, setPage: @setPage
      div className: 'container',
        div {},
          h1 {}, "The page is #{@state.page}"
          FilterableTable

@AdminApp = React.createFactory AdminApp
