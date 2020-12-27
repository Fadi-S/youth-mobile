import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'package:youth_app/utils/User.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future getSections() {
    Request request = Request('/sections', token: Provider.of<User>(context).apiToken);

    return request.get();
  }

  void _logout() {
    Provider.of<Cache>(context, listen: false).clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, User user, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Youth Meeting"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: _logout,
                tooltip: 'Logout',
              ),
            ],
          ),
          body: Center(
            child: FutureBuilder(
              future: getSections(),
              builder: (context, AsyncSnapshot snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                  return CircularProgressIndicator();
                if(snapshot.connectionState == ConnectionState.none)
                  return Center(child: Text('Error Loading sections'));

                var sections = jsonDecode(snapshot.data.body)['sections'];

                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, i) {
                    return Container(
                      child: Text(sections[i].name),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}