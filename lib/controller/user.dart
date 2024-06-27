import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/user_model.dart';

const _usersTable = 'users';
const _columnUserId = 'id';
const _columnUserName = 'userName';
const _columnUserPassword = 'password';

Future<int> createUser(UserModel user) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_usersTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createUser(): $err");
  }
  return id;
}

Future<List<Map<String, dynamic>>> getUserByUserNameAndPassword(String userName, String password) async {
  late Future<List<Map<String, dynamic>>> user;

  try {
    final db = await SQLHelper.getDb();
    user = db.query(_usersTable,
        where: "$_columnUserName = ? AND $_columnUserPassword = ?", whereArgs: [userName, password], limit: 1);
  } catch (err) {
    debugPrint("getUserByUserNameAndPassword(): $err");
  }
  return user;
}

Future<List<Map<String, dynamic>>> checkUserNameExist(String userName) async {
  late Future<List<Map<String, dynamic>>> user;

  try {
    final db = await SQLHelper.getDb();
    user = db.query(_usersTable,
        where: "$_columnUserName = ?", whereArgs: [userName], limit: 1);
  } catch (err) {
    debugPrint("checkUserNameExist(): $err");
  }
  return user;
}