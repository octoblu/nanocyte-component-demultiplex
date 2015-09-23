{Transform} = require 'stream'
_ = require 'lodash'

class Demultiplex extends Transform
  constructor: ->
    super objectMode: true
    @push = _.bind @push, @

  _transform: (envelope, enc, next) =>
    {config,message} = envelope

    _.each config.value, @push
    @push null
    next()

module.exports = Demultiplex
