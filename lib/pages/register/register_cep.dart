import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:via_cep/pages/home/home_page.dart';
import 'package:via_cep/services/ceps_services.dart';

class CepRegisterPage extends StatefulWidget {
  @override
  _CepRegisterPageState createState() => _CepRegisterPageState();
}

class _CepRegisterPageState extends State<CepRegisterPage> {
 bool _isLoading = false;
  final String _lastCepKey = 'last_cep';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: const Text('Cadastro de CEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cepController,
                decoration:const InputDecoration(
                  labelText: 'CEP',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP obrigatório';
                  } else if (value.length != 8) {
                    return 'CEP inválido';
                  } else {
                    return null;
                  }
                },
              ),
             const SizedBox(height: 16),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[900],
                ),
                onPressed: _isLoading ? null : _handleSave,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await CepService().saveLastCep(_cepController.text);
      setState(() {
        _isLoading = false;
      });
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    }
  }
}