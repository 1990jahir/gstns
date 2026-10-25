/// Address details returned by GSTIN lookup API
class GstinAddress {
  final String line1;
  final String line2;
  final String place;
  final String city;
  final String state;
  final String stateCode;
  final String pincode;

  GstinAddress({
    this.line1 = '',
    this.line2 = '',
    this.place = '',
    this.city = '',
    this.state = '',
    this.stateCode = '',
    this.pincode = '',
  });

  factory GstinAddress.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GstinAddress();
    return GstinAddress(
      line1: json['line1']?.toString() ?? '',
      line2: json['line2']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      stateCode: json['state_code']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'line1': line1,
    'line2': line2,
    'place': place,
    'city': city,
    'state': state,
    'state_code': stateCode,
    'pincode': pincode,
  };
}

/// Strongly-typed response model for GSTIN Lookup endpoint (/api/v1/register/gstin-lookup)
class GstinLookupData {
  final String gstin;
  final String legalName;
  final String tradeName;
  final String pan;
  final String firstName;
  final String lastName;
  final String companyName;
  final String status;
  final String? registrationDate;
  final GstinAddress address;
  final bool alreadyRegistered;

  GstinLookupData({
    required this.gstin,
    required this.legalName,
    required this.tradeName,
    required this.pan,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.status,
    this.registrationDate,
    required this.address,
    required this.alreadyRegistered,
  });

  factory GstinLookupData.fromJson(Map<String, dynamic> json) {
    return GstinLookupData(
      gstin: json['gstin']?.toString() ?? '',
      legalName: json['legal_name']?.toString() ?? '',
      tradeName: json['trade_name']?.toString() ?? '',
      pan: json['pan']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
      registrationDate: json['registration_date']?.toString(),
      address: GstinAddress.fromJson(json['address'] as Map<String, dynamic>?),
      alreadyRegistered: json['already_registered'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'gstin': gstin,
    'legal_name': legalName,
    'trade_name': tradeName,
    'pan': pan,
    'first_name': firstName,
    'last_name': lastName,
    'company_name': companyName,
    'status': status,
    'registration_date': registrationDate,
    'address': address.toJson(),
    'already_registered': alreadyRegistered,
  };

  /// Returns the best display name for the business (trade_name or company_name, falling back to legal_name)
  String get effectiveCompanyName {
    if (companyName.trim().isNotEmpty) return companyName.trim();
    if (tradeName.trim().isNotEmpty) return tradeName.trim();
    return legalName.trim();
  }
}

