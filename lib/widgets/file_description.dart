import 'package:doki/data/models.dart';
import 'package:flutter/material.dart';

class FileDescription extends StatelessWidget {
  final Author author;
  final String title;
  final String description;
  final String views;

  const FileDescription(this.author, this.title, this.description, this.views,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 120.0,
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    author.name,
                    style: const TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 30.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )
                        ],
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 30.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(children: [
                    const Icon(
                      Icons.description,
                      size: 15.0,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(description,
                            style: const TextStyle(shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 30.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ], color: Colors.white, fontSize: 14.0)))
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    const Icon(
                      Icons.people,
                      size: 15.0,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(views,
                            style: const TextStyle(shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 30.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ], color: Colors.white, fontSize: 14.0)))
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                ])));
  }
}
