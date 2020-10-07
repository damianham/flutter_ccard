class CreditCardModel {
  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.isCvvFocused, this.idNumber);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String idNumber = '';
  bool isCvvFocused = false;

  String toString() {
    return {cardNumber, expiryDate, cardHolderName, cvvCode, idNumber}
        .toString();
  }
}
