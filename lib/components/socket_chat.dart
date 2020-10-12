import 'dart:convert';
import 'package:chat_app/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatWidget extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChatWidget());
  }

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  SocketIO socketIO;
  List<String> messages;
  double height, width, padding;
  TextEditingController textController;
  ScrollController scrollController;

  @override
  void initState() {
    //Initializing the message list
    messages = List<String>();
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://dry-coast-27898.herokuapp.com/',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();
    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => messages.add(data['message']));
    });
    //Connect to the socket
    socketIO.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context
                .bloc<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    child: Text(
                      messages[index],
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                );
              },
            ),

          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Send a message...',
                    ),
                    controller: textController,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    //Check if the textfield has text or not
                    if (textController.text.isNotEmpty) {
                      //Send the message as JSON data to send_message event
                      socketIO.sendMessage('send_message',
                          json.encode({'message': textController.text}));
                      //Add the message to the list
                      this.setState(() => messages.add(textController.text));
                      textController.clear();
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 100.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      //Scrolldown the list to show the latest message
                    }
                  },
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
