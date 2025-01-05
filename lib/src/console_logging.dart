import 'logging.dart';

/// Console ansi color helper
class ConsoleColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  /// The color
  ///
  /// Values: [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  final int? color;

  /// Construct from [color]
  ///
  /// - [color] The color, Values: [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  const ConsoleColor({this.color});

  /// None color
  const ConsoleColor.none() : this();

  /// Use grayscale levels to construct a gray
  ///
  /// - [level] Floating-point numbers from 0 to 1, 0 is black.
  ConsoleColor.grey({required double level})
      : this(
          color: 232 + (level.clamp(0.0, 1.0) * 23).round(),
        );

  /// To foreground console ansi color string.
  String toFgString() => hasColor ? '${ansiEsc}38;5;${color}m' : '';

  /// To background console ansi color string.
  String toBgString() => hasColor ? '${ansiEsc}48;5;${color}m' : '';

  /// Return a string with the foreground color.
  ///
  /// - [msg] The string to be colored.
  String fgMsg(String msg) => "${toFgString()}$msg${ConsoleColor.ansiDefault}";

  /// Return a string with the background color.
  ///
  /// - [msg] The string to be colored.
  String bgMsg(String msg) => "${toBgString()}$msg${ConsoleColor.ansiDefault}";
}

abstract class ConsoleColors {
  /// Black foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get black => ConsoleColor(color: 0);

  /// White foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get white => ConsoleColor(color: 231);

  /// Gray foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get gray => ConsoleColor.grey(level: .5);

  /// Light gray foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get lightGray => ConsoleColor(color: 252);

  /// Dark gray foreground color
  static ConsoleColor get darkGrey => ConsoleColor.grey(level: .25);

  /// Blue foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get blue => ConsoleColor(color: 21);

  /// Yellow foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get yellow => ConsoleColor(color: 226);

  /// Dark yellow foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get darkYellow => ConsoleColor(color: 58);

  /// Red foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get red => ConsoleColor(color: 196);

  /// Magenta foreground color
  ///
  /// [256 ANSI Color Codes](https://hexdocs.pm/color_palette/ansi_color_codes.html)
  static ConsoleColor get magenta => ConsoleColor(color: 201);
}

/// Provide additional methods
extension ConsoleColorExtensions on ConsoleColor {
  /// Check if there is any color.
  bool get hasColor => color != null;

  /// Use [fgColor] as the foreground color and the current color as background color.
  String withFgMsg(String msg, ConsoleColor fgColor) =>
      "${fgColor.toFgString()}${toBgString()}$msg${ConsoleColor.ansiDefault}";

  /// Use [bgColor] as the background color and the current color as foreground color.
  ///
  /// Return a string that is colored.
  String withBgMsg(String msg, ConsoleColor bgColor) =>
      "${toFgString()}${bgColor.toBgString()}$msg${ConsoleColor.ansiDefault}";
}

/// An example of console logger implementation of [ILogger]
///
/// use [T] type as the logger name.
class ConsoleLogger<T> extends ILogger4<T> {
  final LogLevel _minLevel;

  static final Map<LogLevel, String Function(String msg)> _levelMsgColors = {
    LogLevel.trace: (msg) => msg,
    LogLevel.debug: (msg) => msg,
    LogLevel.info: (msg) => msg,
    LogLevel.warn: (msg) => ConsoleColors.darkYellow.fgMsg(msg),
    LogLevel.error: (msg) => ConsoleColors.red.fgMsg(msg),
    LogLevel.fatal: (msg) => ConsoleColors.magenta.fgMsg(msg),
  };

  static final Map<LogLevel, String Function(String msg)> _levelLabelColors = {
    LogLevel.trace: (msg) => ConsoleColors.gray.withBgMsg(msg, ConsoleColors.black),
    LogLevel.debug: (msg) => ConsoleColors.lightGray.withBgMsg(msg, ConsoleColors.black),
    LogLevel.info: (msg) => ConsoleColors.blue.withBgMsg(msg, ConsoleColors.lightGray),
    LogLevel.warn: (msg) => ConsoleColors.yellow.withBgMsg(msg, ConsoleColors.black),
    LogLevel.error: (msg) => ConsoleColors.black.withBgMsg(msg, ConsoleColors.red),
    LogLevel.fatal: (msg) => ConsoleColors.white.withBgMsg(msg, ConsoleColors.magenta),
  };

  ConsoleLogger({super.name, required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  bool isEnabled(LogLevel logLevel) => logLevel >= _minLevel && logLevel != LogLevel.none;

  @override
  void log(message, LogLevel logLevel, {Object? error, StackTrace? stackTrace}) {
    if (!isEnabled(logLevel)) {
      return;
    }
    final labelColor = _levelLabelColors[logLevel] ?? (msg) => msg;
    final msgColor = _levelMsgColors[logLevel] ?? (msg) => msg;
    final writer = StringBuffer();
    writer.write(labelColor("[${logLevel.name.toUpperCase()}]"));
    writer.writeln(" ${DateTime.now()} [$name]");
    writer.writeln(msgColor(message));
    if (error != null) {
      writer.writeln(msgColor(error.toString()));
    }
    if (stackTrace != null) {
      writer.writeln(msgColor(stackTrace.toString()));
    }
    print(writer.toString().trimRight());
  }
}

/// An example of console logger factory implementation of [ILogger]
class ConsoleLoggerFactory implements ILoggerFactory {
  final LogLevel _minLevel;

  const ConsoleLoggerFactory({required LogLevel minLevel}) : _minLevel = minLevel;

  @override
  ILogger create(String name) {
    return ConsoleLogger(name: name, minLevel: _minLevel);
  }

  @override
  ILogger4<T> createLogger<T>() {
    return ConsoleLogger<T>(minLevel: _minLevel);
  }
}
