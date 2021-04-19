import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {
  DateTime date;
  ValueChanged<DateTime> onSelectedTime;
  TimeComponent({Key key, this.date, this.onSelectedTime}) : super(key: key);
  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _hours = List.generate(24, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _minutes = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _seconds = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  String _hourSelected = '00';
  String _minSelected = '00';
  String _secSelected = '00';

  void invokeCallBack() {
    var newDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      int.parse(_hourSelected),
      int.parse(_minSelected),
      int.parse(_secSelected),
    );
    widget.onSelectedTime(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBox(_hours, (value) {
          setState(() {
            _hourSelected = value;
            invokeCallBack();
          });
        }),
        _buildBox(_minutes, (value) {
          setState(() {
            _minSelected = value;
            invokeCallBack();
          });
        }),
        _buildBox(_seconds, (value) {
          setState(() {
            _secSelected = value;
            invokeCallBack();
          });
        }),
      ],
    );
  }

  Widget _buildBox(List<String> options, ValueChanged<String> onChange) {
    return Container(
      height: 110,
      width: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 10,
            color: Theme.of(context).primaryColor,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: ListWheelScrollView(
        onSelectedItemChanged: (value) =>
            onChange(value.toString().padLeft(2, '0')),
        perspective: 0.01,
        itemExtent: 60,
        physics: FixedExtentScrollPhysics(),
        children: options
            .map<Text>((e) => Text(
                  e,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ))
            .toList(),
      ),
    );
  }
}
