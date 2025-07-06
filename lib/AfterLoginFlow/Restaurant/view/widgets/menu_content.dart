import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/ImageNetwork.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MenuContent extends StatelessWidget {
  final String menuUrl;
  final bool isUrl;
  final WebViewController controller;

  const MenuContent({
    required this.menuUrl,
    required this.isUrl,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (menuUrl.isEmpty) return _buildEmptyState();

    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      width: double.infinity,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: 0,
          lightSource: LightSource.top,
          color: AppColors.listBoxBackgroundColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 1,
          ),
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColorEmboss: Colors.transparent,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final uri = Uri.tryParse(menuUrl);
    if (uri == null) return Center(child: Text('Invalid URL'));

    // Image handling
    if (menuUrl.toLowerCase().endsWith('.png') || 
        menuUrl.toLowerCase().endsWith('.jpg') || 
        menuUrl.toLowerCase().endsWith('.jpeg')) {
      return GestureDetector(
        onTap: () => launchURL(menuUrl),
        child: Center(
          child: ImageNetwork(
            url: menuUrl,
            fit: BoxFit.contain,
            placeHolder: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }
    // PDF handling
    else if (menuUrl.toLowerCase().endsWith('.pdf')) {
      return PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(
        menuUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text('Failed to load PDF')),
      );
    }
    // Web URL handling
    else if (isUrl) {
      return GestureDetector(
        onTap: () => launchURL(menuUrl),
        child: WebViewWidget(
          controller: controller..loadRequest(uri),
        ),
      );
    }
    return Center(child: Text('Unsupported menu format'));
  }

  Widget _buildEmptyState() {
    return Center(
      child: GlobalWidgets.setText(
        'No content available',
        strTextColor: AppColors.strMainTextColorWhite,
      ),
    );
  }
}