class APIPath {
  static String request(String uid, String donateId) => '/users/$uid/donate/$donateId';
  static String requests(String uid) => 'users/$uid/donate';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}

//put all db api here for easy sorting