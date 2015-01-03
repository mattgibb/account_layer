FilterBox = React.createClass
  handleChange: ->
    console.log "changed"
    @props.onUserInput(@refs.filterTextInput.getDOMNode().value)
  render: ->
    `<form>
       <input
         type="text"
         value={this.props.filterText}
         ref="filterTextInput"
         onChange={this.handleChange}
         placeholder="Search..." />
       <p>
         <input type="checkbox" />
         {' '}
         Only show products in stock
       </p>
     </form>`

@FilterBox = React.createFactory FilterBox
