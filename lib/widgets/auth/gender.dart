import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  var radioItem;
  Gender({this.radioItem});
  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  var radioItem = '';
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          groupValue: radioItem,
          title: Text('Male'),
          value: 'male',
          selected: true,
          onChanged: (val) {
            setState(() {
              radioItem = val;
              widget.radioItem(val);
              print(radioItem);
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Femele'),
          value: 'femele',
          onChanged: (val) {
            setState(() {
              radioItem = val;
              widget.radioItem(val);
              print(radioItem);
            });
          },
        ),
      ],
    );
  }
}
