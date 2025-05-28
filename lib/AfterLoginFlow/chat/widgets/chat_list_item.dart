import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';

class ChatListItem extends StatelessWidget {
  final String imgPath;
  final String nameText;
  final String messageText;
  final String timeText;
  final bool isRight;

  const ChatListItem({
    Key? key,
    required this.imgPath,
    required this.nameText,
    required this.messageText,
    required this.timeText,
    this.isRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: -4,
              lightSource: LightSource.topLeft,
              color: isRight ? AppColors.mainBackgroundColorOrange : AppColors.listBoxBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isRight ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    messageText,
                    style: TextStyle(
                      color: isRight ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
