class Role{
  String role;
  int id;
  String email;  
  Role({
    required this.role,
    this.id = -1,
    this.email = "",
  });

  factory Role.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        "id": int id,
        "uuid": int uuid,
        "role": String role,
        "email": String email,
      } => 
        Role(
          role: role,
          id: id,
          email: email),
      {
      "role": String role,
    } => 
      Role(
        role: role,
      ),
      _ => throw const FormatException('Failed to load role.'),
    };
  }
}