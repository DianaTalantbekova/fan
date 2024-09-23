import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key, required this.hintText, this.controller});

  final String hintText;
  final TextEditingController? controller;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int currentLength = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateLength);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateLength);
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      currentLength = widget.controller?.text.length ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 39.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLength: 32,
              cursorColor: Colors.white,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '$currentLength/32',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}