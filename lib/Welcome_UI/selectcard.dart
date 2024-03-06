import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Icons.dart';
class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice, }) : super(key: key);
  final HelloSvg choice;
  // final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // this is the method  to   pass the svg asset image as an arguement in selectcard widget
            Expanded(child: SvgPicture.asset(choice.svgAssetPath,color: choice.color,),),
            // Expanded(child: choice.icon,choice.color),
            //SizedBox(height: 2,),
            Text(
              choice.name,
              style: textStyle,
            )
          ],
        ),
      ),

    );
  }
}