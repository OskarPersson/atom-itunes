iTunesView = require './itunes-view'

module.exports =
  config:
    showEqualizer:
      title: 'Show Equalizer'
      description: 'May cause window resize performance issues & higher CPU.'
      type: 'boolean'
      default: true
    showNotes:
      title: 'Show Notes'
      description: 'Neatly delineate your status bar item with musical notation'
      type: 'boolean'
      default: false
    cycleTrackInfo:
      title: 'Cycle Track Info'
      description: 'Cycle through track, artist and album (in that order)'
      type: 'boolean'
      default: false
    itunesRefreshInterval:
      title: 'iTunes Refresh Interval (ms)'
      description: 'How often to poll iTunes for track info (ms)'
      type: 'integer'
      default: 1500

  consumeStatusBar: (statusBar) ->
    @rdioView = new iTunesView(statusBar)

  deactivate: ->
    @itunesView.destroy()
