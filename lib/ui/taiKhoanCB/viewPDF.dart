import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pakn2021/core/services/callApi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewPDFVB extends StatefulWidget {

  final int idDuThao;
  final String linkpdf;


  ViewPDFVB({this.idDuThao,this.linkpdf});

  @override
  _ViewPDF createState() => _ViewPDF();
}

class _ViewPDF extends State<ViewPDFVB> {

  bool isLoading =  false;
  String localPath;
  String PDF_URL = "";
  SharedPreferences sharedStorage;

  Future<String> loadPDF() async {
      PDF_URL = widget.linkpdf;
    var response = await http.get(Uri.parse(PDF_URL));
    var dir = await getApplicationDocumentsDirectory();//truy cap vao muc chinh
    //File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
    File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi

    await file.writeAsBytes(response.bodyBytes,flush: true);
    return file.path;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.fetchData();
    loadPDF().then((value) {
      if (mounted) {    setState(()
      {
        localPath =  value;
      });}
    }


    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localPath!= null
          ? PDFView(filePath: localPath)
          :Center(child: CircularProgressIndicator()),
    );
  }
}
