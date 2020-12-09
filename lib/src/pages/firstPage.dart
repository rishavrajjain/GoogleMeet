import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'index.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

var titles;

class FirstPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  FirstPage(this.cameras);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  CameraController controller;
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      "To test: long press link and then copy and click from a non-browser "
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      "is properly setup. Look at firebase_dynamic_links/README.md for more "
      "details.";

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    controller = CameraController(widget.cameras[1], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String> createFirstPostLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://agoraflutterquickstart.page.link',
      link: Uri.parse('https://www.compound.com/post?title=$title'),
      androidParameters:
          AndroidParameters(packageName: 'com.example.agoraflutterquickstart'),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('deeplink is $deepLink');

        var isPost = deepLink.pathSegments.contains('post');
        if (isPost) {
          titles = deepLink.queryParameters['title'];
          // if (titles != null) {
          //   titles = '123456';
          // }
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IndexPage(
                    title: titles,
                  )),
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(_linkMessage);
      print(_isCreatingLink);
      print(_testString);
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('yolo');
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Future<void> _createDynamicLink(bool short) async {
  //   setState(() {
  //     _isCreatingLink = true;
  //   });

  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://cx4k7.app.goo.gl',
  //     link: Uri.parse('https://dynamic.link.example/helloworld'),
  //     androidParameters: AndroidParameters(
  //       packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
  //       minimumVersion: 0,
  //     ),
  //     dynamicLinkParametersOptions: DynamicLinkParametersOptions(
  //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
  //     ),
  //     iosParameters: IosParameters(
  //       bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
  //       minimumVersion: '0',
  //     ),
  //   );

  //   Uri url;
  //   if (short) {
  //     final ShortDynamicLink shortLink = await parameters.buildShortLink();
  //     url = shortLink.shortUrl;
  //   } else {
  //     url = await parameters.buildUrl();
  //   }

  //   setState(() {
  //     _linkMessage = url.toString();
  //     _isCreatingLink = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,

      drawer: Drawer(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        "https://avatars2.githubusercontent.com/u/29782913?s=460&u=b05d0b13cd92182f38b9884256d55baae0cfe241&v=4"),
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text(
                        'Rishav Raj Jain',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'rishavrajjain@gmail.com',
                            textAlign: TextAlign.left,
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 18.0)
                        ],
                      ),
                    ]),
                  )
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.cogOutline,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(MdiIcons.messageAlertOutline),
                    SizedBox(width: 10),
                    Text(
                      'Send feedback',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(MdiIcons.alertOctagonOutline),
                    SizedBox(width: 10),
                    Text(
                      'Report abuse',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(MdiIcons.helpCircle),
                    SizedBox(width: 10),
                    Text(
                      'Help',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {},
          ),
        ],
        elevation: 0.0,
        title: Text('Meet'),
        backgroundColor: Colors.transparent,
        //backgroundColor: Color(0xff158274),
        centerTitle: true,
      ),
      body:
          //AspectRatio(
          //   aspectRatio: controller.value.aspectRatio,
          //   child:
          Stack(
        children: <Widget>[
          CameraPreview(controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                  )),
              padding: EdgeInsets.all(10),
              //color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    onPressed: () => getLinc(),
                    // onPressed: () {
                    //   final RenderBox box = context.findRenderObject();
                    //   Share.share(
                    //       'https://agoraflutterquickstart.page.link/14325',
                    //       subject: 'Link',
                    //       sharePositionOrigin:
                    //           box.localToGlobal(Offset.zero) & box.size);
                    // },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color(0xff158274),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'New Meeting',
                          style: TextStyle(color: Color(0xff158274)),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndexPage(
                                  title: '',
                                )),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.keyboard,
                          color: Color(0xff158274),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Meeting Code',
                          style: TextStyle(color: Color(0xff158274)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //),
    );
  }

  Future getLinc() async {
    String code= randomNumeric(6);
    
    print('Code is $code');
    String stg = await createFirstPostLink(code);
    //print(stg);
    final RenderBox box = context.findRenderObject();
    Share.share(stg,
        subject: 'Link',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
