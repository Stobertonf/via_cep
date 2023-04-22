import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:via_cep/models/ceps.dart';
import 'package:via_cep/shared/snackBar.dart';
import 'package:via_cep/services/ceps_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Cep? _cep;
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final String _lastCepKey = 'last_cep';

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  void _handleSearchCep() {
    _searchCep(context);
  }

  

  Future<void> _searchCep(BuildContext context) async {
    if (_cepController.text.isEmpty) {
      _showSnackbar(context, 'Por favor, digite um CEP.');
      return;
    }

    try {
      final cep = await CepService.fetchCep(cep: _cepController.text);
      setState(() {
        _cep = cep;
      });
      showSuccessSnackbar();
    } on CepNotFound catch (error) {
      _showCepNotFoundDialog(context);
    } on PlatformException catch (error) {
      showErrorSnackbar(error.message ?? 'Erro desconhecido');
    } catch (error) {
      showErrorSnackbar('Cep Inválido!!!');
    }
  }

  Future<void> _showCepNotFoundDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('CEP não encontrado'),
          content: const Text('Deseja cadastrar este CEP?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cadastrar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await CepService.saveLastCep(_cepController.text);
      _showSnackbar(context, 'CEP cadastrado com sucesso!');
    }
  }

  

  Future<void> saveLastCep(String cep) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCepKey, cep);
  }

  Future<String?> getLastCep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCepKey);
  }


  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'CEP encontrado com sucesso!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consulta CEP'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _cepController,
                  decoration: const InputDecoration(
                    labelText: 'Digite o CEP',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O CEP é obrigatório';
                    } else if (value.length != 8) {
                      return 'O CEP deve ter 8 dígitos';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _handleSearchCep,
                  child: const Text('Buscar'),
                ),
                if (_cep != null) ...[
                  const SizedBox(height: 16),
                  Text('Endereço: ${_cep!.logradouro}'),
                  Text('Bairro: ${_cep!.bairro}'),
                  Text('Cidade/UF: ${_cep!.localidade} / ${_cep!.uf}'),
                ],
              ],
            ),
          ),
        ));
  }
}