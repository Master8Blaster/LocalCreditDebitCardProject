import 'package:cardproject/models/CardModel.dart';
import 'package:cardproject/models/CardOwnerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wheel_slider/wheel_slider.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Card Holder Name : ${dataList[index].cardHolderName ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Bank Name : ${dataList[index].cardBankName ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Company Name : ${dataList[index].cardCompanyName ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Generated : ${dataList[index].cardGenerateDate ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Expires : ${dataList[index].cardExpiryDate ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Payment : ${dataList[index].cardPaymentDate ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Number : ${dataList[index].cardNumber ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Type : ${dataList[index].cardType ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Limit : ${dataList[index].cardLimit ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "CVV : ${dataList[index].cardCvv ?? ""}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
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

    DateTime cardExpiry = DateTime.now(),
        cardGenerated = DateTime.now(),
        cardPayment = DateTime.now();
    int type = 0;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .03),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .04,
              vertical: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                      hint: "Card Bank Name(SBI,HDFC,etc...)",
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Card Bank Name!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cardNumberController,
                      hint: "Card Number",
                      textInputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberFormatter()
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Card Number!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      value: type,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text("Select Card Type"),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("Debit Card"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Credit Card"),
                        ),
                      ],
                      onChanged: (int? value) {
                        setState(() {
                          type = value ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cardExpiryDateController,
                      hint: "Expiry date of card",
                      enable: false,
                      onTap: () async {
                        GlobalMethods.printLog("ontap");
                        cardExpiry = await showMonthPickerDialog(cardExpiry);
                        cardExpiryDateController.text =
                            DateFormat('MM/yyyy').format(cardExpiry);
                        setState(() {});
                        // GlobalMethods.printLog(.toString());
                      },
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select our card expiry date!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cardGenerateDateController,
                      hint: "Card Generated Date (Card Valid From)",
                      enable: false,
                      onTap: () async {
                        GlobalMethods.printLog("ontap");
                        cardGenerated =
                            await showMonthPickerDialog(cardGenerated);
                        cardGenerateDateController.text =
                            DateFormat('MM/yyyy').format(cardGenerated);
                        setState(() {});
                        // GlobalMethods.printLog(.toString());
                      },
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select card generate date!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cardPaymentDateController,
                      hint: "Card Payment Date (Bill date)",
                      enable: false,
                      onTap: () async {
                        GlobalMethods.printLog("ontap");
                        cardPayment = await showMonthPickerDialog(cardPayment);
                        cardPaymentDateController.text =
                            DateFormat('MM/yyyy').format(cardPayment);
                        setState(() {});
                        // GlobalMethods.printLog(.toString());
                      },
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select you card payment date!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cvvNumberController,
                      hint: "CVV",
                      textInputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Card CVV!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: cardLimitController,
                      hint: "Card Limit",
                      textInputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Card Limit!";
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate() &&
                          type != 0) {
                        if (holderNameController.text
                            .toString()
                            .trim()
                            .isNotEmpty) {
                          CardModel card = CardModel();
                          card.cardOwnerId = widget.ownerModel.id;
                          card.cardLimit = double.parse(
                              cardLimitController.text.toString().trim());
                          card.cardPaymentDate = cardPayment.toIso8601String();
                          card.cardGenerateDate =
                              cardGenerated.toIso8601String();
                          card.cardExpiryDate = cardExpiry.toIso8601String();
                          card.cardCvv = cvvNumberController.text.toString();
                          card.cardNumber =
                              cardNumberController.text.toString();
                          card.cardType = type.toString();
                          card.cardBankName =
                              bankNameController.text.toString();
                          card.cardHolderName =
                              holderNameController.text.toString();
                          card.cardCompanyName =
                              companyNameController.text.toString();

                          GlobalMethods.printLog(card.toMap().toString());
                          await _addCard(card);
                          GlobalMethods.showSnackBar(
                              context,
                              "Your card added successfully.",
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
        ),
      ),
    );
  }

  _buildTextField(
      {required TextEditingController controller,
      required String hint,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      bool enable = true,
      void Function()? onTap,
      List<TextInputFormatter>? textInputFormatters,
      bool isAllInCaps = false}) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      readOnly: !enable,
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

  Future<DateTime> showMonthPickerDialog(DateTime selected) async {
    int selectedIndex = selected.month;
    int selectedYear = selected.year;
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text("Month"),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Year"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectedIndex,
                            underline: Container(),
                            items: [
                              for (int i = 1; i <= 12; i++)
                                DropdownMenuItem<int>(
                                  value: i,
                                  child: Text(i.toString()),
                                  alignment: AlignmentDirectional.center,
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedIndex = value.toInt();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectedYear,
                            underline: Container(),
                            items: [
                              for (int i = DateTime.now().year - 10;
                                  i <= DateTime.now().year + 10;
                                  i++)
                                DropdownMenuItem<int>(
                                    value: i,
                                    child: Text(i.toString()),
                                    alignment: AlignmentDirectional.center),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedYear = value.toInt();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return DateTime(selectedYear, selectedIndex);
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
