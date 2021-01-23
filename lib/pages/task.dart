import 'dart:async';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/data/Task.dart';
import 'package:youth_app/data/User.dart';
import 'package:youth_app/utils/Request.dart';

class TaskPage extends StatefulWidget {
  TaskPage({Key key}) : super(key: key);

  static const String ROUTE = "/task";

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  bool _isLoading = false;
  bool _done = false;

  showModalBottomSheetSuccess(var callback) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            width: 200,
            height: 200,
            child: FlareActor(
              "assets/Check.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "go",
              callback: (_) {
                Navigator.pop(context);

                callback();
              },
            ),
          ),
        );
      },
    );
  }

  void _markAsDone(var id) async {
    setState(() {
      _isLoading = true;
    });

    var response = await Request('/tasks/' + id.toString(), token: Provider.of<User>(context, listen: false).apiToken).post();

    if(response.statusCode == 200)
      showModalBottomSheetSuccess((value) => Navigator.pop(context));

    setState(() {
      _isLoading = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Task task = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Task"),
        actions: [

          Builder(
            builder: (BuildContext context) {
              return Visibility(
                visible: !_isLoading,
                child: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: _done ? null : () => _markAsDone(task.id),
                  tooltip: 'Mark as Completed',
                ),
                replacement: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            },
          ),

        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Text(
            task.name,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}