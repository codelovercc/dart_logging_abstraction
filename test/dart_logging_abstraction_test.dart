import 'package:dart_logging_abstraction/dart_logging_abstraction.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Console logging tests.", () {
    // Logging implementation example can be found in lib/src/console_logging.dart
    test("Trace level test", () {
      final traceLogger = LoggerFactory(minLevel: LogLevel.trace).createLogger<MyClass>();
      final traceLoggerTester = LoggerTester(logger: traceLogger);
      traceLoggerTester.fatal("Fatal on traceLogger", error: Error(), stackTrace: StackTrace.current);
      traceLoggerTester.error("Error on traceLogger", error: Error(), stackTrace: StackTrace.current);
      traceLoggerTester.warn("Warning on traceLogger");
      traceLoggerTester.info("Info on traceLogger");
      traceLoggerTester.debug("Debug on traceLogger");
      traceLoggerTester.trace("trace on traceLogger");
      traceLoggerTester.log("Should not be printed.", LogLevel.none);

      expect(traceLoggerTester.printedLevels[LogLevel.fatal], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.error], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.warn], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.info], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.debug], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.trace], isTrue);
      expect(traceLoggerTester.printedLevels[LogLevel.none], isFalse);
    });
    test("Info level test", () {
      final infoLogger = LoggerFactory(minLevel: LogLevel.info).create("InfoLogger");
      final infoLoggerTester = LoggerTester(logger: infoLogger);
      infoLoggerTester.fatal("Fatal on infoLogger", error: Error(), stackTrace: StackTrace.current);
      infoLoggerTester.error("Error on infoLogger", error: Error(), stackTrace: StackTrace.current);
      infoLoggerTester.warn("Warning on infoLogger");
      infoLoggerTester.info("Info on infoLogger");
      infoLoggerTester.debug("Debug on infoLogger");
      infoLoggerTester.trace("Trace on infoLogger");
      infoLoggerTester.log("Should not be printed.", LogLevel.none);

      expect(infoLoggerTester.printedLevels[LogLevel.fatal], isTrue);
      expect(infoLoggerTester.printedLevels[LogLevel.error], isTrue);
      expect(infoLoggerTester.printedLevels[LogLevel.warn], isTrue);
      expect(infoLoggerTester.printedLevels[LogLevel.info], isTrue);
      expect(infoLoggerTester.printedLevels[LogLevel.debug], isFalse);
      expect(infoLoggerTester.printedLevels[LogLevel.trace], isFalse);
      expect(infoLoggerTester.printedLevels[LogLevel.none], isFalse);
    });
    test("None level should print nothing", () {
      final noneLogger = LoggerFactory(minLevel: LogLevel.none).createLogger<MyClass>();
      final noneLoggerTester = LoggerTester(logger: noneLogger);
      noneLoggerTester.fatal("Fatal on infoLogger", error: Error(), stackTrace: StackTrace.current);
      noneLoggerTester.error("Error on infoLogger", error: Error(), stackTrace: StackTrace.current);
      noneLoggerTester.warn("Warning on infoLogger");
      noneLoggerTester.info("Info on infoLogger");
      noneLoggerTester.debug("Debug on infoLogger");
      noneLoggerTester.trace("Trace on infoLogger");
      noneLoggerTester.log("Should not be printed.", LogLevel.none);

      expect(noneLoggerTester.printedLevels[LogLevel.fatal], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.error], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.warn], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.info], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.debug], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.trace], isFalse);
      expect(noneLoggerTester.printedLevels[LogLevel.none], isFalse);
    });
  });
}

class MyClass {}

class LoggerTester implements ILogger {
  final ILogger logger;
  final Map<LogLevel, bool> printedLevels = {};

  LoggerTester({required this.logger});

  @override
  void log(message, LogLevel logLevel, {Object? error, StackTrace? stackTrace}) {
    printedLevels[logLevel] = logger.isEnabled(logLevel);
    logger.log(message, logLevel, error: error, stackTrace: stackTrace);
  }

  @override
  bool isEnabled(LogLevel logLevel) => logger.isEnabled(logLevel);

  @override
  String get name => logger.name;
}
