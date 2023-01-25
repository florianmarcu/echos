import 'package:echos/screens/register/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class RegisterVerifyPhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RegisterPageProvider>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios)
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            /// Register
            Text("Verification", style: Theme.of(context).textTheme.headline1,),
            /// Create new account
            Text("Echos has sent a code to\n verify your account", style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.tertiary), textAlign: TextAlign.center,),
            Spacer(),
            Text("SMS Code"),
            SizedBox(height: 20,),
            /// The verification code input
            Pinput(
              length:  6,
              onChanged: provider.updateSmsCode,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Resend button
                GestureDetector(
                  onTap: !provider.isCooldownActive
                  ? (){
                    provider.resetAndStartCooldownTimer();
                  }
                  : null,
                  child: Text("Resend", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: 
                    provider.isCooldownActive
                    ? Theme.of(context).primaryColor.withOpacity(0.3)
                    : Theme.of(context).primaryColor
                  ))
                ),
                SizedBox(width: 15,),
                /// Resend cooldown
                Text(provider.remainingTime)
              ],
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: TextButton(
                onPressed: (){
                  provider.signUpWithPhoneNumber(context);
                },
                child: Text("Next"),
              ),
            ),
            Spacer()
          ]
        ),
      ),
    );
  }
}