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
  final List<String?> image;
  final List<int?> catIds;


  PostButtonPressed({
    required this.description,
    required this.postTypeId,
    required this.image,
    required this.catIds,
  });

}

// class GetPostTypes extends NewPostEvents {}


