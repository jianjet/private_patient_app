import 'package:flutter/material.dart';
import 'tracker.dart';

class MoreSypmtoms extends StatefulWidget {
  const MoreSypmtoms({Key? key}) : super(key: key);
  @override 
  State<StatefulWidget> createState() => MoreSypmtomsForms();
}

class MoreSypmtomsForms extends State<MoreSypmtoms> {

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Widget _formsSymptoms() {
    return TextFormField(
      controller: myController,
      decoration: const InputDecoration(labelText: 'Symptoms'),
      validator: (String? value) {
        if (value == null) {
          return 'Don\'t write anything if no symptoms';
        }
        return null;
      },
      onSaved: (String? value) {
      },
    );
  }

  Widget _doneButton(){
    return Container(
      margin: const EdgeInsets.all(16),
      child: FloatingActionButton.extended(
        onPressed: () {
          records.setsMore(myController.text);
          Navigator.pop(context);
        },
        //margin: const EdgeInsets.all(16),
        label: const Text('Done')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Symptoms'),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _formsSymptoms(),
              _doneButton()
            ],
          ),
        ),
      ),
    );
  }
}