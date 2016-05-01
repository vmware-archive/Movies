# Movies

Here's a simple example of an iOS app written in Swift which connects to an API.

Also, there are tests.

## Setting up for Development

There are two parts here: 1) the iOS app, and 2) an Express API server.

### Starting the API server

The API server depends on [NodeJS](https://nodejs.org). Go install that if you don't already have the newest version (6.0.0 or above) on your machine.

Then run the following commands from the root of the repository:

```
$ cd api-server
$ npm install
$ npm start
```

This will start a server on port 8080.

### Building the iOS app

To manage the iOS app's dependencies, we use [Carthage](https://github.com/Carthage/Carthage). If you don't already have the newest version (0.16.2 or above), go install it.

Next, run the following commands from the root of repository:

```
$ cd ios-client
$ make bootstrap
```

This will checkout the app's dependencies and compile them for iOS. Note that we use `make` to manage the iOS app.
