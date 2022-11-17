import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './style.dart' as themeStyle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
      theme: themeStyle.theme,
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;
  static const String uri = 'https://codingapple1.github.io/app/data.json';
  //
  late List? data; // state
  var userImage;

  getData(uri) async{
    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == 200) {
      // result.statusCode -> 성공시 200이 저장되어 있음
      // 실패하면 400, 500 등이 남음
     // 여기에다 성공시 코드 넣음
      setState(() {
        data = json.decode(result.body);
      });
      print(data);
    } else {
      //실패시 실행할 코드
      throw Exception('실패함ㅅㄱ');

    //  }
    }
  }




  @override
  void initState() {
    super.initState();
    // MyApp 위젯이 로드될 때 실행됨
    getData(uri);
  }

  @override

  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('instagram'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                    setState((){
                      userImage = File(image.path); //선택한 이미지 경로를 저장
                    });
                }
                Navigator.push(context, //context: MaterialApp 들어 있는 context
                MaterialPageRoute(builder: (context) => Upload(userImage:userImage))
                );
              },
            )
          ],
        ),
        body: [HomeUI(data : data), Text('샵')][tab],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i){
            setState((){
              tab = i;
            });
            //print(i); // 현재 누른 버튼의 번호
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.black,), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.shop, color: Colors.black), label: 'shop'),
          ],

        ),
      );
    }
  }


class HomeUI extends StatefulWidget {
  HomeUI({Key? key, required this.data}) : super(key: key);
  var data;
// StatefulWidget은 부모가 보낸 state 등록은 첫째 class, 사용은 둘째 클래스
  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  //유저의 스크롤바 높이 측정하려면? - state 만들어서 Listview에 넣기
  var scroll = ScrollController(); // 유저의 스크롤 관련 정보 저장하는 class

  String uri2 = 'https://codingapple1.github.io/app/more1.json';

  addData(uri) async{
    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == 200) {
      setState(() {
        widget.data?.add((json.decode(result.body)));
      });
    } else {
      //실패시 실행할 코드
      throw Exception('실패함ㅅㄱ');
      //  }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() { //필요 없어짐녀 제거하는 것이 성능 좋음
      //print(scroll.position.pixels); // 스크롤바 내린 높이
      // print(scroll.position.maxScrollExtent); // 스크롤 가능 최대 높이
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        //유저가 맨 밑까지 스크롤 했는지 감시
        addData(uri2);

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty){
      print(widget.data);
      return ListView.builder(
        controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (c,i){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.data[i]['image']),
              Text(widget.data[i]['id'].toString()),
              Text(widget.data[i]['likes'].toString()),
              Text(widget.data[i]['date']),
              Text(widget.data[i]['content']),
            ],
          );
        },
      );
    }else{
      return Text('로딩중');
    }

  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage}) : super(key: key);
  @override
  final userImage;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이미지업로드화면'),
            Image.file(userImage),
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)
            ),
          ],
        )
    );

  }
}