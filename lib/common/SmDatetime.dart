import 'dart:developer';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class SmDatetimePicker extends StatefulWidget {
  //region Khai báo biến
  final String format;
  final String labelText;
  final TextEditingController controller;
  ValueChanged<dynamic> onChanged;
  ValueNotifier<DateTime> firstDate;
  ValueNotifier<DateTime> lastDate;
  bool isLastDate;
  bool isTiengAnhOrVN;

  //endregion
  SmDatetimePicker(
      {Key key,
      this.format,
      this.labelText,
      this.controller,
      this.onChanged,
      this.firstDate,
      this.lastDate,
      this.isLastDate,
      this.isTiengAnhOrVN})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BasicDateFieldCustom(
        format: format,
        labelText: labelText,
        controller: controller,
        onChanged: onChanged,
        firstDate: firstDate,
        lastDate: lastDate,
        isLastDate: isLastDate);
  }
}

class _BasicDateFieldCustom extends State<SmDatetimePicker> {
//region Khai báo biến
  final String format;
  final String labelText;
  final TextEditingController controller;
  ValueChanged<dynamic> onChanged;
  ValueNotifier<DateTime> firstDate;
  ValueNotifier<DateTime> lastDate;
  bool isLastDate;
  bool isTA;
  //endregion
  _BasicDateFieldCustom({@required this.format,
    this.labelText,
    this.controller,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.isLastDate});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isTiengAnhOrVN != null){
      isTA = widget.isTiengAnhOrVN;
    }
    else{
      isTA = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(
              color: Colors.blue, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(
              color: Colors.blue, width: 1.0),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(5.0),
        // icon: Icon(Icons.calendar_today),
        hintText: 'Nhập ngày tháng năm',
        labelText: labelText,
      ),
      format: DateFormat(format),
      onChanged: (value) {
        if (value == null)
        {
            if(!isLastDate)
              onChanged(DateTime(1900,1,1));
            else
              onChanged(DateTime(2100,1,1));
        }
        onChanged(value);
      },
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: (isLastDate == true) ? firstDate.value : DateTime(1900),
          initialDate: (isLastDate == false)
              ? ((firstDate.value == DateTime(1900) || firstDate.value == null)
                  ? ((lastDate.value == DateTime(2100))
                      ? DateTime.now()
                      : lastDate.value)
                  : firstDate.value)
              : ((lastDate.value == DateTime(2100) || lastDate.value == null)
                  ? ((firstDate.value == DateTime(1900))
                      ? DateTime.now()
                      : firstDate.value)
                  : lastDate.value),
          lastDate: (isLastDate == false) ? lastDate.value : DateTime(2100),
          // region Đổi ngôn ngữ
          builder: (context, child) => Localizations.override(
            context: context,
            locale: isTA ? Locale('en') : Locale('vi'),
            child: child,
          ),
          //endregion
        );
      },
    );
  }
}
