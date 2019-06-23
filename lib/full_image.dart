import 'dart:math';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullImageView extends StatefulWidget
{
  String imgPath;
  FullImageView(this.imgPath);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FullImageViewState();
      }
}

    
class FullImageViewState extends State<FullImageView>{

static const platform =
  const MethodChannel('com.example.wallscreeny');

  final LinearGradient backGroundGradient = 
  LinearGradient( colors: [Colors.brown,
  Colors.white],
  begin: Alignment.topLeft, end: Alignment.bottomRight
  );

      bool downloading = false;
      var sprogressString = "";
      var progressString = "";
      String _setWallpaper = '';
      //PermissionHandler ermission = PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
      static final Random rand = Random();

  Future<void> downloadImage() async{
    Dio imgDownload = Dio();

      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
      print(permission.value);

      if(permission.value == 0)
      {
           var dir = await getTemporaryDirectory();
            print('${dir.path}');
           var saveLoc = "${dir.path}/wallscreeny/";
           var imageId = rand.nextInt(10000);

          try
          {
            print(saveLoc);
            bool result = FileUtils.mkdir([saveLoc]);
             print(result);
             var filename = imageId.toString() + ".jpg";
          await imgDownload.download(widget.imgPath
                , saveLoc + filename, 
                  onReceiveProgress: (rec, total){
                    setState(() {
                      downloading = true;
                      sprogressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
                      print(sprogressString);
                    });
                });
        }
      
        catch(e){

        }
     setState(() {
      downloading = false;
      sprogressString = "Completed";
    });
      }
      else
      {
         setState(() {
        downloading = false;
        sprogressString = "Permission denied";
      });
      }
  }

  Future<void> setWllpaper() async{
    Dio imgDownload = Dio();
    try
    {
      var dir = await getTemporaryDirectory();
      print(dir);
      await imgDownload.download(widget.imgPath
            , "${dir.path}/mydownload.jpeg", 
              onReceiveProgress: (rec, total){
                setState(() {
                  downloading = true;
                  progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
                  print(progressString);
                  if(progressString == "100%")
                  {
                    _setWallpaer();
                  }
                });
            });
    }
    catch(e){

    }
     setState(() {
      downloading = false;
      progressString = "Completed";
  });
  }

    Future<void> _setWallpaer() async {
    String setWallpaper;
    try {
      final int result =
          await platform.invokeMethod('setWallpaper', 'mydownload.jpeg');
      setWallpaper = 'Wallpaer Updated....';
    } on PlatformException catch (e) {
      setWallpaper = "Failed to Set Wallpaer: '${e.message}'.";
    }
    setState(() {
      _setWallpaper = setWallpaper;
    });
}

  Widget _buildPopupMenu()
  {
      return PopupMenuButton<String>(
        icon: Icon(FontAwesomeIcons.share, color: Colors.black,),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: "F",
            child: Text("Facebook"),
          ),
           PopupMenuItem<String>(
            value: "T",
            child: Text("Twitter"),
          ),
            PopupMenuItem<String>(
            value: "W",
            child: Text("Watsup"),
          ),
        ],
        onSelected: (retVal)
        {
           if(retVal == 'F')
           {
             print(widget.imgPath);
              FlutterShareMe().shareToFacebook(
                url:widget.imgPath,
                msg: "Wall Screeny App"
              );
           }
           if(retVal == 'T')
           {
             FlutterShareMe().shareToTwitter(
                url:widget.imgPath,
                msg: "Wall Screeny App"
              );
           }
          if(retVal == 'W')
           {
             FlutterShareMe().shareToWhatsApp(
                msg: "Wall Screeny App" + widget.imgPath,
              );
           }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient:backGroundGradient,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag:widget.imgPath,
                  child: Image.network(widget.imgPath),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      actions: <Widget>[
                         IconButton(
                         icon: Icon(Icons.file_download, color: Colors.black,),
                         onPressed: (){
                           downloadImage();
                         },
                       ),
                       _buildPopupMenu(),
                      
                      ],
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(Icons.close, color: Colors.black,), 
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.0),
                child: Center(
                    child: downloading
                        ? Container(
                            height: 100.0,
                            width: 200.0,
                            child: Card(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Downloading File : $sprogressString",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                  : Text("")),
              ),
                Align(
                alignment: Alignment(0.0, 0.7),
                child:
                    Text(_setWallpaper, style: TextStyle(color: Colors.white,fontSize: 19.0)),
                ),
            ],
          ),
        ),
      ),
       floatingActionButton: FloatingActionButton.extended(
      elevation: 4.0,
      icon: const Icon(Icons.add),
      label: const Text('Set As Wallpaper'),
      onPressed: () {
        setWllpaper();
      },
    ),
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown.shade400,
        child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.image, color: Colors.black,),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_horiz,color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      ),
    );
  }
  
}