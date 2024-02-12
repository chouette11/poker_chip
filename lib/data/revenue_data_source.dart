import 'package:flutter/services.dart';
import 'package:poker_chip/util/enum/revenue_package.dart';
import 'package:riverpod/riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final revenueProvider =
Provider<BillingDataSource>((ref) => BillingDataSource(ref: ref));

class BillingDataSource {
  BillingDataSource({required this.ref});

  final Ref ref;

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      print('Error purchasing promoted product: ${e.message}');
      throw Exception();
    }
  }

  Future<Offering?> getOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } on PlatformException catch (e) {
      print('Error get offering: ${e.message}');
      throw Exception();
    }
  }

  Future<CustomerInfo?> buyMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offer = offerings.getOffering('only_ad');
      final package = offer!.monthly;
      if (package == null) {
        return null;
      }
      return await Purchases.purchasePackage(package);
    } on PlatformException catch (e) {
      print('Error purchasing promoted product: ${e.message}');
      throw Exception();
    }
  }

  Future<bool> getIsProUser() async {
    final info = await getCustomerInfo();
    print(info);
    print(info.activeSubscriptions);
    return info.activeSubscriptions.contains(RevenuePackageEnum.entitlement.value);
  }
}