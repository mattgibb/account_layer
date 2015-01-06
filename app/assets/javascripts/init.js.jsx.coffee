React.initializeTouchEvents true

$ ->
  root = document.getElementById 'app'
  collections = {}
  _.each AccountLayer.Collections, (constructor, name) ->
    collections[name] = new constructor

  app = AccountLayer.Views.AdminApp
    adminName: root.getAttribute 'data-admin-name'
    collection: collections

  React.render app, root
