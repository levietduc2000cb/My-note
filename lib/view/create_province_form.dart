import 'package:flutter/material.dart';
import 'package:mynote/view/input_form.dart';
import '../controller/province.dart';
import '../model/province_model.dart';

class CreateProvinceForm extends StatefulWidget {
  const CreateProvinceForm(
      {super.key, required this.cancel, required this.createProvince});

  final VoidCallback cancel;
  final Future<void> Function(Map<String, dynamic>) createProvince;

  @override
  State<CreateProvinceForm> createState() => _CreateProvinceForm();
}

class _CreateProvinceForm extends State<CreateProvinceForm> {
  final _createProvinceFormKey = GlobalKey<FormState>();

  TextEditingController provinceName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController licensePlate = TextEditingController();
  TextEditingController university = TextEditingController();
  TextEditingController scenicSpot = TextEditingController();
  TextEditingController specialty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 80,
        ),
        color: Colors.black87,
        child: Form(
          key: _createProvinceFormKey,
          child: SingleChildScrollView(
              child: Expanded(
                  child: Column(
            children: [
              const Center(
                child: Text(
                  'Create Province',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              InputForm(
                  keyboardType: TextInputType.text,
                  controller: provinceName,
                  textInputAction: TextInputAction.next,
                  labelText: 'Province',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your province';
                    }
                    return null;
                  }),
              InputForm(
                  controller: city,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  labelText: 'City',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  }),
              InputForm(
                  controller: licensePlate,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  labelText: 'License plate',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your license plate';
                    } else if (!RegExp(r'^\d+(?:,\d+)*$').hasMatch(value)) {
                      return 'The value is not a comma-separated array of numbers';
                    }
                    return null;
                  }),
              InputForm(
                controller: university,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                labelText: 'University(Optional)',
              ),
              InputForm(
                controller: scenicSpot,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                labelText: 'Scenic spot(Optional)',
              ),
              InputForm(
                controller: specialty,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                labelText: 'Specialty(Optional)',
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: ElevatedButton(
                        onPressed: widget.cancel,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6))),
                        child: const Text('Back'),
                      ),
                    )),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: ElevatedButton(
                                onPressed: submit,
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                child: const Text('Create'))))
                  ],
                ),
              )
            ],
          ))),
        ));
  }

  Future<bool> isExistNameProvince(String nameProvince) async {
    nameProvince = nameProvince.trim().toUpperCase();
    List<dynamic> data = await getProvinceByName(nameProvince);
    return data.isNotEmpty ? true : false;
  }

  Future<void> submit() async {
    if (_createProvinceFormKey.currentState!.validate()) {
      if (await isExistNameProvince(provinceName.text) == false) {
        Map<String, dynamic> provinceObject = {
          "provinceName": provinceName.text,
          "city": city.text,
          "licensePlate": licensePlate.text,
          "university": university.text,
          "scenicSpot": scenicSpot.text,
          "specialty": specialty.text
        };
        await widget.createProvince(provinceObject);
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The province name exists!!!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill input')),
      );
    }
  }
}
