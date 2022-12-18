import 'package:flutter/material.dart';
import 'package:mingle/themes.dart';

class SendMessageWidget extends StatelessWidget {
  final VoidCallback? onSend;

  final TextEditingController _textController;
  const SendMessageWidget({
    Key? key,
    this.onSend,
    required TextEditingController textController,
  })  : _textController = textController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 20,
              ),
              child: TextFormField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableIMEPersonalizedLearning: true,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusColor: MingleTheme.whiteShade1,
                  fillColor: MingleTheme.whiteShade1,
                  alignLabelWithHint: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.insert_emoticon),
                    splashRadius: 10,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onSend,
            child: CircleAvatar(
              backgroundColor: MingleTheme.lightBlueShade,
              radius: 22.0,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
