import 'dart:io';
import 'dart:convert';
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
  
  static Future<String> imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }
  
  static Future<File> base64ToImage(String base64String, String fileName) async {
    final bytes = base64Decode(base64String);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
  
  static Future<Uint8List> imageToBytes(File imageFile) async {
    return await imageFile.readAsBytes();
  }
  
  static Future<File> saveImageLocally(File sourceImage, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    
    final targetPath = '${imagesDir.path}/$fileName';
    return await sourceImage.copy(targetPath);
  }
  
  static Future<void> deleteLocalImage(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/images/$fileName';
    final file = File(imagePath);
    
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  static Future<List<File>> getLocalImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/images');
    
    if (!await imagesDir.exists()) {
      return [];
    }
    
    final files = await imagesDir.list().toList();
    return files.whereType<File>().toList();
  }
}
