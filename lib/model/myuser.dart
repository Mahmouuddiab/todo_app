class MyUser{
  static const String collectinName="users";
  String? id;
  String? name;
  String? email;

  MyUser({required this.id,required this.name,required this.email});

  MyUser.fromJson(Map<String,dynamic>data):this(
      id:data!["id"],
      name:data!['name'],
      email:data!['email']
  );

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'name':name,
      'email':email
    };
  }



}