/// It represents a DTO that will be parsed by your implementation.
///
/// It is recommended to use it when you need to receive a payload which may contains
/// lists of other custom dtos.
abstract class MappableInput {
  const MappableInput();
  MappableInput parse(dynamic map);
}
