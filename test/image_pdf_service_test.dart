import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_watermarker/services/image_pdf_service.dart';

void main() {
  group('ImagePdfService', () {
    test('sanitizeFileName removes illegal characters and trims empties', () {
      expect(
        ImagePdfService.sanitizeFileName('  sales:/Q2*deck  '),
        'sales_Q2_deck',
      );
      expect(
        ImagePdfService.sanitizeFileName('...'),
        'images_to_pdf',
      );
    });

    test('buildOutputPath appends pdf extension', () {
      final String outputPath = ImagePdfService.buildOutputPath(
        outputFolder: 'C:\\exports',
        baseName: 'merged_images',
      );

      expect(outputPath.endsWith('merged_images.pdf'), isTrue);
    });
  });
}
