import 'package:cardproject/models/CardModel.dart';
import 'package:cardproject/models/CardOwnerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_base/DatabaseHelper.dart';
import '../utils/GlobalMethods.dart';

class CardListScreen extends StatefulWidget {
  final CardOwnerModel ownerModel;

  const CardListScreen({super.key, required this.ownerModel});

  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  List<CardModel> dataList = [];
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    getCards();
  }

  getCards() async {
    try {
      dataList = await DatabaseHelper.instance
          .getAllCardByOwnerId(widget.ownerModel.id ?? 0);
      GlobalMethods.printLog(dataList.toSet().toString());
    } catch (e) {
      GlobalMethods.printLog(e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  _addCard(CardModel cardModel) async {
    await DatabaseHelper.instance.addCard(cardModel);
    await getCards();
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
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardListScreen(
              ownerModel: dataList[index],
            ),
          ),
        );*/
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
          dataList[index].cardHolderName ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }

  _buildInsertOwnerDialog() {
    TextEditingController bankNameController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController holderNameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController cvvNumberController = TextEditingController();
    TextEditingController cardLimitController = TextEditingController();
    TextEditingController cardExpiryDateController = TextEditingController();
    TextEditingController cardGenerateDateController = TextEditingController();
    TextEditingController cardPaymentDateController = TextEditingController();

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
              _buildTextField(
                  controller: holderNameController,
                  hint: "Card Holder Name",
                  keyboardType: TextInputType.name,
                  isAllInCaps: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Card Holder Name!";
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: companyNameController,
                  hint: "Card Company Name(Master,Visa,etc...)",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Card Company Name!";
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: bankNameController,
                  hint: "Card Bank Name(Master,Visa,etc...)",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Card Bank Name!";
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: bankNameController,
                  hint: "Card Number",
                  textInputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberFormatter()
                  ],
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Card Number!";
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: bankNameController,
                  hint: "",
                  enable: false,
                  onTap: () async {},
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Card Number!";
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate() &&
                      _scaffoldKey.currentState != null) {
                    if (holderNameController.text
                        .toString()
                        .trim()
                        .isNotEmpty) {
                      CardModel card = CardModel();

                      GlobalMethods.printLog(card.toMap().toString());
                      await _addCard(card);
                      GlobalMethods.showSnackBar(
                          _scaffoldKey.currentState!.context,
                          "Your card added successfully.",
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

  _buildTextField(
      {required TextEditingController controller,
      required String hint,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      bool enable = false,
      void Function()? onTap,
      List<TextInputFormatter>? textInputFormatters,
      bool isAllInCaps = false}) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      readOnly: enable,
      onTap: onTap,
      textCapitalization:
          isAllInCaps ? TextCapitalization.characters : TextCapitalization.none,
      inputFormatters: textInputFormatters,
      /* (value) {
        if (value == null || value.isEmpty) {
          return "Please enter owner name!";
        }
        return null;
      },*/
      decoration: InputDecoration(
        label: Text(hint),
        hintText: hint,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        disabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
