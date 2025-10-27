// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

class PayForWeb implements MakePlatformSpecificPayment {
  @override
  makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    String? callBackUrl,
    String? publicKey,
    String? secretKey,
    String? currency,
    Map? metadata,
    String? plan,
    BuildContext? context,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    final config = js.JsObject.jsify({
      'key': publicKey,
      'email': customerEmail,
      'amount': int.parse(amount), // in kobo
      'ref': reference,
      'currency': currency ?? 'NGN',
      if (plan != null && plan.isNotEmpty) 'plan': plan,
      'metadata': metadata ?? {},
      'callback': js.allowInterop((response) {
        onSuccess();
      }),
      'onClose': js.allowInterop(() {
        onClosed();
      }),
    });    
    js.context['PaystackPop'].callMethod('setup', [config]).callMethod('openIframe');
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
