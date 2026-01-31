import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:photo_view/photo_view.dart';

class ImageNetwork extends StatelessWidget {
  final String url;
  final Widget? placeHolder;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final bool isZoomableViewEnable;

  const ImageNetwork(
      {Key? key,
      required this.url,
      required this.placeHolder,
      this.fit,
      this.isZoomableViewEnable = false,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = url.trim();
    if (effectiveUrl.isEmpty) {
      return placeHolder ??
          Container(
            padding: EdgeInsets.all(5),
            color: Color(0xfff7f7f7),
            height: height,
            width: width,
            child: Image.asset(AssetsConstant.leftArrowIcon),
          );
    }
    return CachedNetworkImage(
      imageUrl: effectiveUrl,
      imageBuilder: (context, imageProvider) {
        return this.isZoomableViewEnable
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Container(
                        child: Stack(
                          children: [
                            PhotoView(
                              backgroundDecoration: BoxDecoration(color: Colors.white),
                              imageProvider: imageProvider,
                            ),
                            Positioned(
                              top: 45,
                              left: 15,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: fit,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ),
              );
      },
      errorWidget: (context, url, error) {
        return placeHolder == null
            ? Container(
                padding: EdgeInsets.all(5),
                color: Color(0xfff7f7f7),
                height: height,
                width: width,
                child: Image.asset(
                  AssetsConstant.leftArrowIcon,
                ),
              )
            : placeHolder ?? Container();
      },
      progressIndicatorBuilder: (context, url, progress) => Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: placeHolder == null
              ? Container(
                  padding: EdgeInsets.all(5),
                  color: Color(0xfff7f7f7),
                  height: height,
                  width: width,
                  child: Image.asset(
                    AssetsConstant.logo,
                    color: Colors.white,
                  ))
              : placeHolder,
        ),
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(bottom: 10),
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey.withOpacity(0.5),
            value: progress.progress,
            strokeWidth: 2,
          ),
        )
      ]),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ImagePlaceholder({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Color(0xfff7f7f7),
      child: Image.asset(
        AssetsConstant.logo,
        color: Colors.white,
        height: 15,
      ),
    );
  }
}
