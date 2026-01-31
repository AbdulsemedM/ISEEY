import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';

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
                    Text(
                      nameText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
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
                        constraints:
                            BoxConstraints(maxWidth: (screenSize.width / 1.5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Text(
                          chatText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                (imgPath.trim().isEmpty)
                    ? CircleAvatar(
                        radius: 16,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : CachedNetworkImage(
                  imageUrl: imgPath.trim(),
                  useOldImageOnUrlChange: true,
                  fadeInDuration: Duration(milliseconds: 300),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 16,
                    );
                  },
                  placeholder: (context, url) {
                    return CircleAvatar(
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return CircleAvatar(
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
