import 'package:flutter/material.dart';
import 'package:profanity_detector/constants.dart';
import 'package:provider/provider.dart';
import '../model/profanity_detector_model.dart';

ProfanityDetectorModel FirstInstance = ProfanityDetectorModel();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

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
      body: ChangeNotifierProvider.value(
        value: FirstInstance,
        builder: (context, child) {
          return SingleChildScrollView(
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
                        FirstInstance.textCheck(controller.text);
                      },
                    ),
                  ),
                  Consumer<ProfanityDetectorModel>(
                    builder: (context, value, child) {
                      return resultContainer(result: value.textResult);
                    },
                  ),
                  Consumer<ProfanityDetectorModel>(
                    builder: (context, value, child) {
                      return Container(
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
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
                                      value.DeleteSelectedImage();
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.blueGrey,
                                    iconSize:
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                child: FirstInstance.selectedImage == null
                                    ? GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.1,
                                                    ),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Color(
                                                                        0xFFd9e0ee))),
                                                        onPressed: () {
                                                          value.selectFile(
                                                              false);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Pick From Camera',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                    ),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Color(
                                                                        0xFFd9e0ee))),
                                                        onPressed: () {
                                                          value
                                                              .selectFile(true);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Pick From Gallery',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Image.file(
                                        value.selectedImage!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<ProfanityDetectorModel>(
                    builder: (context, value, child) {
                      return resultContainer(result: value.imageResult);
                    },
                  ),
                ],
              ),
            )),
          );
        },
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
