import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  var _isListening = false;
  var text = "Please speak";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to text"),
        backgroundColor: Colors.purple[200],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: Colors.purple,
        animate: _isListening,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        endRadius: 80,
        child: GestureDetector(
          onTapDown: (details) {
            setState(() async {
              if (!_isListening) {
                var available = await _speechToText.initialize();
                if ( available) {
                  setState(() {
                    _isListening = true;
                    _speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          text = result.recognizedWords;
                        }
                      );
                    });
                  });
                }
              }
            });
          },
          onTapUp: (details) {
            setState(() {
              _isListening = false;
            });
            _speechToText.stop();
          },
          child: CircleAvatar(
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
