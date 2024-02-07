import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallLogScreen(),
    );
  }
}

class CallLogScreen extends StatefulWidget {
  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  List<CallLogEntry> _callLogs = [];

  @override
  void initState() {
    super.initState();
    _getCallLogs();
  }

  Future<void> _getCallLogs() async {
    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      setState(() {
        _callLogs = entries.toList();
      });
    } catch (e) {
      print("Error fetching call logs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Log App'),
        backgroundColor: const Color.fromARGB(255, 84, 76, 175),
      ),
      body: _buildCallLogList(),
    );
  }

  Widget _buildCallLogList() {
    if (_callLogs.isEmpty) {
      return Center(child: Text('No call logs available.'));
    }

    return ListView.builder(
      itemCount: _callLogs.length,
      itemBuilder: (context, index) {
        CallLogEntry entry = _callLogs[index];

        
        String duration = entry.duration != null
            ? _formatDuration(entry.duration!)
            : 'Unknown Duration';

        String timestamp = entry.timestamp != null
            ? _formatTimestamp(entry.timestamp!)
            : 'Unknown Timestamp';

        return ListTile(
          title: Text(entry.name ?? 'Unknown'),
          subtitle: Text(
              'Number: ${entry.number}\nDuration: $duration\nTime: $timestamp'),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  String _formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}
