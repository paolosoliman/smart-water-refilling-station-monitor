# smart-water-refilling-station-monitor

Project Title: Smart Water Refilling Station Monitor

Description: The Smart Water Refilling Station Monitor is a mobile application designed to monitor water quality, water level and refilling status in a water refilling station. IoT sensors collect water level and water quality data and send it to the cloud. The system helps water station owners monitor their tanks and ensure safe water quality while also providing alerts when refilling is needed.

Technologies Used:
- Flutter (Mobile Application)
- Dart Programming Language
- IoT Sensors
- ESP32 Microcontroller
- Firebase Cloud Platform
- Wi-Fi Communication

Features:
- Real-time water level monitoring
- Basic water quality monitoring
- Refill status alerts
- Water quality history records
- Mobile dashboard to monitor station status

Installation Instructions:
1. Clone the repository:
git clone https://github.com/yourusername/smart-water-refilling-station-monitor.git

2. Open the project using Flutter.

3. Install dependencies:
flutter pub get

4. Run the application:
flutter run or flutter run -d chrome

Setup:
1. Connect the water level and water quality sensors to the ESP32 microcontroller.
2. Configure the ESP32 to send data through Wi-Fi.
3. Connect the ESP32 to Firebase cloud services.
4. Run the Flutter mobile application to monitor the system.
