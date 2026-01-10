import 'user.dart';
import '../enum/enum.dart';

class LoginResponse {
  final LoginStatus status;
  // final User? user;
  final String? message;

  LoginResponse({
    required this.status,
    // this.user,
    this.message,
  });
}