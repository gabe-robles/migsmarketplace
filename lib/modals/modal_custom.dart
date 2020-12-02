import 'package:flutter/material.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:migsmarketplace/components/custom_round_button.dart';

class CustomModal extends StatelessWidget {

  CustomModal({
    this.title,
    this.content,
    this.enableSecondaryAction,
    this.mainAction,
    this.secondaryAction,
    this.onPressed,
  });

  final String title;
  final String content;
  final bool enableSecondaryAction;
  final String mainAction;
  final String secondaryAction;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 280,
        width: 360,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: kH1Blue),
                Padding(padding: const EdgeInsets.all(12.0)),
                Text(content, style: kBody, softWrap: true, overflow: TextOverflow.visible),
                Padding(padding: const EdgeInsets.all(24.0)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: enableSecondaryAction,
                  child: CustomRoundButton(
                    buttonTitle: secondaryAction,
                    buttonColor: kNegativeColor,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                CustomRoundButton(
                  buttonTitle: mainAction,
                  buttonColor: kMainThemeColor,
                  onPressed: onPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}