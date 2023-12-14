import 'package:equatable/equatable.dart';


class CompleteCaseEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartCompleteCase extends CompleteCaseEvents {}

class CompleteButtonPressed extends CompleteCaseEvents{
  final int postId;

  CompleteButtonPressed({
    required this.postId,
  });

}
