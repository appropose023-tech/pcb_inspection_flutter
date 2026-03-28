
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/api_service.dart';
import '../../main.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool processing=false;
  String? resultText;

  @override
  void initState(){
    super.initState();
    controller=CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio:false
    );
    controller!.initialize().then((_) => setState(()=>{}));
  }

  Future<void> captureAndInspect() async {
    if(processing) return;
    setState(()=>processing=true);
    final file = await controller!.takePicture();
    final res = await ApiService.inspectImage(file.path);
    setState((){
      resultText=res;
      processing=false;
    });
  }

  @override
  Widget build(BuildContext context){
    if(!(controller?.value.isInitialized??false)){
      return Scaffold(body:Center(child:CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children:[
          CameraPreview(controller!),
          if(resultText!=null)
            Positioned(
              bottom:40,left:20,right:20,
              child:Container(
                padding:EdgeInsets.all(16),
                color:Colors.red.withOpacity(0.7),
                child:Text(resultText!,style:TextStyle(color:Colors.white,fontSize:18)),
              )
            )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureAndInspect,
        child: Icon(Icons.camera),
      ),
    );
  }
}
