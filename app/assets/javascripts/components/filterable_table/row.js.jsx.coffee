Row = React.createClass
  render: ->
    `<tr>
       <td>{this.props.record.name}</td>
     </tr>`

@Row = React.createFactory Row
