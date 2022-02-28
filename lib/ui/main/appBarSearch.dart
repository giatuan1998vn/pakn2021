import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


class AppbartimKiem extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double barHeight = 50.0;


  AppbartimKiem({  this.title}) ;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 100.0);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: ClipPath(
          //clipper: WaveClip(),
          child: Container(
            height: MediaQuery.of(context).size.width*0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xff3064D0),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(48.0),

              ),
            ),
            child: Column(children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,child: IconButton(
                          icon: new Icon(Icons.clear,color: Colors.white,),
                          onPressed: () => Navigator.of(context),
                        ),),)),
                  Flexible(
                    flex:25,
                    child: Align(alignment: Alignment.center,
                      child: Text(title,style: TextStyle(fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),),),),





                ],
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),

                  child: Container(
                    color: Colors.white,
                    child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.black45,
                    ),
                    child: new TextField(
                      //controller: usernameController,
                      cursorColor: Colors.black45,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffC0C0C0), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: new OutlineInputBorder(
                            borderSide:
                            new BorderSide(color: Colors.black45)),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color(0xffC0C0C0),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                        // prefixIcon: const Icon(
                        //   Icons.person,
                        //   color: Colors.black,
                        // ),

                      ),
                    ),
                  ),)),
            ],),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + 100)
    );
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 30;
    final highPoint = size.height - 60;

    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}