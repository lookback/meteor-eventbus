Package.describe({
  name: 'lookback:eventbus',
  version: '0.1.0',
  summary: 'An event bus for Meteor.',
  git: 'http://github.com/lookback/meteor-eventbus'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.4.2');

  api.use([
    'coffeescript',
    'check'
  ]);

  api.addFiles('eventbus.coffee');
  api.export('EventBus');
});

Package.onTest(function(api) {
  api.use([
    'coffeescript',
    'mike:mocha-package',
    'practicalmeteor:chai',
    'practicalmeteor:sinon',
    'respondly:test-reporter',
    'lookback:eventbus'
  ]);

  api.addFiles([
    'spec/eventbus-spec.coffee'
  ]);
});
