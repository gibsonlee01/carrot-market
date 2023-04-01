import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot/components/manner_temperature_widget.dart';
import 'package:carrot/page/repository/contents_repository.dart';
import 'package:carrot/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key,required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() {
    return _DetailContentViewState();
  }
}



class _DetailContentViewState extends State<DetailContentView> with SingleTickerProviderStateMixin{
  late ContentRepository contentRepository;
 late Size size;
 late List <Map<String,String>> imgList;
 late int _current;
 double scrollpositionToAlpha = 0;
 ScrollController _controller = ScrollController();
 late AnimationController _animationController;
 late Animation _colorTween;
 late bool isMyFavoriteContent;

 @override
 void initState(){
   super.initState();
   isMyFavoriteContent=false;
   contentRepository = ContentRepository();
   _animationController=AnimationController(vsync: this);
   _colorTween=ColorTween(begin: Colors.white, end: Colors.black).animate(_animationController);
   _controller.addListener(() {
     setState(() {
       if(_controller.offset > 225){
         scrollpositionToAlpha=255;
       }else{
         scrollpositionToAlpha= _controller.offset;
       }
       _animationController.value = scrollpositionToAlpha/ 255 ;
     });

   });
_loadMyFavoriteContentState();
 }

  _loadMyFavoriteContentState() async{
   bool ck = await contentRepository.isMyFavoritecontents(widget.data['cid']!);
   setState(() {
     isMyFavoriteContent = ck;
   });
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    size=MediaQuery.of(context).size;
    imgList=[
      {"id":"0","url": widget.data['image']!},
      {"id":"1","url": widget.data['image']!},
      {"id":"2","url": widget.data['image']!},
      {"id":"3","url": widget.data['image']!},
      {"id":"4","url": widget.data['image']!},

    ];
    _current=0;
  }

  Widget _makeIcon(IconData icon){
   return AnimatedBuilder(animation:_colorTween,
       builder:(context,child) =>
           Icon(icon,color: _colorTween.value,));
  }


  PreferredSizeWidget _appbarWidget(){
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha as int),
      elevation: 0,
      leading: IconButton(icon:_makeIcon(Icons.arrow_back), onPressed: () {
        Navigator.pop(context);
      },),
      actions: [
        IconButton(onPressed: (){}, icon: _makeIcon(Icons.share),),
        IconButton(onPressed: (){}, icon: _makeIcon(Icons.more_vert),),
      ],
    );
  }



  Widget _makeSliderImage(){
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"]!,
            child: CarouselSlider(
              items: imgList.map((map){
                return  Image.asset(
                    map["url"]! ,
                    width:size.width , fit:BoxFit.fill);
              },).toList(),
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false ,
                  viewportFraction: 1,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });

                  }),
              //
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((map){
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current ==int.parse(map['id']!)
                          ?Colors.white
                          :Colors.white.withOpacity(0.4)),
                );
              }).toList(),
            ),
          ),

        ],
      ),
    );
  }

  Widget _sellerSimpleInfo(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children:[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width:50,height: 50 , child: Image.asset("assets/images/user.png"),
            ),
          ),
          SizedBox(width: 10, ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('안녕',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16),),
              Text(widget.data["location"]!),
            ],
          ),
          Expanded(child: MannerTemperature(manorTemp:37.5,))
        ]

      ),
    );
  }

  Widget _line(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,color: Colors.grey.withOpacity(0.3),);
  }

  Widget _contentDetail(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height:20),
          Text(widget.data["title"]!,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          Text('디지털/가전 22시간 전',style: TextStyle(color:Colors.grey, fontSize: 12),),
          SizedBox(height:15),
          Text(
            '선물 받은 새 상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.'
            ,style: TextStyle(height: 1.5, fontSize: 15),),
          SizedBox(height:15),
          Text('채팅 3 관심 ${widget.data["likes"]!}  조회 295',style: TextStyle(color:Colors.grey, fontSize: 12),),
          SizedBox(height:15),
        ],
      ),
    );
  }

  Widget _reportButton(){
    return Container(
      margin: EdgeInsets.all(15),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(onPressed: () {  }, child: Text('Report this post',style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17
          ),),),
        ],
      )

    );
  }


  Widget _otherSellContents(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('판매자님의 판매 상품',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text('모두 보기',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
        ],

      ),
    );
  }


  Widget _bodyWidget(){
    return CustomScrollView(controller: _controller,
      slivers:[
        SliverList(delegate: SliverChildListDelegate([
              _makeSliderImage(),
              _sellerSimpleInfo(),
              _line(),
              _contentDetail(),
              _line(),
              _reportButton(),
              _line(),
              _otherSellContents(),
          
        ]) ,),
       SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 15),
         sliver:SliverGrid(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,crossAxisSpacing: 10, mainAxisSpacing: 10),
           delegate: SliverChildListDelegate(List.generate(20,(index){
           return Container(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               ClipRRect(
                 borderRadius: BorderRadius.circular(10),
                   child: Container(color:Colors.grey,height: 150,)),
               Text("상품 제목",style: TextStyle(fontSize: 14),),
               Text("금액",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),


             ],
           ),


           );
         }).toList(),
         ) ,) ,)
        
      ]);
  }

  Widget _bottomBarWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,


        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                contentRepository.addMyFavoriteContent(widget.data);
                setState(() {
                  isMyFavoriteContent = !isMyFavoriteContent;

                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 1000),
                    content: Text(
                      isMyFavoriteContent
                          ? "관심목록에 추가 되었습니다."
                          : "관심목록에서 제거 되었습니다",
                    ),
                  ),
                );
              },
                child: SvgPicture.asset(
                  isMyFavoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
                  width: 25,
                  height: 25,
                  color: Color(0xfff08f4f),
                )),

            Container(
              margin: const EdgeInsets.only(left: 15, right: 10),
              width: 1,height: 40, color: Colors.grey.withOpacity(0.3),
            ),
            Column(
              children: [
                Text(
                  DataUtils.calcStringToWon(widget.data["price"]!)
                  ,style: TextStyle(fontSize:17, fontWeight: FontWeight.bold),),
                Text('가격제안불가',style:TextStyle(fontSize: 14,color:Colors.grey) ,)
              ],
            ),
            Expanded(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color(0xfff08f4f),),
                  child: Text(
                    "채팅으로 거래하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
              ],
            ),)
          ],
        
    ),
    );

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true ,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),



    );
  }

}