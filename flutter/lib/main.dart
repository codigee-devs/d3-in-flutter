import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Streamgraph()),
                SizedBox(height: 40),
                Expanded(child: ZoomableCircles()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// https://observablehq.com/@d3/streamgraph-transitions
class Streamgraph extends StatefulWidget {
  const Streamgraph({super.key});

  @override
  State<Streamgraph> createState() => _StreamgraphState();
}

class _StreamgraphState extends State<Streamgraph> {
  final _controller = WebViewController();

  @override
  void initState() {
    super.initState();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse('http://localhost:3000/example-1'));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.clearCache();
    _controller.clearLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: WebViewWidget(controller: _controller),
    );
  }
}

/// https://observablehq.com/@d3/zoomable-circle-packing
class ZoomableCircles extends StatefulWidget {
  const ZoomableCircles({super.key});

  @override
  State<ZoomableCircles> createState() => _ZoomableCirclesState();
}

class _ZoomableCirclesState extends State<ZoomableCircles> {
  final _controller = WebViewController();
  final _javaScriptChannelName = 'FlutterChannel';
  var _sliderValue = 0.1;

  @override
  void initState() {
    super.initState();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse('http://localhost:3000/example-2'));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.clearCache();
    _controller.clearLocalStorage();
    _controller.removeJavaScriptChannel(_javaScriptChannelName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: WebViewWidget(controller: _controller),
        ),
        Slider.adaptive(
          value: _sliderValue,
          onChanged: (val) {
            _controller.runJavaScript("""
              window.FlutterChannel.postMessage('setColorScale:$val');
            """);

            setState(() {
              _sliderValue = val;
            });
          },
        ),
      ],
    );
  }
}
