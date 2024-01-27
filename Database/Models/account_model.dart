import '../i_model.dart';
import 'package:trader_diary/View/HomeView/DealsBlock/DealGrouper/deals_grouper.dart';

class AccountModel implements IModel {
  @override
  late int? id;
  late String name;
  late double startBalance;
  late double balance;
  late String currency;
  late DealsGrouper dealsGrouper;

  double get deltaAmount => balance - startBalance;
  double get deltaPercent =>
      startBalance != 0 ? deltaAmount / startBalance * 100 : balance;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'startBalance': startBalance,
        'balance': balance,
        'currency': currency,
        'dealsGrouper': dealsGrouper.toMap(),
      };

  @override
  AccountModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    startBalance = map['startBalance'];
    balance = map['balance'];
    currency = map['currency'];
    dealsGrouper =
        DealsGrouper.fromMap(Map<String, dynamic>.from(map['dealsGrouper']));
  }

  AccountModel({
    this.id,
    required this.name,
    required this.startBalance,
    required this.currency,
    required this.dealsGrouper,
  }) : balance = startBalance;
}
