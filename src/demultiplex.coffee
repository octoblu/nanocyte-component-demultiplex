{Transform} = require 'stream'
_ = require 'lodash'

class Demultiplex extends Transform
  constructor: ->
    super objectMode: true
    @push = _.bind @push, @

  _transform: (envelope, enc, next) =>
    {config,message} = envelope
    items = message[config.value]

    _.each items, @push
    @push null
    next()

module.exports = Demultiplex
