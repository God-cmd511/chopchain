enum PaymentMethod { cash, mobileMoney, bankTransfer }

class Payment {
  final String id;
  final String orderId;
  final double amount;
  final PaymentMethod method;
  bool isPaid;
  DateTime? paidDate;

  Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    this.isPaid = false,
    this.paidDate,
  });
}
