{Transform} = require 'stream'
_ = require 'lodash'

class Demultiplex extends Transform
  constructor: ->
    super objectMode: true

  _transform: (envelope, enc, next) =>
    {config,message} = envelope

    _.each config.value, (value) =>
      @push value
      return

    @push null
    next()

module.exports = Demultiplex
