import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Secondpage  extends StatelessWidget{
  
  Widget build(BuildContext context){
    return WebViewPage();
  }
}
class WebViewPage extends StatefulWidget{
  @override
  WebViewPageState createState()=> WebViewPageState();
}
class WebViewPageState extends State<WebViewPage>{




 Completer<WebViewController> _completer  = Completer<WebViewController>();
static String webViewurl ="";
static void weburls(String url){
  webViewurl = url;
}
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepPurple),
      home:Scaffold(
        appBar: AppBar(title: Text('Latest News'),
        centerTitle: true,),
        body: WebView(
        initialUrl: webViewurl,
        onWebViewCreated: (WebViewController webViewController){
          _completer.complete(webViewController);
        },
        ),
        
    ));
  }
}