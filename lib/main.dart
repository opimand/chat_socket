import 'package:bloc/bloc.dart';
import 'package:chat_app/app.dart';
import 'package:chat_app/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:authentication_repository/authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<FireBaseUser>.value(
//       value: AuthService().user,
//       child: MaterialApp(
//         home: Wrapper(),
//       ),
//     );
//   }
// }
