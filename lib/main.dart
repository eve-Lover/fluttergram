import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './style.dart' as themeStyle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용 함수
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Store1(),
    child: MaterialApp(
        theme: themeStyle.theme,
        home: MyApp()
    ),
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
    } else {
      //실패시 실행할 코드
      throw Exception('실패함ㅅㄱ');
    }
    print(data);
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
               // print(data![3]['image'].runtimeType);
                ImagePicker picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                    setState((){
                      userImage = File(image.path);//선택한 이미지 경로를 저장
                    });
                }
                Navigator.push(context, //context: MaterialApp 들어 있는 context
                MaterialPageRoute(builder: (context) => Upload(userImage:userImage, data: data,))
                );
              },
            )
          ],
        ),
        body: [HomeUI(data : data, userImage:userImage), Text('샵')][tab],
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
  HomeUI({Key? key, required this.data, this.userImage}) : super(key: key);
  final data;
  final userImage;
// StatefulWidget은 부모가 보낸 state 등록은 첫째 class, 사용은 둘째 클래스
  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
/*
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
  }*/
/*

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
*/
  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty){
      print(widget.data);
      return ListView.builder(
       // controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (c,i){
          var img;
          if(widget.data[i]['image'].runtimeType == String){
            img = Image.network(widget.data[i]['image']);
          }else{
            img = Image.file(widget.data[i]['image'], width: 500, height: 500);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              img,
              //Image.network(widget.data[i]['image']),
              GestureDetector(
                  child: Text(widget.data[i]['user'].toString()),
                  onTap: (){
                    Navigator.push(context,
                    CupertinoPageRoute(builder: (c) => Profile())
                    );
                  },
              ),
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

class Upload extends StatefulWidget {
  const Upload({Key? key, this.userImage, this.data}) : super(key: key);
  @override
  final data;
  final userImage;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String inputText = '';

  _addData() {
    var userData = {
      "id" : 0,
      "image" : widget.userImage,
      "likes" : 0,
      "date" : "Nov 18",
      "content" : inputText,
      "liked" : false,
      "user" : "nayoung"
    };
    setState(() {
      widget.data.add(userData);
      print(widget.data);
    });
  }



  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: (){
                  Navigator.pop(context);
                },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이미지업로드화면'),
            TextField(
              onChanged: (text){
                setState((){
                  inputText = text;
                });
              },),
            Image.file(widget.userImage, width: 200, height: 200, ),
            ElevatedButton(
                onPressed: (){
                  _addData();
                  Navigator.pop(context);
                },
                child: Text('업로드',))
          ],
        )
    );
  }
}

class Store1 extends ChangeNotifier {
  var name = 'john kim';
  int follow = 0;
  bool isFollow = false;
  changeName(newName){
    name = newName;
    notifyListeners();
  }
  chageFollow(){
    if(isFollow == false){
      follow += 1;
    }else{
      follow -= 1;
    }
    notifyListeners();
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store1>().name)),
      body: Container(
        margin: EdgeInsets.all(7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.person),
            Text('팔로우 ${context.watch<Store1>().follow}명'),
            ElevatedButton(
                onPressed: (){
                  context.read<Store1>().chageFollow();
                },
                child: Text('팔로우'))
          ],
        ),
      ),
    );
  }
}
