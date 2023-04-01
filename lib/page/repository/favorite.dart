import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/data_utils.dart';
import '../detail.dart';

class MyFavoriteContents extends StatefulWidget {
  MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() {
    return _MyFavoriteContentsState();
  }
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget _appbarwidget(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
          children:
          [
            Text('관심목록',style: TextStyle(fontSize: 20,color: Colors.black,),),
          ]

      )
    );
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _appbarwidget(),
      body: Container(),
    );
  }
}