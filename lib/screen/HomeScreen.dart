import 'package:flutter/material.dart';
import 'package:login/class/classUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<User> usersList = [];

  String? _users;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _users = pref.getString('users');
    if (_users != null) {
      List<dynamic> userMaps = jsonDecode(_users!);
      setState(
        () {
          usersList = userMaps
              .map(
                (map) => User.fromMap(
                  Map<String, String>.from(map),
                ),
              )
              .toList();
        },
      );
    }
  }

  void _saveUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Map<String, String>> userMaps =
        usersList.map((user) => user.toMap()).toList();
    await pref.setString(
      'users',
      jsonEncode(userMaps),
    );
  }

  void _addUser() {
    if (_controllerEmail.text.isNotEmpty && _controllerEmail.text.isNotEmpty) {
      User newUser =
          User(email: _controllerEmail.text, password: _controllerPass.text);
      setState(() {
        usersList.add(newUser);
      });
      _saveUsers();
      _controllerEmail.clear();
      _controllerPass.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Email'),
              controller: _controllerEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              controller: _controllerPass,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Registrate'),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final user = usersList[index];
                  return ListTile(
                    title: Text(user.email),
                    subtitle: Text(user.password),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
