import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Alarm Clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
        hintColor: Colors.greenAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  List<Alarm> alarms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text(' Alarm Clock'),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.pink[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Set Your Alarm',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeInputField(hourController, 'Hour'),
                    const SizedBox(width: 20),
                    _buildTimeInputField(minuteController, 'Minute'),
                  ],
                ),
                const SizedBox(height: 30),
                _buildActionButton(
                  'Create Alarm',
                  Icons.alarm_add,
                  () {
                    int? hour = int.tryParse(hourController.text);
                    int? minutes = int.tryParse(minuteController.text);

                    if (hour != null && minutes != null) {
                      FlutterAlarmClock.createAlarm(
                          hour: hour, minutes: minutes);
                      setState(() {
                        alarms.add(
                            Alarm(hour: hour, minute: minutes, isActive: true));
                      });
                    } else {
                      showErrorDialog(
                          context, 'Please enter valid hour and minute.');
                    }
                  },
                ),
                const SizedBox(height: 15),
                _buildActionButton(
                  'Show Alarms',
                  Icons.access_alarms,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlarmListPage(alarms: alarms),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInputField(TextEditingController controller, String hint) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Container(
        width: 80,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintStyle: TextStyle(color: Colors.grey[300]),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.tealAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class Alarm {
  final int hour;
  final int minute;
  bool isActive;

  Alarm({required this.hour, required this.minute, required this.isActive});
}

class AlarmListPage extends StatefulWidget {
  final List<Alarm> alarms;

  AlarmListPage({required this.alarms});

  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm List'),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.pink[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.alarms.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(
                  Icons.alarm,
                  color: Colors.green,
                  size: 36,
                ),
                title: Text(
                  '${widget.alarms[index].hour}:${widget.alarms[index].minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Switch(
                  value: widget.alarms[index].isActive,
                  onChanged: (bool value) {
                    setState(() {
                      widget.alarms[index].isActive = value;

                      if (value) {
                        FlutterAlarmClock.createAlarm(
                          hour: widget.alarms[index].hour,
                          minutes: widget.alarms[index].minute,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Alarm for ${widget.alarms[index].hour}:${widget.alarms[index].minute.toString().padLeft(2, '0')} is turned off',
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
