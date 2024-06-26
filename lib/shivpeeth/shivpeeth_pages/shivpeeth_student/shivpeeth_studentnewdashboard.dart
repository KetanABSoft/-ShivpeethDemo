import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messeges_with_firebase/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_parentview_attendance.dart';
import 'package:messeges_with_firebase/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentfee_report.dart';
import 'package:messeges_with_firebase/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_studentstafflist.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/conurl.dart';
import '../../../dash_board_screen.dart';
import '../../../home_screen.dart';
import '../../../notice_screen.dart';
import '../../../notification_services.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_color.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_icons.dart';
import '../shivpeeth_Authentication/shivpeeth_login.dart';
import '../shivpeeth_adapter/notice_adapter.dart';
import '../shivpeeth_home/shivpeeth_calender.dart';
import '../shivpeeth_home/shivpeeth_homework.dart';
import '../shivpeeth_home/shivpeeth_lessionplanning.dart';
import '../shivpeeth_home/shivpeeth_profile.dart';
import '../shivpeeth_home/shivpeeth_social_media_link.dart';
import '../shivpeeth_home/shivpeethnotic.dart';
import '../shivpeeth_parent/shivpeeth_childlist.dart';
import '../shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'Shivpeeth_studenttimetable.dart';
class studentdashboardnew extends StatefulWidget {
  const studentdashboardnew({super.key});

  @override
  State<studentdashboardnew> createState() => studentdashboardnewState();
}

class studentdashboardnewState extends State<studentdashboardnew> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(WireframeThemecontroler());
  bool isDark = true;
  String? id;
  String? roleid;
  String? username = "";
  String? designation = "";
  String? class_id;
  String? section_id;
  String? Attendence = "";
  String? fessdue = "";
  String? photo;
  String? branch_id;
  String? session_id;

  // late NotificationServices notificationServices;
  NotificationServices notificationServices = NotificationServices();

  ImageProvider? _imageProvider;
  String? dashboardimageUrl;
  bool _isImageLoaded = false;
  bool _isLoading = true; // Add this variable to track loading state

  String? email;
  String? mobileno;
  String? youtube;
  String? twiter;
  String? facebook;
  String? instgram;
  String? instutuename;
  String? domain;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _notificationCount = 0;
  List<RemoteMessage> _notifications = [];

  void getInitialMessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleMessage(message, fromDialog: false);

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _notificationCount=_notifications.length;
        });
      });
    }
  }

  void _handleMessage(RemoteMessage message, {bool fromDialog = true}) {
    if (fromDialog) {
      Navigator.of(context).pop(); // Close the dialog before navigation
    }
    if (message.data["page"] == "notice") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WireframeEvents()));
    } else if (message.data["page"] == "fees") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => studentfeereportpersonal()));
    } else if (message.data["page"] == "homework") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Wireframehomework(
          classid: class_id.toString(),
          sectionid: section_id.toString())));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid page in notification data"),
        duration: Duration(seconds: 3),
      ));
    }
    if(_notifications.contains(message)){
      setState(() {
        _notifications.remove(message);
        _notificationCount=_notifications.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    //  notificationServices = NotificationServices(context);
    notificationServices.requestNotificationPermission();
    FirebaseMessaging.instance.requestPermission();
    // notificationServices.firebaseInit();
    notificationServices.setupInteractMessage(context);
    notificationServices.forgroundMessage();
    // notificationServices.firebaseInitnew(context);
    notificationServices.firebaseInitnew(context);

    fcmtoken();
    fetchstoryData();
    fetchamountpaid();
    setState(() {
      fetchDashboardImage();
      fetch_drawerdata();

      getInitialMessage();

      FirebaseMessaging.onMessage.listen((message) {
        setState(() {
          _notifications.add(message);
          _notificationCount++;
        });
        _showSnackBar(message.notification?.title ?? "Notification", message.notification?.body ?? "");
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        setState(() {
          _notifications.add(message);
          _notificationCount++;
        });
        _handleMessage(message, fromDialog: false); // Directly call the handler to manage navigation
      });
    });
  }
  void _showSnackBar(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),
          SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14),
              ),
        ],
      ),
      duration: Duration(seconds: 10),
      backgroundColor: Colors.green,
    ));
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifications"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_notifications[index].notification?.body ?? "Invalid Notification"),
                  onTap: () {
                    _handleMessage(_notifications[index]);// Navigate based on notification
                    // _notifications.clear();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                _notificationCount = 0;
                // _notifications.clear();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // notificationServices = NotificationServices(context);
    notificationServices.requestNotificationPermission();
    //notificationServices.firebaseInit();
    notificationServices.firebaseInitnew(context);
  }

  void handleNotificationResponse(Map<String, dynamic> data) {
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());

    final String id = body['id'];
    // BuildContext context;
    print("idname");
    print(context);

    if (id == 'notice') {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return WireframeEvents();
        },
      ));
    }
  }

  void fetch_drawerdata() async {
    var urlString = AppString.constanturl + 'Get_drawerdata';
    Uri uri = Uri.parse(urlString);

    var response = await http.post(uri, body: {});

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        email = jsondata['institute_email'] ?? "";
        mobileno = jsondata['mobileno'] ?? "";
        youtube = jsondata['youtube_url'] ?? "";
        facebook = jsondata['facebook_url'] ?? "";
        instgram = jsondata['twitter_url'] ?? "";
        instutuename = jsondata['institute_name'] ?? "";
        domain = jsondata['footer_text'] ?? "";
      });
    }
  }

  void fetchDashboardImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    branch_id = preferences.getString('branch_id');
    String type =
        'report-card-logo'; // Assuming type and id are provided somehow

    String filePath =
        AppString.baseurl + 'uploads/app_image/$type-$branch_id.png';
    String newfilepath = 'uploads/app_image/$type-$branch_id.png';

    bool fileExists = await doesFileExist(filePath);

    if (fileExists && branch_id != null) {
      dashboardimageUrl = baseUrl(newfilepath);
      _isImageLoaded = true;
      _setImageProvider(dashboardimageUrl.toString());
    } else {
      dashboardimageUrl = baseUrl('uploads/app_image/$type.png');
      _isImageLoaded = true;
      _setImageProvider(dashboardimageUrl.toString());
    }
    setState(() {
      _isLoading = false;
    });

    // Use imageUrl as needed
  }

  String baseUrl(String path) {
    return AppString.baseurl + path; // Replace with your base URL
  }

// Mocking the file_exists function
  Future<bool> doesFileExist(String finewlepath) async {
    String imageUrl = finewlepath;
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImagenew(data['content-type']);
  }

  bool checkIfImagenew(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

  void _setImageProvider(String dashboardimageUrl) async {
    if (dashboardimageUrl != "") {
      _imageProvider = NetworkImage(dashboardimageUrl.toString());
    } else {
      _imageProvider = AssetImage(WireframePngimage.prashalaback);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void fetchstoryData() async {
    var urlString = AppString.constanturl + 'getdashboarddata';
    Uri uri = Uri.parse(urlString);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    roleid = preferences.getString('role');
    branch_id = preferences.getString('branch_id');
    print(branch_id.toString());
    var response = await http.post(uri,
        body: {"id": '$id', "role": '$roleid', "branch_id": '$branch_id'});

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        username = jsondata['name'] ?? '';
        designation = jsondata['designation'] ?? '';
        class_id = jsondata['class_id'];
        section_id = jsondata['section_id'];
        photo = jsondata['photo'];
      });
    }
  }

  void fetchamountpaid() async {
    var urlString = AppString.constanturl + 'Fetch_amount_atview_stud';
    Uri uri = Uri.parse(urlString);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    session_id = preferences.getString('session_id');
    branch_id = preferences.getString('branch_id');
    var response = await http.post(uri,
        body: {"id": id, "branch_id": branch_id, "session_id": session_id});

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      setState(() {
        Attendence = jsondata['studentpresent'].toString();
        fessdue = jsondata['dueamount'].toString();
        ;
      });
    }
  }

  Future fcmtoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? token = await FirebaseMessaging.instance.getToken();

    id = preferences.getString('id');
    var urlString = AppString.constanturl + 'update_fcm';

    Uri uri = Uri.parse(urlString);
    var response =
        await http.post(uri, body: {"fcm_token": '$token', "id": '$id'});
  }

  Future<bool> doesImageExist(String photo) async {
    String imageUrl = AppString.studentimageurl + photo;
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(50.0), // Set your desired height here
            child: AppBar(
              // backgroundColor:WireframeColor.appbarcolor,
              backgroundColor: WireframeColor.appcolor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      WireframeColor.bootomcolor,
                      WireframeColor.appcolor
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: (){
                        _showNotificationsDialog();
                    },
                    child: Stack(
                      children: [
                        Icon(Icons.notifications_none_outlined, color: Colors.black, size: 35),
                        if (_notificationCount > 0)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                // '$_notificationCount',
                                _notificationCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        WireframeColor.bootomcolor,
                        WireframeColor.appcolor,
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Center(
                      //       child: Image(
                      //         image: AssetImage(WireframePngimage.drawerimage), // Replace 'assets/android_logo.png' with your actual image path
                      //         width: 120, // Adjust the size as needed
                      //         height: 120, // Adjust the size as needed
                      //       ),
                      //     ),
                      //     SizedBox(width: 16), // Adjust the spacing as needed
                      //   ],
                      // ),

                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(
                              //  image: AssetImage(WireframePngimage.drawerimage), // Replace 'assets/android_logo.png' with your actual image path
                              image: NetworkImage(AppString
                                  .drawerimage), // Replace 'assets/android_logo.png' with your actual image path
                              width: 100, // Adjust the size as needed
                              height: 100, // Adjust the size as needed
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (instutuename.toString() != "")
                            Text(instutuename.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          SizedBox(width: 16), // Adjust the spacing as needed
                        ],
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 25, // Specify the width as per your preference
                    height: 25, // Specify the height as per your preference
                    child: Image.asset(WireframePngimage
                        .mail), // Use AssetImage for preloading
                  ),
                  title: Text(
                    email.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                ),
                Divider(), // Add a divider here
                ListTile(
                  leading: SizedBox(
                    width: 25, // Specify the width as per your preference
                    height: 25, // Specify the height as per your preference
                    child: Icon(Icons.language,
                        color: Colors.blue), // Use AssetImage for preloading
                  ),
                  title: Text(
                    domain.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                  onTap: () {
                    launch(domain.toString());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    size: 25,
                    color: Colors.blue,
                  ),
                  title: Text(
                    mobileno.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                  onTap: () {
                    launch("tel:$mobileno");
                  },
                ),
                Divider(),
                ListTile(
                  leading: SizedBox(
                    width: 25, // Specify the width as per your preference
                    height: 25, // Specify the height as per your preference
                    child: Image.asset(WireframePngimage
                        .youtube), // Use AssetImage for preloading
                  ),
                  title: Text(
                    youtube.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                  onTap: () {
                    launch(youtube.toString());
                  },
                ),
                Divider(),
                ListTile(
                  leading: SizedBox(
                    width: 25, // Specify the width as per your preference
                    height: 25, // Specify the height as per your preference
                    child: Image.asset(WireframePngimage
                        .instagram), // Use AssetImage for preloading
                  ),
                  title: Text(
                    instgram.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                  onTap: () {
                    launch(instgram.toString());
                  },
                ),
                Divider(),
                ListTile(
                  leading: SizedBox(
                    width: 25, // Specify the width as per your preference
                    height: 25, // Specify the height as per your preference
                    child: Image.asset(WireframePngimage
                        .facebook), // Use AssetImage for preloading
                  ),
                  title: Text(
                    facebook.toString(),
                    style: TextStyle(
                      color:
                          Colors.black, // Change color as per your preference
                      fontSize: 14, // Change font size as per your preference
                      fontWeight: FontWeight.normal, // Apply bold style
                    ),
                  ),
                  onTap: () {
                    launch(facebook.toString());
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  //height: height / 2,
                  // height: height / 1.5,
                  height: 410,
                  child: Stack(
                    children: [
                      Container(
                        width: width / 1,
                        height: MediaQuery.of(context).size.height / 2.9,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                WireframeColor.bootomcolor,
                                WireframeColor.appcolor
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    // Show progress indicator if isLoading is true
                                    if (_isLoading)
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    // Show image if it's loaded
                                    if (!_isLoading)
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: _isImageLoaded
                                                ? _imageProvider!
                                                : AssetImage(WireframePngimage
                                                    .prashalaback),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 10,
                        right: 10,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: WireframeColor.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: WireframeColor.appcolor,
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width / 1.4,
                                              child: Text(
                                                username.toString(),
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height / 120,
                                            ),
                                            Text(
                                              designation.toString(),
                                              style: sansproRegular.copyWith(
                                                fontSize: 12,
                                                color: WireframeColor.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          highlightColor:
                                              WireframeColor.transparent,
                                          splashColor:
                                              WireframeColor.transparent,
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return const loginprofile();
                                              },
                                            ));
                                          },
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                WireframeColor.white,
                                            //child: Image.asset(WireframePngimage.loginprofile),
                                            child: photo.toString() != ""
                                                ? FutureBuilder(
                                                    future: doesImageExist(
                                                        photo.toString()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasError ||
                                                            snapshot.data !=
                                                                true) {
                                                          // Handle error or image not found case
                                                          return Image.asset(
                                                            WireframePngimage
                                                                .loginprofile,
                                                            width: 40,
                                                            height: 40,
                                                          );
                                                        } else {
                                                          // Display the valid image
                                                          return Image.network(
                                                            AppString
                                                                    .studentimageurl +
                                                                photo
                                                                    .toString(),
                                                            width: 40,
                                                            height: 40,
                                                          );
                                                        }
                                                      } else {
                                                        // Show a loading indicator while checking for image existence
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  )
                                                : Image.asset(
                                                    WireframePngimage
                                                        .loginprofile,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                          width: width / 2.5,
                                          height: 30,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const childpraentlist();
                                                },
                                              ));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: WireframeColor.lightgray,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "Change Children",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15,
                                                    color: WireframeColor
                                                        .appcolor),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: WireframeColor.textgrayline,
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          highlightColor:
                                              WireframeColor.transparent,
                                          splashColor:
                                              WireframeColor.transparent,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                      "Fees/Attendance Details ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Image.asset(
                                                        WireframePngimage
                                                            .attendanceicon,
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        "Attendance - " +
                                                            Attendence
                                                                .toString() +
                                                            "%",
                                                        style: sansproSemibold
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color: WireframeColor
                                                                    .lightblack),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(
                                                  color: WireframeColor
                                                      .textgrayline,
                                                  height: 2,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Image.asset(
                                                        WireframePngimage
                                                            .rsicon,
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        "Fees Due - ₹" +
                                                            fessdue.toString(),
                                                        style: sansproSemibold
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color: WireframeColor
                                                                    .lightblack),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      //  Positioned(
                      //   //top: 200,
                      //   bottom: 0,
                      //  left: 10,
                      //   right: 10,
                      //   child: Padding(
                      //       padding:   EdgeInsets.all(7),
                      //        child: Container(
                      //    width: MediaQuery.of(context).size.width,
                      //  // height:200, // Add your desired height,
                      //       child: Row(
                      //          //mainAxisAlignment: MainAxisAlignment.center,

                      //         children: [
                      //            Expanded(
                      //          child: InkWell(
                      //             highlightColor: WireframeColor.transparent,
                      //             splashColor: WireframeColor.transparent,

                      //             child: Container(

                      //               decoration: BoxDecoration(
                      //                   color: WireframeColor.white,
                      //                   borderRadius: BorderRadius.circular(20),
                      //                   border: Border.all(
                      //                     color: WireframeColor.appcolor,
                      //                   )),

                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     SizedBox(height: 20,),
                      //        Container(
                      //        margin: EdgeInsets.only(left: 20),
                      //        child:Text("Fees/Attendance Details ",
                      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                      //        textAlign: TextAlign.left) ,)
                      //          ,

                      //          SizedBox(height: 20,),
                      //                     Row(
                      //                       children: [
                      //                         Container(
                      //                        margin: EdgeInsets.only(left: 10),
                      //                        child:  Image.asset(
                      //                           WireframePngimage.attendanceicon,
                      //                           height: 40,
                      //                           width: 40,
                      //                         ),),
                      //               SizedBox(width:5),
                      //                           Container(
                      //                         margin: EdgeInsets.only(left: 10),
                      //                         child:Text(
                      //                          "Attendance - "+Attendence.toString()+"%",
                      //                           style: sansproSemibold.copyWith(
                      //                               fontSize: 18,
                      //                               color: WireframeColor.lightblack),
                      //                         ),),

                      //                       ],
                      //                     )
                      //                     ,
                      //                     SizedBox(height: 10,),

                      //                     Divider(color: WireframeColor.textgrayline,
                      //                     height: 2,),

                      //                SizedBox(height: 10,),
                      //                      Row(
                      //                       children: [
                      //                         Container(
                      //                          margin: EdgeInsets.only(left: 10),
                      //                        child:
                      //                         Image.asset(
                      //                           WireframePngimage.rsicon,
                      //                           height: 40,
                      //                           width: 40,
                      //                         ),),
                      //                   SizedBox(width:5),
                      //                        Container(
                      //                        margin: EdgeInsets.only(left: 10),
                      //                         child:
                      //                         Text(
                      //                          "Fees Due - ₹"+fessdue.toString(),
                      //                           style: sansproSemibold.copyWith(
                      //                               fontSize: 18,
                      //                               color: WireframeColor.lightblack),
                      //                         ),
                      //                        ),

                      //                           Spacer(),
                      //                       ],
                      //                     ),
                      //               SizedBox(height: 10,),

                      //                   ],
                      //                 ),

                      //             ),
                      //           ),

                      //        ) ],
                      //       )
                      //       )
                      //       )
                      //       )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 26, vertical: height / 36),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Wireframe_student_att(
                                      classid: class_id.toString(),
                                      sectionid: section_id.toString());
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage
                                          .student_attendance_admin,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Attendance",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Wireframehomework(
                                      classid: class_id.toString(),
                                      sectionid: section_id.toString());
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.homeworkdash,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Homework",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return studenttimetable(
                                      classid: class_id.toString(),
                                      sectionid: section_id.toString());
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.time_dash,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Timetable",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 56,
                      ),
                      Row(
                        children: [
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const WireframeEvents();
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.notice_admin,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Notice",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const WireframeCalender();
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.calendar_admin,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Calendar",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const studentfeereportpersonal();
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.feestatus_dash,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Fee Status",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 56,
                      ),
                      Row(
                        children: [
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const socialmedia();
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.social_link_admin,
                                      height: height / 20,
                                      //width: 30,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Social Links",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return lessionplan(
                                      classid: class_id.toString(),
                                      sectionid: section_id.toString());
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.ledash,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Lesson PL.",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            highlightColor: WireframeColor.transparent,
                            splashColor: WireframeColor.transparent,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const student_stafflist();
                                },
                              ));
                            },
                            child: Container(
                              width: width / 3.5,
                              decoration: BoxDecoration(
                                color: WireframeColor.lightgray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36,
                                    vertical: height / 36),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      WireframePngimage.staff_admin,
                                      height: height / 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      height: height / 36,
                                    ),
                                    Center(
                                      child: Text(
                                        "Staff",
                                        style: sansproRegular.copyWith(
                                          fontSize: 15,
                                          color: WireframeColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height / 56,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Exit App', style: TextStyle(fontFamily: 'Poppins')),
            content: Text('Do you want to exit the app?',
                style: TextStyle(fontFamily: 'Poppins')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(fontFamily: 'Poppins')),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _onPop() async {
    return false;
  }
}
