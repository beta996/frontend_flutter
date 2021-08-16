
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload image to the server',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectedImage;
  String message = "";

  uploadImage() async{
    var client = new HttpClient();
    var clientHTTP = await client.get('127.0.0.1', 5000, '/upload');
    final request = http.MultipartRequest("POST", Uri.parse("http://127.0.0.1:5000/upload"));
    //final request = http.MultipartRequest("POST", clientHTTP));

    final headers = {"Content-type:":"multipart/form-data"};
    request.files.add(http.MultipartFile('image',selectedImage!.readAsBytes().asStream(),selectedImage!.lengthSync(), filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final res_json = jsonDecode(res.body);
    message = res_json["message"];
    setState(() {

    });
  }


  Future getImage() async {
    PickedFile? pickedImage = await ImagePicker().getImage(source: ImageSource.camera);


    setState(() {
      selectedImage = File(pickedImage!.path);
    });
    uploadImage();
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String bgPath = appDocDir.uri.resolve("background.jpg").path;
    // File bgFile = await pickedImage.copy(bgPath);

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: selectedImage == null
                ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  RaisedButton(
                    color: Colors.lightGreenAccent,
                    onPressed: () {
                      getImage();
                    },
                    child: Text("PICK FROM CAMERA"),
                  )
                ],
              ),
            ) : Container(
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),


            )));
  }
}