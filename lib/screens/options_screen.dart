import 'package:flutter/material.dart';
import 'package:pdf_watermarker/services/preferences_service.dart';
import 'package:pdf_watermarker/theme/retro_theme.dart';
import 'package:file_picker/file_picker.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  bool _isPdfWatermark = false;
  String _watermarkPath = '';
  String _outputFolderPath = '';
  int _namingConvention = 0;
  final TextEditingController _appendController = TextEditingController();
  final TextEditingController _sequentialController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() {
    setState(() {
      _isPdfWatermark = PreferencesService.isPdfWatermark;
      _watermarkPath = PreferencesService.watermarkPath ?? '';
      _outputFolderPath = PreferencesService.outputFolderPath ?? '';
      _namingConvention = PreferencesService.namingConvention;
      _appendController.text = PreferencesService.appendText;
      _sequentialController.text = PreferencesService.sequentialBaseName;
    });
  }

  Future<void> _pickWatermark() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      String path = result.files.single.path!;
      bool isPdf = path.toLowerCase().endsWith('.pdf');
      
      await PreferencesService.setWatermarkPath(path);
      await PreferencesService.setIsPdfWatermark(isPdf);
      
      setState(() {
        _watermarkPath = path;
        _isPdfWatermark = isPdf;
      });
    }
  }

  Future<void> _pickOutputFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      await PreferencesService.setOutputFolderPath(result);
      setState(() {
        _outputFolderPath = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OPTIONS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSectionTitle('1. WATERMARK SOURCE'),
          _buildPathBox(_watermarkPath, 'SELECT FILE', _pickWatermark),
          const SizedBox(height: 8),
          Text(
            _isPdfWatermark ? 'FORMAT: PDF OPACITY INTACT' : 'FORMAT: IMAGE (API REDUCED OPACITY)',
            style: const TextStyle(color: RetroTheme.secondary, fontSize: 8),
          ),
          
          const SizedBox(height: 32),
          _buildSectionTitle('2. OUTPUT FOLDER'),
          _buildPathBox(_outputFolderPath, 'SELECT DIR', _pickOutputFolder),

          const SizedBox(height: 32),
          _buildSectionTitle('3. NAMING CONVENTION'),
          _buildNamingOptions(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(color: RetroTheme.accent, fontSize: 14),
      ),
    );
  }

  Widget _buildPathBox(String path, String buttonText, VoidCallback onPressed) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: RetroTheme.border, width: 2),
            ),
            child: Text(
              path.isEmpty ? 'NOT SET' : path.split('/').last,
              style: const TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildNamingOptions() {
    return Column(
      children: [
        RadioListTile<int>(
          title: const Text('APPEND TEXT', style: TextStyle(fontSize: 10)),
          value: 0,
          groupValue: _namingConvention,
          activeColor: RetroTheme.primary,
          onChanged: (val) async {
            if (val != null) {
              await PreferencesService.setNamingConvention(val);
              setState(() => _namingConvention = val);
            }
          },
        ),
        if (_namingConvention == 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _appendController,
              decoration: const InputDecoration(labelText: 'APPEND STRING'),
              onChanged: (val) => PreferencesService.setAppendText(val),
            ),
          ),
        const SizedBox(height: 16),
        RadioListTile<int>(
          title: const Text('SEQUENTIAL', style: TextStyle(fontSize: 10)),
          value: 1,
          groupValue: _namingConvention,
          activeColor: RetroTheme.primary,
          onChanged: (val) async {
            if (val != null) {
              await PreferencesService.setNamingConvention(val);
              setState(() => _namingConvention = val);
            }
          },
        ),
        if (_namingConvention == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _sequentialController,
              decoration: const InputDecoration(labelText: 'BASE NAME (e.g. Doc_)'),
              onChanged: (val) => PreferencesService.setSequentialBaseName(val),
            ),
          ),
      ],
    );
  }
}
