import 'package:ecommerce_app/management/flutter_management.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/db_helper.dart';
import '../../models/user.dart';
import '../../widgets/appbar_back_button.dart';
import '../../widgets/custom_textfield.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _passwordVisible = false;
  double? textfieldSizedboxHeight = 15.sp;
  var key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.sp,
              ),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.sp,
              ),
              Form(
                  key: key,
                  child: Column(
                    children: [
                      CustomTextfield(
                        textInputType: TextInputType.name,
                        controller: ref
                            .watch(registerPageViewModel)
                            .firstNameController,
                        text: Text('First Name'),
                      ),
                      SizedBox(
                        height: textfieldSizedboxHeight,
                      ),
                      CustomTextfield(
                        textInputType: TextInputType.name,
                        controller: ref
                            .watch(registerPageViewModel)
                            .lastNameController,
                        text: Text('Last Name'),
                      ),
                      SizedBox(
                        height: textfieldSizedboxHeight,
                      ),
                      CustomTextfield(
                        validator: ref.read(registerPageViewModel).emailValidator,
                        textInputType: TextInputType.emailAddress,
                        controller:
                            ref.watch(registerPageViewModel).emailController,
                        text: Text('Email'),
                      ),
                      SizedBox(
                        height: textfieldSizedboxHeight,
                      ),
                      IntrinsicHeight(
                        child: CustomTextfield(
                          validator: ref.read(registerPageViewModel).passwordValidator,
                          textInputType: TextInputType.visiblePassword,
                          controller: ref
                              .watch(registerPageViewModel)
                              .passwordController,
                          text: Text('Password'),
                          obscureText: !_passwordVisible,
                          iconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: _passwordVisible
                                ? Icon(
                                    Icons.visibility,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      CustomButton(
                        text: 'Sign up',
                        onPressed: () {
                          if (ref
                                  .watch(registerPageViewModel)
                                  .passwordController
                                  .text
                                  .isNotEmpty &&
                              ref
                                  .watch(registerPageViewModel)
                                  .emailController
                                  .text
                                  .isNotEmpty &&
                              ref
                                  .watch(registerPageViewModel)
                                  .firstNameController
                                  .text
                                  .isNotEmpty &&
                              ref
                                  .watch(registerPageViewModel)
                                  .lastNameController
                                  .text
                                  .isNotEmpty && key.currentState!.validate()){
                            ref.read(registerPageViewModel).signUp(context);
                          }else
                            {
                             ref.read(registerPageViewModel).showRegisterDialog(context: context,);
                            }

                        },
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
