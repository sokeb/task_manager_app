import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../utilities/asset_paths.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AssetPaths.backgroundSvg,
            height: MediaQuery.of(context).size.height, fit: BoxFit.cover),
        child
      ],
    );
  }
}
