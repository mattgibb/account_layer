Table = React.createClass
  render: ->
    lastCategory = null
    rows = @props.records.map (record) ->
      `<Row record={record} key={record.id} />`
    `<table>
       <thead>
         <tr>
           <th>Name</th>
           <th>Price</th>
         </tr>
       </thead>
       <tbody>{rows}</tbody>
     </table>`

@Table = React.createFactory Table
