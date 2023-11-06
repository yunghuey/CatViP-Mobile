import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add post"),
        ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _caption(),
            ),
          ],
        ),
      ),
    );
  }




  Widget _caption(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,

          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )
        ),
        prefixIcon: Icon(
          Icons.closed_caption,
          color: Colors.green,
        ),
        labelText: "Caption",
          helperText: "",
        hintText: "Write a caption.",
      ),
    );
  }
}
