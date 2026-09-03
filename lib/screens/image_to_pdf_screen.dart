import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:pdf_watermarker/services/image_pdf_service.dart';
import 'package:pdf_watermarker/services/preferences_service.dart';
import 'package:pdf_watermarker/theme/retro_theme.dart';

class ImageToPdfScreen extends StatefulWidget {
  const ImageToPdfScreen({
    required this.initialImages,
    super.key,
  });

  final List<File> initialImages;

  @override
  State<ImageToPdfScreen> createState() => _ImageToPdfScreenState();
}

class _ImageToPdfScreenState extends State<ImageToPdfScreen> {
  late final TextEditingController _fileNameController;
  late List<File> _images;

  @override
  void initState() {
    super.initState();
    _images = List<File>.from(widget.initialImages);
    _fileNameController = TextEditingController(
      text: ImagePdfService.createDefaultFileName(),
    );
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  Future<void> _pickMoreImages() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result == null) {
      return;
    }

    final List<File> files = result.paths
        .whereType<String>()
        .map(File.new)
        .where(
          (File file) => !_images.any(
            (File existing) => existing.path == file.path,
          ),
        )
        .toList();

    if (files.isEmpty) {
      return;
    }

    setState(() {
      _images.addAll(files);
    });
  }

  void _removeImageAt(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final File moved = _images.removeAt(oldIndex);
      _images.insert(newIndex, moved);
    });
  }

  Future<void> _exportPdf() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add at least one image before exporting.',
            style: TextStyle(color: RetroTheme.accent),
          ),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: RetroTheme.background,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: RetroTheme.secondary, width: 4),
          ),
          title: Text('BUILDING PDF'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: RetroTheme.secondary),
              SizedBox(height: 20),
              Text(
                'CONVERTING IMAGES INTO A SINGLE PDF...',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    final ImagePdfResult result = await ImagePdfService.createPdfFromImages(
      orderedImages: _images,
      requestedFileName: _fileNameController.text,
    );

    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: RetroTheme.background,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: result.success ? RetroTheme.primary : RetroTheme.accent,
              width: 4,
            ),
          ),
          title: Text(result.success ? 'PDF READY' : 'EXPORT FAILED'),
          content: Text(
            result.success
                ? 'Saved to:\n${result.outputPath}'
                : (result.error ?? 'Unknown error while generating PDF.'),
            style: const TextStyle(fontSize: 10),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ACKNOWLEDGE',
                style: TextStyle(color: RetroTheme.secondary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String outputFolder = PreferencesService.outputFolderPath ?? 'NOT SET';

    return Scaffold(
      appBar: AppBar(
        title: const Text('IMAGES TO PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: RetroTheme.primary, width: 3),
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IMAGES: ${_images.length}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'OUTPUT: ${p.basename(outputFolder)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'DRAG THE LIST TO REARRANGE. TOP ITEM BECOMES PAGE 1.',
                    style: TextStyle(color: RetroTheme.secondary, fontSize: 8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _fileNameController,
              decoration: const InputDecoration(
                labelText: 'PDF FILE NAME',
                hintText: 'images_20260424_182000',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('ADD MORE'),
                    onPressed: _pickMoreImages,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('EXPORT PDF'),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: RetroTheme.secondary,
                        width: 4,
                      ),
                      foregroundColor: RetroTheme.secondary,
                    ),
                    onPressed: _exportPdf,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _images.isEmpty
                  ? const Center(
                      child: Text(
                        'NO IMAGES SELECTED',
                        style: TextStyle(color: RetroTheme.accent, fontSize: 10),
                      ),
                    )
                  : ReorderableListView.builder(
                      onReorder: _reorderImages,
                      itemCount: _images.length,
                      itemBuilder: (BuildContext context, int index) {
                        final File image = _images[index];

                        return Container(
                          key: ValueKey(image.path),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: RetroTheme.border,
                              width: 2,
                            ),
                            color: Colors.black,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                image,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 56,
                                  color: RetroTheme.background,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                            title: Text(
                              p.basename(image.path),
                              style: const TextStyle(fontSize: 10),
                            ),
                            subtitle: Text(
                              'PAGE ${index + 1}',
                              style: const TextStyle(
                                color: RetroTheme.secondary,
                                fontSize: 8,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _removeImageAt(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: RetroTheme.accent,
                                  ),
                                ),
                                ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(
                                    Icons.drag_indicator,
                                    color: RetroTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
