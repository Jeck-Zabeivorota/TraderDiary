import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trader_diary/Instruments/date_duration.dart';
import '../elements.dart';

class DateFieldController {
  late int _day, _month, _year;

  int get day => _day;
  int get month => _month;
  int get year => _year;

  set day(int value) {
    int maxDay = DateDuration.daysInMonth(_month, _year);
    if (value < 1 || value > maxDay) throw Exception('incorrect day: $value');
    _day = value;
  }

  set month(int value) {
    if (value < 1 || value > 12) throw Exception('incorrect month: $value');
    _month = value;
  }

  set year(int value) {
    if (value < 1 || value > 9999) throw Exception('incorrect year: $value');
    _year = value;
  }

  DateTime get date => DateTime(year, month, day);

  void setValues(DateTime date) {
    _day = date.day;
    _month = date.month;
    _year = date.year;
  }

  DateFieldController(int year, [int month = 1, int day = 1]) {
    this.year = year;
    this.month = month;
    this.day = day;
  }

  DateFieldController.fromDateTime({required DateTime date}) {
    setValues(date);
  }
}

class DateField extends StatefulWidget {
  final DateFieldController controller;

  const DateField({super.key, required this.controller});

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final _dayController = TextEditingController(),
      _monthController = TextEditingController(),
      _yearController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
  }

  void onChanged(TextEditingController control) {
    if (control.text.isEmpty) {
      control.text = '1';
    }

    int value = int.parse(control.text);
    if (value < 1) {
      value = 1;
      control.text = '1';
    }

    if (control == _dayController) {
      final maxDay = DateDuration.daysInMonth(
          widget.controller.month, widget.controller.year);
      if (value > maxDay) {
        value = maxDay;
        control.text = value.toString();
      }
      widget.controller.day = value;
    } else if (control == _monthController) {
      if (value > 12) {
        value = 12;
        control.text = value.toString();
      }
      widget.controller.month = value;
    } else {
      if (value > 9999) {
        value = 9999;
        control.text = value.toString();
      }
      widget.controller.year = value;
    }
  }

  TextField _createField(
    TextEditingController controller,
    double width,
  ) =>
      TextField(
        onChanged: (_) => onChanged(controller),
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyles.text(),
        decoration: InputDecorations.field(width: width),
      );

  @override
  Widget build(BuildContext context) {
    _dayController.text = widget.controller.day.toString();
    _monthController.text = widget.controller.month.toString();
    _yearController.text = widget.controller.year.toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Templates.field(
          label: 'День',
          child: _createField(_dayController, 40),
        ),
        const SizedBox(width: 5),
        Templates.field(
          label: 'Месяц',
          child: _createField(_monthController, 40),
        ),
        const SizedBox(width: 5),
        Templates.field(
          label: 'Год',
          child: _createField(_yearController, 60),
        ),
      ],
    );
  }
}
