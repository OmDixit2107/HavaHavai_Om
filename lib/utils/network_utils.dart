import 'dart:io';

class NetworkUtils {
  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      print('Error checking internet connectivity: $e');
      return false;
    }
  }
}
