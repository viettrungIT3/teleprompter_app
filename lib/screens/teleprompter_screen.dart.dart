import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/config.dart';
import '../utils/constants /enums.dart';

class TeleprompterScreen extends StatefulWidget {
  final String text;
  const TeleprompterScreen({
    super.key,
    required this.text,
  });

  @override
  State<TeleprompterScreen> createState() => _TeleprompterScreenState();
}

class _TeleprompterScreenState extends State<TeleprompterScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFullOverlay = false; // Full overlay status
  Offset _overlayPosition = const Offset(0, 0); // Overlay position
  Size _overlaySize = const Size(300, 200); // Overlay size
  final double _scrollSpeed = ConfigTeleprompter.defaultScrollSpeed;
  ScrollStatus _scrollStatus = ScrollStatus.initial;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFullOverlay() {
    setState(() {
      _isFullOverlay = !_isFullOverlay;
    });
  }

  void _onScrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _scrollStatus = ScrollStatus.finished;
      });
      return;
    }
    if (_scrollStatus == ScrollStatus.paused ||
        _scrollStatus == ScrollStatus.finished) {
      return;
    }
    if (_scrollStatus == ScrollStatus.scrolling) {
      _continueScroll();
    }
  }

  void _continueScroll() {
    setState(() {
      _scrollStatus = ScrollStatus.scrolling;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients &&
          _scrollController.offset <
              _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(_scrollController.offset + _scrollSpeed / 10);
      }
    });
  }

  void _stopScrolling() {
    setState(() {
      _scrollStatus = ScrollStatus.paused;
    });
  }

  void _resetAndContinueScroll() {
    setState(() {
      _scrollStatus = ScrollStatus.initial;
    });
    _scrollController.jumpTo(0);
    _continueScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teleprompter"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent),
            ),
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.background,
                ),
                Positioned(
                  top: _isFullOverlay ? 0 : _overlayPosition.dy,
                  left: _isFullOverlay ? 0 : _overlayPosition.dx,
                  width: _isFullOverlay
                      ? constraints.maxWidth
                      : _overlaySize.width,
                  height: _isFullOverlay
                      ? constraints.maxHeight
                      : _overlaySize.height,
                  child: Opacity(
                    opacity: 0.75,
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              // IconButton(
                              //   icon: const Icon(Icons.edit, color: Colors.white),
                              //   onPressed: () {
                              //     // TODO: Edit text logic
                              //   },
                              // ),
                              IconButton(
                                icon: const Icon(Icons.fullscreen,
                                    color: Colors.white),
                                onPressed: _toggleFullOverlay,
                              ),
                            ],
                          ),
                          // Scrolling Text
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Text(
                                widget.text,
                                style: const TextStyle(
                                  fontSize: 24,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: _isFullOverlay ? 0.0 : 1.0,
                                child: IconButton(
                                  onPressed: () {
                                    // TODO: Resize logic
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.resize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    _scrollStatus == ScrollStatus.scrolling
                                        ? _stopScrolling
                                        : _scrollStatus == ScrollStatus.finished
                                            ? _resetAndContinueScroll
                                            : _continueScroll,
                                icon: Icon(
                                  _scrollStatus == ScrollStatus.scrolling
                                      ? Icons.pause
                                      : _scrollStatus == ScrollStatus.finished
                                          ? Icons.replay
                                          : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              Opacity(
                                opacity: _isFullOverlay ? 0.0 : 1.0,
                                child: GestureDetector(
                                  onPanUpdate: !_isFullOverlay
                                      ? (details) {
                                          // Prevent dragging outside screen bounds
                                          final screenSize =
                                              MediaQuery.of(context).size;
                                          final newPosition =
                                              _overlayPosition + details.delta;

                                          // Check if new position would place overlay outside screen
                                          if (newPosition.dx < 0 ||
                                              newPosition.dx +
                                                      _overlaySize.width >
                                                  screenSize.width ||
                                              newPosition.dy < 0 ||
                                              newPosition.dy +
                                                      _overlaySize.height >
                                                  screenSize.height) {
                                            return;
                                          }
                                          setState(() {
                                            _overlayPosition += details.delta;
                                          });
                                        }
                                      : null,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      CupertinoIcons.move,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
