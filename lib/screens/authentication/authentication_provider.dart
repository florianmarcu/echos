import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class AuthenticationPageProvider with ChangeNotifier{

  bool isLoading = false;
  String? email = "";
  String? password = "";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

  
  void logIn(BuildContext context) async{
    _loading();

    if(formKey.currentState!.validate()){
      var result = await Authentication.signInWithEmailAndPassword(email!, password!);
      if(result.runtimeType == FirebaseAuthException){
        handleError(context, result.error);
      }
      else Navigator.pop(context);
    }
    _loading();
    notifyListeners();
  }

  void updateSelectedEmail(String? email){
    this.email = email;

    notifyListeners();
  }

  void updateSelectedPassword(String? password){
    this.password = password;

    notifyListeners();
  }

  void updatePasswordVisibility(){
    passwordVisible = !passwordVisible;

    notifyListeners();
  }

  String? validateEmail(String? email){
    if(email == null || email == "")
      return "You must enter an email";
    if(email.contains("@") == false || email.contains(".") == false || email.indexOf("@") > email.lastIndexOf("."))
      return "You must enter a valid email";
    return null;

  }

  String? validatePassword(String? password){
    if(password == null || password == "")
      return "You must enter a valid password";
    if(password.length < 8)
      return "You must enter a password that is at least 8 characters long";
    return null;
  }

  void handleError(BuildContext context, String? message){
    String displayedMessage = "";
    switch(message){
      case "wrong-phone-number":
        displayedMessage = "The provided phone number is invalid.";break;
      case "privacy-policy-not-accepted":
        displayedMessage = "Privacy policy must be accepted.";break;
      case "terms-and-conditions-not-accepted":
        displayedMessage = "Terms and conditions must be accepted.";break;
      default:
        displayedMessage = "An error has occured, try again later";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(displayedMessage) 
    ));
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}