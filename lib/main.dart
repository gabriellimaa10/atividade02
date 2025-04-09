import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atividade02',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UserSearchScreen(),
    );
  }
}

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String? name;
  String? email;
  String? avatar;
  String? errorMessage;

  Future<void> fetchUser(int id) async {
    final url = Uri.parse('https://reqres.in/api/users/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          name = "nome: ${data['first_name']} ${data['last_name']}";
          email = "email: ${data['email']}";
          avatar = data['avatar'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = "Não achamos esse usuário!";
          name = null;
          email = null;
          avatar = null;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "Erro ao buscar usuário! Verifique sua net patrão.";
        name = null;
        email = null;
        avatar = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Usuário'),
      backgroundColor: Colors.blue.shade200),
      backgroundColor: Colors.green.shade100,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Digite um ID de 1 a 12',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                final id = int.tryParse(_controller.text);
                if (id != null && id > 0 && id <= 12) {
                  fetchUser(id);
                } else {
                  setState(() {
                    errorMessage = "ID não existe! Insira um número entre 1 e 12 por favor.";
                  });
                }
              },
              child: const Text('Buscar ID'),
            ),
            const SizedBox(height: 30),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (name != null && email != null && avatar != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(avatar!),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    name!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(email!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
