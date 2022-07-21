import 'package:doki/screens/settings_screen.dart';
import 'package:doki/screens/update_screen.dart';
import 'package:doki/screens/upload_screen.dart';
import 'package:doki/screens/viewer_vm.dart';
import 'package:doki/widgets/actions_toolbar.dart';
import 'package:doki/widgets/file_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import '../data/models.dart';
import '../widgets/bottom_bar.dart';
import 'browser_screen.dart';

// built upon https://github.com/salvadordeveloper/TikTok-Flutter/blob/master/lib/screens/feed_screen.dart

class ViewerScreen extends StatefulWidget {
  const ViewerScreen({Key? key}) : super(key: key);

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  final locator = GetIt.instance;
  final viewerViewModel = GetIt.instance<ViewerViewModel>();

  @override
  void initState() {
    viewerViewModel.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewerViewModel>.reactive(
      disposeViewModel: false,
      builder: (context, model, child) => fileScreen(),
      viewModelBuilder: () => viewerViewModel,
    );
  }

  Widget fileScreen() {
    return Scaffold(
        backgroundColor: GetIt.instance<ViewerViewModel>().actualScreen == 0
            ? Colors.black
            : Colors.white,
        body: Stack(
          children: [
            PageView.builder(
              itemCount: 2,
              physics: viewerViewModel.actualScreen != 0
                  ? const NeverScrollableScrollPhysics()
                  : null,
              onPageChanged: (value) {
                if (value == 1) {
                  SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                          systemStatusBarContrastEnforced: false,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent,
                          systemNavigationBarIconBrightness: Brightness.dark,
                          statusBarIconBrightness: Brightness.dark,
                          systemNavigationBarContrastEnforced: false));
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
                      overlays: []);
                } else {
                  SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                          systemStatusBarContrastEnforced: false,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent,
                          systemNavigationBarIconBrightness: Brightness.light,
                          statusBarIconBrightness: Brightness.light,
                          systemNavigationBarContrastEnforced: false));
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
                      overlays: []);
                }
              },
              itemBuilder: ((context, index) {
                if (index == 0) {
                  return appView();
                } else {
                  return infoView();
                }
              }),
            )
          ],
        ));
  }

  Widget infoView() {
    var files = GetIt.instance<ViewerViewModel>().viewableFiles;
    var previous = GetIt.instance<ViewerViewModel>().previous;
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppBar(
              title: Text(files.isNotEmpty
                  ? files[previous].file.title ??
                      files[previous].file.fileUrl.replaceAll("files/", "")
                  : 'No connection to server')),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${(files[previous].file.size / 1e3 / 1e3).toStringAsFixed(2)} MB",
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Filesize',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${DateTime.fromMillisecondsSinceEpoch(files[previous].file.unixTime * 1e3.toInt())}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Upload date',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  files[previous].file.author.name,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Uploader',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${files[previous].file.views}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Views',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${files[previous].file.folder}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  files[previous]
                      .file
                      .fileUrl
                      .split('.')[
                          files[previous].file.fileUrl.split('.').length - 1]
                      .toUpperCase(),
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('File type',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  files[previous].file.tags ?? "None",
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Text('Tags',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const Divider(),
          Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 20, right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Under construction!');
                  },
                  child: const Text('Download'))),
        ]),
      )),
    );
  }

  Widget appView() {
    // bottombar is not const due to .setActiveScreen
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: currentScreen(),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget currentScreen() {
    // these can't be const in the same manner as bottombar
    switch (viewerViewModel.actualScreen) {
      case 0:
        return fileViewScreen();
      case 1:
        // ignore: prefer_const_constructors
        return BrowserScreen();
      case 2:
        // ignore: prefer_const_constructors
        return UploadScreen();
      case 3:
        // ignore: prefer_const_constructors
        return UpdateScreen();
      case 4:
        // ignore: prefer_const_constructors
        return SettingsScreen();
      default:
        return fileViewScreen();
    }
  }

  Widget fileViewScreen() {
    if (viewerViewModel.viewableFiles.isEmpty) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text("Loading"),
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
            child: PageView.builder(
              controller: viewerViewModel.pageController = PageController(
                initialPage: viewerViewModel.previous,
                viewportFraction: 1,
              ),
              itemCount: viewerViewModel.viewableFiles.length,
              onPageChanged: (index) {
                index = index % viewerViewModel.viewableFiles.length;
                viewerViewModel.changeFile(index);
              },
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                index = index % viewerViewModel.viewableFiles.length;
                return fileCard(viewerViewModel.viewableFiles[index]);
              },
            ),
            onRefresh: () async {
              viewerViewModel.refresh();
            }),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      viewerViewModel.dokiSource!.files.isNotEmpty
                          ? 'doki'
                          : '',
                      style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 20.0,
                              color: Color.fromARGB(128, 0, 0, 0),
                            )
                          ]))
                ]),
          ),
        ),
      ],
    );
  }

  Widget fileCard(ViewCard viewCard) {
    return Stack(
      children: [
        viewCard.controller != null
            ? SizedBox.expand(
                child: FittedBox(
                fit: viewerViewModel.coverFit ? BoxFit.cover : BoxFit.contain,
                child: SizedBox(
                  width: viewCard.controller?.value.size.width ?? 0,
                  height: viewCard.controller?.value.size.height ?? 0,
                  child: GestureDetector(
                      onDoubleTap: () => viewerViewModel.toggleFit(),
                      onTap: () {
                        if (viewCard.controller!.value.isPlaying) {
                          viewCard.controller?.pause();
                        } else {
                          viewCard.controller?.play();
                        }
                      },
                      child: VideoPlayer(viewCard.controller!)),
                ),
              ))
            : Container(
                color: Colors.black,
                child: const Center(
                  child: Text("Loading"),
                ),
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FileDescription(
                    viewCard.file.author,
                    viewCard.file.title ??
                        viewCard.file.fileUrl.replaceAll("files/", ""),
                    viewCard.file.description ?? 'N/A',
                    viewCard.file.views.toString()),
                ActionsToolbar(viewCard.file.likes.toString(),
                    viewCard.file.likes.toString()),
              ],
            ),
            const SizedBox(height: kBottomNavigationBarHeight + 30)
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var element in viewerViewModel.viewableFiles) {
      element.controller?.dispose();
    }
    super.dispose();
  }
}
