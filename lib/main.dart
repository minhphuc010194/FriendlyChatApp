import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
      .copyWith(secondary: Colors.orangeAccent[400]),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FriendlyChatApp();
  }
}

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration:
                  Theme.of(context).platform == TargetPlatform.iOS // NEW
                      ? BoxDecoration(
                          // NEW
                          border: Border(
                            // NEW
                            top: BorderSide(color: Colors.grey[200]!), // NEW
                          ), // NEW
                        ) // NEW
                      : null,
              child: _buildTextcomposer(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextcomposer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoButton(
                    // NEW
                    child: const Text('Send'), // NEW
                    onPressed: _isComposing // NEW
                        ? () => _handleSubmitted(_textController.text) // NEW
                        : null,
                  )
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                  ),
          )
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  // const ChatMessage({Key? key}) : super(key: key);
  const ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    String _name = 'Bum';
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

