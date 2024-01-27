import 'package:trader_diary/extension_methods.dart';
import '../i_model.dart';

class DealModel implements IModel {
  @override
  late int? id;
  late String symbol;
  late double amount;
  late DateTime date;
  late double ratio;
  late String description;
  late List<String> imagesNames;
  late List<int> tagsIds;
  late int accountId;

  bool get isProfit => amount > 0;
  bool get isLoss => amount < 0;
  bool get isBreakeven => amount == 0;

  // methods

  static double amountSum(List<DealModel> deals) {
    double sum = 0;
    for (var deal in deals) {
      sum += deal.amount;
    }
    return sum;
  }

  static double ratioSum(List<DealModel> deals) {
    double sum = 0;
    for (var deal in deals) {
      sum += deal.ratio;
    }
    return sum;
  }

  static Map<String, DateTime> maxAndMinDate(List<DealModel> deals) {
    if (deals.isEmpty) throw Exception('items is empty');

    DateTime maxDate = deals[0].date, minDate = deals[0].date;
    for (int i = 1; i < deals.length; i++) {
      if (deals[i].date > maxDate) maxDate = deals[i].date;
      if (deals[i].date < minDate) minDate = deals[i].date;
    }
    return {'max': maxDate, 'min': minDate};
  }

  static List<double> createChartData(List<DealModel> deals) {
    List<double> data = [0];
    double value = 0;

    for (int i = deals.length - 1; i >= 0; i--) {
      value += deals[i].amount;
      data.add(value);
    }

    return data;
  }

  // constructors

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'symbol': symbol,
        'amount': amount,
        'date': date,
        'ratio': ratio,
        'description': description,
        'imagesNames': imagesNames,
        'tagsIds': tagsIds,
        'accountId': accountId,
      };

  @override
  DealModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    symbol = map['symbol'];
    amount = map['amount'];
    date = map['date'];
    ratio = map['ratio'];
    description = map['description'];
    imagesNames = map['imagesNames'] as List<String>;
    tagsIds = map['tagsIds'] as List<int>;
    accountId = map['accountId'];
  }

  DealModel({
    this.id,
    required this.symbol,
    required this.amount,
    required this.date,
    this.ratio = 1,
    this.description = '',
    this.imagesNames = const [],
    this.tagsIds = const [],
    required this.accountId,
  });
}
