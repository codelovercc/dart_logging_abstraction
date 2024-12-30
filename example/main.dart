import 'package:dart_logging_abstraction/dart_logging_abstraction.dart';

void main() {
  // Logging implementation example can find in lib/src/console_logging.dart
  final traceLogger = LoggerFactory(minLevel: LogLevel.trace).createLogger<MyClass>();
  traceLogger.fatal("Fatal on traceLogger", error: Error(), stackTrace: StackTrace.current);
  traceLogger.error("Error on traceLogger", error: Error(), stackTrace: StackTrace.current);
  traceLogger.warn("Warning on traceLogger");
  traceLogger.info("Info on traceLogger");
  traceLogger.debug("Debug on traceLogger");
  traceLogger.trace("trace on traceLogger");

  final infoLogger = LoggerFactory(minLevel: LogLevel.info).create("InfoLogger");
  infoLogger.fatal("Fatal on infoLogger", error: Error(), stackTrace: StackTrace.current);
  infoLogger.error("Error on infoLogger", error: Error(), stackTrace: StackTrace.current);
  infoLogger.warn("Warning on infoLogger");
  infoLogger.info("Info on infoLogger");
  infoLogger.debug("Debug on infoLogger");
  infoLogger.trace("trace on infoLogger");
}

class MyClass {}
