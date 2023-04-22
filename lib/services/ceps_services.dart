import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep/models/ceps.dart';

class ViaCepService {
  static Future<Ceps> fetchCep({required ceps}) async {
    final response = await http.get('https://viacep.com.br/ws/$ceps/json/' as Uri);
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return Ceps.fromJson(decodedJson);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}