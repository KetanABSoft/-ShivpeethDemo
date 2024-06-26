import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../constant/conurl.dart';

class stutimetableadapter extends StatefulWidget {
    final String? timetableimage;

  const stutimetableadapter({
    required this.timetableimage
,    super.key});

  @override
  State<stutimetableadapter> createState() => stutimetableadapterState();

  
}
  


class stutimetableadapterState extends State<stutimetableadapter> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
 @override
Widget build(BuildContext context) {
  print(widget.timetableimage);

  final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZoomedImagePage(
              imageUrl: AppString.imageurl + widget.timetableimage.toString(),
            ),
          ),
        );
      },
      child: Container(
        // Container to hold the image with rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.network(
            AppString.imageurl + widget.timetableimage.toString(),
            width: width, // Set the width to the full width of the screen
            height: height / 1, // Set the height as needed
            fit: BoxFit.fill, // Adjust the fit based on your requirements
          ),
        ),
      ),
    );
  }
}

class ZoomedImagePage extends StatelessWidget {
  final String imageUrl;

  const ZoomedImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
       body: Container( 
                    child: PhotoView( 
                        imageProvider:NetworkImage(imageUrl),
                    ) 
    ));
  }
}