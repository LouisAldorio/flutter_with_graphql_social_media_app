class User {
  String id;
  String name;
  String username;
  String email;

  String street;
  String suite;
  String city;
  String zipcode;

  String phone;
  String website;
  String companyName;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.phone,
    required this.website,
    required this.companyName,
    required this.email,
  });
}