
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class FCMService{

  //Asi cargamos la instancea que necesita firebase
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  //De esta forma creamos un stream que emititra el evento al recibir una notificacion
  //para asi poder ser escuchada desde otros widgets
  static StreamController<String> _messageStrean = new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStrean.stream;


  static Future _onBackgroungMessage( RemoteMessage message) async{

    print('Notificacion desde el background ${message.messageId}');
      //Asi emitimos el evento a traves del stream
    _messageStrean.add( message.notification?.title ?? 'Sin titulo');
  }

  static Future _onMessageHandler( RemoteMessage message) async{

    print('Notificacion desde el background ${message.messageId}');

    print('Data recibida de la notificacion ${message.data}');

    _messageStrean.add( message.notification?.title ?? 'Sin titulo');
  }

  static Future _onMessageOpenApp( RemoteMessage message) async{

    print('Notificacion desde el background ${message.messageId}');

    _messageStrean.add( message.notification?.title ?? 'Sin titulo');
  }

//Este metodo inicializa la configuracion de la app y obtenemos el token
  static Future initializeApp() async{

     await Firebase.initializeApp();

     token = await FirebaseMessaging.instance.getToken();

      //Asi asignamos los callback para manejar los eventos de las notificaciones
      //Cuando la app esta en el background, ya sea cerrada
      FirebaseMessaging.onBackgroundMessage( _onBackgroungMessage );
      //Cuando llega una notificacion mientras la app esta abierta
      FirebaseMessaging.onMessage.listen( _onMessageHandler );
      //Cuando se el usuario abre la notificacion 
      FirebaseMessaging.onMessageOpenedApp.listen( _onMessageOpenApp);



     print('Este es el token generado del usuario: $token');

  }

  static closStreams(){
    _messageStrean.close();
  }


}