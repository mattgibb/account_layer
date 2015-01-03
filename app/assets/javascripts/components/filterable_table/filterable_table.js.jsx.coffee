@FilterableTable = React.createClass
  getInitialState: ->
    filterText: ''
  render: ->
    `<div>
       <FilterBox
         filterText={this.state.filterText}
         onUserInput={this.handleUserInput}
       />
       <Table records={this.props.records} />
     </div>`

  handleUserInput: (filterText) ->
    @setState filterText: filterText


