import 'package:flutter/material.dart';
import 'package:via_cep/services/ceps_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  late String _result;

 @override
  void dispose() {
    _searchCepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar CEPS'),
      ),
      body: SingleChildScrollView(
        padding:const  EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _searchCep(),
           _searchCepButton(),
          ],
        ),
      ),
    );
  }
Widget _searchCep() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(labelText: 'CEP'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

   Widget _circularLoading() {
    return const CircularProgressIndicator(
      value: 15.0,
    );
  }

  Widget _searchCepButton() {
    Widget buttonContent = _loading
        ? _circularLoading()
        : const Text('Consultar');

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        onPressed: _searchCep,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
 
}