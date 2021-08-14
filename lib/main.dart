// import 'dart:html';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('', [
    NotificationChannel(
      channelKey: 'base-notification',
      channelName: "Base Notification",
      defaultColor: Colors.red,
      ledColor: Colors.white,
      channelShowBadge: true,
      playSound: true,
      importance: NotificationImportance.High,
      channelDescription: '${Emojis.hand_selfie}+ Some notifications',
    )
  ]);
  // AmbientLightSensor();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Show the some test notification'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    ' Allow',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification created'),
        ),
      );
    });

    AwesomeNotifications().actionStream.listen((notification) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationPage(),
          ),
          (route) => route.isFirst);
    });
  }

  int createId() {
    int date = DateTime.now().millisecondsSinceEpoch.remainder(1000);
    return date;
  }

  Future<void> crateNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 3,
            channelKey: 'base-notification',
            body: 'some notification on test',
            title:
                '${Emojis.money_money_bag + Emojis.plant_cactus} Buy Plant Food!!!'));
  }

  @override
  void dispose() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button to see notification',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crateNotification,
        tooltip: 'push Notification',
        child: Icon(
          Icons.notifications,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Notification page',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
