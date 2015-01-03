@NavBar = React.createClass
  getInitialState: ->
    page: 'Home'

  setPage: (event) ->
    alert event
    @setState page: event.target.id

  handleClick: (e) ->
    @setState
      page: e.target.textContent

  pages: [
    'Home'
    'Accounts'
    'Transactions'
  ]
  
  createItem:  (page) =>
    `<li onClick={this.handleClick} key={page}>{page}</li>`

  render: ->
    `<div>
       <ul>{this.pages.map(this.createItem)}</ul>
       <p>The page is {this.state.page}</p>
     </div>`
