import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class NewPostEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartNewPost extends NewPostEvents {}

class PostButtonPressed extends NewPostEvents{
  final String description;
  final int postTypeId;
  final String? image;
  final int catId;


  PostButtonPressed({
    required this.description,
    required this.postTypeId,
    required this.image,
    required this.catId,
  });

}

class GetPostTypes extends NewPostEvents {}


