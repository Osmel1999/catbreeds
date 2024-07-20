import 'package:catbreeds/HomePage.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final String name;
  final String image;
  final String texto;
  const InfoPage({
    super.key,
    required this.name,
    required this.image,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: media.height,
            width: media.width,
            alignment: Alignment.center,
            child: Text(name),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: media.height * 0.01, horizontal: media.width * 0.02),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ImageWithLoadingIndicator(imageUrl: image),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      texto,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 45,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
