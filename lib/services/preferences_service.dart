import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Watermark Type
  static bool get isPdfWatermark => _prefs.getBool('isPdfWatermark') ?? false;
  static Future<void> setIsPdfWatermark(bool value) async {
    await _prefs.setBool('isPdfWatermark', value);
  }

  // Watermark Path
  static String? get watermarkPath => _prefs.getString('watermarkPath');
  static Future<void> setWatermarkPath(String path) async {
    await _prefs.setString('watermarkPath', path);
  }

  // Output Folder Path
  static String? get outputFolderPath => _prefs.getString('outputFolderPath');
  static Future<void> setOutputFolderPath(String path) async {
    await _prefs.setString('outputFolderPath', path);
  }

  // Naming Convention
  // 0 = Append Text, 1 = Sequential
  static int get namingConvention => _prefs.getInt('namingConvention') ?? 0;
  static Future<void> setNamingConvention(int value) async {
    await _prefs.setInt('namingConvention', value);
  }

  // Appended Text (if namingConvention == 0)
  static String get appendText => _prefs.getString('appendText') ?? '_watermarked';
  static Future<void> setAppendText(String value) async {
    await _prefs.setString('appendText', value);
  }

  // Sequential Base Name (if namingConvention == 1)
  static String get sequentialBaseName => _prefs.getString('sequentialBaseName') ?? 'File_';
  static Future<void> setSequentialBaseName(String value) async {
    await _prefs.setString('sequentialBaseName', value);
  }
}
