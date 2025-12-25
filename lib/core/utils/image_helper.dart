import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  ImageHelper._();
  
  static final ImagePicker _picker = ImagePicker();
  
  static Future<File?> pickFromCamera({
    int imageQuality = 80,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<File?> pickFromGallery({
    int imageQuality = 80,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<String> imageToBase64(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return Future.value(base64Encode(bytes));
  }
  
  static Future<File> base64ToImage(String base64String, String fileName) async {
    final bytes = base64Decode(base64String);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<Uint8List> imageToBytes(File imageFile) async {
    return imageFile.readAsBytes();
  }
  
  static Future<File> saveImageLocally(File sourceImage, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
    }
    
    final targetPath = '${imagesDir.path}/$fileName';
    return sourceImage.copy(targetPath);
  }
  
  static Future<void> deleteLocalImage(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/images/$fileName';
    final file = File(imagePath);
    
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
  
  static Future<List<File>> getLocalImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    
    if (!imagesDir.existsSync()) {
      return [];
    }
    
    final files = imagesDir.listSync();
    return files.whereType<File>().toList();
  }
}
