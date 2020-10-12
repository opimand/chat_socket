import 'package:chat_app/services/auth.dart';
import 'package:chat_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[100],
            appBar: AppBar(
              backgroundColor: Colors.teal[400],
              elevation: 0.0,
              title: Text('Sign up'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  textColor: Colors.white,
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                          decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (val) => val.length < 6
                              ? 'Enter an password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.teal[400],
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);

                              dynamic result = await _auth
                                  .registerWithEmailAndPassword(email, password);
                              print(result);

                              if (result == null) {
                                setState(() {
                                  error = 'please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ]
            ),
          );
  }
}
