$.facebox.settings.closeImage = '/assets/closelabel.png'
$.facebox.settings.loadingImage = '/assets/loading.gif'

$ ->
  window.FAYE_CLIENT = new Faye.Client('/faye')
