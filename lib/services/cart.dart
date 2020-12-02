import 'package:cloud_firestore/cloud_firestore.dart';

class CartServices {

  //Declare Firebase Instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Merchant Create Product
  createOrder (

      String customerName,
      String customerAddress,
      String customerCity,
      String customerPhone,
      bool customerConfirmed,
      bool merchantNotificationShown,
      bool notificationShown,
      int orderAmount,
      DateTime orderDatetime,
      List<String> orderItem,
      List<int> orderItemAmount,
      List<String> orderMarket,
      List<String> orderMerchant,
      List<String> orderMerchantId,
      List<String> orderMerchantPhone,
      int orderServiceFee,
      List<int> orderUnit,
      List<int> orderUnitPrice,
      List<String> orderWeight,
      bool riderAccepted,
      bool riderConfirmed,
      String riderLocation,
      String riderName,
      String riderNotes,
      String riderPhone,
      ) async {

    DocumentReference docRef = await _firestore
        .collection('orders')
        .add({
      'customer_name' : customerName,
      'customer_address': customerAddress,
      'customer_city': customerCity,
      'customer_phone': customerPhone,
      'customer_confirmed': customerConfirmed,
      'merchant_notification_shown' : merchantNotificationShown,
      'notification_shown' : notificationShown,
      'order_amount' : orderAmount,
      'order_datetime': orderDatetime,
      'order_item' : orderItem,
      'order_item_amount': orderItemAmount,
      'order_market': orderMarket,
      'order_merchant': orderMerchant,
      'order_merchant_id': orderMerchantId,
      'order_merchant_phone': orderMerchantPhone,
      'order_service_fee': orderServiceFee,
      'order_unit': orderUnit,
      'order_unit_price': orderUnitPrice,
      'order_weight': orderWeight,
      'rider_accepted': riderAccepted,
      'rider_confirmed': riderConfirmed,
      'rider_location': riderLocation,
      'rider_name': riderName,
      'rider_notes': riderNotes,
      'rider_phone': riderPhone,
    });


    _firestore.collection('products').doc(docRef.id).update({'order_id' : docRef.id});

  }

  //Merchant Create Product
  updateOrder (

      String orderId,
      DateTime orderDatetime,
      String riderName,
      String riderPhone,

      ) async {

    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({
          'order_datetime': orderDatetime,
          'rider_name': riderName,
          'rider_phone': riderPhone,
    });

  }

}