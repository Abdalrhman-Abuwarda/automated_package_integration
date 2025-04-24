import 'package:automated_package_integration/core/services/app_logger.dart';

/// A component-specific logger that prepends the component name to logs.
/// Makes it easier to filter logs for specific components.
class ComponentLogger {
  final String _component;
  final AppLogger _logger;

  ComponentLogger(this._component) : _logger = AppLogger();

  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v('[$_component] $message', error, stackTrace);
  }

  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d('[$_component] $message', error, stackTrace);
  }

  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('[$_component] $message', error, stackTrace);
  }

  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w('[$_component] $message', error, stackTrace);
  }

  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('[$_component] $message', error, stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf('[$_component] $message', error, stackTrace);
  }
}
