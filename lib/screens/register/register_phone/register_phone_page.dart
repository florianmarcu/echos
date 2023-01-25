import 'package:country_list/country_list.dart';
import 'package:echos/screens/authentication/authentication_page.dart';
import 'package:echos/screens/authentication/authentication_provider.dart';
import 'package:echos/screens/register/register_provider.dart';
import 'package:echos/screens/register/register_verify_phone/register_verify_phone_page.dart';
import 'package:flutter/material.dart';

class RegisterPhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Countries.list.length);
    var provider = context.watch<RegisterPageProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(),
                  /// Register
                  Text("Register", style: Theme.of(context).textTheme.headline1,),
                  /// Create new account
                  Text("Create a new account", style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
                  Spacer(),
                  Form(
                    key: provider.phoneNumberFormKey,
                    child: Column(
                      children: [
                        /// Country
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
                          child: DropdownButtonFormField<Country?>(
                            isExpanded: true,
                            menuMaxHeight: 400,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              label: Padding(
                                padding: const EdgeInsetsDirectional.only(top: 20.0),
                                child: Text("Country"),
                              ),
                              prefixIcon: Container(
                                padding: EdgeInsetsDirectional.all(8),
                                width: 50,
                                child: Image.asset('icons/flags/png/${provider.selectedCountry!.isoCode.toLowerCase()}.png', package: 'country_icons',),
                              ),
                            ),
                            value: provider.selectedCountry,
                            items: Countries.list.map((country) => DropdownMenuItem<Country?>(
                              value: country,
                              child: Container(
                                child: Text(country.name, style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary)),
                              )
                            )).toList(),
                            onChanged: provider.updateSelectedCountry,
                          ),
                        ),   
                        SizedBox(height: 20,),
                        ///Phone number
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
                            initialValue: provider.selectedPhoneNumber,
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration( 
                              hintText: "712345678",
                              label: Padding(
                                padding: const EdgeInsetsDirectional.only(top: 20.0),
                                child: Text("Enter phone number"),
                              ),
                              prefixIcon: Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: Text("${provider.selectedCountry!.dialCode}", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).primaryColor),),
                              )
                            ),
                            onChanged: provider.updateSelectedPhoneNumber,
                          ),
                        ),        
                         
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  /// Already have an account? Log In
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "Already have an account?", style: Theme.of(context).textTheme.headline6,),
                    WidgetSpan(child: SizedBox(width: 10,)),
                    WidgetSpan(child: GestureDetector(
                      child: Text("Log in", style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (_) => AuthenticationPageProvider(),
                          child: AuthenticationPage(),
                        )));
                      },
                    )),
                  ])),
                  Spacer(),
                  ///Privacy policy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "I have read and accept the ", style: Theme.of(context).textTheme.bodyText2
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: (){},
                                child: Text("Privacy Policy", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.primary)),
                              )
                            ),
                            TextSpan(
                              text: "\nand agree that my personal data will be\nprocessed by you."
                            ),
                          ]
                        )
                      ),
                      Checkbox(
                        fillColor: MaterialStateProperty.all<Color>(Colors.green),
                        side: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1),
                        value: provider.isPrivacyPolicyAgreed, 
                        onChanged: provider.updateIsPrivacyPolicyAgreed
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "I have read and accept the ", style: Theme.of(context).textTheme.bodyText2
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: (){},
                            child: Text("Terms of use", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.primary)),
                          )
                        ),
                        TextSpan(
                          text: ".", style: Theme.of(context).textTheme.bodyText2
                        ),
                      ])),
                      Checkbox(
                        fillColor: MaterialStateProperty.all<Color>(Colors.green),
                        side: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 1),
                        value: provider.isTermsAndConditionsAgreed, 
                        onChanged: provider.updateIsTermsAndConditionsAgreed
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: TextButton(
                      onPressed: () async{
                        var result = await provider.startPhoneAuth(context);
                        if(result == true)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                            value: provider,
                            child: RegisterVerifyPhonePage(),
                          )));
                      },
                      child: Text("Next"),
                    ),
                  ),
                  Spacer()
                ],
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