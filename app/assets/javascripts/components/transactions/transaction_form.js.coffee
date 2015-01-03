TransactionForm = React.createClass
  mixins: [Backbone.React.Component.mixin]

  submitForm: ->
    title = @refs.postTitle.getDomNode().value
    body  = @refs.postBody.getDomNode().value

    if title.trim().length is 0 or body.trim().length is 0
      alert 'Title and body cannot be blank.'
    else
      @getCollection().create new AccountLayer.Models.Transaction(title: title, body: body),
        wait: true
        at: 0
        success: (model, response) ->
          console.log 'Success'
        error: (model, response) ->
          console.log 'Error'

      @refs.postTitle.getDomNode().value = ''
      @refs.postBody.getDomNode().value  = ''


  render: ->
    div className: 'panel panel-default',
      div className: 'panel-heading', 'Create transaction'
      div className: 'panel-body',
        form classname: 'post-form',
          div className: 'form-group',
            label {}, 'Title'
            input ref: 'trasactionTitle', className: 'form-control', type: 'text', placeholder: 'Enter title...'
          div className: 'form-group',
            label {}, 'body'
            input ref: 'postBody', className: 'form-control', type: 'text', placeholder: 'Enter body...'
          a onClick: @submitForm, className: 'btn btn-primary', 'Create transaction'


AccountLayer.Views.TransactionForm = React.createFactory TransactionForm
