import 'package:cardproject/screens/CardListScreen.dart';
import 'package:flutter/material.dart';
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
    await DatabaseHelper.instance.addCardOwners(ownerName);
    await getCardOwners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GlobalMethods.printLog("flottingclick1");
          showDialog(
            context: context,
            builder: (context) => _buildInsertOwnerDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: dataList.isNotEmpty && !isLoading
            ? ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) => _buildListItem(context, index),
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
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Do you want to add ?",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            GlobalMethods.printLog("flottingclick");
                            showDialog(
                              context: context,
                              builder: (context) => _buildInsertOwnerDialog(),
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
                        const SizedBox(height: 10),
                        const Text(
                          "Click it.",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
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
      child: Container(
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
      ),
    );
  }

  _buildInsertOwnerDialog() {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .03),
      child: Container(
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
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter owner name!";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text("Owner Name"),
                  hintText: "Owner Name",
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate() &&
                      _scaffoldKey.currentState != null) {
                    if (controller.text.toString().trim().isNotEmpty) {
                      GlobalMethods.printLog(controller.text.toString().trim());

                      await _addOwner(controller.text.toString().trim());
                      GlobalMethods.printLog(
                          "added ${controller.text.toString().trim()}");
                      GlobalMethods.showSnackBar(
                          _scaffoldKey.currentState!.context,
                          "New CardOwner '${controller.text.toString().trim()}' added successfully.",
                          Theme.of(_scaffoldKey.currentState!.context)
                              .primaryColor);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "ADD",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
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
