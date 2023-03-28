import 'package:flutter/material.dart';
import 'package:push_notifications_app/services/push_notifications_service.dart';


import 'package:push_notifications_app/screens/screens.dart';

void main() async {

  //asegurarnos de que un context estara listo antes de esta intstruccion
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationServices.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    //Context!
    PushNotificationServices.messagesStream.listen((message) {

      // print('MyApp: $message');
      navigatorKey.currentState?.pushNamed('Message', arguments: message);

      final snackBar = SnackBar(content: Text( message ));
      messengerKey.currentState?.showSnackBar(snackBar);

     });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Quitar el debug banner de la app
      debugShowCheckedModeBanner: false,

      title: 'Push Notifications',
      initialRoute: 'Home',

      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: messengerKey, //Mostrar snacks

      routes: {
        'Home'    : ( _ ) => const HomeScreen(),
        'Message' : ( _ ) => const MessageScreen(),
      }
    );
  }
}