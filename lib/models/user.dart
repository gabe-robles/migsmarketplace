class User {

  final String uid;

  User({ this.uid });

}

class UserData {

  UserData({
    this.uid,
    this.merchantName,
    this.merchantPhone,
    this.merchantMarket,
  });

  final String uid;
  final String merchantName;
  final String merchantPhone;
  final String merchantMarket;

}