import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:via_cep/models/ceps.dart';

class CepService {
  static Future<Cep> fetchCep({required String cep}) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return Cep.fromJson(decodedJson);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}