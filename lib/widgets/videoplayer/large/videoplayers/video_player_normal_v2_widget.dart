import 'dart:html';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';
import 'package:video_player/video_player.dart';

import 'dart:js' as js;

//? FULLScreen sollte eig es gleiche seinwia Normal weil Flex und so, ondere methods holt ibergebn
class VideoPlayerNormalV2 extends StatefulWidget {
  const VideoPlayerNormalV2(
      {Key? key,
      required this.controller,
      required this.firstTimeExternAccess,
      required this.streamQualityKeysSorted,
      required this.activeQualityStream,
      required this.focusNode,
      required this.handleEscape})
      : super(key: key);

  final VideoPlayerController controller;
  final bool firstTimeExternAccess;
  final List<int> streamQualityKeysSorted;
  final int activeQualityStream;
  final FocusNode focusNode;

  final Function() handleEscape;
  // Map<int, String> streamQualityURL = {};
  // List<int> streamQualityKeysSorted = [];
  // late int activeQualityStream;

  @override
  _VideoPlayerNormalV2State createState() => _VideoPlayerNormalV2State();
}

class _VideoPlayerNormalV2State extends State<VideoPlayerNormalV2> {
  late bool _firtTimeExternAccess = false;

  //Menu Vars
  bool _isFullScreen = false;
  bool _showMenu = false;
  bool _showQuality = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _firtTimeExternAccess = widget.firstTimeExternAccess;
      // preventDefault();
      // js.JsObject.fromBrowserObject(js.context.)
      // @JS('JSON.stringify');
      // js.context.callMethod('alert', ["alerrtest"]);
      window.addEventListener("resize", (e) {
        // print("ss");
        // widget.handleEscape.call();
        // EasyDebounce.debounce(
        //     'fullscreenbuild-debouncer', // <-- An ID for this particular debouncer
        //     const Duration(seconds: 2), // <-- The debounce duration
        //     () {
        //   print("ss");

        // });
        widget.handleEscape.call(); // <-- The target method
        // print("ss");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _showMenu ? SystemMouseCursors.basic : SystemMouseCursors.none,
      //On Player Exit
      onExit: (PointerExitEvent event) {
        if (_showMenu) {
          EasyDebounce.debounce(
              'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
              const Duration(seconds: 2), // <-- The debounce duration
              () {
            if (_showMenu) {
              if (mounted) {
                setState(() {
                  _showMenu = false;
                  _showQuality = false;
                  print("_showMenu set to false");
                });
              }
            }
          });
        }
      },
      onEnter: (PointerEnterEvent event) {
        widget.focusNode.requestFocus();
        if (!_showMenu) {
          if (mounted) {
            setState(() {
              _showMenu = true;
              print("_showMenu set to true");
            });
          }

          EasyDebounce.debounce(
              'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
              const Duration(seconds: 5), // <-- The debounce duration
              () {
            if (_showMenu) {
              if (mounted) {
                setState(() {
                  _showMenu = false;
                  _showQuality = false;
                  print("_showMenu set to false");
                });
              }
            }
          }); // <-- The target method
        }
      },
      onHover: (PointerHoverEvent event) {
        if (!_showMenu) {
          if (mounted) {
            setState(() {
              _showMenu = true;
              print("_showMenu set to true");
            });
          }

          EasyDebounce.debounce(
              'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
              const Duration(seconds: 7), // <-- The debounce duration
              () {
            if (_showMenu) {
              if (mounted) {
                setState(() {
                  _showMenu = false;
                  _showQuality = false;
                  print("_showMenu set to false");
                });
              }
            }
          }); // <-- The target method
        }
      },
      child: AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        // Use the VideoPlayer widget to display the video.
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            //VideoPlayer Normal
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("tap");
                _firtTimeExternAccess = false;
                if (widget.controller.value.isPlaying) {
                  if (mounted) {
                    setState(() {
                      widget.controller.pause();
                      print("paused");

                      _showMenu = true;
                      print("_showMenu set to true");
                      _showQuality = false;
                    });
                  }

                  EasyDebounce.debounce(
                      'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                      const Duration(seconds: 2), // <-- The debounce duration
                      () {
                    if (_showMenu) {
                      if (mounted) {
                        setState(() {
                          _showMenu = false;
                          _showQuality = false;
                          print("_showMenu set to false");
                        });
                      }
                    }
                  }); // <-- The target method

                } else {
                  // If the video is paused, play it.
                  if (mounted) {
                    setState(() {
                      widget.controller.play();
                      print("playing");

                      _showMenu = true;
                      print("_showMenu set to true");
                      _showQuality = false;
                    });
                  }

                  EasyDebounce.debounce(
                      'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                      const Duration(seconds: 2), // <-- The debounce duration
                      () {
                    if (_showMenu) {
                      if (mounted) {
                        setState(() {
                          _showMenu = false;
                          _showQuality = false;
                          print("_showMenu set to false");
                        });
                      }
                    }
                  }); // <-- The target method

                }
              },
              child: IgnorePointer(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: VideoPlayer(widget.controller)),
              ),
            ),
            _showMenu
                //VideoPlayerMenu Normal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _showQuality
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .videoPlayerIconBackgroundColor
                                          .withOpacity(0.6)),
                                  child: Column(
                                      //Generate Quality Menu
                                      children: List.generate(
                                          widget.streamQualityKeysSorted.length,
                                          (index) {
                                    return Container(
                                      color: widget.streamQualityKeysSorted
                                                  .elementAt(index) ==
                                              widget.activeQualityStream
                                          ? Theme.of(context)
                                              .colorScheme
                                              .brandColor
                                          : Colors.transparent,
                                      child: TextButton(
                                          onPressed: () {
                                            if (mounted) {
                                              //TODO Handle in Parent
                                              // setState(() {
                                              //   _firtTimeExternAccess = false;
                                              //   activeQualityStream =
                                              //       streamQualityKeysSorted
                                              //           .elementAt(index);
                                              //   _initializePlay(
                                              //       streamQualityURL[
                                              //           activeQualityStream]!,
                                              //       widget.controller.value
                                              //           .position);
                                              //   _showMenu = false;
                                              //   _showQuality = false;
                                              // });
                                            }
                                          },
                                          child: Text(widget
                                                  .streamQualityKeysSorted
                                                  .elementAt(index)
                                                  .toString() +
                                              'p')),
                                    );
                                  })),
                                )
                              : const SizedBox(),
                          RotatedBox(
                            quarterTurns: 3,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Theme.of(context)
                                    .colorScheme
                                    .highlightColor,
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .videoPlayerIconBackgroundColor
                                    .withOpacity(0.6),
                                // trackShape: RectangularSliderTrackShape(),
                                trackHeight: 10,
                                thumbColor: Theme.of(context)
                                    .colorScheme
                                    .highlightColor,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 7,
                                    elevation: 0,
                                    pressedElevation: 0,
                                    disabledThumbRadius: 7),

                                overlayColor: Colors.transparent,
                                // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              ),
                              child: Slider(
                                mouseCursor: SystemMouseCursors.resizeUpDown,

                                value: widget.controller.value.volume * 100,
                                min: 0,
                                max: 100,
                                //divisions: 20,
                                //label: (widget.controller!.value.volume * 100).round().toString(),
                                onChanged: (double value) {
                                  if (mounted) {
                                    setState(() {
                                      widget.controller.setVolume(value / 100);
                                    });
                                  }

                                  if (!_showMenu) {
                                    if (mounted) {
                                      setState(() {
                                        _showMenu = true;
                                        print("_showMenu set to true");
                                      });
                                    }

                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      if (_showMenu) {
                                        if (mounted) {
                                          setState(() {
                                            _showMenu = false;
                                            print("_showMenu set to false");
                                          });
                                        }
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          MaterialButton(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            minWidth: 0,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _firtTimeExternAccess = false;
                              if (widget.controller.value.isPlaying) {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.pause();
                                    print("paused");
                                  });
                                }
                              } else {
                                // If the video is paused, play it.
                                if (mounted) {
                                  setState(() {
                                    widget.controller.play();
                                    print("playing");
                                  });
                                }
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPlayerIconBackgroundColor
                                      .withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    widget.controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 32,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .highlightColor,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          MaterialButton(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            minWidth: 0,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              if (widget.controller.value.isPlaying) {
                                if (mounted) {
                                  setState(() {
                                    widget.controller.pause();
                                    print("paused");
                                  });
                                }
                              } else {
                                // If the video is paused, play it.
                                if (mounted) {
                                  setState(() {
                                    widget.controller.play();
                                    print("playing");
                                  });
                                }
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPlayerIconBackgroundColor
                                      .withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.skip_next,
                                    size: 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .highlightColor,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Video Position
                          Text(widget.controller.value.position.inSeconds
                              .toString()),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 15,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                                child: VideoProgressIndicator(
                                  widget.controller,
                                  colors: VideoProgressColors(
                                      playedColor: Theme.of(context)
                                          .colorScheme
                                          .highlightColor,
                                      bufferedColor: Theme.of(context)
                                          .colorScheme
                                          .videoPlayerIconBackgroundColor
                                          .withOpacity(0.6),
                                      backgroundColor: Colors.grey),
                                  allowScrubbing: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Show Qualities Button
                          MaterialButton(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            minWidth: 0,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _firtTimeExternAccess = false;
                                  _showQuality = !_showQuality;
                                  _showMenu = true;
                                });
                              }

                              EasyDebounce.debounce(
                                  'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
                                  const Duration(
                                      seconds: 5), // <-- The debounce duration
                                  () {
                                if (_showMenu) {
                                  if (mounted) {
                                    setState(() {
                                      _firtTimeExternAccess = false;
                                      _showMenu = false;
                                      _showQuality = false;
                                      print("_showMenu set to false");
                                    });
                                  }
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPlayerIconBackgroundColor
                                      .withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.settings,
                                    size: 28,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .highlightColor,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Fullscreen Button Normal PLayer
                          MaterialButton(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            minWidth: 0,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              //TODO Handle in Parent
                              // if (!_isFullScreen) {
                              //   if (mounted) {
                              //     setState(() {
                              //       _isFullScreen = true;
                              //       goFullScreen();
                              //     });
                              //   }
                              // } else {
                              //   if (mounted) {
                              //     setState(() {
                              //       _isFullScreen = false;
                              //       exitFullScreen();
                              //     });
                              //   }
                              // }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .videoPlayerIconBackgroundColor
                                      .withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.fullscreen,
                                    size: 32,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .highlightColor,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      )
                    ],
                  )
                : const SizedBox(),
            //FirstTimeExternAccess
            _firtTimeExternAccess
                ? Center(
                    child: MaterialButton(
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      minWidth: 0,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        _firtTimeExternAccess = false;
                        if (widget.controller.value.isPlaying) {
                          if (mounted) {
                            setState(() {
                              widget.controller.pause();
                              print("paused");
                            });
                          }
                        } else {
                          // If the video is paused, play it.
                          if (mounted) {
                            setState(() {
                              widget.controller.play();
                              print("playing");
                            });
                          }
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context)
                                .colorScheme
                                .videoPlayerIconBackgroundColor
                                .withOpacity(0.6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.play_arrow,
                              size: 128,
                              color:
                                  Theme.of(context).colorScheme.highlightColor,
                            ),
                          )),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  // Widget videoPlayerKeyboardListener(Widget child) {
  //   // return KeyboardListener(focusNode: focusNode, child: child);
  //   return KeyboardListener(
  //       autofocus: true,
  //       focusNode: focusNode,
  //       onKeyEvent: (event) {
  //         print("EVENT");
  //         if (event is KeyDownEvent) {
  //           // if(event.physicalKey)
  //           // print("Physical: " + event.physicalKey.toString());
  //           // print("Logical: " + event.logicalKey.toString());
  //           // print("Character: " + event.character.toString());

  //           // prevent from writing comment
  //           if (event.logicalKey.keyLabel == 'F') {
  //             print("F pressed");
  //             if (_isFullScreen) {
  //               exitFullScreen();
  //               setState(() {
  //                 _isFullScreen = false;
  //               });
  //             } else {
  //               goFullScreen();
  //               setState(() {
  //                 _isFullScreen = true;
  //               });
  //             }
  //           } else if (event.logicalKey.keyLabel == ' ') {
  //             print("Space pressed");
  //             if (_controller.value.isPlaying) {
  //               if (mounted) {
  //                 setState(() {
  //                   _controller.pause();
  //                   print("paused");

  //                   _showMenu = true;
  //                   print("_showMenu set to true");
  //                 });
  //               }

  //               EasyDebounce.debounce(
  //                   'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
  //                   const Duration(seconds: 2), // <-- The debounce duration
  //                   () {
  //                 if (_showMenu) {
  //                   if (mounted) {
  //                     setState(() {
  //                       _showMenu = false;
  //                       _showQuality = false;
  //                       print("_showMenu set to false");
  //                     });
  //                   }
  //                 }
  //               }); // <-- The target method

  //             } else {
  //               // If the video is paused, play it.
  //               if (mounted) {
  //                 setState(() {
  //                   _controller.play();
  //                   print("playing");

  //                   _showMenu = true;
  //                   print("_showMenu set to true");
  //                 });
  //               }

  //               EasyDebounce.debounce(
  //                   'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
  //                   const Duration(seconds: 2), // <-- The debounce duration
  //                   () {
  //                 if (_showMenu) {
  //                   if (mounted) {
  //                     setState(() {
  //                       _showMenu = false;
  //                       _showQuality = false;
  //                       print("_showMenu set to false");
  //                     });
  //                   }
  //                 }
  //               }); // <-- The target method

  //             }
  //           } else if (event.logicalKey.keyLabel == 'Escape') {
  //             print("Escape");
  //             // if (!document.documentElement!.webkitIsFullScreen &&
  //             //     !document.mozFullScreen &&
  //             //     !document.msFullscreenElement) {}
  //             // document.onFullscreenChange.
  //             if (_isFullScreen) {
  //               setState(() {
  //                 _isFullScreen = false;
  //               });
  //               exitFullScreen();
  //             }
  //           }
  //         }
  //       },
  //       child: MouseRegion(
  //           cursor:
  //               _showMenu ? SystemMouseCursors.basic : SystemMouseCursors.none,
  //           //On Player Exit
  //           onExit: (PointerExitEvent event) {
  //             if (_showMenu) {
  //               EasyDebounce.debounce(
  //                   'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
  //                   const Duration(seconds: 2), // <-- The debounce duration
  //                   () {
  //                 if (_showMenu) {
  //                   if (mounted) {
  //                     setState(() {
  //                       _showMenu = false;
  //                       _showQuality = false;
  //                       print("_showMenu set to false");
  //                     });
  //                   }
  //                 }
  //               });
  //             }
  //           },
  //           onEnter: (PointerEnterEvent event) {
  //             focusNode.requestFocus();
  //             if (!_showMenu) {
  //               if (mounted) {
  //                 setState(() {
  //                   _showMenu = true;
  //                   print("_showMenu set to true");
  //                 });
  //               }

  //               EasyDebounce.debounce(
  //                   'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
  //                   const Duration(seconds: 5), // <-- The debounce duration
  //                   () {
  //                 if (_showMenu) {
  //                   if (mounted) {
  //                     setState(() {
  //                       _showMenu = false;
  //                       _showQuality = false;
  //                       print("_showMenu set to false");
  //                     });
  //                   }
  //                 }
  //               }); // <-- The target method
  //             }
  //           },
  //           onHover: (PointerHoverEvent event) {
  //             if (!_showMenu) {
  //               if (mounted) {
  //                 setState(() {
  //                   _showMenu = true;
  //                   print("_showMenu set to true");
  //                 });
  //               }

  //               EasyDebounce.debounce(
  //                   'showMenuTextField-debouncer', // <-- An ID for this particular debouncer
  //                   const Duration(seconds: 7), // <-- The debounce duration
  //                   () {
  //                 if (_showMenu) {
  //                   if (mounted) {
  //                     setState(() {
  //                       _showMenu = false;
  //                       _showQuality = false;
  //                       print("_showMenu set to false");
  //                     });
  //                   }
  //                 }
  //               }); // <-- The target method
  //             }
  //           },
  //           child: child));
  // }
}
