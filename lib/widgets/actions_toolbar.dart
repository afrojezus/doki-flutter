import 'package:doki/screens/viewer_vm.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ActionsToolbar extends StatelessWidget {
  final String views;
  final String likes;

  const ActionsToolbar(this.views, this.likes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        overlaidAction(icon: Icons.thumb_up, title: likes, action: () {}),
        overlaidAction(
            icon: GetIt.instance<ViewerViewModel>().coverFit
                ? Icons.tv
                : Icons.fit_screen,
            title: GetIt.instance<ViewerViewModel>().coverFit
                ? 'Cover'
                : 'Contain',
            action: () => GetIt.instance<ViewerViewModel>().toggleFit()),
        /*overlaidAction(
            icon: GetIt.instance<ViewerViewModel>().loop
                ? Icons.loop
                : Icons.fast_rewind,
            title:
                GetIt.instance<ViewerViewModel>().loop ? 'Loop' : 'Continious',
            action: () => GetIt.instance<ViewerViewModel>().toggleLoop()),*/
        overlaidAction(
            icon: GetIt.instance<ViewerViewModel>().muted
                ? Icons.volume_mute
                : Icons.volume_up,
            title: GetIt.instance<ViewerViewModel>().muted ? 'Muted' : 'Unmute',
            action: () => GetIt.instance<ViewerViewModel>().toggleMute()),
        overlaidAction(
          icon: Icons.cast,
          title: 'Cast',
          action: () {},
        )
      ]),
    );
  }

  Widget overlaidAction(
      {required String title,
      required IconData icon,
      required Function() action}) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: action,
            borderRadius: BorderRadius.circular(16),
            child: Container(
                margin: const EdgeInsets.only(top: 15.0),
                width: 60.0,
                height: 60.0,
                child: Column(children: [
                  Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 0, 0, 0),
                              blurRadius: 30.0,
                            ),
                          ]),
                      child: Icon(icon, size: 25.0, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(title,
                        style: const TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 30.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0)),
                  )
                ]))));
  }
}
