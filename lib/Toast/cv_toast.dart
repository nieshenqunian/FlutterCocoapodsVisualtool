import 'package:flutter/material.dart';

class CVToast extends StatefulWidget {
  final String? toast;
  const CVToast({this.toast, super.key});

  @override
  State<CVToast> createState() => _CVToastState();
}

class _CVToastState extends State<CVToast> with TickerProviderStateMixin {
  AnimationController? aniControl;
  Animation<double>? animation;

  @override
  void initState() {
    aniControl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    animation = Tween(begin: 0.0, end: 1.0).animate(aniControl!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    aniControl!.forward();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FadeTransition(
          opacity: animation!,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration:BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 12,
                  spreadRadius: 0
                ),
              ]
            ),
            child: Text(
              widget.toast!, 
              style: const TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
            ),
          )
        ),
        const SizedBox(height: 30,),
      ],
    );
  }
}

showCVToast(BuildContext context, String toast) {
  Navigator.of(context).push(
    _toastRoute(toast)
  );
  dismiss().then((value) {
    Navigator.pop(context);
  });
}
 
Route _toastRoute(String toast) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder:(context, animation, secondaryAnimation) => CVToast(toast: toast,),
    transitionsBuilder:(context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Future<bool> dismiss() async {
  await Future.delayed(const Duration(seconds: 2));
  return true;
}