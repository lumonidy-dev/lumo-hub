class Profile {
  final String? name;
  final String? email;
  final String phoneNumber;
  String? photoUrl;
  final String displayName;
  final String role;

  // Constructores
  Profile({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? displayName,
  })  : email = email ?? '',
        name = name ?? '',
        phoneNumber = phoneNumber ?? '',
        photoUrl = photoUrl ?? '',
        displayName = displayName ?? name ?? '',
        role = 'client';

  // Método para convertir un documento de Firestore en un objeto Profile
  factory Profile.fromFirestore(Map<String, dynamic> data) {
    return Profile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      displayName: data['displayName'] ?? data['name'] ?? '',
    );
  }

  // Método para convertir un objeto Profile en un documento de Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'Profile(name: $name \n email: $email \n phoneNumber: $phoneNumber \n photoUrl: $photoUrl \n displayName: $displayName \n role: $role)';
  }
}
