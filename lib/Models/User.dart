import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  final String name;
  final int? age;
  final String email;
  final String password;
  

  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'email': email,
        'password': password,
      };

  
}

