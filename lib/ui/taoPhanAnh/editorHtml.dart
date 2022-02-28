import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart' show parse;
import 'package:html_editor_enhanced/html_editor.dart';



class HtmlEditorExampleApp extends StatefulWidget {
  HtmlEditorExampleApp({Key key}) : super(key: key);


  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExampleApp> {
  String result = "";
  final HtmlEditorController controller = HtmlEditorController();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
        HtmlEditor(
          controller: controller, //required
          hint: 'Nội dung câu hỏi...',
            //initalText: "text content initial, if any",
            options: HtmlEditorOptions(
              // height: 400,
            ),callbacks: Callbacks(
          onChange: (String changed) {
            print("content changed to $changed");
            if(mounted){ setState(() {

              HtmlTags.removeTag(

                callback: (string) {

                },
              );
            });}
          },
          onEnter: () {
            print("enter/return pressed");
          },
          onFocus: () {
            print("editor focused");
          },
          onBlur: () {
            print("editor unfocused");
          },
          onBlurCodeview: () {
            print("codeview either focused or unfocused");
          },
          onInit: () {
            print("init");
          },
          onKeyDown: (int keyCode) {
            print("$keyCode key downed");
          },
          onKeyUp: (int keyCode) {
            print("$keyCode key released");
          },
          onPaste: () {
            print("pasted into editor");
          },
        ),

            toolbar: [
              Style(),
              Font(buttons: [FontButtons.bold, FontButtons.underline,
                FontButtons.italic],
              )
            ]
          )

            ],
          ),
        ),
      ),
    );
  }
}
class HtmlTags {

  static void removeTag({ htmlString, callback }){
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}