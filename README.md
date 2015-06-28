# Event Bus for Meteor

Reactivity in all its glory, but sometimes you just need a plain old event bus.

## Installation

```
meteor add lookback:eventbus
```

This package runs both on the server and client.

## API

Create bus objects (preferrably globals) by calling the exported `EventBus` function:

```js
Bus = EventBus();
```

Three methods are exposed along with many aliases, matching your preference:

### `dispatch`

*Aliases:* `add`, `send`, `emit`, `trigger`
  
```js
dispatch(event:String, [data...]);
```
  
Trigger an event and sends it off to the bus. Call with the event name and as many arguments with as many types as you want:
  
```js
Bus.dispatch('MyEvent', 'Important info string', [1, 2], {foo: 'bar'});
```

### `register`

*Aliases:* `on`

```js
register(event:String, handler:Function);
```

Register a listener on the bus and handle it with a handler function. The data you sent (if any) in `dispatch` will be available as arguments to the handler.

```js
Bus.register('MyEvent', function(str, arr, obj) {
    console.log(str);
    // => 'Important info string'
    console.log(arr);
    // => [1, 2]
    console.log(obj);
    // => {foo: 'bar'}
});
```

### `remove`

*Aliases:* `off`, `deregister`

```js
remove(event:String, [handler:Function]);
```

Stop listening to `event` completely, or remove a single handler only.

```js
// Remove specialHandler only.
Bus.remove('MyEvent', specialHandler);

// Remove all listeners to 'MyEvent'.
Bus.remove('MyEvent');
```

## Sample usage

```js
// In some init file.
Bus = EventBus();
```
```js
// Somewhere else. 
Meteor.methods({
  addPost: function(title, text) {
    check(title, String);
    check(text, String);

    var post = {
      title: title,
      text: text,
      author: Meteor.userId()
    };

    Posts.insert(post, function(err, postId) {
      if(!err) {
        // Add the post id and send off to bus!
        Bus.dispatch('posts/new', _.extend(post, {_id: postId}));
      }
    });
  }
});
```
```js
// Somewhere completely else (in a notification-center.js file perhaps?)

Bus.register('posts/new', function(post) {
  check(post, {
    _id: String,
    title: String,
    text: String,
    author: String
  });

  // Send email to subscribers.
  var subscribers = Posts.getSubscribers(post._id);
  EmailNotifications.sendSubscriptionEmail(subscribers, post);

  // Perhaps some analytics tracking?
  Analytics.track('New Post', post._id);

  // In-app notifications?
  Notifications.newPost(post._id);

  // ..
});
```

## Tests

Run tests with:

```bash
make test
```

Or check them out in browser on `localhost:5000`:

```bash
meteor test-packages --port 5000 --driver-package respondly:test-reporter ./
```

***

Made by [Lookback](http://github.com/lookback).
