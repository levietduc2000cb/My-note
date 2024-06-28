import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/province_model.dart';

const _provincesTable = 'provinces';

const _columnProvinceId = 'id';
const _columnProvinceName = 'provinceName';
const _columnProvinceUserId = 'userId';

Future<int> createProvince(ProvinceModel province) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_provincesTable, province.toMapHasUserId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createProvince(): $err");
  }

  return id;
}

// Read all provinces
Future<List<Map<String, dynamic>>> getProvinces() async {
  late Future<List<Map<String, dynamic>>> provinces;
  try {
    final db = await SQLHelper.getDb();
    provinces = db.query(_provincesTable);
  } catch (err) {
    debugPrint("getProvinces(): $err");
  }

  return provinces;
}

// Read all provinces
Future<List<Map<String, dynamic>>> getProvincesByUserId(int userId) async {
  late Future<List<Map<String, dynamic>>> provinces;

  try {
    final db = await SQLHelper.getDb();

    provinces = db.query(_provincesTable,
        where: "$_columnProvinceUserId = ?", whereArgs: [userId]);
  } catch (err) {
    debugPrint("getProvincesByUserId(): $err");
  }

  return provinces;
}

// Read a single item by id
Future<List<Map<String, dynamic>>> getProvince(int id) async {
  late Future<List<Map<String, dynamic>>> province;

  try {
    final db = await SQLHelper.getDb();

    province = db.query(_provincesTable,
        where: "$_columnProvinceId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getProvince(): $err");
  }

  return province;
}

// Read a single item by id
Future<List<Map<String, dynamic>>> getProvinceByName(
    String nameProvince) async {
  late Future<List<Map<String, dynamic>>> province;

  try {
    final db = await SQLHelper.getDb();

    province = db.query(_provincesTable,
        where: "$_columnProvinceName = ?", whereArgs: [nameProvince], limit: 1);
  } catch (err) {
    debugPrint("getProvinceByName(): $err");
  }

  return province;
}

// Read list provinces by provinceName
Future<List<Map<String, dynamic>>> getProvincesByProvinceName(
    String name, String? orderBy) async {
  late Future<List<Map<String, dynamic>>> provinces;
  try {
    name = "%$name%";
    final db = await SQLHelper.getDb();
    if (orderBy != null && orderBy.isNotEmpty) {
      provinces = db.query(_provincesTable,
          where: "$_columnProvinceName LIKE ?",
          whereArgs: [name],
          orderBy: "$_columnProvinceName $orderBy");
    } else {
      provinces = db.query(_provincesTable,
          where: "$_columnProvinceName LIKE ?", whereArgs: [name]);
    }
  } catch (err) {
    debugPrint("getProvince(): $err");
  }

  return provinces;
}

// Read list provinces by provinceName
Future<List<Map<String, dynamic>>> getProvincesByProvinceNameAndUserId(
    String name, int userId, String? orderBy) async {
  late Future<List<Map<String, dynamic>>> provinces;
  try {
    name = "%$name%";
    final db = await SQLHelper.getDb();
    if (orderBy != null && orderBy.isNotEmpty) {
      provinces = db.query(_provincesTable,
          where: "$_columnProvinceUserId = ? AND $_columnProvinceName LIKE ?",
          whereArgs: [userId, name],
          orderBy: "$_columnProvinceName $orderBy");
    } else {
      provinces = db.query(_provincesTable,
          where: "$_columnProvinceUserId = ? AND $_columnProvinceName LIKE ?",
          whereArgs: [userId, name]);
    }
  } catch (err) {
    debugPrint("getProvince(): $err");
  }

  return provinces;
}

// Update an province by id
Future<int> updateProvince(ProvinceModel province) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(
        _provincesTable, {_columnProvinceName: province.provinceName},
        where: "$_columnProvinceId = ?", whereArgs: [province.id]);
  } catch (err) {
    debugPrint("updateProvince(): $err");
  }

  return result;
}

// Delete a single item by id
Future<void> deleteProvince(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_provincesTable,
        where: "$_columnProvinceId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an item: $err");
  }
}
