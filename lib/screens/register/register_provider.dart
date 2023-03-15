import 'dart:async';
import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list/country_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_provider.dart';
import 'register_user_data_form/register_user_data_form_page.dart';
export 'package:provider/provider.dart';

class RegisterPageProvider with ChangeNotifier{
  bool isLoading = false;
  bool? isPrivacyPolicyAgreed = false;
  bool? isTermsAndConditionsAgreed = false;
  String? selectedFullName;
  String? selectedEmail;
  String? selectedPassword;
  String? selectedReenteredPassword;
  Country? selectedCountry = Countries.list.first;
  String? selectedPhoneNumber = ""; 
  bool passwordVisible = false;
  // var countryList = Countries.list.map((country) => DropdownMenuItem<String>(
  //   value: country.name,
  //   child: Text(country.name)
  // )).toList();
  String remainingTime = "00:59";
  int remainingTimeInSeconds = 59;
  bool isCooldownActive = false;
  String? smsCode;
  String? verificationId;
  GlobalKey<FormState> phoneNumberFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> userDataFormKey = GlobalKey<FormState>();


  RegisterPageProvider(){
    getData();
  }

  Future<void> getData() async{
    _loading();

    _loading();
    notifyListeners();
  }

  Future<bool?> startPhoneAuth(BuildContext context) async{
    _loading();

    try{
      if(selectedCountry == null || selectedPhoneNumber == null || selectedPhoneNumber == "") 
        throw FirebaseAuthException(code: "wrong-phone-number"); 
      if(isPrivacyPolicyAgreed != true)
        throw FirebaseAuthException(code: "privacy-policy-not-accepted"); 
      if(isTermsAndConditionsAgreed != true)
        throw FirebaseAuthException(code: "terms-and-conditions-not-accepted");

      var phoneNumber = selectedCountry!.dialCode + selectedPhoneNumber!;

      /// Check if there already exists a user account with the specified phone number
      var query = await FirebaseFirestore.instance.collection('users').where("phone_number", isEqualTo: phoneNumber).get(); 
      if(query.docs.length == 0) 
        await Authentication.verifyPhoneNumber(phoneNumber, context, this);
      else throw FirebaseAuthException(code: "user-already-exists");
    }
    on FirebaseAuthException
    catch(e){
      handleError(context, e.code);

      _loading();

      return false;
    }


    !isCooldownActive
    ? resetAndStartCooldownTimer()
    : null;


    _loading();
    notifyListeners();
    return true;
  }

  void signUpWithPhoneNumber(BuildContext context) async{
    _loading();

    /// Check if the sms code is valid
    if(smsCode != null && verificationId != null){
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: smsCode!);
      var userCredential = await Authentication.auth.signInWithCredential(phoneAuthCredential);
      if(userCredential.user != null)
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: RegisterUserDataFormPage()
        )));
    }

    _loading();
    notifyListeners();
  }

  void signUpWithEmailAndPasswordAndLinkWithPhoneNumber(BuildContext context) async{
    _loading();

    if(userDataFormKey.currentState!.validate())
      try{
        var result = await Authentication.signUpWithEmailAndPasswordAndLinkWithPhoneNumber(selectedFullName!, selectedEmail!, selectedPassword!);
        if(result != null && result.runtimeType == FirebaseAuthException){
          throw result;
        }
        else {
          // Refresh current user
          // if(Authentication.auth.currentUser != null && result.runtimeType == AuthCredential){
          print("------------REAUTH--------------");
            // await Authentication.signOut();
          await Authentication.auth.currentUser!.reload();
          // }
          // if((await SharedPreferences.getInstance()).getBool('welcome') == true){
            Navigator.pop(context);
            Navigator.pop(context);
          // }
          // Navigator.pop(context);

          }
      }
      on FirebaseAuthException
      catch(error){
        handleError(context, error.code);
        _loading();
        notifyListeners();
      }
  }

  void tryToLogOut(BuildContext context){
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Container(
              height: 150,
              width: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Are you sure you want to leave this page? You will lose the progress."),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Stay"),
                        ),
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style!.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).highlightColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), 
                              side: BorderSide(
                                color: Theme.of(context).primaryColor
                              )
                            )),
                          ),
                          onPressed: () async{
                            Navigator.pop(context);
                            // _loading();
                            await Authentication.signOut();
                            // _loading();
                          },
                          child: Text(
                            "Leave", 
                            style: TextStyle(
                              fontSize: 17*(1/MediaQuery.textScaleFactorOf(context)),
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );

  }

  void handleError(BuildContext context, String? message){
    String displayedMessage = "";
    switch(message){
      case "user-already-exists":
        displayedMessage = "A user already exists associated with the given phone number";break;
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

  void resetCooldownTimer(){
    this.remainingTime = "00:59";
    this.remainingTimeInSeconds = 59;
    isCooldownActive = false;

    notifyListeners();
  }

  void resetAndStartCooldownTimer(){

    this.isCooldownActive = true;
    this.remainingTime = "00:59";
    this.remainingTimeInSeconds = 59;
    
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(remainingTimeInSeconds == 0){
        timer.cancel();
        isCooldownActive = false;
      }
      else{
        remainingTimeInSeconds -= 1;
        if(remainingTimeInSeconds ~/ 60 == 0 && remainingTimeInSeconds > 10){
          remainingTime = "00:${remainingTimeInSeconds}";
        } 
        else remainingTime = "00:0${remainingTimeInSeconds}";
      }

      notifyListeners();
    });

    notifyListeners();
  }

  String? validateFullName(String? fullName){
    if(fullName == null || fullName == "")
      return "You must enter a valid name";
    return null;
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

  String? validateReenteredPassword(String? reenteredPassword){
    if(reenteredPassword != selectedPassword)
      return "The re-entered password doesn't match";
    return null;
  }

  void updateIsPrivacyPolicyAgreed(bool? isPrivacyPolicyAgreed){
    this.isPrivacyPolicyAgreed = isPrivacyPolicyAgreed;
    
    notifyListeners();
  }

  void updateIsTermsAndConditionsAgreed(bool? isTermsAndConditionsAgreed){
    this.isTermsAndConditionsAgreed = isTermsAndConditionsAgreed;
    
    notifyListeners();
  }

  void updateSelectedCountry(Country? country){
    this.selectedCountry = country;

    notifyListeners();
  }

  void updateSelectedPhoneNumber(String? phoneNumber){
    this.selectedPhoneNumber = phoneNumber;

    notifyListeners();
  }

  void updateSmsCode(String? code){
    this.smsCode = code;

    notifyListeners();
  }

  void updateVerificationId(String verificationId){
    this.verificationId = verificationId;

    notifyListeners();
  }

  void updateSelectedFullName(String? fullName){
    this.selectedFullName = fullName;

    notifyListeners();
  }

  void updateSelectedEmail(String? email){
    this.selectedEmail = email;

    notifyListeners();
  }

  void updateSelectedPassword(String? password){
    this.selectedPassword = password;

    notifyListeners();
  }

  void updateSelectedReenteredPassword(String? reenteredPassword){
    this.selectedReenteredPassword = reenteredPassword;

    notifyListeners();
  }
  
  void updatePasswordVisibility(){
    passwordVisible = !passwordVisible;

    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}