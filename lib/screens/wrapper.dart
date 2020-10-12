import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/authentication/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireBaseUser>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    }
    return Home();
  }
}
