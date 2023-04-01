import 'package:carrot/page/detail.dart';
import 'package:carrot/page/repository/contents_repository.dart';
import 'package:carrot/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {


  late String currentLocation;
  ContentRepository contentRepository = ContentRepository();
  final Map<String, String> locationTypeToString = {
    "ara": "아라동",
    "ora": "오라동",
    "imae": "이매동",
  };

  @override
  void initState(){
    super.initState();
    currentLocation = "ara";
  }





  PreferredSizeWidget _appbarWidget(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: GestureDetector(
        onTap: (){
          print('click');
        },
        child:PopupMenuButton<String>(
          offset: Offset(0,25),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),1
          ),
          onSelected: (String where){
            print(where);
            setState(() {
              currentLocation = where;
            });
            },
          itemBuilder:(BuildContext Context){
            return[
              PopupMenuItem(value: "ara",child: Text("아라동"),),
              PopupMenuItem(value: "ora",child: Text("오라동"),),
              PopupMenuItem(value: "imae",child: Text("이매동"),),
            ];

          } ,
            child: Row(
              children: [
                Text(locationTypeToString[currentLocation]!,style: TextStyle(color:Colors.black)),
                Icon(Icons.arrow_drop_down, color: Colors.black,),
            ],
          ),
        ),


      ) ,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search),color: Colors.black,),
        IconButton(onPressed: (){}, icon: Icon(Icons.tune),color: Colors.black,),
        IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/svg/bell.svg",width: 22),),
      ],
    );
  }

  _loadContents(){
   return contentRepository.loadContentFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String,String>> datas){
    return  ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _content, int index){
        return GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context){
              return DetailContentView(
                  data: datas[index],
              );
            }));

          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),

            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]["cid"]!,
                    child: Image.asset( datas[index]["image"]!,
                      width: 100, height: 100, ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 100,
                    child:Column(
                        crossAxisAlignment:CrossAxisAlignment.start ,
                        children: [

                          Text(datas[index]["title"]!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize:15),),
                          SizedBox(height: 5,),
                          Text(datas[index]["location"]!
                            ,style: TextStyle(fontSize:12,color: Colors.black.withOpacity(0.3),),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            DataUtils.calcStringToWon(datas[index]["price"]!)
                            ,style:TextStyle(fontWeight: FontWeight.w700) ,),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/svg/heart_off.svg',width: 13, height: 13,),
                                SizedBox(width: 5,),
                                Text(datas[index]["likes"]!),
                              ],
                            ),
                          ),


                        ]),),
                ),

              ],

            ),
          ),
        );
      },
      separatorBuilder: (BuildContext, int index){
        return Container(height: 1,color: Colors.black.withOpacity(0.4));
      },
      itemCount: 10,
    );

  }

  Widget _bodyWidget(){
  return FutureBuilder(
      future: _loadContents(),
    builder: (BuildContext context, dynamic snapshot){
        if (snapshot.connectionState != ConnectionState.done){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Center(child: Text('해당 지역의 데이터가 없습니다.'),);
        }
        if(snapshot.hasData){
          return _makeDataList(snapshot.data);
        }
        return Center(child:Text("해당 지역의 데이터가 없습니다."));


    }
  );

  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),



    );

  }





}