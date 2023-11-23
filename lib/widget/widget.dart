import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    required this.icon,
    this.suffixicon,
    this.suffixOnpress,
    this.obscurebool = false,
    this.onChanged,
  });
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData icon;
  final IconData? suffixicon;
  final void Function()? suffixOnpress;
  final void Function(String?)? onChanged;
  final bool obscurebool;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscurebool,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: suffixOnpress,
          icon: Icon(suffixicon),
        ),
        prefixIcon: Icon(
          icon,
        ),
        labelText: label,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFF188F79),
            ),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
      validator: validator,
    );
  }
}

class ElevatedBtnWidget extends StatelessWidget {
  const ElevatedBtnWidget({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final void Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        backgroundColor: const Color(0XFF188F79),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class TextFormFieldAreaWidget extends StatelessWidget {
  const TextFormFieldAreaWidget({
    Key? key,
    required this.labelText,
    required this.validator,
    required this.icon,
    this.controller,
  }) : super(key: key);
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLines: 10,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: labelText,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0XFF188F79),
              ),
            ),
          ),
          validator: validator,
          controller: controller,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class AuthContainerLoginSignupWidget extends StatelessWidget {
  const AuthContainerLoginSignupWidget({
    super.key,
    required this.size,
    required this.title,
    required this.imagesrc,
    required this.ontap,
  });

  final Size size;
  final String title;
  final String imagesrc;
  final void Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: size.width / 2 - 30,
        height: size.height / 12.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagesrc,
              width: (size.height / 12) / 2,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}

void newshowSnackbar(
    BuildContext context, String title, String message, contentType) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: AwesomeSnackbarContent(
          inMaterialBanner: true,
          title: title,
          message: message,
          contentType: contentType)));
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    super.key,
    required this.size,
    required this.imagsrc,
    required this.title,
    this.onTap,
  });

  final Size size;
  final String imagsrc;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width - 40,
        height: size.height / 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(21),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 2,
                spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagsrc),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountListTileWidget extends StatelessWidget {
  const AccountListTileWidget({
    super.key,
    required this.title,
    this.trailingIcon,
    required this.leadingIcon,
    this.onTap,
  });
  final String title;
  final IconData? trailingIcon;
  final IconData leadingIcon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0Xff188F79).withOpacity(0.09),
        ),
        child: Icon(
          leadingIcon,
          color: const Color(0Xff188F79),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailingIcon,
        color: const Color(0Xff188F79),
        size: 20,
      ),
    );
  }
}

class AddTextFeildWidget extends StatelessWidget {
  const AddTextFeildWidget({
    super.key,
    required this.title,
    required this.textlabel,
    required this.iconData,
    this.controller,
    this.validator,
    this.onChanged,
  });
  final String title;
  final String textlabel;
  final IconData iconData;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 10),
        TextFormWidget(
          onChanged: onChanged,
          label: textlabel,
          icon: iconData,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
