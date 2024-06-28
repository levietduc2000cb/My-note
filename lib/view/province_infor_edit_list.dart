import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'create_province_infor_edit_form.dart';

class ProvinceInforEditList extends StatefulWidget {
  const ProvinceInforEditList(
      {super.key,
      required this.idProvince,
      required this.titleForm,
      required this.handleDelete,
      required this.handleCreate,
      required this.render,
      required this.idKey,
      required this.nameKey});

  final int idProvince;
  final String titleForm;
  final Future<dynamic> Function() render;
  final Future<dynamic> Function(dynamic) handleCreate;
  final Future<dynamic> Function(dynamic) handleDelete;
  final String idKey;
  final String nameKey;

  @override
  State<ProvinceInforEditList> createState() => _ProvinceInforEditList();
}

class _ProvinceInforEditList extends State<ProvinceInforEditList> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    renderInforList();
  }

  @override
  Widget build(BuildContext context) {
    String titleForm = widget.titleForm;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Text(
                      titleForm,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )))
          ],
        ),
        Column(
          children: [
            for (dynamic data in dataList)
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      // Màu nền
                      border: Border.all(
                        color: Colors.grey, // Màu border
                        width: 2.0, // Độ rộng border
                      ),
                      borderRadius: BorderRadius.circular(6.0), // Bo góc border
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data[widget.nameKey].toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white70),
                        ),
                        IconButton(
                            onPressed: () =>
                                deleteItemFromList(data[widget.idKey]),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ))
                ],
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              onPressed: () => showForm(context),
              child: Text('New $titleForm'),
            ))
          ],
        )
      ],
    );
  }

  Future<void> renderInforList() async {
    dynamic result = await widget.render();
    setState(() {
      dataList = result ?? [];
    });
  }

  Future<void> deleteItemFromList(int id) async {
    String title = widget.titleForm;
    showConfirmationDialog(
        context: context,
        title: 'Delete',
        content: 'Do you want to delete this $title',
        onConfirm: () async {
          try {
            await widget.handleDelete(id);
            renderInforList();
          } catch (e) {
            if (!mounted) return;
            showNotification(context, "Delete a failed!!!");
          }
        });
  }

  void showForm(BuildContext context) {
    String title = widget.titleForm;
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CreateProvinceInforEditForm(
            title: title,
            cancel: () => Navigator.of(context).pop(),
            createNew: (dynamic data) async {
              Navigator.of(context).pop();
              data['provinceId'] = widget.idProvince;
              await widget.handleCreate(data);
              renderInforList();
            },
          );
        });
  }

  void showNotification(BuildContext context, String? title) {
    final snackBar = SnackBar(
      content: Text("$title"),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
