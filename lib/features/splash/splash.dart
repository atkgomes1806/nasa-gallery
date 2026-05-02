import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nasa_app/features/home_page/home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  ui.Image? _firstFrame;

  @override
  void initState() {
    super.initState();
    _loadFirstFrame();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  Future<void> _loadFirstFrame() async {
    try {
      final ByteData data = await rootBundle.load(
        'assets/images/nasa_logo.gif',
      );
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      setState(() {
        _firstFrame = frameInfo.image;
      });
    } catch (_) {
      // se falhar, não quebra a tela; imagem ficará nula até Image.asset carregar
      setState(() => _firstFrame = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            width: 320,
            height: 320,
            child: _firstFrame != null
                ? RawImage(image: _firstFrame, fit: BoxFit.contain)
                : Image.asset(
                    'assets/images/nasa_logo.gif',
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
