

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class showImage extends StatelessWidget {
  final String linkImage;
  showImage({Key key, this.linkImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child:  PhotoView(
            imageProvider: NetworkImage(linkImage)
        )
    );
  }
}
