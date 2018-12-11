import 'package:flutter/material.dart';

import './pokemon.dart';
import './pokemon_create.dart';
import './pokemon_owned.dart';

class PokemonAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("Julian Currie"),
              ),
              ListTile(
                title: Text('All Pokemon'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Pokemon()),
                  );
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Pokemon'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: "Create Pokemon",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "My Pokemon",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PokemonCreatePage(),
            PokemonOwnedPage(),
          ],
        ),
      ),
    );
  }
}
