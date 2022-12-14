import 'dart:convert';

import 'package:client_common/api/response_models/cgu_response.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/cgu_model.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:provider/provider.dart';

class CguPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CguPageState();
  }
}

class _CguPageState extends State<CguPage> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = context.read<AuthModel>();
    CguModel cguModel = context.read<CguModel>();

    return SimplePage(
      child: LenraFlex(
        fillParent: true,
        direction: Axis.vertical,
        children: [
          FutureBuilder(
            future: Future.wait([cguModel.getLatestCguAsMd("en"), cguModel.getLatestCgu()]),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return LenraFlex(
                  fillParent: true,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LenraFlex(
                      fillParent: true,
                      padding: EdgeInsets.only(bottom: 16),
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LenraButton(
                          type: LenraComponentType.tertiary,
                          onPressed: () {
                            CommonNavigator.go(context, CommonNavigator.cguFR);
                          },
                          text: "See the french original version",
                        ),
                      ],
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(border: Border.all(color: LenraColorThemeData.greyLight)),
                      child: Markdown(
                        controller: _controller,
                        data: utf8.decode(snapshot.data[0].bodyBytes),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.animateTo(
                          _controller.offset + 350,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        color: LenraColorThemeData.greyLight,
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    LenraFlex(
                      fillParent: true,
                      padding: EdgeInsets.only(top: 32),
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LenraButton(
                          type: LenraComponentType.secondary,
                          onPressed: () {
                            authModel.logout().then((value) {
                              CommonNavigator.go(context, CommonNavigator.login);
                            });
                          },
                          text: "I refuse and logout",
                          leftIcon: Icon(Icons.close),
                        ),
                        LenraButton(
                          onPressed: () {
                            cguModel.acceptCgu((snapshot.data[1] as CguResponse).id).then((value) {
                              CommonNavigator.go(context, CommonNavigator.login);
                            });
                          },
                          text: "I accept",
                          leftIcon: Icon(Icons.done),
                        ),
                      ],
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Error");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
