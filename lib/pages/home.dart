import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/data/Section.dart';
import 'package:youth_app/data/Task.dart';
import 'package:youth_app/pages/task.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'package:youth_app/data/User.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static const String ROUTE = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Section>> getSections() async {
    var cache = Provider.of<Cache>(context);
    var sections;

    if((sections = cache.getStringIfBefore('sections', 3600)) != null) {
      return Section.fromList(jsonDecode(sections)['sections'] ?? []);
    }

    var response = await Request('/sections', token: Provider.of<User>(context).apiToken).get();

    if(response.statusCode == 200) {
      cache.setStringWithTime('sections', response.body);

      sections = jsonDecode(response.body)['sections'];
    }

    return Section.fromList(sections ?? []);
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

                var sections = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, i) {
                    Section section = sections.elementAt(i);

                    return Container(
                      child: Card(
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            section.name,
                          ),
                          children: section.tasks.map<Widget>((Task task) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5,),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(128, 201, 54, 0.8),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.of(context).pushNamed(TaskPage.ROUTE, arguments: task),
                                child: Text(
                                  task.name,
                                  textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
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