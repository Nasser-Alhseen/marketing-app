import 'package:data_users/app_colors.dart';
import 'package:data_users/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:data_users/app_icons.dart';
import 'package:data_users/app_styles.dart';
import 'package:data_users/responsive_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';

// import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: height,
                            color: const Color.fromARGB(255, 22, 27, 34),
                            child: Column(
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/images/market.png',
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    'Rateb For Marketing',
                                    style: ralewayStyle.copyWith(
                                      fontSize: 48.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.isSmallScreen(context)
                        ? height * 0.032
                        : height * 0.12),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Sign In👇',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(height: height * 0.064),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          controller: email,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset(AppIcons.emailIcon),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Email',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.014),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          controller: password,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 16.0,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset(AppIcons.eyeIcon),
                            ),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset(AppIcons.lockIcon),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Password',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(height: height * 0.05),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            Dio dio = Dio();

                            String apiUrl =
                                'https://marketing-data.onrender.com/users/login';
                            Map<String, dynamic> requestBody = {
                              'email': email.text,
                              'password': password.text,
                            };
                            var response;
                            try {
                              response =
                                  await dio.post(apiUrl, data: requestBody);
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                prefs.setBool('logged', true);

                                prefs.setString('email', email.text);
                                prefs.setString('password', password.text);
                                prefs.setInt(
                                  'balance',
                                  response.data['user'][0]['balance'],
                                );

                                // print(box.read("logged")+box.read("email"));

                                Get.to(() => Home(
                                      balance: response.data['user'][0]
                                          ['balance'],
                                    ));
                              } else {
                                // Failed sign-in
                              }
                            } catch (error) {
                              // Handle error
                            }
                          },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 160.0, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: const Color.fromARGB(255, 22, 27, 34),
                            ),
                            child: Text(
                              'Sign In',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        ' contact us to create an account 👇',
                        style: ralewayStyle.copyWith(
                          fontSize: 25.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // String url = 'https://wa.me/+96170400713';
                            // if (await canLaunch(url)) {
                            //   await launch(url);
                            // } else {
                            //   throw 'Could not launch $url';
                            // }
                          },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: const Color.fromARGB(255, 36, 126, 24),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Whats App',
                                  style: ralewayStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '70 400 713',
                                  style: ralewayStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
