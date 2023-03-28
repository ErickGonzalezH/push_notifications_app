import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class PushNotificationServices {

  //Obtener instancia de firebase messaging
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler( RemoteMessage  message) async {
    // print('onBackground Handler ${message.messageId}');
    print( message.data );
    _messageStream.sink.add( message.data['product'] ?? 'No data' );
  }

  static Future _onMessageHandler( RemoteMessage  message) async {
    // print('onMessage Handler ${message.messageId}');

    print( message.data );
    _messageStream.sink.add( message.data['product'] ?? 'No data' );
  }

  static Future _onMessageOpenApp( RemoteMessage  message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');
    print( message.data );
    _messageStream.sink.add( message.data['product'] ?? 'No data' );
  }


  static Future initializeApp() async {
     
    // Push Notifications
    //generar token
    await Firebase.initializeApp();
    await messaging.getInitialMessage();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage( _backgroundHandler );
    FirebaseMessaging.onMessage.listen( _onMessageHandler );
    FirebaseMessaging.onMessageOpenedApp.listen( _onMessageOpenApp );
    


    // Local Notifications

  }

  static closeStreams() {
    _messageStream.close();
  }


}