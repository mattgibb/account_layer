TransactionList = React.createClass
  mixins: [Backbone.React.Component.mixin]

  render: ->
    div className: 'model-list',
      @getCollection().map (model) ->
        div className: 'well',
          h1 {}, model.get('title')
          p {}, model.get('body')
          
AccountLayer.Views.TransactionList = React.createFactory TransactionList
