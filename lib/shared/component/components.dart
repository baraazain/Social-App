import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/network/local/shared_preferance.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

void goTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void goToFinal(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

void logOut(context, Widget) {
  CacheHelper.removeData(key: 'token');
  goToFinal(context, Widget);
}

void printFull(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}

Widget sperator() => Container(
      color: Colors.grey,
      height: 1,
      width: double.infinity,
    );

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) {
  return AppBar(
    actions: actions,
    titleSpacing: 5,
    title: Text(title!),
    leading: IconButton(
      icon: const Icon(IconBroken.Arrow___Left_2),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

Widget defaultButton({
  required void Function() function,
  Color color = defaultColor,
  double width = double.infinity,
  double height = 40,
  required String title,
  double radius = 0.0,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        minWidth: width,
        height: height,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextField({
  required Function validat,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String label,
  void Function()? ontap,
  IconData? prefixIcon,
  IconData? suffixIcon,
  void Function()? suffixPressed,
  bool isPassword = false,
}) =>
    TextFormField(
      validator: (value) {
        return validat(value);
      },
      obscureText: isPassword,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: suffixPressed,
        ),
        border: OutlineInputBorder(),
      ),
      onTap: ontap,
    );

void toast({
  required Color color,
  required String message,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
