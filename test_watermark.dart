import 'dart:io';
import 'package:pdf_watermarker/services/watermark_service.dart';
import 'package:pdf_watermarker/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await PreferencesService.init();

  // Create a dummy PDF
  final testPdf = File('test_input.pdf');
  // Just a tiny valid PDF base64
  final emptyPdf = 'JVBERi0xLjcKCjEgMCBvYmogICUKPDwKICAvVHlwZSAvQ2F0YWxvZwogIC9QYWdlcyAyIDAgUgo+PgplbmRvYmoKCjIgMCBvYmogICUKPDwKICAvVHlwZSAvUGFnZXMKICAvS2lkcyBbMyAwIFJdCiAgL0NvdW50IDEKPj4KZW5kb2JqCgozIDAgb2JqICAlCjw8CiAgL1R5cGUgL1BhZ2UKICAvUGFyZW50IDIgMCBSCiAgL01lZGlhQm94IFswIDAgNTk1LjI4IDg0MS44OV0KICAvUmVzb3VyY2VzIDw8Pj4KPj4KZW5kb2JqCgp4cmVmCjAgNAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMTAgMDAwMDAgbiAKMDAwMDAwMDA2MCAwMDAwMCBuIAowMDAwMDAwMTE1IDAwMDAwIG4gCnRyYWlsZXIKPDwKICAvU2l6ZSA0CiAgL1Jvb3QgMSAwIFIKPj4Kc3RhcnR4cmVmCjE5MQolJUVPRgo=';
  import 'dart:convert';
  await testPdf.writeAsBytes(base64Decode(emptyPdf));

  // Options
  await PreferencesService.setWatermarkPath('assets/icon/WhatsApp Image 2026-02-25 at 10.59.46 PM.jpeg');
  await PreferencesService.setIsPdfWatermark(false);
  await PreferencesService.setOutputFolderPath('.');
  await PreferencesService.setNamingConvention(0);
  await PreferencesService.setAppendText('_watermarked');

  print('Starting processing...');
  final result = await WatermarkService.processFiles(
    sourceFiles: [testPdf],
    onProgress: (c, t) => print('Progress $c / $t'),
  );

  print('Result: Success ${result.successCount}, Fails ${result.failCount}, Errors: ${result.errors}');
  
  if (File('test_input_watermarked.pdf').existsSync()) {
    print('Output file exists! Size: ${File('test_input_watermarked.pdf').lengthSync()} bytes');
  } else {
    print('Output file DOES NOT EXIST.');
  }
  
  exit(0);
}
