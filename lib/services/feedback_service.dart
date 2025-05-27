import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:absolute_cinema/models/feedback_model.dart';

class FeedbackService {
  static const String baseUrl = 'https://pember-api-eta.vercel.app';

  static Future<List<FeedbackModel>> getAllFeedback() async {
    final response = await http.get(Uri.parse('$baseUrl/feedbacks'));
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data.map((json) => FeedbackModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data feedback');
    }
  }

  static Future<bool> uploadFeedback({
    required String userId,
    required String title,
    required String desctiption,
    required String location,
    required String rating,
    required File image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/feedback'));

    request.fields['userId'] = userId;
    request.fields['title'] = title;
    request.fields['desctiption'] = desctiption;
    request.fields['location'] = location;
    request.fields['rating'] = rating;

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', lookupMimeType(image.path) ?? 'jpeg'),
        filename: basename(image.path),
      ),
    );

    final response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      final error = await response.stream.bytesToString();
      print('Upload gagal: $error');
      return false;
    }
  }
}
