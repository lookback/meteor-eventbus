should()

describe 'EventBus', ->

  it 'should be exported', ->
    EventBus.should.exist

  it 'should be possible to create new instances (buses)', ->
    bus = EventBus()

    bus.should.be.an.object

  it 'should have a rich API', ->
    bus = EventBus()

    bus.should.respondTo 'dispatch'
    bus.should.respondTo 'add'
    bus.should.respondTo 'send'
    bus.should.respondTo 'emit'
    bus.should.respondTo 'trigger'

    bus.should.respondTo 'register'
    bus.should.respondTo 'on'

    bus.should.respondTo 'off'
    bus.should.respondTo 'deregister'
    bus.should.respondTo 'remove'

  # And its aliases.
  describe 'dispatch and register', ->

    beforeEach ->
      @bus = EventBus()
      @eventName = 'foo'
      @bus.register @eventName, spies.create 'listener'

    afterEach ->
      spies.restoreAll()

    it 'should dispatch an event and catch it', ->
      @bus.dispatch @eventName

      spies.listener.should.have.been.called

    it 'should be able to pass arbitrary arguments', ->
      @bus.dispatch @eventName, 'foo', {foo: 'bar'}, ['foo']

      spies.listener.should.have.been.calledWith 'foo', {foo: 'bar'}, ['foo']


  # And its aliases.
  describe '#deregister', ->

    it 'should be able to deregister all listeners from the bus', ->
      bus = EventBus()
      bus.register 'foo', spies.create 'listener1'
      bus.register 'foo', spies.create 'listener2'

      bus.dispatch 'foo'
      bus.deregister 'foo'
      bus.dispatch 'foo'

      spies.listener1.should.have.been.calledOnce
      spies.listener2.should.have.been.calledOnce

    it 'should be able to deregister a single listener from the bus', ->
      bus = EventBus()
      bus.register 'foo', spies.create 'listener'

      bus.dispatch 'foo'
      bus.deregister 'foo', spies.listener

      bus.dispatch 'foo'
      spies.listener.should.have.been.calledOnce
