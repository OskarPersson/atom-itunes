iTunesView = require './itunes-view'

module.exports =
  config:
    showEqualizer:
      title: 'Show Equalizer'
      description: 'May cause window resize performance issues'
      type: 'boolean'
      default: true

  consumeStatusBar: (statusBar) ->
    @rdioView = new iTunesView(statusBar)

  deactivate: ->
    @itunesView.destroy()
