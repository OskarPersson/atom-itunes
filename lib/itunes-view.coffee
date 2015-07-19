{View} = require 'atom-space-pen-views'
itunesDesktop = require './itunes-desktop'

module.exports =
class itunesView extends View
  @content: ->
    @div class: 'itunes', =>
      @div outlet: 'container', class: 'itunes-container inline-block', =>
        @span outlet: 'soundBars', class: 'itunes-sound-bars', =>
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'

        @a outlet: 'currentlyPlaying', href: 'javascript:',''

  initialize: (statusBar) ->
    @statusBar = statusBar
    @currentTrack = {}
    @currentState = null
    @initiated = false
    @itunesDesktop = new itunesDesktop

    @addCommands()
    @attach()

  destroy: ->
    @detach()

  # Commands
  addCommands: ->
    # Defaults
    for command in itunesDesktop.COMMANDS
      do (command) =>
        atom.commands.add 'atom-workspace', "itunes:#{command.name}", => @itunesDesktop[command.name]()

    # Open current track with iTunes.app
    atom.commands.add 'atom-workspace', 'itunes:open-current-track', => @openWithitunes()

  # Attach the view to the farthest right of the status bar
  attach: =>
    @statusBarTile = @statusBar.addRightTile(item: this, priority: -1001)

    # Navigate to current track inside itunes
    @currentlyPlaying.on 'click', (e) =>
      @itunesDesktop.openWindow()

    # Toggle equalizer on config change
    atom.config.observe 'atom-itunes.showEqualizer', (value) =>
      @toggleEqualizer(value)

  toggleEqualizer: (show) ->
    if show
      @soundBars.removeAttr('data-hidden')
    else
      @soundBars.attr('data-hidden', true)

  attached: =>
    setInterval =>
      @itunesDesktop.currentState (state) =>
        if state isnt @currentState
          @currentState = state
          @soundBars.attr('data-state', state)

        # iTunes is closed
        if state is undefined
          if @initiated
            @initiated = false
            @currentTrack = {}
            @container.removeAttr('data-initiated')
          return

        # iTunes is paused, but we know about the current track
        return if state is 'paused' and @initiated

        # Get current track data
        @itunesDesktop.currentlyPlaying (data) =>
          return unless data.artist and data.track
          return if data.artist is @currentTrack.artist and data.track is @currentTrack.track
          @currentlyPlaying.text "#{data.artist} - #{data.track}"
          @currentTrack = data

          # Display container when hidden
          return if @initiated
          @initiated = true
          @container.attr('data-initiated', true)
    , 1500
