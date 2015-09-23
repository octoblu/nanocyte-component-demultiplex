Demultiplex = require '../src/demultiplex'

describe 'Demultiplex', ->
  beforeEach ->
    @sut = new Demultiplex

  describe 'when called', ->
    beforeEach (done) ->
      @callback = sinon.spy(done)
      @sut.write message: {a: []}, config: {value: 'a'}, @callback

    it 'should have called done', ->
      expect(@callback).to.have.been.called

  describe 'when a single element array is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        while result = @sut.read()
          @results.push result

      @sut.write message: {foo: ['item']}, config: {value: 'foo'}

    it 'should emit one message with the item', ->
      expect(@results).to.include 'item'

  describe 'when a two element array is written', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        while result = @sut.read()
          @results.push result

      @sut.write message: {foo: ['item1', 'item2']}, config: {value: 'foo'}

    it 'should emit two messages, one for each item', ->
      expect(@results).to.include.same.members ['item1', 'item2']

  describe 'when the config value points to a different key', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        while result = @sut.read()
          @results.push result

      @sut.write message: {bar: ['item']}, config: {value: 'bar'}

    it 'should emit one message with the item', ->
      expect(@results).to.include 'item'

  describe 'when the config value points to a key not in the message', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        while result = @sut.read()
          @results.push result

      @sut.write message: {}, config: {value: 'bar'}

    it 'should do nothing', ->
      expect(@results).to.be.empty

  describe 'when the config value is not set', ->
    beforeEach (done) ->
      @sut.on 'end', done

      @results = []
      @sut.on 'readable', =>
        while result = @sut.read()
          @results.push result

      @sut.write message: {}, config: {}

    it 'should do nothing', ->
      expect(@results).to.be.empty
