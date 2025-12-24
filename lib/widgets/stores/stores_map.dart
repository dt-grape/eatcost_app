import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StoresMap extends StatefulWidget {
  final double height;

  const StoresMap({
    super.key,
    this.height = 300,
  });

  @override
  State<StoresMap> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMap> {
  late final WebViewController _controller;
  bool _isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (kDebugMode) {
              print('Страница начала загрузку: $url');
            }
          },
          onPageFinished: (url) {
            if (kDebugMode) {
              print('Страница загружена: $url');
            }
            if (mounted) {
              setState(() {
                _isMapLoaded = true;
              });
            }
          },
          onWebResourceError: (error) {
            if (kDebugMode) {
              print('Ошибка загрузки: ${error.description}');
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://yandex.ru/map-widget/v1/?um=constructor%3A19c91f724a92402054791fa743027aec5ba5d2eef9d41d40ee388c833eaeda39&source=constructor',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (!_isMapLoaded)
              Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3D5A3E),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
