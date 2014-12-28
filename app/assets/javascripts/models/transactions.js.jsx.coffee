TransactionsListItem = React.createClass
  render: ->
    React.DOM.li({}, @props.transaction.name)

TransactionsList = React.createClass
  # Component's API method
  getInitialState: -> 
    search: ''

  setSearch: (event) ->
    @setState search: event.target.value  

  transactions: ->
    @props.transactions.filter( 
      (transaction) => transaction.name.indexOf(@state.search) > -1
    )

  render: ->
    # Wrapper that contains another components
    React.DOM.div({}, 
      @searchInput()
      @transactionsList()    
    )

  searchInput: ->
    React.DOM.input({
      name: 'search'
      onChange: @setSearch
      placeholder: 'Search...'
    })

  transactionsList: ->
    React.DOM.ul({}, [
      for transaction in @transactions()
        TransactionsListItem({transaction: transaction})
      ])
