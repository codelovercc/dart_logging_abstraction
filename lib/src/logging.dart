/// Log levels
///
/// [LogLevel.trace]<[LogLevel.debug]<[LogLevel.info]<[LogLevel.warn]<[LogLevel.error]<[LogLevel.fatal]<[LogLevel.none]
enum LogLevel {
  /// Logs that contain the most detailed messages. These messages may contain sensitive application data.
  /// These messages are disabled by default and should never be enabled in a production environment.
  trace(0),

  /// Logs that are used for interactive investigation during development.
  /// These logs should primarily contain information useful for debugging and have no long-term value.
  debug(1000),

  /// Logs that track the general flow of the application. These logs should have long-term value.
  info(2000),

  /// Logs that highlight an abnormal or unexpected event in the application flow,
  /// but do not otherwise cause the application execution to stop.
  warn(3000),

  /// Logs that highlight when the current flow of execution is stopped due to a failure.
  /// These should indicate a failure in the current activity, not an application-wide failure.
  error(4000),

  /// Logs that describe an unrecoverable application or system crash,
  /// or a catastrophic failure that requires immediate attention.
  fatal(5000),

  /// Not used for writing log messages. Specifies that a logging category should not write any messages.
  none(6000);

  final int _value;

  /// constructor [LogLevel]
  /// - [value] the log level's value
  const LogLevel(int value) : _value = value;
}

/// Provide operators for [LogLevel]
extension LogLevelOperatorExtensions on LogLevel {
  /// returns `true` if this [LogLevel] is greater than [other]
  bool operator >(LogLevel other) => _value > other._value;

  /// returns `true` if this [LogLevel] is greater than or equals to [other]
  bool operator >=(LogLevel other) {
    return _value >= other._value;
  }

  /// returns `true` if this [LogLevel] is less than [other]
  bool operator <(LogLevel other) => _value < other._value;

  /// returns `true` if this [LogLevel] is less than or equals to [other]
  bool operator <=(LogLevel other) => _value <= other._value;
}

/// A logger that log information
abstract interface class ILogger {
  /// The logger's name
  abstract final String name;

  /// Check if the given [logLevel] is enabled.
  bool isEnabled(LogLevel logLevel);

  /// write a log.
  ///
  /// - [message] the message.
  /// - [logLevel] log will be write in this level.
  /// - [error] log an error if there is.
  /// - [stackTrace] log the stack trace if it's not `null`.
  void log(dynamic message, LogLevel logLevel, {Object? error, StackTrace? stackTrace});
}

/// Logger for type [T]
abstract class ILogger4<T> implements ILogger {
  @override
  final String name;

  /// Create a logger
  ///
  /// If [name] is not `null` then it will be used as the logger name, otherwise use type [T] as the logger name.
  ILogger4({String? name})
      : name = name ?? "$T",
        assert(name != null || T != dynamic && T != Object,
            "The parameters 'name' and 'T' must be specified specifically for one of them.");
}

/// A factory that creates [ILogger] instance.
abstract interface class ILoggerFactory {
  /// create [ILogger]
  ///
  /// - [name] the name of the logger.
  ILogger create(String name);

  /// Create a logger use a type name as the logger's name.
  ///
  /// - [T] the type.
  ILogger4<T> createLogger<T>();
}

/// Provide logging methods for [ILogger]
extension LoggerExtensions on ILogger {
  /// Write a [LogLevel.trace] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void trace(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.trace, error: error, stackTrace: stackTrace);

  /// Write a [LogLevel.debug] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void debug(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.debug, error: error, stackTrace: stackTrace);

  /// Write a [LogLevel.info] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void info(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.info, error: error, stackTrace: stackTrace);

  /// Write a [LogLevel.warn] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void warn(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.warn, error: error, stackTrace: stackTrace);

  /// Write a [LogLevel.error] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.error, error: error, stackTrace: stackTrace);

  /// Write a [LogLevel.fatal] level log.
  ///
  /// Your can find the parameters document in method [ILogger.log].
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      log(message, LogLevel.fatal, error: error, stackTrace: stackTrace);
}
