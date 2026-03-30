import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool processing = false;
  InspectionResult? result;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> captureAndInspect() async {
    if (controller == null || processing) return;

    setState(() => processing = true);

    final image = await controller!.takePicture();
    final file = File(image.path);

    final api = ApiService();
    final response = await api.inspectImage(file);

    setState(() {
      result = response;
      processing = false;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('PCB Inspector')),
      body: Stack(
        children: [
          CameraPreview(controller!),
          if (result != null) _drawBoxes(result!.defects),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: captureAndInspect,
        label: processing
            ? const Text("Processing…")
            : const Text("Capture & Inspect"),
        icon: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _drawBoxes(List<PCBDefect> defects) {
    return Stack(
      children: defects.map((d) {
        return Positioned(
          left: d.x.toDouble(),
          top: d.y.toDouble(),
          width: d.w.toDouble(),
          height: d.h.toDouble(),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 3),
            ),
          ),
        );
      }).toList(),
    );
  }
}
