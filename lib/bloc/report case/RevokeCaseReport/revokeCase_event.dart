import 'package:equatable/equatable.dart';


class RevokeCaseEvents extends Equatable{
  @override
  List<Object> get props => [];
}


class StartRevokeCase extends RevokeCaseEvents {}

class RevokeCaseButtonPressed extends RevokeCaseEvents{
  final int postId;

  RevokeCaseButtonPressed({
    required this.postId,
  });

}