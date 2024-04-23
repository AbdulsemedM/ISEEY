import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RightChatBubble extends StatelessWidget {
  final String imgPath;
  final String nameText;
  final int timestamp;
  final String chatText;

  const RightChatBubble({
    Key? key,
    required this.imgPath,
    required this.nameText,
    required this.timestamp,
    required this.chatText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: -3,
                        lightSource: LightSource.top,
                        color: AppColors.mainBackgroundColorOrange,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 0.1,
                        ),
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(0)),
                        ),
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: Colors.transparent,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: (screenSize.width / 1.5)),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: GlobalWidgets.buildChatMsgContent(chatText.trim()),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      alignment: Alignment.centerRight,
                      child: GlobalWidgets.setText(
                        getTimeStampToFormattedTime(timestamp: timestamp),
                        strTextColor: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
