import 'package:cargadatos/classes/magnitud_response.dart';
import 'package:cargadatos/classes/magnitud_sent.dart';
import 'package:cargadatos/classes/medicion_response.dart';
import 'package:cargadatos/classes/medicion_sent.dart';
import 'package:cargadatos/classes/sensor.dart';
import 'package:cargadatos/classes/unidad_response.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Configuración de la API
class ApiConfig {
  static const String baseUrl =
      'http://localhost:80'; // Cambiar según tu servidor
  static String? authToken;

  static Map<String, String> getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }
}

// SERVICIOS API
class ApiService {
  // MAGNITUDES
  static Future<List<MagnitudResponse>> getMagnitudes() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/magnitudes/list'),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MagnitudResponse.fromJson(e)).toList();
    }
    throw Exception('Error al cargar magnitudes');
  }

  static Future<String> createMagnitud(MagnitudSent data) async {
    try{
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/magnitudes'),
        headers: ApiConfig.getHeaders(),
        body: json.encode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception('Error al crear magnitud $e');
    }
    return "";
  }

  static Future<void> deleteMagnitud(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/magnitudes/$id'),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar magnitud');
    }
  }

  static Future<Map<String, dynamic>> updateMagnitud(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/magnitudes/$id'),
      headers: ApiConfig.getHeaders(),
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Error al actualizar magnitud');
  }

  // LOCATIONS
  static Future<List<dynamic>> getLocations() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/locations/list'),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Error al cargar ubicaciones');
  }

  static Future<Map<String, dynamic>> createLocation(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/locations'),
      headers: ApiConfig.getHeaders(),
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Error al crear ubicación');
  }

  static Future<void> deleteLocation(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/locations/$id'),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar ubicación');
    }
  }

  // SENSORS
  static Future<List<Sensor>> getSensors() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/sensor/list'),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Sensor.fromJson(e)).toList();
      }
    } catch (e) {
      throw Exception("Error al cargar sensores: '$e'");
    }
    return [];
  }

  static Future<Map<String, dynamic>> createSensor(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/sensors'),
      headers: ApiConfig.getHeaders(),
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Error al crear sensor');
  }

  static Future<void> deleteSensor(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/sensors/$id'),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar sensor');
    }
  }

  // MEASUREMENTS
  static Future<List<MedicionResponse>> getMeasurements() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/measurements/list'),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MedicionResponse.fromJson(e)).toList();
      }
    } catch (e) {
      throw Exception("Error al cargar mediciones: '$e'");
    }
    return [];
  }

  static Future<String> createMeasurement(Medicion data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/measurements'),
        headers: ApiConfig.getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception('Error al crear medición: $e');
    }
    return "";
  }

  // UNITS
  static Future<List<UnidadResponse>> getUnits() async {
    try {
       final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/units/list'),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => UnidadResponse.fromJson(e)).toList();
      } else {
        throw Exception('Error al cargar unidades');
      }
    }
    catch (e) {
      throw Exception("Error al cargar unidades: '$e'");
    }
  }

  // AUTH
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/login_check'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }
}
