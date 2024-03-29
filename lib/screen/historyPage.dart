import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mystock/components/alertDialogue.dart';
import 'package:mystock/components/commonColor.dart';
import 'package:mystock/components/commonPopup.dart';
import 'package:mystock/components/dateFind.dart';
import 'package:mystock/components/transInfoBottomsheet.dart';
import 'package:mystock/controller/controller.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime now = DateTime.now();
  TransaInfoBottomsheet infoshowsheet = TransaInfoBottomsheet();
  AlertCommon popup = AlertCommon();
  DateFind dateFind = DateFind();
  String? date;
  List<String> s = [];
  List<String> splitted = [];
  ValueNotifier<bool> visible = ValueNotifier(false);
  String? selectedtransaction;
  String? todaydate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateFormat('dd-MM-yyyy kk:mm:ss').format(now);
    todaydate = DateFormat('dd-MM-yyyy').format(now);
    s = date!.split(" ");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction History",
          style: GoogleFonts.aBeeZee(
            textStyle: Theme.of(context).textTheme.bodyText2,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: P_Settings.buttonColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: P_Settings.loginPagetheme,
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Container(
                height: double.infinity,
                // height: size.height*0.8,
                child: SpinKitFadingCircle(
                  color: P_Settings.loginPagetheme,
                ));
          } else {
            return SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: size.height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            // String df;
                            // String tf;
                            dateFind.selectDateFind(context, "from date");
                            // if (value.fromDate == null) {
                            //   df = todaydate.toString();
                            // } else {
                            //   df = value.fromDate.toString();
                            // }
                            // if (value.todate == null) {
                            //   tf = todaydate.toString();
                            // } else {
                            //   tf = value.todate.toString();
                            // }
                            // Provider.of<Controller>(context, listen: false)
                            //     .historyData(context, splitted[0], "",
                            //         df, tf);
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: P_Settings.loginPagetheme,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          value.fromDate == null
                              ? todaydate.toString()
                              : value.fromDate.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            dateFind.selectDateFind(context, "to date");
                          },
                          icon: Icon(Icons.calendar_month)),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          value.todate == null
                              ? todaydate.toString()
                              : value.todate.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // dropDownCustom(size,""),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    dropDownCustom(size, ""),
                    Flexible(
                        child: Container(
                      height: size.height * 0.05,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: P_Settings.loginPagetheme,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(2), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            String df;
                            String tf;

                            if (value.fromDate == null) {
                              df = todaydate.toString();
                            } else {
                              df = value.fromDate.toString();
                            }
                            if (value.todate == null) {
                              tf = todaydate.toString();
                            } else {
                              tf = value.todate.toString();
                            }

                            print("splited-----$splitted");
                            if (splitted != null && splitted.isNotEmpty) {
                              Provider.of<Controller>(context, listen: false)
                                  .historyData(
                                      context, splitted[0], "", df, tf);
                            }
                          },
                          child: Text(
                            "Apply",
                            style: GoogleFonts.aBeeZee(
                              textStyle: Theme.of(context).textTheme.bodyText2,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: P_Settings.buttonColor,
                            ),
                          )),
                    ))
                  ],
                ),

                ValueListenableBuilder(
                    valueListenable: visible,
                    builder: (BuildContext context, bool v, Widget? child) {
                      print("value===${visible.value}");
                      return Visibility(
                        visible: v,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Text(
                            "Please choose TransactionType",
                            style: GoogleFonts.aBeeZee(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      );
                    }),
                Divider(),

                // Container(
                //   width: size.width*0.5,
                //   height: size.height * 0.2,
                //   child: Lottie.asset(
                //     'asset/filter.json',
                //     // height: size.height*0.3,
                //     // width: size.height*0.3,
                //   )
                // ),
                value.isLoading
                    ? SpinKitFadingCircle(
                        color: P_Settings.loginPagetheme,
                      )
                    : value.historyList.length == 0
                        ? Center(
                            child: Container(
                                height: size.height * 0.2,
                                child: Lottie.asset(
                                  'asset/historyjson.json',
                                  // height: size.height*0.3,
                                  // width: size.height*0.3,
                                )),
                          )
                        : Container(
                            height: size.height * 0.7,
                            child: ListView.builder(
                              itemCount: value.historyList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  trailing: Wrap(
                                    spacing: 10,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getTransinfoList(
                                                    context,
                                                    value.historyList[index]
                                                        ['os_id'],
                                                    "");
                                            infoshowsheet.showtransInfoSheet(
                                                context,
                                                index,
                                                splitted[0],
                                                splitted[3],
                                                value.historyList[index]
                                                    ['os_id']);
                                          },
                                          icon: Icon(Icons.info)),
                                      // IconButton(
                                      //     icon: Icon(
                                      //       Icons.edit,
                                      //       color: P_Settings.editclr,
                                      //     ),
                                      //     onPressed: () {
                                      //       // Provider.of<Controller>(context,
                                      //       //         listen: false)
                                      //       //     .saveCartDetails(
                                      //       //         context,
                                      //       //         widget.transId,
                                      //       //         value.historyList[index]
                                      //       //             ['to_branch_id']!,
                                      //       //        value.historyList[index]
                                      //       //                 ['trans_remark'],
                                      //       //         "1");
                                      //       Provider.of<Controller>(context,
                                      //               listen: false)
                                      //           .getBranchList(
                                      //               context,
                                      //               "history",
                                      //               value.historyList[index]
                                      //                   ['to_branch_id']!);
                                      //       Navigator.pushReplacement<void,
                                      //               void>(
                                      //           context,
                                      //           MaterialPageRoute<void>(
                                      //             builder:
                                      //                 (BuildContext context) =>
                                      //                     TransactionPage(
                                      //               page: "history",
                                      //               remrk:
                                      //                   value.historyList[index]
                                      //                       ['trans_remark'],
                                      //               branch:
                                      //                   value.historyList[index]
                                      //                       ['to_branch_id'],
                                      //               translist: splitted,
                                      //             ),
                                      //           ));
                                      //     }),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: P_Settings.delete,
                                          ),
                                          onPressed: () {
                                            popup.buildPopupDialog(
                                                context,
                                                size,
                                                splitted,
                                                index,
                                                todaydate!);
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (ctx) => AlertDialog(
                                            //     content: Text(
                                            //         "Do you want to delete???"),
                                            //     actions: <Widget>[

                                            //       Row(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment.end,
                                            //         children: [
                                            //           ElevatedButton(
                                            //             style: ElevatedButton
                                            //                 .styleFrom(
                                            //                     primary: P_Settings
                                            //                         .loginPagetheme),
                                            //             onPressed: () async {
                                            //               print(
                                            //                   "heloooooooooooooooo");
                                            //               Provider.of<Controller>(
                                            //                       context,
                                            //                       listen: false)
                                            //                   .saveCartDetails(
                                            //                       ctx,
                                            //                       splitted[0],
                                            //                       value.historyList[
                                            //                               index]
                                            //                           [
                                            //                           'to_branch_id'],
                                            //                       value.historyList[
                                            //                               index]
                                            //                           [
                                            //                           'trans_remark'],
                                            //                       "2",
                                            //                       value.historyList[
                                            //                               index]
                                            //                           ['os_id'],
                                            //                       "delete");
                                            //               String df;
                                            //               String tf;

                                            //               if (value.fromDate ==
                                            //                   null) {
                                            //                 df = todaydate
                                            //                     .toString();
                                            //               } else {
                                            //                 df = value.fromDate
                                            //                     .toString();
                                            //               }
                                            //               if (value.todate ==
                                            //                   null) {
                                            //                 tf = todaydate
                                            //                     .toString();
                                            //               } else {
                                            //                 tf = value.todate
                                            //                     .toString();
                                            //               }

                                            //               //////////////////////////////////////////////////

                                            //               await Provider.of<
                                            //                           Controller>(
                                            //                       context,
                                            //                       listen: false)
                                            //                   .historyData(
                                            //                       context,
                                            //                       splitted[0],
                                            //                       "",
                                            //                       df,
                                            //                       tf);

                                            //               //  Navigator.of(ctx)
                                            //               //     .pop();
                                            //             },
                                            //             child: Text("Ok"),
                                            //           ),
                                            //           SizedBox(
                                            //             width:
                                            //                 size.width * 0.01,
                                            //           ),
                                            //           ElevatedButton(
                                            //             style: ElevatedButton
                                            //                 .styleFrom(
                                            //                     primary: P_Settings
                                            //                         .loginPagetheme),
                                            //             onPressed: () {
                                            //               Navigator.of(ctx)
                                            //                   .pop();
                                            //             },
                                            //             child: Text("Cancel"),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ],
                                            //   ),
                                            // );
                                          }),
                                    ],
                                  ),
                                  title: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${value.historyList[index]['series']} ",
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: P_Settings.historyPageText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text(
                                        "(${value.historyList[index]['entry_date']})",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                          color: P_Settings.historyPageText,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "${value.historyList[index]['trans_remark']}",
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: P_Settings.historyPageText,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
              ],
            ));
          }
        },
      ),
    );
  }

///////////////////////////////////////////////////////////////////

  Widget dropDownCustom(Size size, String type) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: P_Settings.loginPagetheme,
                  style: BorderStyle.solid,
                  width: 0.4),
            ),
            child: DropdownButton<String>(
              itemHeight: null,
              isExpanded: true,
              value: selectedtransaction,

              // isDense: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select Transaction"),
              ),
              // isExpanded: true,
              autofocus: false,
              underline: SizedBox(),
              elevation: 0,
              items: value.transactionist
                  .map((item) => DropdownMenuItem<String>(
                      value:
                          "${item.transId},${item.transPrefix},${item.transType},${item.transVal},${item.branch_selection}",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.transType.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      )))
                  .toList(),
              onChanged: (item) {
                print("clicked");
                if (item != null) {
                  setState(() {
                    selectedtransaction = item;
                  });
                  print("selectedtransaction-----${selectedtransaction}");

                  splitted = selectedtransaction!.split(',');

                  print("splitted-----${splitted}");
                  if (splitted[4] == "1") {
                    Provider.of<Controller>(context, listen: false)
                        .setstockTranserselected(true);

                    // Provider.of<Controller>(context, listen: false)
                    //     .getBranchList(context);
                  } else {
                    Provider.of<Controller>(context, listen: false)
                        .setstockTranserselected(false);
                  }
                  // String df;
                  // String tf;

                  // if (value.fromDate == null) {
                  //   df = todaydate.toString();
                  // } else {
                  //   df = value.fromDate.toString();
                  // }
                  // if (value.todate == null) {
                  //   tf = todaydate.toString();
                  // } else {
                  //   tf = value.todate.toString();
                  // }

                  // Provider.of<Controller>(context, listen: false)
                  //     .historyData(context, splitted[0], "", df, tf);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
