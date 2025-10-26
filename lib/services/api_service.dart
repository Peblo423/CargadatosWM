import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cargadatos/classes/magnitud_response.dart';
import 'package:cargadatos/classes/magnitud_sent.dart';
import 'package:cargadatos/classes/medicion_response.dart';
import 'package:cargadatos/classes/medicion_sent.dart';
import 'package:cargadatos/classes/sensor_response.dart';
import 'package:cargadatos/classes/sensor_sent.dart';
import 'package:cargadatos/classes/unidad_response.dart';
import 'package:cargadatos/classes/ubicacion_response.dart';
import 'package:cargadatos/classes/ubicacion_sent.dart';

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
  //============== HELPERS PRIVADOS ==============
  static Future<T> _get<T>(String endpoint, T Function(dynamic) fromJson) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception('Error al cargar datos de $endpoint');
      }
    } catch (e) {
      throw Exception('Fallo en la petición a $endpoint: $e');
    }
  }

  static Future<void> _create(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.getHeaders(),
        body: json.encode(data),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Error al crear en $endpoint. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo en la petición a $endpoint: $e');
    }
  }

  static Future<void> _delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Error al eliminar en $endpoint. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo en la petición a $endpoint: $e');
    }
  }

  //============== AUTH ==============
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
      // Si el login falla, lanza un error específico.
      throw Exception('Usuario o contraseña incorrectos');
    } catch (e) {
      // Relanza el error para que la UI pueda manejarlo.
      rethrow;
    }
  }

  //============== MAGNITUDES ==============
  static Future<List<MagnitudResponse>> getMagnitudes() async {
    return await _get('/api/magnitudes/list',
        (data) => (data as List).map((e) => MagnitudResponse.fromJson(e)).toList());
  }

  static Future<void> createMagnitud(MagnitudSent data) async {
    return await _create('/api/magnitudes', data.toJson());
  }

  static Future<void> deleteMagnitud(String id) async {
    return await _delete('/api/magnitudes/$id');
  }

  //============== LOCATIONS ==============
  static Future<List<UbicacionResponse>> getLocations() async {
    return await _get('/api/locations/list',
        (data) => (data as List).map((e) => UbicacionResponse.fromJson(e)).toList());
  }

  static Future<void> createLocation(UbicacionSent data) async {
    return await _create('/api/locations', data.toJson());
  }

  static Future<void> deleteLocation(String id) async {
    return await _delete('/api/locations/$id');
  }

  //============== SENSORS ==============
  static Future<List<SensorResponse>> getSensors() async {
    return await _get(
        '/api/sensor/list', (data) => (data as List).map((e) => SensorResponse.fromJson(e)).toList());
  }

  static Future<void> createSensor(SensorSent data) async {
    return await _create('/api/sensors', data.toJson());
  }

  static Future<void> deleteSensor(String id) async {
    return await _delete('/api/sensors/$id');
  }

  //============== MEASUREMENTS ==============
  static Future<List<MedicionResponse>> getMeasurements() async {
    return await _get('/api/measurements/list',
        (data) => (data as List).map((e) => MedicionResponse.fromJson(e)).toList());
  }

  static Future<void> createMeasurement(MedicionSent data) async {
    return await _create('/api/measurements', data.toJson());
  }

  //============== UNITS ==============
  static Future<List<UnidadResponse>> getUnits() async {
    return await _get(
        '/api/units/list', (data) => (data as List).map((e) => UnidadResponse.fromJson(e)).toList());
  }
}