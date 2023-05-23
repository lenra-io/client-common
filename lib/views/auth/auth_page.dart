import 'dart:html' as html;

import 'package:client_common/api/application_api.dart';
import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/views/auth/auth_page_form.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/component/lenra_text.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AppAuthPage extends StatefulWidget {
  final bool? isRegisterPage;
  AppAuthPage({Key? key, this.isRegisterPage}) : super(key: key);

  @override
  State<AppAuthPage> createState() => _AppAuthPageState();
}

class _AppAuthPageState extends State<AppAuthPage> {
  final logger = Logger('AuthPage');

  var themeData = LenraThemeData();

  String? redirectTo;
  String? appServiceName;

  @override
  Widget build(BuildContext context) {
    redirectTo = context.read<AuthModel>().redirectToRoute;
    print("redirectTo $redirectTo");
    RegExp regExp = RegExp(r"app\/([a-fA-F0-9-]{36})");
    final match = regExp.firstMatch(redirectTo ?? "/");
    appServiceName = match?.group(1);
    print("appServiceName $appServiceName");

    return SimplePage(
      header: appServiceName != null ? Container() : null,
      child: LenraFlex(
        spacing: 32,
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        fillParent: true,
        children: [
          appHeader(),
          AuthPageForm(widget.isRegisterPage),
        ],
      ),
    );
  }

  Widget appHeader() {
    if (appServiceName != null) {
      return FutureBuilder(
        future: ApplicationApi.getAppByServiceName(appServiceName!),
        builder: (context, AsyncSnapshot<AppResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return LenraFlex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 32,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(255, 187, 234, 255),
                  ),
                  child: LenraText(
                    text: snapshot.data?.name?[0].toUpperCase() ?? "A",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: LenraColorThemeData.lenraBlue,
                    ),
                  ),
                ),
                LenraFlex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LenraText(
                      text: snapshot.data?.name ?? "App",
                      style: themeData.lenraTextThemeData.headline1,
                    ),
                    LenraFlex(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LenraText(text: "by"),
                        Image.asset(
                          "assets/images/logo-horizontal-black.png",
                          scale: 1.25,
                        ),
                        IconButton(
                          onPressed: () {
                            html.window.open('https://lenra.io', "_blank");
                          },
                          icon: Icon(Icons.info_outline),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          }
        },
      );
    }
    return Container();
  }
}
