import 'package:equatable/equatable.dart';


class EditPostEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartEditPost extends EditPostEvents {}

class SaveButtonPressed extends EditPostEvents{
  final String description;
  final int postId;

  SaveButtonPressed({
    required this.description,
    required this.postId,
  });

}