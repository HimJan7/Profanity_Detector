import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';

const apiUrl =
    'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content-file';
const apiKey = '7714d7cd12msh5daa162749f3d03p1c54fbjsn188d53b0c6bb';

class ProfanityDetectorModel extends ChangeNotifier {
  final filter = ProfanityFilter();

  String _text = '';
  int _textResult = 0;
  File? _selectedImage;
  int _imageResult = 0;

  String get text => _text;

  void DeleteSelectedImage() {
    _selectedImage = null;
    _imageResult = 0;
    notifyListeners();
  }

  void textCheck(String value) {
    _text = value;
    if (_text.isEmpty) {
      _textResult = 0;
    } else {
      _textResult = filter.hasProfanity(_text) ? 2 : 1;
    }
    notifyListeners();
  }

  int get textResult => _textResult;

  File? get selectedImage => _selectedImage;

  void selectFile(bool pickFromGallery) async {
    var file = await ImagePicker().pickImage(
      source: pickFromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    if (file == null) {
      return;
    } else {
      ImageCheck(File(file.path));
    }
  }

  void ImageCheck(File? value) {
    _selectedImage = value;
    if (_selectedImage == null) {
      _imageResult = 0;
    } else {
      makePostRequest();
    }
    notifyListeners();
  }

  int get imageResult => _imageResult;

  void makePostRequest() async {
    _imageResult = 3;
    notifyListeners();

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host':
          'nsfw-images-detection-and-classification.p.rapidapi.com',
    });
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      selectedImage!.path,
    ));
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var decodeVal = jsonDecode(responseString);
      if (decodeVal['unsafe'].toString() == 'true') {
        _imageResult = 2;
      } else {
        _imageResult = 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }
}
