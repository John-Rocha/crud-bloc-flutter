part of 'note_validation_cubit.dart';

abstract class NoteValidationState extends Equatable {
  const NoteValidationState();

  @override
  List<Object> get props => [];
}

//campos do formulário aguardando validação com sucesso
class NoteValidating extends NoteValidationState {
  const NoteValidating({
    this.titleMessage,
    this.contentMessage,
  });

  final String? titleMessage;
  final String? contentMessage;

  NoteValidating copyWith({
    String? titleMessage,
    String? contentMessage,
  }) {
    return NoteValidating(
      titleMessage: titleMessage ?? this.titleMessage,
      contentMessage: contentMessage ?? this.contentMessage,
    );
  }

  @override
  List<Object> get props => [titleMessage!, contentMessage!];
}

// campos do formulário validados com sucesso
class NoteValidated extends NoteValidationState {
  const NoteValidated();

  @override
  List<Object> get props => [];
}
