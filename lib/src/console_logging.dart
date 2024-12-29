import 'logging.dart';

/// An example of console logger implementation of [ILogger]
///
/// use [T] type as the logger name.
class ConsoleLogger<T> extends ILogger4<T> {
  final LogLevel _minLevel;

  ConsoleLogger({super.name, required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  bool isEnabled(LogLevel logLevel) => logLevel >= _minLevel && _minLevel != LogLevel.none;

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
    print(writer.toString().trimRight());
  }
}

/// An example of console logger factory implementation of [ILogger]
class LoggerFactory implements ILoggerFactory {
  final LogLevel _minLevel;

  const LoggerFactory({required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  ILogger create(String name) {
    return ConsoleLogger(name: name, minLevel: _minLevel);
  }

  @override
  ILogger4<T> createLogger<T>() {
    return ConsoleLogger<T>(minLevel: _minLevel);
  }
}
