import 'dart:async';

class FirebaseService {
  static final _controller = StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get sensorStream => _controller.stream;

  static void updateData(Map<String, dynamic> data) {
    _controller.add(data);
  }

  static Future<void> sendDrainCommand(bool drain) async {
    // Will connect to Firebase when running on phone
    print('Drain command: $drain');
  }
}