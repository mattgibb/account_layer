React.initializeTouchEvents true

$ ->
  root = document.getElementById 'app'
  app = AdminApp
    adminName: root.getAttribute 'data-admin-name'
    collection:
      transactions: new AccountLayer.Collections.Transactions

  React.render app, root
