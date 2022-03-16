import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  final Widget? image;
  final TextEditingController controller;
  final BorderRadius? inputRadius;
  final Function onSend,onImageRemoved;

  const CommentBox({Key? key,
    this.image,
    required this.controller,
    this.inputRadius,
    required this.onSend , required this.onImageRemoved }) : super(key: key);

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Widget? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Colors.grey[300],
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,10,10,10),
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: "Add New Comment",
              suffixIcon: IconButton(
                icon: Icon(Icons.send,color: Theme.of(context).primaryColor),
                onPressed: () {
                  widget.onSend();
                },
              ),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: widget.inputRadius ?? BorderRadius.circular(32),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _removable(BuildContext context, Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              image = null;
              widget.onImageRemoved();
            });
          },
        )
      ],
    );
  }

  Widget _imageView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image,
      ),
    );
  }
}