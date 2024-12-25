<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# dart_logging_abstraction

An logging abstraction package for logging.

## Features

Provide logging interfaces, common objects and with out any implementations.

## Getting started

Install this package, use other logging package implementation adapt to this package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
/// An example console logger implementation of [ILogger]
class ConsoleLogger implements ILogger {
  @override
  final String name;
  final LogLevel _minLevel;

  const ConsoleLogger({required this.name, required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  bool isEnabled(LogLevel logLevel) => logLevel >= _minLevel;

  @override
  void log(message, LogLevel logLevel, {Object? error, StackTrace? stackTrace}) {
    if (!isEnabled(logLevel)) {
      return;
    }
    final writer = StringBuffer();
    writer.writeln("[${logLevel.name}] ${DateTime.now()} [$name]");
    writer.writeln(message);
    if (error != null) {
      writer.writeln(error);
    }
    if (stackTrace != null) {
      writer.writeln(stackTrace);
    }
    writer.write("\b\b");
    print(writer);
  }
}

/// An example console logger factory implementation of [ILogger]
class LoggerFactory implements ILoggerFactory {
  final LogLevel _minLevel;

  const LoggerFactory({required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  ILogger create(String name) {
    return ConsoleLogger(name: name, minLevel: _minLevel);
  }
}
```

## Additional information

If you have any issues or suggests please redirect
to [repo](https://github.com/codelovercc/dart_logging_abstraction)
or [send an email](mailto:codelovercc@gmail.com) to me.
