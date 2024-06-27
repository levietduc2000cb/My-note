import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/scenic_spot_model.dart';

const _scenicSpotTable = 'scenicSpot';
const _columnScenicSpotId = 'id';
const _columnProvinceIdRelative = 'provinceId';

Future<int> createScenicSpot(ScenicSpotModel scenicSpot) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_scenicSpotTable, scenicSpot.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createScenicSpot(): $err");
  }

  return id;
}


Future<List<Map<String, dynamic>>> getScenicSpots() async {
  late Future<List<Map<String, dynamic>>> scenicSpots;
  try {
    final db = await SQLHelper.getDb();
    scenicSpots = db.query(_scenicSpotTable);
  } catch (err) {
    debugPrint("getScenicSpots(): $err");
  }

  return scenicSpots;
}

Future<List<Map<String, dynamic>>> getScenicSpotsByProvinceId(int idProvince) async {
  late Future<List<Map<String, dynamic>>> scenicSpots;
  try {
    final db = await SQLHelper.getDb();
    scenicSpots = db.query(_scenicSpotTable, where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("getScenicSpotsByProvinceId(): $err");
  }

  return scenicSpots;
}


Future<List<Map<String, dynamic>>> getScenicSpot(int id) async {
  late Future<List<Map<String, dynamic>>> scenicSpot;

  try {
    final db = await SQLHelper.getDb();

    scenicSpot = db.query(_scenicSpotTable,
        where: "$_columnScenicSpotId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getScenicSpot(): $err");
  }

  return scenicSpot;
}


Future<int> updateScenicSpot(ScenicSpotModel scenicSpot) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(_scenicSpotTable, scenicSpot.toMap(),
        where: "$_columnScenicSpotId = ?", whereArgs: [scenicSpot.id]);
  } catch (err) {
    debugPrint("updateScenicSpot(): $err");
  }

  return result;
}


Future<void> deleteScenicSpot(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_scenicSpotTable, where: "$_columnScenicSpotId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an scenic spot: $err");
  }
}

Future<void> deleteScenicSpotByProvinceId(int idProvince) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_scenicSpotTable, where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an license plate: $err");
  }
}