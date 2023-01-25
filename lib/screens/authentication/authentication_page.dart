import 'package:echos/screens/authentication/authentication_provider.dart';
import 'package:echos/screens/forgot_password/forgot_password_page.dart';
import 'package:echos/screens/forgot_password/forgot_password_provider.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AuthenticationPageProvider>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary,)
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: provider.formKey,
                child: Column(
                  children: [
                    Spacer(),
                    /// Log in
                    Text("Log in", style: Theme.of(context).textTheme.headline1,),
                    /// Log into your account
                    Text("If you already have an account, log in", style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.tertiary), textAlign: TextAlign.center,),
                    Spacer(),
                    /// Email field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0,1), 
                                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
                                  blurRadius: 4,
                                  spreadRadius: 0.1
                                ),
                              ]
                            ),
                            child: TextFormField(
                              initialValue: provider.email,
                              keyboardType: TextInputType.emailAddress,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                              decoration: InputDecoration( 
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Email",
                              ),
                              validator: provider.validateEmail,
                              onChanged: provider.updateSelectedEmail,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0,1), 
                                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
                                  blurRadius: 4,
                                  spreadRadius: 0.1
                                ),
                              ]
                            ),
                            child: TextFormField(
                              initialValue: provider.password,
                              obscureText: !provider.passwordVisible,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                              decoration: InputDecoration( 
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  highlightColor: Colors.grey[200],
                                  splashColor: Colors.grey[400],
                                  icon: Icon(Icons.visibility, color: Theme.of(context).unselectedWidgetColor,), 
                                  onPressed: provider.updatePasswordVisibility, 
                                  padding: EdgeInsets.zero, 
                                ),
                              ),
                              validator: provider.validatePassword,
                              onChanged: provider.updateSelectedPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forgot password?"),
                        SizedBox(width: 8,),
                        GestureDetector(
                          child: Text("Reset here", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).primaryColor)),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                            create: (_) => ForgotPasswordPageProvider(),
                            child: ForgotPasswordPage(),
                          ))),
                        )
                      ],
                    ),
                    Spacer(),
                    Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: TextButton(
                          onPressed: (){
                            provider.logIn(context);
                          },
                          child: Text("Log in"),
                        ),
                      ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
          provider.isLoading
          ? Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), backgroundColor: Colors.transparent,)
            ),
          )
          : Container(),
        ],
      )
    );
  }
}