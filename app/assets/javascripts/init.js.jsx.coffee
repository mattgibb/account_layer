React.initializeTouchEvents true

$ ->
  root = document.getElementById 'app'
  adminName = root.getAttribute 'data-admin-name'
  React.render AdminApp(adminName: adminName), root
