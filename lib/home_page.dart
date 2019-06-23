import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallscreeny/cat_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
{
  List<DocumentSnapshot> wallImagesList;
  StreamSubscription<QuerySnapshot> subscription;
  final CollectionReference collecctionReference = Firestore.instance.collection("categories");



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    subscription = collecctionReference.snapshots().listen((dataSnapshots){
      setState(() {
        wallImagesList = dataSnapshots.documents;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("WallScreeny",
        textAlign: TextAlign.center,),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                image: DecorationImage(
                  image: AssetImage('assets/adventure.jpg'),
                  fit: BoxFit.cover
                  )
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Wall Screeny", textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            ListTile(
              title: Text('Technology'),
              leading: Icon(FontAwesomeIcons.laptopCode, color: Colors.brown,),
              onTap: () {

              },
            ),
             ListTile(
              title: Text('Nature'),
              leading: Icon(FontAwesomeIcons.tree, color: Colors.brown,),
              onTap: () {

              },
            ),
              ListTile(
              title: Text('Baby'),
              leading: Icon(FontAwesomeIcons.baby, color: Colors.brown,),
              onTap: () {

              },
            ),

              ListTile(
              title: Text('Art'),
              leading: Icon(FontAwesomeIcons.artstation, color: Colors.brown,),
              onTap: () {

              },
            ),
              ListTile(
              title: Text('Love'),
              leading: Icon(FontAwesomeIcons.heart, color: Colors.brown,),
              onTap: () {

              },
            ),
              ListTile(
              title: Text('Cofee'),
              leading: Icon(FontAwesomeIcons.coffee, color: Colors.brown,),
              onTap: () {

              },
            ),
               ListTile(
              title: Text('Code'),
              leading: Icon(FontAwesomeIcons.code, color: Colors.brown,),
              onTap: () {

              },
            ),
               ListTile(
              title: Text('Fashion'),
              leading: Icon(FontAwesomeIcons.shirtsinbulk, color: Colors.brown,),
              onTap: () {

              },
            ),
                 ListTile(
              title: Text('Cars'),
              leading: Icon(FontAwesomeIcons.car, color: Colors.brown,),
              onTap: () {

              },
            ),
          ],
        ),
      ),
      body: wallImagesList != null?
       StaggeredGridView.countBuilder(
         padding: const EdgeInsets.all(7.0),
         crossAxisCount: 4,
         itemCount:wallImagesList.length ,
         itemBuilder: (context,i)
         {
           String imgPath = wallImagesList[i].data['url'];
           String imgTitle = wallImagesList[i].data['title'];
           return Material(
             elevation: 7.0,
             borderRadius: BorderRadius.all(Radius.circular(7.0)),
             child: InkWell(
               onTap: () => Navigator.push(context, MaterialPageRoute(
                 builder: (context) => CategoryPage(imgTitle)
               )),
               child: Stack(
                 children: <Widget>[
                 FadeInImage(
                     height: 400.0,
                     width: double.infinity,
                     image: NetworkImage(imgPath),
                     fit: BoxFit.cover,
                     placeholder: AssetImage("assets/wallscreeny.jpg"),
                   ),
                 Align(
                   alignment: AlignmentDirectional.bottomCenter,
                   child: Container(
                     padding: EdgeInsets.all(7.0),
                     decoration: BoxDecoration(
                       color: Colors.black54
                     ),
                     child: new Text(
                 imgTitle,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    ),
                    ),
                    width: double.infinity,
                   ),
                 )
                 ], 
               ),
             ),
           );
         },
         staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven?2:3),
         mainAxisSpacing: 7.0,
         crossAxisSpacing: 7.0,
       ): Center(
         child: CircularProgressIndicator(),
       )
    );
  }

}