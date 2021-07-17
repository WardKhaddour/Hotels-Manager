import 'dart:io';

class CheckInternet {
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on Exception catch (error) {
      print('error in connection $error');
      return false;
    }
  }
}
