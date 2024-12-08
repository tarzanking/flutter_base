import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

extension ImageEx on String {
  String imagePath({String format  = 'png'}) {
    return 'assets/images/$this.$format';
  }

  // use this when image is url, otherwise use AssetImage instead
  ImageProvider? imageProvider({String? holderImg}) {
    if (isNotEmpty == true) {
      return CachedNetworkImageProvider(this);
    } else if (holderImg?.isNotEmpty == true) {
      return AssetImage(holderImg!.imagePath());
    } else {
      return null;
    }
  }
}
