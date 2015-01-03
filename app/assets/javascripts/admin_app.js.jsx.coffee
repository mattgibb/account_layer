{div, p, h1} = React.DOM

React.initializeTouchEvents true

AdminApp = React.createClass
  getInitialState: ->
    page: 'Home'

  setPage: (page) ->
    @setState page: page

  records: [
    {category: 'Sporting Goods', price: '$49.99', stocked: true, name: 'Football'},
    {category: 'Sporting Goods', price: '$9.99', stocked: true, name: 'Baseball'},
    {category: 'Sporting Goods', price: '$29.99', stocked: false, name: 'Basketball'},
    {category: 'Electronics', price: '$99.99', stocked: true, name: 'iPod Touch'},
    {category: 'Electronics', price: '$399.99', stocked: false, name: 'iPhone 5'},
    {category: 'Electronics', price: '$199.99', stocked: true, name: 'Nexus 7'}
  ]
  render: ->
    div {},
      NavBar adminName: @props.adminName, page: @state.page, setPage: @setPage
      div className: 'container',
        div {},
          h1 {}, "The page is #{@state.page}"
          FilterableTable records: @records

@AdminApp = React.createFactory AdminApp
