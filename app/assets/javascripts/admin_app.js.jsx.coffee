{div, p, h1} = React.DOM

AdminApp = React.createClass
  mixins: [Backbone.React.Component.mixin]

  getInitialState: ->
    page: 'Home'

  table: ->
    records = @getCollection()[@state.page.toLowerCase()]
    AccountLayer.Views.FilterableTable records: records if records

  setPage: (newPage) ->
    @getCollection()[newPage.toLowerCase()]?.fetch()
    @setState page: newPage

  # componentDidMount: @fetchRecords

  render: ->
    div {},
      AccountLayer.Views.NavBar adminName: @props.adminName, page: @state.page, setPage: @setPage
      div className: 'container',
        div {},
          h1 {}, "The page is #{@state.page}"
          @table()

@AdminApp = React.createFactory AdminApp
