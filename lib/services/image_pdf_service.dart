import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:pdf_watermarker/services/preferences_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ImagePdfResult {
  final bool success;
  final String? outputPath;
  final String? error;

  const ImagePdfResult({
    required this.success,
    this.outputPath,
    this.error,
  });
}

class ImagePdfService {
  static const String _fallbackBaseName = 'images_to_pdf';

  static Future<ImagePdfResult> createPdfFromImages({
    required List<File> orderedImages,
    required String requestedFileName,
  }) async {
    final String? outputFolder = PreferencesService.outputFolderPath;

    if (orderedImages.isEmpty) {
      return const ImagePdfResult(
        success: false,
        error: 'Select at least one image before exporting.',
      );
    }

    if (outputFolder == null || outputFolder.isEmpty) {
      return const ImagePdfResult(
        success: false,
        error: 'Output folder not set in Options.',
      );
    }

    final String safeBaseName = sanitizeFileName(requestedFileName);
    final String outputPath = buildOutputPath(
      outputFolder: outputFolder,
      baseName: safeBaseName,
    );

    final PdfDocument document = PdfDocument();

    try {
      for (final File imageFile in orderedImages) {
        final List<int> bytes = await imageFile.readAsBytes();
        final PdfBitmap bitmap = PdfBitmap(bytes);
        final PdfPage page = document.pages.add();
        final Size pageSize = page.getClientSize();

        const double margin = 24;
        final double maxWidth = pageSize.width - (margin * 2);
        final double maxHeight = pageSize.height - (margin * 2);
        final double widthRatio = maxWidth / bitmap.width;
        final double heightRatio = maxHeight / bitmap.height;
        final double scale = math.min(widthRatio, heightRatio);

        final double drawWidth = bitmap.width * scale;
        final double drawHeight = bitmap.height * scale;
        final double x = (pageSize.width - drawWidth) / 2;
        final double y = (pageSize.height - drawHeight) / 2;

        page.graphics.drawImage(
          bitmap,
          Rect.fromLTWH(x, y, drawWidth, drawHeight),
        );
      }

      final File outFile = File(outputPath);
      await outFile.writeAsBytes(document.saveSync(), flush: true);

      return ImagePdfResult(success: true, outputPath: outputPath);
    } catch (e) {
      return ImagePdfResult(
        success: false,
        error: 'Failed to create PDF: $e',
      );
    } finally {
      document.dispose();
    }
  }

  @visibleForTesting
  static String sanitizeFileName(String rawName) {
    final String compactWhitespace = rawName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    final String stripped = compactWhitespace
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
    final String collapsed = stripped.replaceAll(RegExp(r'_+'), '_');
    final String cleaned = collapsed
        .replaceAll(RegExp(r'^[._ ]+'), '')
        .replaceAll(RegExp(r'[._ ]+$'), '');

    return cleaned.isEmpty ? _fallbackBaseName : cleaned;
  }

  @visibleForTesting
  static String buildOutputPath({
    required String outputFolder,
    required String baseName,
  }) {
    final String safeBaseName = sanitizeFileName(baseName);
    String candidatePath = p.join(outputFolder, '$safeBaseName.pdf');
    int suffix = 2;

    while (File(candidatePath).existsSync()) {
      candidatePath = p.join(outputFolder, '${safeBaseName}_$suffix.pdf');
      suffix++;
    }

    return candidatePath;
  }

  static String createDefaultFileName() {
    final DateTime now = DateTime.now();
    final String twoDigitMonth = now.month.toString().padLeft(2, '0');
    final String twoDigitDay = now.day.toString().padLeft(2, '0');
    final String twoDigitHour = now.hour.toString().padLeft(2, '0');
    final String twoDigitMinute = now.minute.toString().padLeft(2, '0');
    final String twoDigitSecond = now.second.toString().padLeft(2, '0');

    return 'images_${now.year}$twoDigitMonth$twoDigitDay'
        '_$twoDigitHour$twoDigitMinute$twoDigitSecond';
  }
}
