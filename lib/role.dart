class Role{
  final String role;

  const Role({
    required this.role,
  });

  factory Role.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      "role": String role,
    } => 
      Role(
        role: role,
      ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}