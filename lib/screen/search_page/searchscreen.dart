import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:mystock/components/commonColor.dart';
import 'package:mystock/components/infoBottomSheet.dart';
import 'package:mystock/controller/controller.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  String type;
  SearchScreen({required this.type});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchcontroll = TextEditingController();
  InfoBottomsheet infoshowsheet = InfoBottomsheet();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: P_Settings.loginPagetheme,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Provider.of<Controller>(context, listen: false).searchList.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: size.width * 0.95,
              height: size.height * 0.09,
              child: TextField(
                autofocus: true,
                controller: searchcontroll,
                onChanged: (value) {
                  if (value != null || value.isNotEmpty) {
                    print("value-----$value");
                    Provider.of<Controller>(context, listen: false)
                        .setIssearch(true);
                    // value = searchcontroll.text;
                    Provider.of<Controller>(context, listen: false)
                        .searchItem(context, value);
                  } else {
                    Provider.of<Controller>(context, listen: false)
                        .setIssearch(false);
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search Item here",
                  prefixIcon: Icon(
                    Icons.search,
                    color: P_Settings.loginPagetheme,
                  ),
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: P_Settings.loginPagetheme),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 94, 95, 94)),
                  ),
                ),
              ),
            ),
          ),
          Consumer<Controller>(builder: (context, value, child) {
            if (value.isSearch == false) {
              // return SpinKitFadingCircle(
              //   color: P_Settings.loginPagetheme,
              // );
              return Container(
                  height: size.height * 0.15,
                  // child: Text("No Data Found !!!"),
                  child: Lottie.asset(
                    'asset/search.json',
                    // height: size.height*0.3,
                    // width: size.height*0.3,
                  ));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: value.searchList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Provider.of<Controller>(context, listen: false)
                            .getinfoList(
                                context, value.searchList[index]["item_id"]);
                        infoshowsheet.showInfoSheet(context);
                      },
                      title: Row(
                        children: [Text(value.searchList[index]["item_name"])],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                              "MOP :  ${value.searchList[index]["s_rate_1"]}"),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(
                              "MRP :  ${value.searchList[index]["s_rate_2"]}"),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
