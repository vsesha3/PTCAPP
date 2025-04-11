// ignore_for_file: non_constant_identifier_names

class StudentProfileModel {
  final int id;
  final StudentModel student;
  final ParentsModel parent;
  final AddressModel address;
  final String source;
  final String other_source;
  final String created_at;
  final String updated_at;

  StudentProfileModel({
    required this.id,
    required this.student,
    required this.parent,
    required this.address,
    required this.source,
    required this.other_source,
    required this.created_at,
    required this.updated_at,
  });

  factory StudentProfileModel.empty() {
    return StudentProfileModel(
      id: 0,
      student: StudentModel(
        full_name: '',
        nickname: '',
        school: '',
        other_info: '',
        date_of_birth: '',
        age: 0,
        gender: '',
        branch: '',
        nationality: '',
        photograph: '',
      ),
      parent: ParentsModel(
        father_first_name: '',
        father_photo: '',
        father_contact: '',
        father_email: '',
        father_social_media: '',
        father_profession: '',
        father_date_of_birth: '',
        father_age: 0,
        mother_photo: '',
        mother_first_name: '',
        mother_contact: '',
        mother_email: '',
        mother_social_media: '',
        mother_profession: '',
        mother_date_of_birth: '',
        mother_age: 0,
      ),
      address: AddressModel(
        address: '',
        work_address: '',
        emergency_contact: '',
      ),
      source: '',
      other_source: '',
      created_at: '',
      updated_at: '',
    );
  }
}

class StudentModel {
  // ignore: non_constant_identifier_names
  String full_name;
  String nickname;
  String school;
  String other_info;
  String date_of_birth;
  int age;
  String gender;
  String branch;
  String nationality;
  String photograph;

  StudentModel({
    this.full_name = '',
    this.nickname = '',
    this.school = '',
    this.other_info = '',
    required this.date_of_birth,
    required this.age,
    required this.gender,
    required this.branch,
    required this.nationality,
    required this.photograph,
  });
}

class ParentsModel {
  final String father_first_name;
  final String father_photo;
  final String father_contact;
  final String father_email;
  final String father_social_media;
  final String father_profession;
  final String father_date_of_birth;
  final int father_age;

  final String mother_photo;
  final String mother_first_name;
  final String mother_contact;
  final String mother_email;
  final String mother_social_media;
  final String mother_profession;
  final String mother_date_of_birth;
  final int mother_age;

  ParentsModel({
    required this.father_first_name,
    required this.father_photo,
    required this.father_contact,
    required this.father_email,
    required this.father_social_media,
    required this.father_profession,
    required this.father_date_of_birth,
    required this.father_age,
    required this.mother_photo,
    required this.mother_first_name,
    required this.mother_contact,
    required this.mother_email,
    required this.mother_social_media,
    required this.mother_profession,
    required this.mother_date_of_birth,
    required this.mother_age,
  });
}

class AddressModel {
  final String address;
  final String work_address;
  final String emergency_contact;

  AddressModel({
    required this.address,
    required this.work_address,
    required this.emergency_contact,
  });
}
