import 'package:echos/screens/register/register_provider.dart';
import 'package:flutter/material.dart';

class RegisterUserDataFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RegisterPageProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () {
            provider.tryToLogOut(context);
          },
          icon: Icon(Icons.arrow_back_ios)
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: provider.userDataFormKey,
                child: Column(
                  children: [
                    Spacer(),
                    /// Full name field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full name",
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
                              initialValue: provider.selectedFullName,
                              keyboardType: TextInputType.name,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                              decoration: InputDecoration( 
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Full name",
                              ),
                              validator: provider.validateFullName,
                              onChanged: provider.updateSelectedFullName,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              initialValue: provider.selectedEmail,
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
                              initialValue: provider.selectedPassword,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("8-character minimum; case sensitive"),
                    ),
                     /// Password confirmation field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Re-enter password",
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
                              initialValue: provider.selectedReenteredPassword,
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
                              validator: provider.validateReenteredPassword,
                              onChanged: provider.updateSelectedReenteredPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: TextButton(
                        onPressed: (){
                          provider.signUpWithEmailAndPasswordAndLinkWithPhoneNumber(context);
                        },
                        child: Text("Register"),
                      ),
                    ),
                    Spacer(),
                  ]
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
      ),
    );
  }
}