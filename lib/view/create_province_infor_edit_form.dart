import 'package:flutter/material.dart';
import 'package:mynote/view/input_form.dart';

class CreateProvinceInforEditForm extends StatefulWidget {
  const CreateProvinceInforEditForm({super.key,required this.title, required this.cancel, required this.createNew});

  final title;
  final VoidCallback cancel;
  final Future<void> Function(Map<String, dynamic>) createNew;

  @override
  State<CreateProvinceInforEditForm> createState() => _CreateProvinceInforEditForm();
}

class _CreateProvinceInforEditForm extends State<CreateProvinceInforEditForm> {
  final _createProvinceInforEditFormKey = GlobalKey<FormState>();

  TextEditingController otherValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    return  Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 80,
        ),
        color: Colors.black87,
        child: Form(
          key: _createProvinceInforEditFormKey,
          child: SingleChildScrollView(
              child: Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'New $title',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      InputForm(
                          keyboardType: title == 'License plate' ? TextInputType.number : TextInputType.text,
                          controller: otherValue,
                          textInputAction: TextInputAction.next,
                          labelText: widget.title,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your $title';
                            }
                            else if(title == 'License plate' && int.tryParse(value) != null){
                              return 'Please enter an integer';
                            }
                            return null;
                          }),
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

  Future<void> submit() async {
    if (_createProvinceInforEditFormKey.currentState!.validate()) {
      Map<String, dynamic> provinceObject = {
        "otherValue": otherValue.text,
      };
      await widget.createNew(provinceObject);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill input')),
      );
    }
  }

}
