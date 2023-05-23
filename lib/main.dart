import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int id;
  final String email;
  final String password;

  User({this.id, this.email, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}

class DatabaseHelper {
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        email: maps[0]['email'],
        password: maps[0]['password'],
      );
    }

    return null;
  }
}

class RegisterLoginScreen extends StatefulWidget {
  @override
  _RegisterLoginScreenState createState() => _RegisterLoginScreenState();
}

class _RegisterLoginScreenState extends State<RegisterLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginForm = true;
  bool _isLoading = false;

  DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginForm ? 'Login' : 'Register'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  child: Text(_isLoginForm ? 'Login' : 'Register'),
                  onPressed: _isLoading ? null : _submitForm,
                ),
                FlatButton(
                  child: Text(
                      _isLoginForm ? 'Create an account' : 'Have an account? Sign in'),
                  onPressed: () {
                    setState(() {
                      _isLoginForm = !_isLoginForm;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isLoginForm) {
          final user = await _databaseHelper.getUserByEmail(_emailController.text);
          if (user != null && user.password == _passwordController.text) {
            // Login successful
            Navigator.pushReplacementNamed(context as BuildContext, '/home');
          } else {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Invalid credentials'),
                content: Text('Please enter valid email and password.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            );
          }
        } else {
          final newUser = User(
            email: _emailController.text,
            password: _passwordController.text,
          );
          await _databaseHelper.insertUser(newUser);

          // Registration successful
          Navigator.pushReplacementNamed(context as BuildContext, '/home');
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong. Please try again.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
