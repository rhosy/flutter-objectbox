import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int personId;
  final String name;

  Person({
    this.personId = 0,
    this.name = "no name",
  });
}
