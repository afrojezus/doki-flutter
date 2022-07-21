import 'package:cached_network_image/cached_network_image.dart';
import 'package:doki/constants.dart';
import 'package:doki/data/models.dart';
import 'package:doki/screens/viewer_vm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final files = GetIt.instance<ViewerViewModel>().dokiSource?.files;
  List<File> filteredFiles = <File>[];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    filteredFiles.clear();
    filteredFiles.addAll(files!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: _controller,
        decoration: const InputDecoration(isDense: true, hintText: "Search"),
      )),
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: filteredFiles.length, // this works surprisingly well
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        itemBuilder: (context, index) {
          index = index % filteredFiles.length;
          return gridTile(filteredFiles[index]);
        },
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
      bottomNavigationBar:
          const SizedBox(height: kBottomNavigationBarHeight + 30),
    );
  }

  Widget gridTile(File file) {
    try {
      if (file.thumbnail != null) {
        var image = CachedNetworkImage(
            fit: BoxFit.cover, imageUrl: dokiBaseUrl + file.thumbnail!);
        return Stack(children: [
          Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                SizedBox.expand(child: image),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            file.title ?? file.fileUrl.replaceAll("files/", ""),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 20.0)
                                ],
                                color: Colors.white))))
              ])),
          Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          GetIt.instance<ViewerViewModel>().getFile(file))))
        ]);
      }
      return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: () => GetIt.instance<ViewerViewModel>().getFile(file),
              child: Stack(children: [
                const SizedBox.expand(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.music_note, size: 36),
                        ))),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            file.title ?? file.fileUrl.replaceAll("files/", ""),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))))
              ])));
    } on Exception catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return const Card(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.error, size: 36)));
    }
  }
}
