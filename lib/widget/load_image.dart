import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottery/utils/image_extension.dart';

/// 加载图片（支持本地与网络图片）
class LoadImage extends StatelessWidget {

  const LoadImage(this.image, {
    super.key,
    this.file,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
    this.format = "png",
    this.holderImg = "",
  });

  final File? file;
  final String? image;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final String format;
  final String holderImg;

  @override
  Widget build(BuildContext context) {
    if(file?.path.isNotEmpty == true){
      return LoadFileImage(
        file,
        fit: fit,
        width: width,
        height: height,
        holderImg: holderImg,
      );
    }

    if (image?.isNotEmpty == true) {
      if (image!.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: image!,
          placeholder: (context, url) => LoadAssetImage(holderImg, height: height, width: width, fit: fit),
          errorWidget: (context, url, error) => LoadAssetImage(holderImg, height: height, width: width, fit: fit),
          width: width,
          height: height,
          fit: fit,
          color: color,
        );
      } else {
        return LoadAssetImage(image,
          height: height,
          width: width,
          fit: fit,
          format: format,
          color: color,
        );
      }
    }

    return LoadAssetImage(holderImg,
      height: height,
      width: width,
      fit: fit,
      format: format,
      color: color,
    );
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {

  const LoadAssetImage(this.image, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.format = 'png',
    this.gaplessPlayback = true,
    this.color,
    this.imageFrontPath,
  });

  final String? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;
  final bool gaplessPlayback;
  final Color? color;
  final String? imageFrontPath;

  String? get absolutePath => imageFrontPath != null ? '$imageFrontPath/$image.$format' : null;

  @override
  Widget build(BuildContext context) {
    if (image?.isNotEmpty == true) {
      return Image.asset(
        absolutePath ?? image!.imagePath(format: format),
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: gaplessPlayback,
        color: color,
      );
    }
    return SizedBox(height: height, width: width,);
  }
}

class LoadFileImage extends StatelessWidget {

  const LoadFileImage(this.file, {
    super.key,
    this.width,
    this.height,
    this.fit  = BoxFit.fill,
    this.holderImg,
  });

  final File? file;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? holderImg;

  @override
  Widget build(BuildContext context) {
    return file != null ? Image.file(
      file!,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
    ) : LoadAssetImage(
      holderImg,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

