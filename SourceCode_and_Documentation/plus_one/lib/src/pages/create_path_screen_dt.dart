import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plus_one/src/pages/view_path_screen.dart';
import 'package:plus_one/src/providers/path.dart';
import 'package:plus_one/src/providers/paths.dart';
import 'package:provider/provider.dart';
import '../providers/paths.dart';
import '../styling/color_palettes.dart';
import '../styling/custom_text_styles.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class CreatePath extends StatefulWidget {
  static const routeName = '/create-path';
  @override
  _CreatePathState createState() => _CreatePathState();
}

class _CreatePathState extends State<CreatePath> {
  DateTime _time = DateTime.now();
  DateTime _date = DateTime.now();
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormatter = DateFormat('Hms');
  final _formKey = GlobalKey<FormState>();
  String _theme = "";

  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final pathsList = Provider.of<Paths>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sixtyPercOrange,
        title: Text(
          'PlusOne',
          style: buildLogoTextStyle(40),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            height: MediaQuery.of(context).copyWith().size.height / 5,
            child: Text(
              "WHEN DO YOU WANT TO GO ON YOUR ADVENTURE?",
              style: buildBoldRobotoText(30, Colors.blue),
            ),
          ),
          Container(
            child: Column(
              children: [
                Text("THEMES"),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _theme = "CITY";
                    });
                  },
                  child: Text("CITY"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _theme = "TOURIST ATTRACTION";
                    });
                  },
                  child: Text("TOURIST ATTRACTION"),
                ),
              ],
            ),
          ),

          // Container(
          //   padding: EdgeInsets.all(15),
          //   width: double.infinity,
          //   // height: MediaQuery.of(context).copyWith().size.height / 5,
          //   child: Form(
          //     key: _formKey,
          //     child: Column(
          //       children: [
          //         buildTextField(context, "TITLE", title),
          //         buildTextField(context, "DESCRIPTION", description),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Platform.isAndroid
              ? ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('SELECT DATE'),
                )
              : ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime newdate) {
                                setState(() {
                                  _date = newdate;
                                });
                              },
                              mode: CupertinoDatePickerMode.date,
                            ),
                          );
                          // Navigator.of(context).popUntil((route) => false)
                        });
                  },
                  child: Text('SELECT DATE'),
                ),
          SizedBox(height: 10),
          Text(
            'Selected Date: ${dateFormatter.format(_date)}',
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newdate) {
                          setState(() {
                            _time = newdate;
                          });
                        },
                        mode: CupertinoDatePickerMode.time,
                      ),
                    );
                    // Navigator.of(context).popUntil((route) => false)
                  });
            },
            child: Text('SELECT TIME'),
          ),
          SizedBox(height: 10),
          Text(
            'Selected time: ${timeFormatter.format(_time)}',
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.green,
        ),
        child: IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              Path newPath = await Provider.of<Paths>(context, listen: false)
                  .addPath(_theme, _date, _time);
              print("Hello");

              Navigator.of(context).pushReplacementNamed(
                  ViewPathScreen.routeName,
                  arguments: newPath.id);
            }),
      ),
    );
  }

  Widget buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20.0, bottom: 8.0),
        child: Text(
          label,
          style: buildRobotoTextStyle(20.0, Colors.black),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Theme(
          data: ThemeData(
            primaryColor: seafoamGreen,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 36.0,
            child: buildTextFormField(controller),
          ),
        ),
      ),
    ]);
  }

  Widget buildTextFormField(TextEditingController controller) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a Title';
        }
        return null;
      },
      showCursor: true,
      decoration: InputDecoration(
        errorStyle: TextStyle(height: 0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        filled: true,
        fillColor: Colors.grey[200].withOpacity(0.75),
      ),
      style: buildRobotoTextStyle(14.0, Colors.black),
    );
  }
}
