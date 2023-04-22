import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:via_cep/models/ceps.dart';
import 'package:via_cep/services/ceps_services.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Cep? _cep;
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();

  Future<void> _searchCep() async {
    if (_formKey.currentState!.validate()) {
      try {
        final cep = await CepService.fetchCep(cep: _cepController.text);
        setState(() {
          _cep = cep;
        });
      } on PlatformException catch (error) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Erro'),
            content: Text(error.message ?? 'Erro desconhecido'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Erro desconhecido'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
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
                onPressed: _searchCep,
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
      ),
    );
  }
}