class Profile {
  final String? name;
  final String? email;
  final String? phone;
  final String? displayName;
  String? photoUrl;
  final String role;

  // Constructores
  Profile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? displayName,
  })  : email = email ?? 'No disponible',
        name = name ?? 'No disponible',
        phone = phone ?? 'No disponible',
        photoUrl = photoUrl ??
            'https://firebasestorage.googleapis.com/v0/b/lumo-ghub.appspot.com/o/users_profile%2Fb0fpiXJ9qhYywvKd5AOHehw2WwU2%2FimgProfile.gif?alt=media',
        displayName = displayName ?? 'No disponible',
        role = 'client';

  // Método para convertir un documento de Firestore en un objeto Profile
  factory Profile.fromFirestore(Map<String, dynamic> data) {
    return Profile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phoneNumber'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      displayName: data['displayName'] ?? data['name'] ?? '',
    );
  }

  // Método para convertir un objeto Profile en un documento de Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'Profile(name: $name \n email: $email \n phoneNumber: $phone \n photoUrl: $photoUrl \n displayName: $displayName \n role: $role)';
  }
}
