import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profanity_detector/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? selectedImage = null;
  final filter = ProfanityFilter();
  TextEditingController controller = TextEditingController();
  int textResult = 0;
  int imageResult = 0;

  void selectFile(bool pickFromGallery) async {
    var file = await ImagePicker().pickImage(
      source: pickFromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    if (file == null) {
      return;
    } else {
      setState(() {
        selectedImage = File(file.path);
      });

      makePostRequest(selectedImage);
    }
  }

  void makePostRequest(var files) async {
    setState(() {
      imageResult = 3;
    });
    final apiUrl =
        'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content-file';
    final apiKey = '7714d7cd12msh5daa162749f3d03p1c54fbjsn188d53b0c6bb';

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host':
          'nsfw-images-detection-and-classification.p.rapidapi.com',
    });
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      files.path,
    ));
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var decodeVal = jsonDecode(responseString);
      if (decodeVal['unsafe'].toString() == 'true') {
        setState(() {
          imageResult = 2;
        });
      } else {
        setState(() {
          imageResult = 1;
        });
      }
      print(imageResult);
    } else {
      for (int i = 0; i < 20; i++) {
        print('failed');
      }
      // handle error
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profanity Detector',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        backgroundColor: Color(0xFFd9e0ee),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Text Here',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                height: 30,
                child: TextField(
                  controller: controller,
                  decoration: kRoundInputDecoration,
                  onChanged: (text) {
                    bool resultingVal = filter.hasProfanity(text);
                    setState(() {
                      if (text.isEmpty) {
                        textResult = 0;
                      } else {
                        resultingVal ? textResult = 2 : textResult = 1;
                      }
                    });
                  },
                ),
              ),
              resultContainer(result: textResult),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    color: Color(0xFFd9e0ee),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Upload Your Image',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 19),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              'PNG and JPG files are allowed',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedImage = null;
                                imageResult = 0;
                              });
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.blueGrey,
                            iconSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.03,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03),
                        child: selectedImage == null
                            ? GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                            ),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Color(0xFFd9e0ee))),
                                                onPressed: () {
                                                  selectFile(false);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Pick From Camera',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                )),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Color(0xFFd9e0ee))),
                                                onPressed: () {
                                                  selectFile(true);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Pick From Gallery',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                )),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          color: Colors.blueGrey,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                        ),
                                        Text(
                                          'Click Here',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    )),
                              )
                            : Image.file(
                                selectedImage!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              resultContainer(result: imageResult),
            ],
          ),
        )),
      ),
    );
  }
}

class resultContainer extends StatelessWidget {
  resultContainer({super.key, required this.result});

  final int result;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.2,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),

          //   color: result == 0 ? Color(0xFF6fe9ac) : Color(0xFFf0c6c7),
          color: result == 0
              ? Color(0xFFd9e0ee)
              : result == 1
                  ? Color(0xFF6fe9ac)
                  : result == 2
                      ? Color(0xFFf0c6c7)
                      : Color(0xFFd9e0ee),
        ),
        child: Center(
          child: Text(
              result == 0
                  ? 'WAITING'
                  : result == 1
                      ? 'PASSED'
                      : result == 2
                          ? 'FAILED'
                          : 'TESTING',
              style: TextStyle(
                  // color: result ? Color(0xFF007332) : Color(0xFFf3200b),
                  color: result == 0
                      ? Colors.black54
                      : result == 1
                          ? Color(0xFF007332)
                          : result == 2
                              ? Color(0xFFf3200b)
                              : Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20)),
        ),
      ),
    );
  }
}
