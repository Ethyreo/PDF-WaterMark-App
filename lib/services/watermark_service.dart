import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf_watermarker/services/preferences_service.dart';
import 'package:path/path.dart' as p;

class WatermarkResult {
  final int successCount;
  final int failCount;
  final List<String> errors;

  WatermarkResult(this.successCount, this.failCount, this.errors);
}

class WatermarkService {
  static Future<WatermarkResult> processFiles({
    required List<File> sourceFiles,
    required Function(int current, int total) onProgress,
  }) async {
    int success = 0;
    int fails = 0;
    List<String> errors = [];

    final String? watermarkPath = PreferencesService.watermarkPath;
    final String? outputFolder = PreferencesService.outputFolderPath;
    final bool isPdfWatermark = PreferencesService.isPdfWatermark;
    final int namingConvention = PreferencesService.namingConvention;
    final String appendText = PreferencesService.appendText;
    final String seqBase = PreferencesService.sequentialBaseName;

    if (watermarkPath == null || watermarkPath.isEmpty) {
      return WatermarkResult(0, sourceFiles.length, ['Watermark source not set in Options.']);
    }
    if (outputFolder == null || outputFolder.isEmpty) {
      return WatermarkResult(0, sourceFiles.length, ['Output folder not set in Options.']);
    }

    try {
      // Pre-load watermark
      final File wmFile = File(watermarkPath);
      final Uint8List wmBytes = await wmFile.readAsBytes();
      
      PdfDocument? wmPdfDoc;
      PdfBitmap? wmBitmap;

      if (isPdfWatermark) {
        wmPdfDoc = PdfDocument(inputBytes: wmBytes);
      } else {
        wmBitmap = PdfBitmap(wmBytes);
      }

      for (int i = 0; i < sourceFiles.length; i++) {
        final File file = sourceFiles[i];
        try {
          final Uint8List targetBytes = await file.readAsBytes();
          final PdfDocument targetDoc = PdfDocument(inputBytes: targetBytes);

          for (int pageIdx = 0; pageIdx < targetDoc.pages.count; pageIdx++) {
            final PdfPage page = targetDoc.pages[pageIdx];
            final Size pageSize = page.getClientSize();

            if (isPdfWatermark && wmPdfDoc != null) {
              // Extract template from the first page of the watermark PDF
              final PdfTemplate template = wmPdfDoc.pages[0].createTemplate();
              page.graphics.drawPdfTemplate(template, const Offset(0, 0));
            } else if (wmBitmap != null) {
              // Image logic - Center it, max 80% of page size, 25% opacity
              final double maxWidth = pageSize.width * 0.8;
              final double maxHeight = pageSize.height * 0.8;
              final double imgWidth = wmBitmap.width.toDouble();
              final double imgHeight = wmBitmap.height.toDouble();

              final double ratio = (maxWidth / imgWidth < maxHeight / imgHeight) 
                  ? maxWidth / imgWidth 
                  : maxHeight / imgHeight;

              final double newWidth = imgWidth * ratio;
              final double newHeight = imgHeight * ratio;

              final double x = (pageSize.width - newWidth) / 2;
              final double y = (pageSize.height - newHeight) / 2;

              page.graphics.save();
              page.graphics.setTransparency(0.25);
              page.graphics.drawImage(wmBitmap, Rect.fromLTWH(x, y, newWidth, newHeight));
              page.graphics.restore();
            }
          }

          // Generate file name
          String newFileName = '';
          if (namingConvention == 0) {
            String base = p.basenameWithoutExtension(file.path);
            newFileName = '$base$appendText.pdf';
          } else {
            newFileName = '${seqBase}${i + 1}.pdf';
          }

          final File outFile = File(p.join(outputFolder, newFileName));
          final List<int> outBytes = targetDoc.saveSync();
          await outFile.writeAsBytes(outBytes);
          targetDoc.dispose();

          success++;
        } catch (e) {
          fails++;
          errors.add('${p.basename(file.path)}: $e');
        }

        onProgress(i + 1, sourceFiles.length);
      }

      if (wmPdfDoc != null) wmPdfDoc.dispose();

    } catch (e) {
      errors.add('Critical error: $e');
    }

    return WatermarkResult(success, fails, errors);
  }
}
