import 'package:chat_app/services/auth.dart';
import 'package:chat_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';

class SignIn extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignIn());
  }

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  //text filed state
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
              title: Text('Chat App'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  textColor: Colors.white,
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                // padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter an password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.teal[400],
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);

                              if (result == null) {
                                setState(() {
                                  error = 'Email or password incorrect';
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithGoogle();
                      if (result == null) {
                        setState(() {
                          error = 'Email or password incorrect';
                          loading = false;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("assets/google_logo.png"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 200.0,
                  child: OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithFacebook();
                      if (result == null) {
                        setState(() {
                          error = 'Email or password incorrect';
                          loading = false;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("assets/fb_logo.png"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
