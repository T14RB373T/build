import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() {
  runApp(const AppsR());
}

class AppsR extends StatelessWidget {
  const AppsR({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrivacyGate(),
    );
  }
}

class PrivacyGate extends StatelessWidget {
  const PrivacyGate({super.key});

  Future<void> handleTracking() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.privacy_tip, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "APPS-R",
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kami menggunakan data untuk meningkatkan pengalaman dan analitik.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await handleTracking();

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const WebApp()),
                  );
                }
              },
              child: const Text("Masuk"),
            )
          ],
        ),
      ),
    );
  }
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://444u.my.id/app/new"))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => loading = false);
          },
        ),
      );
  }

  Future<bool> back() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (loading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}