import 'package:flutter/material.dart';
import 'package:nocrime/screens/predict_other_screen.dart';

class SelectBoxWidget extends StatefulWidget {
  final Future<List<String>> future;
  final String hint;
  final void Function(String) onChanged;
  final String? dropDownValue;

  const SelectBoxWidget({
    required Key key,
    required this.future,
    required this.dropDownValue,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectBoxWidget> createState() => _SelectBoxWidgetState();
}

class _SelectBoxWidgetState extends State<SelectBoxWidget> {
  String? dropDownValue;

  void setPredictionParms(String? value) {
    var keyTag = widget.key.toString();
    predictionParms[
        keyTag.substring(2, keyTag.length - 2).replaceAll('\'', '')] = value;
  }

  @override
  Widget build(BuildContext context) {
    const double paddingSize = 6;
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 3, right: 20, top: paddingSize, bottom: paddingSize),
                child: Container(
                  // width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(131, 131, 255, 0.4),
                    border:
                        Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton(
                    elevation: 8,
                    dropdownColor: const Color.fromARGB(255, 37, 37, 47),
                    value: widget.dropDownValue,
                    hint: Text(
                      widget.hint,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    menuMaxHeight: 500,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print('$value');
                      if (value != null) {
                        widget.onChanged(value);
                        setPredictionParms(value);
                      }
                    },
                  ),
                ),
              )
            : const CircularProgressIndicator();
      },
      future: widget.future,
    );
  }
}
