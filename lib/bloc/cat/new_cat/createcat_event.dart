import 'package:CatViP/model/cat/cat_model.dart';
import 'package:equatable/equatable.dart';

class CreateCatEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartCreateCat extends CreateCatEvents {}

class CreateButtonPressed extends CreateCatEvents{
  CatModel cat;

  CreateButtonPressed({required this.cat });
}
