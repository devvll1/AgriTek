import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sectors.dart';

class SectorService {
  final String apiUrl = 'http://localhost:3000/api/sectors';
  final String uploadUrl = 'http://localhost:3000/upload';

  // CREATE
  Future<Sector> createSector(Sector sector) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sector.toJson()),
    );

    if (response.statusCode == 201) {
      return Sector.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sector');
    }
  }

  // READ - Get all sectors
  Future<List<Sector>> getSectors() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((sector) => Sector.fromJson(sector)).toList();
    } else {
      throw Exception('Failed to load sectors');
    }
  }

  // READ - Get a single sector by ID
  Future<Sector> getSectorById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Sector.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sector');
    }
  }

  // UPDATE
  Future<Sector> updateSector(String id, Sector sector) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sector.toJson()),
    );

    if (response.statusCode == 200) {
      return Sector.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update sector');
    }
  }

  // DELETE
  Future<void> deleteSector(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete sector');
    }
  }

  // UPLOAD IMAGE
  Future<void> uploadImage(String filePath) async {
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      throw Exception('Failed to upload image');
    }
  }

  // GET IMAGE URL
  String getImageUrl(String fileName) {
    return 'http://localhost:3000/image/$fileName';
  }
}
