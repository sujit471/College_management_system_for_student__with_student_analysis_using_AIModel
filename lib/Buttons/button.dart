import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final String hintText;
  final Widget emoji;



  // flutter to reuse the code in
// can be used in other dart files to import and reuse the code


  CustomButton({super.key,
    required this.title,
    required this.onTap,
    required this.hintText,
    required this.emoji,

  });
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: onTap,
        child: Container(
           height: 50,
          //this is to set for  the width of the button or any text field

          margin: const EdgeInsets.symmetric(horizontal: 20),

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

           color: Colors.white,

           boxShadow: const [
             BoxShadow(
               color: Color.fromRGBO(196,135, 198, 1),
               blurRadius: 20,

             )
           ]
             ),
          // child: Center(
          //     child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              //controller: emailController,

              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: emoji,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  )),
            ),
          ),
        ),

      ),
    );
  }
}
