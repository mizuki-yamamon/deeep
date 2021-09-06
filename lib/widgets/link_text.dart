import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextAtoms extends StatefulWidget {
  final String? text;
  final TextStyle? linkStyle;
  final TextStyle? textStyle;

  LinkTextAtoms({this.text, this.linkStyle, this.textStyle});

  @override
  createState() => LinkTextAtomsState();
}

class LinkTextAtomsState extends State<LinkTextAtoms> {
  List<GestureRecognizer>? recList;

  @override
  Widget build(BuildContext context) {
    // 通常のテキストデフォルトスタイル
    TextStyle text =
        Theme.of(context).textTheme.bodyText1!.merge(widget.textStyle);
    // リンク時のテキストデフォルトスタイル
    TextStyle link = Theme.of(context)
        .textTheme
        .bodyText1!
        .merge(TextStyle(
            inherit: true,
            color: Colors.blue,
            decoration: TextDecoration.underline))
        .merge(widget.linkStyle);

    List<TextSpan> children = [];
    List matches = RegExp(
            r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?")
        .allMatches(widget.text!)
        .toList();
    List<TextSpan> links = matches.map<TextSpan>((m) {
      // GestureRecognizer rec = TapGestureRecognizer()
      //   ..onTap = () async {
      //     print('aaaaa');
      //     // URL を処理できるアプリケーションが存在しない可能性があるためcanLaunchメソッドで処理可能かどうかチェックし、OK の場合のみlaunch()メソッドを呼ぶようにする
      //     // if (await canLaunch(m.group(0))) {
      //     //   await launch(m.group(0), forceSafariVC: false);
      //     // }
      //   };
      // recList!.add(rec);
      return TextSpan(
          text: m.group(0),
          style: link,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              //URL を処理できるアプリケーションが存在しない可能性があるためcanLaunchメソッドで処理可能かどうかチェックし、OK の場合のみlaunch()メソッドを呼ぶようにする
              if (await canLaunch(m.group(0))) {
                await launch(m.group(0), forceSafariVC: false);
              } else {
                print("error");
              }
            });
    }).toList();
    if (matches.length > 0) {
      for (var i = 0; i < matches.length; i++) {
        if (i == 0) {
          if (matches[i].start != 0) {
            children.add(TextSpan(
                text: widget.text!.substring(0, matches[i].start),
                style: text));
          }
          children.add(links[i]);
          continue;
        }
        children.add(TextSpan(
            text: widget.text!.substring(matches[i - 1].end, matches[i].start),
            style: text));
        children.add(links[i]);
      }
      if (matches.last.end != widget.text!.length) {
        children.add(TextSpan(
            text: widget.text!.substring(matches.last.end), style: text));
      }
    } else {
      children.add(TextSpan(text: widget.text, style: text));
    }
    return RichText(text: TextSpan(children: children));
  }

  // @override
  // dispose() {
  //   for (int i = recList!.length - 1; i >= 0; i--) {
  //     recList!.removeAt(i);
  //   }
  //   super.dispose();
  // }
}
