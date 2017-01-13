{Transform} = require 'stream'
_ = require 'lodash'

class Demultiplex extends Transform
  constructor: ->
    super objectMode: true

  _transform: (envelope, enc, next) =>
    {config,message} = envelope
    { value } = config

    return @emit 'error', new Error 'Cannot demultiplex over this value' unless _.isArray(value) || _.isPlainObject(value)

    _.each value, (v) =>
      @push v
      return

    @push null
    next()

module.exports = Demultiplex
