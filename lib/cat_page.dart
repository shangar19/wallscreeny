import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallscreeny/full_image.dart';


class CategoryPage extends StatefulWidget
{
  String catName;
  CategoryPage(this.catName);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryPageState(catName);
  }
}

class CategoryPageState extends State<CategoryPage>
{
  String name;
  CategoryPageState(this.name);

  List<DocumentSnapshot> wallImagesList;
  StreamSubscription<QuerySnapshot> subscription;
  final CollectionReference collecctionReference = Firestore.instance.collection("wallpapers");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription = collecctionReference.where("catname",isEqualTo: name).snapshots().listen((dataSnapshots){
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

  Widget _buildAppbar(String cname)
  {
    MaterialColor colors;

     if(cname == "Nature")
     {
        colors = Colors.green;
     }
    else if(cname == "Car")
     {
       colors = Colors.red;
     }
    else if(cname == "Baby")
     {
        colors = Colors.blueGrey;
     }
      else if(cname == "Love")
     {
         colors = Colors.pink;
     }
     else if(cname == "Fashion")
     {
        colors = Colors.purple;
     }
    else if(cname == "Cofee")
     {
        colors = Colors.blue;
     }
     else
     {
         colors = Colors.brown;
     }
      return AppBar(
          backgroundColor: colors,
          title: Text(name + " " + "(" + wallImagesList.length.toString() + ")",
           textAlign: TextAlign.center,),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppbar(name),
      body: wallImagesList != null?
       StaggeredGridView.countBuilder(
         padding: const EdgeInsets.all(7.0),
         crossAxisCount: 4,
         itemCount:wallImagesList.length ,
         itemBuilder: (context,i)
         {
           String imgPath = wallImagesList[i].data['url'];
           return Material(
             elevation: 7.0,
             borderRadius: BorderRadius.all(Radius.circular(7.0)),
             child: InkWell(
               onTap: () => Navigator.push(context, MaterialPageRoute(
                 builder: (context) => FullImageView(imgPath)
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