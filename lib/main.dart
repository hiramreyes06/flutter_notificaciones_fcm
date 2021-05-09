import 'package:flutter/material.dart';
import 'package:notificaciones_fcm/src/services/fcm_service.dart';
import 'package:notificaciones_fcm/src/vistas/home_screen.dart';
import 'package:notificaciones_fcm/src/vistas/message.dart';
 
void main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await FCMService.initializeApp();

runApp(MyApp());

}
 
 //Es necesario convertir el widget principal a un statfull
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //Asi se obtiene la referencia al contexto
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  //Es necesario marcar el estado de la app para escuchar las notificaciones
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//Aqui ya tenemos un contexto, para poder reaccionar a las notificaciones y navegar
  FCMService.messagesStream.listen((message) { 

    print('My app: $message');

    navigatorKey.currentState?.pushNamed('message', arguments: message);

    final snackBar = SnackBar(content: Text(message));

    messengerKey.currentState?.showSnackBar(snackBar);


  });


  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      initialRoute: 'home',
      routes: {
        'home' : ( _ ) => HomeScrenn(),
        'message': ( _ ) => Message()
      },

    );
  }
}