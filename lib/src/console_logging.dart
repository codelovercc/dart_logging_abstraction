import 'logging.dart';

/// An example of console logger implementation of [ILogger]
class ConsoleLogger implements ILogger {
  final LogLevel _minLevel;

  const ConsoleLogger({required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  bool isEnabled(LogLevel logLevel) => logLevel >= _minLevel;

  @override
  void log(message, LogLevel logLevel, {Object? error, StackTrace? stackTrace}) {
    if (!isEnabled(logLevel)) {
      return;
    }
    final writer = StringBuffer();
    writer.writeln("[${logLevel.name}] ${DateTime.now()}");
    writer.writeln(message);
    if (error != null) {
      writer.writeln(error);
    }
    if (stackTrace != null) {
      writer.writeln(stackTrace);
    }
    print(writer.toString().trimRight());
  }
}

/// An example of console logger factory implementation of [ILogger]
class LoggerFactory implements ILoggerFactory {
  final LogLevel _minLevel;

  const LoggerFactory({required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  ILogger createLogger() {
    return ConsoleLogger(minLevel: _minLevel);
  }
}
