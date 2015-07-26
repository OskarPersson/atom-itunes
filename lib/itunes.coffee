iTunesView = require './itunes-view'

module.exports =
  config:
    showEqualizer:
      title: 'Show Equalizer'
      description: 'May cause window resize performance issues'
      type: 'boolean'
      default: true
    iTunesCheckInterval:
      title: 'iTunes Check Interval (ms)'
      description: 'How often to poll iTunes for track info'
      type: 'integer'
      default: 1500

  consumeStatusBar: (statusBar) ->
    @rdioView = new iTunesView(statusBar)

  deactivate: ->
    @itunesView.destroy()
