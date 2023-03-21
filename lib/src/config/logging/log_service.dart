import 'package:logger/logger.dart';

class LogService {
  const LogService(this._logger);

  factory LogService.forClass(String className) {
    final l = Logger(printer: _SimpleLogPrinter(className));
    return LogService(l);
  }

  final Logger _logger;

  void debug(dynamic message) => _logger.d(message);
  void info(dynamic message) => _logger.i(message);
  void error(dynamic message) => _logger.e(message);
  void warn(dynamic message) => _logger.w(message);
  void verbose(dynamic message) => _logger.v(message);
  void wtf(dynamic message) => _logger.wtf(message);
}

class _SimpleLogPrinter extends PrettyPrinter {
  final String className;

  _SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final level = event.level;
    final color = PrettyPrinter.levelColors[level]!;
    final emoji = PrettyPrinter.levelEmojis[level];
    final message = event.message as Object?;
    return [color('$emoji $className - $message')];
  }
}
