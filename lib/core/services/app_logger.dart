import 'package:logger/logger.dart';

/// Application logger service.
/// Provides consistent logging functionality throughout the app.
class AppLogger {
  // Singleton instance
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  // Create a logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
  );

  // In release mode, use a simpler log format
  final Logger _releaseLogger = Logger(
    printer: SimplePrinter(printTime: true),
    level: Level.warning, // Only log warnings and errors in release mode
  );

  // Determine which logger to use based on debug/release mode
  Logger get logger => const bool.fromEnvironment('dart.vm.product')
      ? _releaseLogger
      : _logger;

  // Log levels

  /// Log verbose message
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.v(message, error: error, stackTrace: stackTrace);
  }

  /// Log debug message
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.wtf(message, error: error, stackTrace: stackTrace);
  }
}

// Global logger instance for easy access
final log = AppLogger();