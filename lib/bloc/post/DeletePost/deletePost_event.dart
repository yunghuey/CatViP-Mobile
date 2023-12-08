import 'package:equatable/equatable.dart';


class DeletePostEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeletePost extends DeletePostEvents {}

class DeleteButtonPressed extends DeletePostEvents{
  final int postId;

  DeleteButtonPressed({
    required this.postId,
  });

}