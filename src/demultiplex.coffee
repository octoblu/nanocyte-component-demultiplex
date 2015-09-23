ReturnValue = require 'nanocyte-component-return-value'

class Demultiplex extends ReturnValue
  onEnvelope: (envelope) =>
    return envelope.message

module.exports = Demultiplex
