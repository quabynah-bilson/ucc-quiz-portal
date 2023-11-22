import 'package:objectbox/objectbox.dart';

// ignore_for_file: public_member_api_docs

@Entity()
class Active {
  int? id;
  int? count;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  Active(this.count, {this.id = 0, this.comment, DateTime? date}) 
   :   date = date ?? DateTime.now();
}