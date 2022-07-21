import 'dart:math';

import 'package:doki/data/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import '../data/models.dart';

class ViewerViewModel extends BaseViewModel {
  PageController? pageController;
  List<ViewCard> viewableFiles = <ViewCard>[];
  DokiAPI? dokiSource;
  int previous = 0;
  int actualScreen = 0;
  bool loop = true;
  bool coverFit = true;
  bool muted = false;

  init() async {
    try {
      dokiSource = DokiAPI();
      await dokiSource?.load();
      viewableFiles.add(getRandomFile());
      viewableFiles.add(getRandomFile());
      await viewableFiles[0].loadController(loop);
      await viewableFiles[0].controller?.play();
    } on Exception catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    } finally {
      notifyListeners();
    }
  }

  // DIRTY
  refresh() {
    init();
  }

  toggleFit() {
    coverFit = !coverFit;
    notifyListeners();
  }

  toggleLoop() {
    loop = !loop;
    for (var element in viewableFiles) {
      element.controller?.setLooping(loop);
      element.controller?.addListener(() => {
            if (element.controller?.value.position ==
                element.controller?.value.duration)
              pageController?.animateToPage(previous + 1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn)
          });
    }
    notifyListeners();
  }

  toggleMute() {
    muted = !muted;
    viewableFiles[previous].controller?.setVolume(muted ? 0.0 : 1.0);
    notifyListeners();
  }

  ViewCard getRandomFile() {
    final random = Random();
    return ViewCard(
        file: dokiSource!.files[random.nextInt(dokiSource!.files.length)]);
  }

  getFile(File file) async {
    setActualScreen(0);
    previous = 0;
    for (var element in viewableFiles) {
      element.controller?.dispose();
      element.controller = null;
    }
    viewableFiles.clear();
    viewableFiles.add(ViewCard(
        file: dokiSource!.files.where((element) => element == file).first));
    viewableFiles.add(getRandomFile());
    await viewableFiles[0].loadController(loop);
    await viewableFiles[0].controller?.play();
    notifyListeners();
  }

  changeFile(index) async {
    if (kDebugMode) {
      print(index);
      print(viewableFiles.length - 1);
    }
    if (viewableFiles[index].controller == null) {
      await viewableFiles[index].loadController(loop);
      viewableFiles[index].disposed = false;
      /*
      if (loop) {
        viewableFiles[index].controller?.addListener(() => {
              if (viewableFiles[index].controller?.value.position ==
                  viewableFiles[index].controller?.value.duration)
                pageController?.animateToPage(previous + 1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeIn)
            });
      }*/
    }

    await viewableFiles[index].controller?.play();

    if (viewableFiles[previous].controller != null) {
      await viewableFiles[previous].controller?.pause();
    }
    if ((previous - 1 > 0) &&
        (previous - 1 < previous) &&
        viewableFiles[previous - 1].controller != null) {
      await viewableFiles[previous - 1].controller?.pause();
      await viewableFiles[previous - 1].controller?.dispose();
      viewableFiles[previous - 1].controller = null;
      viewableFiles[previous - 1].disposed = true;
    }
    if ((viewableFiles.length - 1) == index) {
      viewableFiles.add(getRandomFile());
    }

    previous = index;
    notifyListeners();
  }

  void setActualScreen(index) {
    actualScreen = index;
    if (index == 0) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: false,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarContrastEnforced: false));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: []);
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: false,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: []);
    }
    notifyListeners();
  }
}
