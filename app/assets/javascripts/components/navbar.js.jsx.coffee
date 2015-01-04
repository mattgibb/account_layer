{li, a} = React.DOM

NavBarItem = React.createClass
  classes: ->
    "active" if @props.active
  render: ->
    li {},
      a 
        href: "#"
        className: @classes()
        onClick: @props.onClick
        @props.children

NavBar = React.createClass
  setPage: (event) ->
    @props.setPage event.target.textContent

  pages: [
    'Home'
    'Accounts'
    'Transactions'
  ]

  createItem: (page) ->
    `<NavBarItem active={page == this.props.page}
                 onClick={this.setPage}
                 key={page}>{page}</NavBarItem>`

  render: ->
    `<nav className="navbar navbar-fixed-top navbar-inverse">
       <div className="container">
         <div className="navbar-header">
           <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
             <span className="sr-only">Toggle navigation</span>
             <span className="icon-bar"></span>
             <span className="icon-bar"></span>
             <span className="icon-bar"></span>
           </button>
           <a className="navbar-brand" href="#">Account Layer</a>
         </div>
         <div id="navbar" className="collapse navbar-collapse">
           <ul className="nav navbar-nav">
             {this.pages.map(this.createItem)}
           </ul>
           <ul className="nav navbar-nav navbar-right">
             <li><p className="admin-name">{this.props.adminName}</p></li>
             <li><a href="/signout">Sign Out</a></li>
           </ul>
         </div>
       </div>
     </nav>`

@NavBar = React.createFactory NavBar
