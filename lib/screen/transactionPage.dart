import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mystock/components/commonColor.dart';
import 'package:mystock/controller/controller.dart';
import 'package:mystock/screen/historyPage.dart';
import 'package:mystock/screen/itemSelection.dart';
import 'package:mystock/screen/stocktransfer.dart/stockTransfer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<String> splitted = [];
  ValueNotifier<bool> visible = ValueNotifier(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared();
  }

  String? branch_id;
  String? staff_name;
  String? branch_name;
  String? branch_prefix;
  String? user_id;

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branch_id = prefs.getString("branch_id");
    staff_name = prefs.getString("staff_name");
    branch_name = prefs.getString("branch_name");
    branch_prefix = prefs.getString("branch_prefix");
    user_id = prefs.getString("user_id");
  }

  String? selectedbranch;
  String? selectedtransaction;
  String? branch_selection;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },
                icon: Icon(Icons.history))
          ],
          leading: IconButton(
              onPressed: () {
                Provider.of<Controller>(context, listen: false)
                    .setstockTranserselected(false);
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: P_Settings.loginPagetheme),
      body: Consumer<Controller>(
        builder: (context, value, child) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              dropDownCustom(size, "transaction"),
              value.stocktransferselected
                  ? dropDownbranch(size, "branch")
                  : Container(),
              SizedBox(
                height: size.height * 0.08,
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
                              textStyle: Theme.of(context).textTheme.bodyText2,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: P_Settings.loginPagetheme,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        print("selectedtransaction----$selectedtransaction");

                        if (selectedtransaction != null) {
                          visible.value = false;
                          Provider.of<Controller>(context, listen: false)
                              .getItemCategory(context);
                          List<Map<String, dynamic>> list =
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .getProductDetails();
                          
                          print("fkjdfjdjfnzskfn;lg------${list}");
                          if (list.length > 0) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => ItemSelection(
                                        list: list,
                                        transVal: int.parse(splitted[3]),
                                      )
                                  // OrderForm(widget.areaname,"return"),
                                  ),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => StockTransfer(
                            //             list: list,
                            //             transVal: int.parse(splitted[3]),
                            //           )),
                            // );
                          }
                        } else {
                          visible.value = true;
                        }

                        // return await showDialog(
                        //     context: context,
                        //     barrierDismissible: false, // user must tap button!
                        //     builder: (BuildContext context) {
                        //       return WillPopScope(
                        //         onWillPop: () async => false,
                        //         child: buildPopupDialog("content", context, size),
                        //       );
                        //     });
                      },
                      child: Text(
                        'Confirmation',
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.bodyText2,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: P_Settings.buttonColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget dropDownCustom(Size size, String type) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: P_Settings.loginPagetheme,
                  style: BorderStyle.solid,
                  width: 0.4),
            ),
            child: DropdownButton<String>(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.transType.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )))
                  .toList(),
              onChanged: (item) {
                print("clicked");
                if (item != null) {
                  setState(() {
                    visible.value = false;
                    selectedtransaction = item;
                  });
                  print("selectedtransaction-----${selectedtransaction}");

                  splitted = selectedtransaction!.split(',');

                  print("splitted-----${splitted}");
                  if (splitted[4] == "1") {
                    Provider.of<Controller>(context, listen: false)
                        .setstockTranserselected(true);
                    Provider.of<Controller>(context, listen: false)
                        .getBranchList(context);
                  } else {
                    Provider.of<Controller>(context, listen: false)
                        .setstockTranserselected(false);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  ////////////////////////////////////
  Widget dropDownbranch(Size size, String type) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: P_Settings.loginPagetheme,
                  style: BorderStyle.solid,
                  width: 0.4),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedbranch,
              // isDense: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(type == "transaction"
                    ? "Select Transaction"
                    : "Select Branch"),
              ),
              // isExpanded: true,
              autofocus: false,
              underline: SizedBox(),
              elevation: 0,
              items: value.branchist
                  .map((item) => DropdownMenuItem<String>(
                      value: item.uID.toString(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.branchName.toString(),
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
                    selectedbranch = item;
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
}
