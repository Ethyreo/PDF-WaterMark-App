import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdf_watermarker/theme/retro_theme.dart';

class StickyAudioPlayer extends StatefulWidget {
  const StickyAudioPlayer({super.key});

  @override
  State<StickyAudioPlayer> createState() => _StickyAudioPlayerState();
}

class _StickyAudioPlayerState extends State<StickyAudioPlayer> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // Expecting the mp3 in assets/audio/track.mp3
      await _player.setAsset('assets/audio/track.mp3');
      await _player.setLoopMode(LoopMode.one);
      
      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      });
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _restart() {
    _player.seek(Duration.zero);
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: RetroTheme.accent, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: RetroTheme.primary,
              size: 30,
            ),
            onPressed: _togglePlay,
          ),
          const SizedBox(width: 32),
          IconButton(
            icon: const Icon(Icons.replay, color: RetroTheme.secondary, size: 30),
            onPressed: _restart,
          ),
        ],
      ),
    );
  }
}
