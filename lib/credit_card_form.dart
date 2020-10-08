import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'credit_card_model.dart';
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm(
      {Key key,
      this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      @required this.onCreditCardModelChange,
      this.themeColor,
      this.textColor = Colors.black,
      this.cursorColor,
      this.cardHolderNameInputDecoration,
      this.cardNumberInputDecoration,
      this.cvvInputDecoration,
      this.idInputDecoration,
      this.textStyle,
      this.onTapExpDate,
      this.expiryDateInputDecoration,
      this.prompts})
      : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;
  final InputDecoration cardNumberInputDecoration;
  final InputDecoration expiryDateInputDecoration;
  final InputDecoration cvvInputDecoration;
  final InputDecoration cardHolderNameInputDecoration;
  final InputDecoration idInputDecoration;
  final TextStyle textStyle;
  final Function onTapExpDate;
  final Map<String, String> prompts;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;

  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;
  Map<String, String> prompts = {
    'card_number': 'Card number',
    'expires': 'Expires',
    'cvv': 'CVV',
    'card_holder': 'Card Holder'
  };

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;
    prompts = widget.prompts ?? prompts;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _cardHolderNameController.value = TextEditingValue(text: cardHolderName);

    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextField(
                controller: _cardNumberController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
                style: widget.textStyle == null
                    ? TextStyle(
                        color: widget.textColor,
                      )
                    : widget.textStyle,
                maxLines: 1,
                decoration: widget.cardNumberInputDecoration == null
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        labelText: prompts['card_number'],
                        hintText: 'xxxx xxxx xxxx xxxx',
                        border: const OutlineInputBorder(),
                      )
                    : widget.cardNumberInputDecoration,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      onTap: widget.onTapExpDate,
                      readOnly: widget.onTapExpDate == null ? false : true,
                      controller: _expiryDateController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: widget.textStyle == null
                          ? TextStyle(
                              color: widget.textColor,
                            )
                          : widget.textStyle,
                      decoration: widget.expiryDateInputDecoration ??
                          InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: prompts['expires'],
                              hintText: 'MM/YY'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextField(
                      focusNode: cvvFocusNode,
                      controller: _cvvCodeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: widget.textStyle == null
                          ? TextStyle(
                              color: widget.textColor,
                            )
                          : widget.textStyle,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: widget.cvvInputDecoration == null
                          ? InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: prompts['cvv'],
                              hintText: 'XXX',
                            )
                          : widget.cvvInputDecoration,
                      keyboardType: TextInputType.number,
                      onChanged: (String text) {
                        setState(() {
                          cvvCode = text;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: widget.textStyle == null
                    ? TextStyle(
                        color: widget.textColor,
                      )
                    : widget.textStyle,
                decoration: widget.cardHolderNameInputDecoration == null
                    ? InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: prompts['card_holder'],
                      )
                    : widget.cardHolderNameInputDecoration,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
