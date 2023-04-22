import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:via_cep/models/ceps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CepService {
  static Future<Cep> fetchCep({required String cep}) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return Cep.fromJson(decodedJson);
    } else {
      throw Exception('Requisição inválida!');
    }
  }

 static Future<void> saveCep({required String cep}) async {
  final prefs = await SharedPreferences.getInstance();
  final cepList = prefs.getStringList('cepList') ?? [];
  
  if (!cepList.contains(cep)) {
    cepList.add(cep);
    await prefs.setStringList('cepList', cepList);
  }
}


  Future<void> saveLastCep(String cep) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCepKey, cep);
  }


}