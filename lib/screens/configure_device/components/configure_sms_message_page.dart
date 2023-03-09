import 'package:echos/screens/configure_device/configure_device_provider.dart';
import 'package:flutter/material.dart';

class ConfigureSmsMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ConfigureDevicePageProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton.extended(
          backgroundColor: (provider.validateSmsMessage(provider.newButtonSettings['sms_message']) != null)
          ? Colors.grey[400]
          : Theme.of(context).primaryColor,
          heroTag: null,
          elevation: 2,
          onPressed: (provider.validateSmsMessage(provider.newButtonSettings['sms_message']) != null)
          ? null
          : (){
            if(provider.validateSmsMessage(provider.newButtonSettings['sms_message']) == null)
              Navigator.pop(context);
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
          "Change SMS message"
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0.1,
                  blurRadius: 10,
                  offset: const Offset(0, 0)
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width*0.9,
            //height: 300,
            child: TextFormField(
              validator: provider.validateSmsMessage,
              initialValue: provider.newButtonSettings['sms_message'],
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                
              ),
              minLines: 6,
              maxLines: 10,
              onChanged: (value) => provider.updateButtonSettings('sms_message', value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 25.0, vertical: 10),
            child: Text("You must enter a message that is at least 10 characters long."),
          )
        ],
      ),
    );
  }
}