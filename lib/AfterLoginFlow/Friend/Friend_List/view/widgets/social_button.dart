import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  final String asset;
  final String url;

  const SocialButton({
    required this.asset,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: NeumorphicButton(
        padding: EdgeInsets.zero,
        child: Center(
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
          ),
        ),
        onPressed: () => launchUrl(Uri.parse(url)),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.circle(),
          depth: -5,
          lightSource: LightSource.top,
          color: AppColors.listBoxBackgroundColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 0.3,
          ),
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColorEmboss: AppColors.innerShadowColor,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
        ),
      ),
    );
  }
}