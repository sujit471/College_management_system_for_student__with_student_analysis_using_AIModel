import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HelloSvg extends StatelessWidget {
   final String svgAssetPath;
  final String name;
  final Color color;
   // final VoidCallbackAction onTap;
   final double width;
   final double height;
   final Widget destinationPage;

   // final String routeName;
  // final Icon icon;
  //final String ontap;
   HelloSvg({super.key,
   required this.name,
     required this.svgAssetPath,
    required this.color,
     // required this.onTap,
     required this.width,  required this.height, required this.destinationPage,
    // required this.icon,

  }) ;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 90,),

        SingleChildScrollView(child: InkWell(
          // onTap: (){
          //   onTap;
          // },
          // child: icon,

          child: SvgPicture.asset(svgAssetPath,
            height: height,
            width:width,
            color: color,
            //allowDrawingOutsideViewBox: true,
          ),
        ),

        ),
            const SizedBox(height: 20,),
            Text(name),
          ],
        )
      ],
    );
  }
}


