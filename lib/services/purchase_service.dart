import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const _kProProductId = 'standby_hub_pro';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  ProductDetails? _proProduct;

  bool get isAvailable => _isAvailable;
  ProductDetails? get proProduct => _proProduct;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate);

    final response = await _iap.queryProductDetails({_kProProductId});
    if (response.productDetails.isNotEmpty) {
      _proProduct = response.productDetails.first;
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
      if (purchase.productID == _kProProductId &&
          purchase.status == PurchaseStatus.purchased) {
        _onProPurchased?.call();
      }
    }
  }

  void Function()? _onProPurchased;

  set onProPurchased(void Function()? callback) {
    _onProPurchased = callback;
  }

  Future<bool> buyPro() async {
    if (_proProduct == null) return false;
    final param = PurchaseParam(productDetails: _proProduct!);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService();
  ref.onDispose(service.dispose);
  return service;
});
