import 'package:flutter/material.dart';

class SearchProvinceForm extends StatefulWidget {
  const SearchProvinceForm({super.key, required this.handleSearch});

  final Future<void> Function(String?, String?) handleSearch;

  @override
  State<SearchProvinceForm> createState() => _SearchProvinceForm();
}

class _SearchProvinceForm extends State<SearchProvinceForm> {
  final _searchProvinceKey = GlobalKey<FormState>();

  TextEditingController provinceName = TextEditingController();
  String selectedSort = 'Default';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _searchProvinceKey,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: provinceName,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        hintText: 'Search province...',
                        border: InputBorder.none,
                    )
                  )),
              IconButton(
                onPressed: search,
                icon: const Icon(Icons.search),
              ),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.black,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: InputBorder.none
                        ),
                    value: selectedSort,
                    items: <String>['Default', 'High to low', 'Low to high']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSort = newValue!;
                      });
                    },
                  ))
                ],
              ),
            )
          ],
        )
    );
  }

  void search(){
    widget.handleSearch(provinceName.text, selectedSort);
  }
}
