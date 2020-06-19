
import 'dart:async';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:newsApp/second.dart';
import 'dart:convert';
import 'package:get/get.dart';

void main(){
runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatelessWidget{
  
  Widget build(BuildContext context){
    return MainPage();
  }
}

class MainPage extends StatefulWidget{
 
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPageState();
  }
}
class MainPageState extends State<MainPage>{

String notification_url;
void configOneSignal()async{
 await OneSignal.shared.init("885d45f8-4bf1-4fdf-93f4-082f5f12f6ea");

 OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
 OneSignal.shared.setNotificationReceivedHandler((notification) {
   setState(() {
  
      notification_url =notification.payload.additionalData['url'].toString() ;
      
   });
    
 });
 OneSignal.shared.setNotificationOpenedHandler((openedResult) {
   WebViewPageState.weburls(notification_url);
    Get.to(Secondpage());
 });
 
}

static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
 final _controller = NativeAdmobController();
static String alert_CountryName;
static String countryName;
Position _currentPosition;

initState(){
_getCurrentLocation();
configOneSignal();
 
}

List newsData;
Future<String> Data() async{

    if(countryName == null){
      Duration(milliseconds: 10);
    }
    else{
  
    var response = await http.get('https://newsapi.org/v2/top-headlines?country=${countryName}&apiKey=3a408c34077e4804a3a508f2b75c6484');
    
   setState(() {
      var result =json.decode(response.body);
      newsData = result['articles'];
   });
   
      }
}

var PrimaryColor = const Color(0xFF151026);
  Widget build(BuildContext context){
    
    Data();
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepPurple),
      home: Scaffold(
      
      appBar: 
      PreferredSize(
        preferredSize: Size.fromHeight(150.0),
      
      child:AppBar(
       bottom: PreferredSize(child:
       Padding(
         padding: EdgeInsets.all(25),
         child: Container(child: Text('Latest News',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),)
       , preferredSize: Size.fromHeight(50.0)),
        elevation: 10,
       title: Text('Home'),
        actions: <Widget>[
          GestureDetector(
          onTap:() {
        showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('Country'),
            content: Text(alert_CountryName),
           )
          );
      },
          child:IconButton(
      
            icon: Icon(Icons.location_on,color: Colors.white,),),
          ),
          ],
      
        )
      ),
        body:
       
        Column(children: <Widget>[
       Expanded(child:ListView.separated(
        
          itemBuilder: (context,index){
           
            return 

            GestureDetector(
            onTap: (){
            
            WebViewPageState.weburls(newsData[index]['url']);
            Get.to(Secondpage());
            },
            
            child: Card(
            elevation: 10,
             
              child: Padding(
                
                padding: EdgeInsets.only(top: 35,bottom: 35,left: 10),

                child: Column(children: <Widget>[
                 Text(newsData[index]['title'],
                 style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold) 
                 ,
                 ),
                 
                 Text(newsData[index]['description'],
                 style: TextStyle(fontSize: 15),
                 
                  )  
                ],
              ),
            ),
          ),
        ) ; 
      },
         separatorBuilder: (context, index){
           if(index==5){
            return Container(
              height: 200,
              child:Container(
                  child:NativeAdmob(
              adUnitID: _adUnitID ,
              controller: _controller,
              )   
            )
          );
        }
              else{
                return Divider();
              }
            },
          itemCount:newsData==null ? 0:newsData.length 
          
          ),
        
        )  
      ]
    )   
  ),
    
  );
  }
  _getCurrentLocation() {
    
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        getPlace();
        
      });
    }).catchError((e) {
      
    });
  }
 getPlace() async{
 
List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(_currentPosition.latitude,_currentPosition.longitude);
  setState(() {
     countryName = placemark[0].isoCountryCode;
     alert_CountryName = placemark[0].country;

  });
}
}
