import 'package:country_list/country_list.dart';
import 'package:echos/screens/configure_device/components/configure_sms_message_page.dart';
import 'package:echos/screens/configure_device/configure_device_provider.dart';
import 'package:flutter/material.dart';

import 'components/configure_email_message_page.dart';

class ConfigureDevicePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ConfigureDevicePageProvider>();
    print(provider.newButtonSettings);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton.extended(
          backgroundColor: !provider.haveSettingsChanged
          ? Colors.grey[400]
          : Theme.of(context).primaryColor,
          heroTag: null,
          elevation: 2,
          onPressed: !provider.haveSettingsChanged
          ? null
          : (){
            if(provider.formKey.currentState!.validate()) {
              provider.saveChanges().then((value) {
                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Changes saved successfully!")
                ));
              });
            }
          }, 
          label: Text('Save changes', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).canvasColor),)
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary,)
        ),
        title: Text(
          "Configure"
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: provider.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Switch.adaptive( /// Switch for button's state
                        activeColor: Theme.of(context).primaryColor,
                        value: provider.newButtonSettings['on_press'] ?? false, 
                        onChanged: (value) => provider.updateButtonSettings("on_press", value)
                      ),
                      Container( /// Switch's text
                        width: 230,
                        child: Stack(
                          children: [
                            Text("React when pressed", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Tooltip(
                                showDuration: Duration(milliseconds: 10000),
                                triggerMode: TooltipTriggerMode.tap,
                                child: Icon(Icons.info, size: 20, color: Theme.of(context).colorScheme.tertiary),
                                message: "Whenever pressed, the physical button will send an email, make a phone call and send an SMS.\n\nMake sure you only use it in emergency situations.",
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding( /// Number for phone call title
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Make phone call to phone number", style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  Row( /// Number for phone call field
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.phone, color: Theme.of(context).colorScheme.tertiary),
                      SizedBox(width: 10),
                      /// country code for call
                      Container(
                        width: MediaQuery.of(context).size.width*0.32,
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
                        child: DropdownButtonFormField<String?>(
                          isExpanded: true,
                          menuMaxHeight: 400,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            // label: Padding(
                            //   padding: const EdgeInsetsDirectional.only(top: 20.0),
                            //   child: Text("Country"),
                            // ),
                            prefixIcon: Container(
                              padding: EdgeInsetsDirectional.all(8),
                              width: 40,
                              child: Image.asset('icons/flags/png/${Countries.list.firstWhere((country) => country.dialCode == provider.newButtonSettings['call_phone_number_prefix']).isoCode.toLowerCase()}.png', package: 'country_icons',),
                            ),
                          ),
                          value: provider.newButtonSettings['call_phone_number_prefix'] ?? "",
                          items: Countries.list.map((country) => DropdownMenuItem<String?>(
                            value: country.dialCode,
                            child: Container(
                              child: Text(
                                country.dialCode == provider.newButtonSettings['call_phone_number_prefix']
                                ? "${country.dialCode}"
                                :"${country.name} | ${country.dialCode}" , 
                                style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary)
                              ),
                            )
                          )).toList(),
                          onChanged: (value) => provider.updateButtonSettings("call_phone_number_prefix", value),

                        ),
                      ),
                      SizedBox(width: 10,),
                      /// phone number for call
                      Container(
                        width: MediaQuery.of(context).size.width*0.48,
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
                          controller: provider.callPhoneNumberTextFieldController,
                          validator: provider.validateCallPhoneNumber,
                          //initialValue: provider.newButtonSettings['call_phone_number'],
                          keyboardType: TextInputType.phone,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: "712345678",
                            // label: Padding(
                            //   padding: const EdgeInsetsDirectional.only(top: 20.0, start: 10),
                            //   child: Text("Enter phone number"),
                            // ),
                            // prefixIcon: Container(
                            //   width: 50,
                            //   alignment: Alignment.center,
                            //   child: Text("${provider.selectedSmsPhoneNumberCountry!.dialCode}", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).primaryColor),),
                            // )
                          ),
                          onChanged: (value) => provider.updateButtonSettings('call_phone_number', value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Send SMS to phone number", style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.sms, color: Theme.of(context).colorScheme.tertiary),
                      SizedBox(width: 10),
                      /// country code for sms
                      Container(
                        width: MediaQuery.of(context).size.width*0.32,
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
                        child: DropdownButtonFormField<String?>(
                          isExpanded: true,
                          menuMaxHeight: 400,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            // label: Padding(
                            //   padding: const EdgeInsetsDirectional.only(top: 20.0),
                            //   child: Text("Country"),
                            // ),
                            prefixIcon: Container(
                              padding: EdgeInsetsDirectional.all(8),
                              width: 40,
                              child: Image.asset('icons/flags/png/${Countries.list.firstWhere((country) => country.dialCode == provider.newButtonSettings['sms_phone_number_prefix']).isoCode.toLowerCase()}.png', package: 'country_icons',),
                            ),
                          ),
                          value: provider.newButtonSettings['sms_phone_number_prefix'] ?? "",
                          items: Countries.list.map((country) => DropdownMenuItem<String?>(
                            value: country.dialCode,
                            child: Container(
                              child: Text(
                                country.dialCode == provider.newButtonSettings['sms_phone_number_prefix']
                                ? "${country.dialCode}"
                                :"${country.name} | ${country.dialCode}" , 
                                style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary)
                              ),
                            )
                          )).toList(),
                          onChanged: (value) => provider.updateButtonSettings("sms_phone_number_prefix", value),

                        ),
                      ),   
                      SizedBox(width: 10,),
                      /// phone number for sms
                      Container(
                        width: MediaQuery.of(context).size.width*0.48,
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
                          controller: provider.smsPhoneNumberTextFieldController,
                          validator: provider.validateSmsPhoneNumber,
                          //initialValue: provider.newButtonSettings['sms_phone_number'] ?? "",
                          keyboardType: TextInputType.phone,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration( 
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: "712345678",
                            errorMaxLines: 2
                            // label: Padding(
                            //   padding: const EdgeInsetsDirectional.only(top: 20.0, start: 10),
                            //   child: Text("Enter phone number"),
                            // ),
                            // prefixIcon: Container(
                            //   width: 50,
                            //   alignment: Alignment.center,
                            //   child: Text("${provider.selectedSmsPhoneNumberCountry!.dialCode}", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).primaryColor),),
                            // )
                          ),
                          onChanged: (value) => provider.updateButtonSettings('sms_phone_number', value),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider.value(
                                value: provider,
                                child: ConfigureSmsMessagePage()
                              )
                            ));
                          },
                          child: Text(
                            "Change message",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.underline, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(width: 10,),
                        provider.validateSmsMessage(provider.newButtonSettings['sms_message']) != null
                        ? Icon(Icons.info_outline, size: 15, color: Colors.red)
                        : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding( /// email title
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Send email to address", style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  Row(/// email field
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.email, color: Theme.of(context).colorScheme.tertiary),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width*0.8,
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
                          controller: provider.emailTextFieldController,
                          validator: provider.validateEmailAddress,
                          //initialValue: provider.newButtonSettings['email'] ?? "",
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration( 
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: "help@help.com",
                          ),
                          onChanged: (value) => provider.updateButtonSettings('email', value),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider.value(
                                value: provider,
                                child: ConfigureEmailMessagePage()
                              )
                            ));
                          },
                          child: Text(
                            "Change message",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.underline, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(width: 10,),
                        provider.validateEmailMessage(provider.newButtonSettings['email_message']) != null
                        ? Icon(Icons.info_outline, size: 15, color: Colors.red)
                        : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          provider.isLoading
          ? Container(
            height: 5,
            width: MediaQuery.of(context).size.width,
            child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
          )
          : Container(),
        ],
      ),
    );
  }
}