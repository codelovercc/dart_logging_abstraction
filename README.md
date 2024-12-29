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

[![pub package](https://img.shields.io/pub/v/dart_logging_abstraction?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/dart_logging_abstraction)
[![CI](https://img.shields.io/github/actions/workflow/status/codelovercc/dart_logging_abstraction/dart.yml?branch=main&logo=github-actions&logoColor=white)](https://github.com/codelovercc/dart_logging_abstraction/actions)
[![Last Commits](https://img.shields.io/github/last-commit/codelovercc/dart_logging_abstraction?logo=git&logoColor=white)](https://github.com/codelovercc/dart_logging_abstraction/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/codelovercc/dart_logging_abstraction?logo=github&logoColor=white)](https://github.com/codelovercc/dart_logging_abstraction/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/codelovercc/dart_logging_abstraction?logo=github&logoColor=white)](https://github.com/codelovercc/dart_logging_abstraction)
[![License](https://img.shields.io/github/license/codelovercc/dart_logging_abstraction?logo=open-source-initiative&logoColor=green)](https://github.com/codelovercc/dart_logging_abstraction/blob/main/LICENSE)

An logging abstraction package for logging.

## Features

Provide logging interfaces, common objects and with example implementations.

## Getting started

Install this package, use other logging package implementation adapt to this package.

## Usage

```dart
import 'package:dart_logging_abstraction/dart_logging_abstraction.dart';

void main() {
  // Logging implementation example can find in lib/src/console_logging.dart
  final traceLogger = LoggerFactory(minLevel: LogLevel.trace).createLogger<MyClass>();
  traceLogger.fatal("Fatal on traceLogger", error: Error(), stackTrace: StackTrace.current);
  traceLogger.error("Error on traceLogger", error: Error(), stackTrace: StackTrace.current);
  traceLogger.warning("Warning on traceLogger");
  traceLogger.info("Info on traceLogger");
  traceLogger.debug("Debug on traceLogger");
  traceLogger.trace("trace on traceLogger");

  final infoLogger = LoggerFactory(minLevel: LogLevel.info).create("InfoLogger");
  infoLogger.fatal("Fatal on infoLogger", error: Error(), stackTrace: StackTrace.current);
  infoLogger.error("Error on infoLogger", error: Error(), stackTrace: StackTrace.current);
  infoLogger.warning("Warning on infoLogger");
  infoLogger.info("Info on infoLogger");
  infoLogger.debug("Debug on infoLogger");
  infoLogger.trace("trace on infoLogger");
}

class MyClass {}
```

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
