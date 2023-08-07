import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class SelectBox extends StatefulWidget {
  const SelectBox({
    super.key,
    required this.list,
    required this.hint,
  });

  final List<String> list;
  final String hint;

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  final double paddingSize = 14;
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    void onChanged(String? value) {
      setState(() {
        if (value != null) {
          dropDownValue = value;
        }
      });
    }

    return Padding(
      padding: EdgeInsets.only(right: 8, top: paddingSize, bottom: paddingSize),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: radius_5,
        ),
        child: DropdownButton(
          value: dropDownValue,
          hint: Text(widget.hint),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          isExpanded: true,
          underline: const SizedBox(),
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => onChanged(value),
        ),
      ),
    );
  }
}
