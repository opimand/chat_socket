import 'package:chat_app/components/socket_chat.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text('Chat me'),
        backgroundColor: Colors.teal[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
            ),
            label: Text(
                'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: ChatWidget(),
      ),

    );
  }
}