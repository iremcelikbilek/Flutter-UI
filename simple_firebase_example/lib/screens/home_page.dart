import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_firebase_example/main.dart';



class HomePage extends StatefulWidget {

  String userId;
  HomePage({this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController textEditingController1,textEditingController2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"),
      actions: [
        IconButton(icon: Icon(Icons.close_outlined), onPressed: () async{
          if(_auth.currentUser != null){
            await _auth.signOut();
          }else{
            debugPrint("Zaten oturum açan kullanıcı yok !!");
          }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

        }),
      ],),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dialogGoster();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("users/${widget.userId}/contacts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(child: Text("Gösterilecek Kişi Yok"));
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Yükleniyor",style: TextStyle(fontSize: 20),)
            ],
          );
        }
        return ListView(
          children: snapshot.data.docs.map((doc) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              color: Theme.of(context).accentColor.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Dismissible(
                background:  Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                key: Key(doc.id),
                onDismissed: (DismissDirection direction){
                  if(direction == DismissDirection.endToStart){
                    _firestore.doc("users/${widget.userId}/contacts/${doc.id}").delete().whenComplete(() {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("${doc.data()['adSoyad']} silindi."),
                      action: SnackBarAction(
                        label: "Geri Al",
                        onPressed: (){
                          _firestore.collection("users/${widget.userId}/contacts").add({
                            "adSoyad" : doc.data()["adSoyad"],
                            "telefon" : doc.data()["telefon"]
                          });
                        },
                      ),));
                    });
                  }

                },
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage("assets/images/avatar.jfif"),),
                  title: Text(doc.data()['adSoyad']),
                  subtitle: Text(doc.data()['telefon']),
                ),
              ),
            ),
          )).toList(),
        );
        });
  }

  void dialogGoster() {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context){
      return SimpleDialog(
        title: Text("Kişi Ekle"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textEditingController1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Ad Soyad",
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: textEditingController2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Telefon",
                  hintStyle: TextStyle(color: Colors.grey[400])
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                veriEkle();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ]
                    )
                ),
                child: Center(
                  child: Text("Kaydet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          )
        ],
      );
      },
    );
  }

  void veriEkle() {
     _firestore.collection("users/${widget.userId}/contacts").add({
      "adSoyad" : textEditingController1.text,
      "telefon" : textEditingController2.text
    }).whenComplete(() {
      Navigator.of(context).pop();
      textEditingController1.clear();
      textEditingController2.clear();
      debugPrint("kişi eklendi");
    });
  }
}
