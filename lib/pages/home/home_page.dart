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
 
}