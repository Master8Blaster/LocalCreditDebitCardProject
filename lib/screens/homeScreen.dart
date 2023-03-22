import 'package:cardproject/screens/CardListScreen.dart';
import 'package:cardproject/utils/ColrosConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../data_base/DatabaseHelper.dart';

import '../models/CardOwnerModel.dart';
import '../utils/GlobalMethods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardOwnerModel> dataList = [];
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    getCardOwners();
  }

  getCardOwners() async {
    try {
      dataList = await DatabaseHelper.instance.getAllCardOwners();
      GlobalMethods.printLog(dataList.toSet().toString());
    } catch (e) {
      GlobalMethods.printLog(e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  _addOwner(String ownerName) async {
    GlobalMethods.printLog(ownerName);
    await DatabaseHelper.instance.addCardOwners(ownerName);
    await getCardOwners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "WellCome\nBack!",
        ),
      ),*/
      /*  floatingActionButton: dataList.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                GlobalMethods.printLog("flottingclick1");
                showDialog(
                  context: context,
                  builder: (context) => _buildInsertOwnerDialog(),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,*/
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: dataList.isNotEmpty && !isLoading
                    ? ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) =>
                            _buildListItem(context, index),
                      )
                    : isLoading
                        ? const CircularProgressIndicator()
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  "There are no any Card owner added.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                // const SizedBox(height: 8),
                                const Text(
                                  "Do you want to add ?",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    GlobalMethods.printLog("flottingclick");
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          _buildInsertOwnerDialog(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Click it.",
                                  style: TextStyle(
                                    fontSize: 24,
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

  _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          const Text(
            "Welcome\nBack!",
            style: TextStyle(
              color: COLORTEXT,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              GlobalMethods.printLog("flottingclick");
              showDialog(
                context: context,
                builder: (context) => _buildInsertOwnerDialog(),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: Svg(
                      "assets/svgs/add_owner.svg",
                      size: Size(20, 20),
                      color: COLORTEXT,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Add Owner",
                    style: TextStyle(
                      color: COLORTEXT,
                      textBaseline: TextBaseline.alphabetic,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardListScreen(
              ownerModel: dataList[index],
            ),
          ),
        );
      },
      child: ListTile(
        title: Text(
          "Card Holder Name",
          style: TextStyle(
            color: COLORTEXT,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          dataList[index].ownerName ?? '',
          style: TextStyle(
            color: COLORTEXT,
            fontSize: 20,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(3),
          width: MediaQuery.of(context).size.width * .13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image(
              image: Svg(
                "assets/svgs/user.svg",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ), /*Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          dataList[index].ownerName ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),*/
    );
  }

  _buildInsertOwnerDialog() {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .03),
      child: Container(
        decoration: BoxDecoration(
          color: COLORDIALOG,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .04, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: controller,
                maxLines: 1,
                style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  color: COLORTEXT,
                ),
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter owner name!";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Owner Name",
                  hintStyle: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: COLORTEXT,
                  ),
                  alignLabelWithHint: false,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    if (controller.text.toString().trim().isNotEmpty) {
                      GlobalMethods.printLog(controller.text.toString().trim());

                      await _addOwner(controller.text.toString().trim());
                      GlobalMethods.printLog(
                          "added ${controller.text.toString().trim()}");
                      GlobalMethods.showSnackBar(
                          context,
                          "New CardOwner '${controller.text.toString().trim()}' added successfully.",
                          Theme.of(context).primaryColor);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "ADD OWNER",
                    style: TextStyle(
                      fontSize: 18,
                      color: COLORTEXT,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
