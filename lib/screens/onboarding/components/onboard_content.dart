import 'package:flutter/material.dart';
import 'package:echos/utils/utils.dart';

class OnboardContent extends StatelessWidget {
  final String image;
  final String title;
  final String content;

  OnboardContent(this.image, this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 30, bottom: 0),
            child: Image.asset(
              localAsset(image), 
              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.5,
            ),
          ),
        ),
        Spacer(),
        Text(title, style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
        Spacer(),
        Text(content, style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor, fontSize: 17)),
        //Spacer()
      ],
    );
  }
}