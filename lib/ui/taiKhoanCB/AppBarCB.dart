import 'package:flutter/material.dart';
import 'package:pakn2021/ui/taiKhoanCB/timKiemCB.dart';
import 'package:pakn2021/ui/trangChu/timKiem.dart';

class MainAppBarCB extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double barHeight = 50.0;

  MainAppBarCB({  this.title}) ;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex:3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10,top:75),
                      child: Align(
                        alignment: Alignment.topLeft,
                          child:GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Image.asset(
                              "assets/menuleft.png",
                              fit:BoxFit.fill,
                              height: 25,
                              width: 25,
                            ),
                          ),),)),

                Flexible(
                  flex: 9,
                  child: Align(alignment: Alignment.centerRight,
                    child: Text(title,style: TextStyle(fontSize: 18,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),),),),
                Flexible(
                  flex:3,
                  child: Padding(
                    padding: EdgeInsets.only(top:60),
                    child: Align(
                    alignment: Alignment.topRight,child: IconButton(
                      icon: new Icon(Icons.search,color: Colors.white,),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => timKiemCB(),
                        ),
                      ),
                    ),),))



              ],
            ),
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