import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Notifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/second': (context) => SecondPage(),
        '/third': (context) => ThirdPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: Text('Go to Second Page'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              child: Text('Go to Third Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}

class BatteryNotifier extends StatefulWidget {
  @override
  _BatteryNotifierState createState() => _BatteryNotifierState();
}

class _BatteryNotifierState extends State<BatteryNotifier> {
  final Battery _battery = Battery();
  final FlutterTts _flutterTts = FlutterTts();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _initBatteryListener();
  }

  void _initBatteryListener() async {
    // Get current battery level
    _batteryLevel = await _battery.batteryLevel;
    setState(() {});

    // Listen for battery level changes
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      _batteryLevel = await _battery.batteryLevel;
      setState(() {});

      if (_batteryLevel < 15) {
        _notifyUser();
      }
    });
  }

  void _notifyUser() async {
    await _flutterTts.speak("Warning! Your battery level is below 15 percent.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Level'),
      ),
      body: Center(
        child: Text(
          'Battery Level: $_batteryLevel%',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
