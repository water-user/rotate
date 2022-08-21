import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isRotated = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final statusBarPadding = MediaQuery.of(context).viewPadding.top;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height - statusBarPadding;
    final portraitSize = Size(screenWidth, screenWidth * 0.5);
    final landscapeSize = Size(screenHeight, screenWidth);
    final sizeTween = SizeTween(begin: portraitSize, end: landscapeSize);
    final Tween<double> rotationTween = Tween(begin: 0.0, end: pi / 2);
    final Tween<double> yAlignmentTween = Tween(begin: -1, end: 0.0);

    return SafeArea(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return OverflowBox(
              maxWidth: screenHeight,
              maxHeight: screenHeight,
              alignment: Alignment(0, yAlignmentTween.evaluate(_controller)),
              child: Transform.rotate(
                angle: rotationTween.evaluate(_controller),
                child: SizedBox(
                  width: (sizeTween.evaluate(_controller) as Size).width,
                  height: (sizeTween.evaluate(_controller) as Size).height,
                  child: Stack(
                    // fit: StackFit.expand,
                    children: [
                      child!,
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            if (_controller.value == 0) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          },
                          icon: const Icon(Icons.subdirectory_arrow_left),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          child: const VideoWidget(),
        ),
      ),
    );
  }
}

class VideoWidget extends StatelessWidget {
  const VideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse('https://www.youtube.com/embed/RDfjXj5EGqI'),
      ),
      // initialOptions: options,
      onWebViewCreated: (controller) {},
      onLoadError: (controller, url, code, message) {},
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return NavigationActionPolicy.CANCEL;
      },
    );
  }
}
