import 'package:flutter/material.dart';
import 'package:plus_one/src/styling/color_palettes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:plus_one/src/styling/custom_text_styles.dart';

//  flutter_webview_plugin: ^0.3.11


class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: sixtyPercOrange,
          title: Center(child: Text('PlusOne', style: buildLogoTextStyle(40))),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Icon(
              Icons.call,
              color: Colors.transparent,
            ),
            Icon(
              Icons.call,
              color: Colors.transparent,
            )
          ],
        ),
      body: FutureBuilder(
          future: rootBundle.loadString("assets/README.md"),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data,
                styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(color: persianGreen, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
