import 'package:equatable/equatable.dart';

import '../../../model/cat/cat_model.dart';
import '../../../model/post/postType.dart';

class OwnCatsState extends Equatable{
  @override
  List<Object> get props => [];
}

// Get Own Cats
class GetOwnCatsInitial extends OwnCatsState { }

class GetOwnCatsLoading extends OwnCatsState { }

class GetOwnCatsLoaded extends OwnCatsState {
  final List<CatModel> cats;
  GetOwnCatsLoaded({required this.cats});
}

class GetOwnCatsError extends OwnCatsState {
  final String? error;
  GetOwnCatsError({required this.error});
}
