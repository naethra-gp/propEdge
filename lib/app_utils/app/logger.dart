import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:prop_edge/app_services/local_db/local_services/local_services.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  late final Logger logger;
  late final File _logFile;

  factory LogService() {
    return _instance;
  }

  LogService._internal();

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/app_log.txt');

    logger = Logger(
      printer: SimplePrinter(
        colors: false, // Colorful log messages
        printTime: true, // Should each log print the time
      ),
      output: _FileLogOutput(_logFile),
      level: Level.info, // Capture all levels
    );
  }

  Future<String> getLogs() async {
    if (await _logFile.exists()) {
      return await _logFile.readAsString();
    }
    return "No logs available.";
  }

  Future<void> clearLogs() async {
    if (await _logFile.exists()) {
      await _logFile.writeAsString('');
    }
  }

  void i(String message) => logger.i(message);
  void d(String message) => logger.d(message);
  void w(String message) => logger.w(message);
  void e(String message) => logger.e(message);
  void v(String message) => logger.v(message);
}

class _FileLogOutput extends LogOutput {
  final File file;

  _FileLogOutput(this.file);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      try {
        file.writeAsStringSync("$line\n", mode: FileMode.append, flush: true);
      } catch (e, stackTrace) {
        CommonFunctions().appLog(e, stackTrace);
      }
    }
  }
}
