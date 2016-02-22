_           = require 'lodash'
Demultiplex = require '../src/demultiplex'

describe 'Demultiplex', ->
  beforeEach ->
    @sut = new Demultiplex

  describe 'when called', ->
    beforeEach (done) ->
      @callback = sinon.spy(done)
      @sut.write config: {value: []}, @callback

    it 'should have called done', ->
      expect(@callback).to.have.been.called

  describe 'when a single element array is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {value: ['item']}

    it 'should emit one message with the item', ->
      expect(@results).to.include 'item'

  describe 'when a two element array is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {value: ['item1', 'item2']}

    it 'should emit two messages, one for each item', ->
      expect(@results).to.include.same.members ['item1', 'item2']

  describe 'when a 100 element array is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {value: _.times(100)}

    it 'should emit 100 messages, one for each item', ->
      expect(@results).to.deep.equal _.times(100)

  describe 'when a 0 element is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {value: [0]}

    it 'should emit 0 element, one for each item', ->
      expect(@results).to.deep.equal [0]

  describe 'when a false element is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {value: [false]}

    it 'should emit false element, one for each item', ->
      expect(@results).to.deep.equal [false]

  describe 'when the config value doesn\'t exist', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        until (result = @sut.read()) == null
          @results.push result

      @sut.write config: {}

    it 'should do nothing', ->
      expect(@results).to.be.empty
