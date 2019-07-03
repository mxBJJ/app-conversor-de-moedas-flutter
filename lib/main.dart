import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/all";

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isNotEmpty) {
      double real = double.parse(text);

      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    } else {
      dolarController.text = "";
      euroController.text = "";
    }
  }

  void _dolarChanged(String text) {
    if (text.isNotEmpty) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    } else {
      realController.text = "";
      euroController.text = "";
    }
  }

  void _euroChanged(String text) {
    if (text.isNotEmpty) {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    } else {
      realController.text = "";
      dolarController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Icon(
                  Icons.monetization_on,
                  size: 150.0,
                  color: Colors.amber,
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              dolar = double.parse(snapshot.data["USD"]["high"]
                  .toString()
                  .replaceFirst(RegExp(','), '.'));
              euro = double.parse(snapshot.data["EUR"]["high"]
                  .toString()
                  .replaceFirst(RegExp(','), '.'));

              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  title: Text("Money Convert"),
                  backgroundColor: Colors.amber,
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 120.0, color: Colors.amber),
                      Divider(),
                      Divider(),
                      buildTextInput(
                          "Real", realController, "R\$", _realChanged),
                      Divider(),
                      buildTextInput(
                          "Dólar", dolarController, "U\$\$", _dolarChanged),
                      Divider(),
                      buildTextInput("Euro", euroController, "€", _euroChanged),
                    ],
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildTextInput(String text, TextEditingController controller,
      String prefix, Function f) {
    return TextField(
      controller: controller,
      onChanged: f,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.amber, fontSize: 30.0),
      decoration: InputDecoration(
          prefixText: prefix,
          labelText: text,
          labelStyle: TextStyle(
            color: Colors.amber,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    );
  }
}
