import 'package:flutter/material.dart';
import 'package:mynote/model/city_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';

const _cityTable = 'city';
const _columnCityId = 'id';
const _columnProvinceIdRelative = 'provinceId';

Future<int> createCity(CityModel city) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_cityTable, city.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createCity(): $err");
  }

  return id;
}

Future<List<Map<String, dynamic>>> getCities() async {
  late Future<List<Map<String, dynamic>>> cities;
  try {
    final db = await SQLHelper.getDb();
    cities = db.query(_cityTable);
  } catch (err) {
    debugPrint("getCities(): $err");
  }

  return cities;
}

Future<List<Map<String, dynamic>>> getCitiesByProvinceId(int idProvince) async {
  late Future<List<Map<String, dynamic>>> cities;
  try {
    final db = await SQLHelper.getDb();
    cities = db.query(_cityTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("getCitiesByProvinceId(): $err");
  }

  return cities;
}

Future<List<Map<String, dynamic>>> getCity(int id) async {
  late Future<List<Map<String, dynamic>>> city;

  try {
    final db = await SQLHelper.getDb();

    city = db.query(_cityTable,
        where: "$_columnCityId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getCity(): $err");
  }

  return city;
}

Future<int> updateCity(CityModel city) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(_cityTable, city.toMap(),
        where: "$_columnCityId = ?", whereArgs: [city.id]);
  } catch (err) {
    debugPrint("updateCity(): $err");
  }

  return result;
}

// Delete a single item by id
Future<void> deleteCity(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_cityTable, where: "$_columnCityId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an city: $err");
  }
}

Future<void> deleteCityByProvinceId(int idProvince) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_cityTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("Something went wrong when deleting city: $err");
  }
}
