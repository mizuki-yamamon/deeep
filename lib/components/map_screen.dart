import 'dart:async';

import 'package:deep/components/gridtile.dart';
import 'package:deep/components/todo_list/mandala_grid.dart';
import 'package:deep/models/todo.dart';
import 'package:deep/models/todo_data.dart';
import 'package:deep/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final TodoBloc? bloc;
  final List<Todo>? alltodos;
  MapScreen({Key? key, @required this.bloc, @required this.alltodos})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double mediaWidth = 80;
  double scaleWidthFactor = 1;

  double minWidth = 40;
  double maxWidth = 160;
  Offset? position;
  String _taptag = 'aaa';
  String _tapid = 'aaa';
  GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoData>(builder: (context, model, child) {
      return StreamBuilder<List<Todo>>(
          stream: widget.bloc!.todoStream,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              List<Todo> _allList = snapshot.data!;

              List<Todo> _todoList = snapshot.data!
                  .where((element) => element.tag == 'Todo')
                  .toList();
              // _todoList.where((element) => element.tag == 'Todo').toList();
              _todoList.sort((a, b) => a.number!.compareTo(b.number!));
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  backgroundColor: Colors.grey[100],
                  centerTitle: true,
                  elevation: 0.0,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
                ),
                body: Center(
                  child: InteractiveViewer(
                    alignPanAxis: false,
                    constrained: false,
                    panEnabled: true,
                    scaleEnabled: true,
                    boundaryMargin: EdgeInsets.all(2560.0),

                    //boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.01,
                    maxScale: 10,
                    onInteractionStart: (details) =>
                        print('onInteractionStart: ' + details.toString()),
                    onInteractionEnd: (details) {
                      print('onInteractionEnd: ' + details.toString());
                      setState(() {
                        // コメントを外すと、操作後に初期位置に戻る
                        //_transformationController.value = Matrix4.identity();
                      });
                    },

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: _todoList.asMap().keys.toList().map((index) {
                        return _cells(
                            model, index, _todoList[index], _allList, 0
                            // ),
                            );
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
    });
  }

  Widget _cells(
    TodoData model,
    int index,
    Todo _todo,
    List<Todo> _allTodo,
    double height,
  ) {
    int length = 0;
    double length2 = 0;
    List<double> distance = [];
    List<Todo> _todoList = _allTodo
        .where((element) => element.tag == _todo.tag! + _todo.id!)
        .toList();
    print(_todo.tag);

    List<Todo> _tree = _allTodo
        .where((element) => element.tag!.contains(_todo.tag! + _todo.id!))
        .toList();
    print('_tree');

    _tree.forEach((e1) {
      if (_tree
              .where((element) => element.tag!.contains((e1.tag! + e1.id!)))
              .length ==
          0) {
        length++;
      }
    });
    _todoList.forEach((element2) {
      double length3 = 0;
      List<Todo> _tree2 = _allTodo
          .where(
              (element) => element.tag!.contains(element2.tag! + element2.id!))
          .toList();
      print('_tree');
      _tree2.forEach((e1) {
        if (_tree
                .where((element) => element.tag!.contains((e1.tag! + e1.id!)))
                .length ==
            0) {
          length2++;
          length3++;
        }
      });
      print('_tree!!');
      if (length3 == 0) {
        length2++;
        length3++;
      }
      if (distance.isEmpty) {
        distance.add(length3 / 2);
      } else {
        distance.add(length2 - (length3 / 2));
      }

      // print(distance);
    });

    print('ここ2！');
    print(length);
    print(distance);

    // if (_todoList.isNotEmpty) {
    return Padding(
        padding: _todo.tag == 'Todo'
            ? const EdgeInsets.all(70.0)
            : const EdgeInsets.all(0.0),
        // child: Container(
        //   margin: const EdgeInsets.all(15.0),
        //   padding: const EdgeInsets.all(3.0),
        //   decoration: BoxDecoration(
        //     color: Colors.blue.withOpacity(0.1),
        //     borderRadius: BorderRadius.all(Radius.circular(50)),
        //     //border: Border.all(color: Colors.blueAccent)
        //   ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _card(model, index, _todo, height),
            _todoList.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _todoList.asMap().keys.toList().map((index) {
                      return _cells(
                        model,
                        index,
                        _todoList[index],
                        _allTodo,
                        (length / 2 - distance[index]) * 150,
                      );
                    }).toList())
                : Container()
          ],
          // ),
        ));
  }

  // Offset calculateSizeAndPosition() {
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     final RenderBox box =
  //         keyText.currentContext!.findRenderObject() as RenderBox;

  //     setState(() {
  //       position = box.localToGlobal(Offset.zero);
  //     });
  //   });
  //   return position!;
  // }

  Widget _card(TodoData model, int index, Todo _todo,
      double height //containerKey,containerRect,
      ) {
    GlobalKey widgetKey = GlobalKey();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _todo.tag == 'Todo'
            ? Container()
            : CustomPaint(
                size: Size(75, 0), //child:や親ウィジェットがない場合はここでサイズを指定できる
                painter: LinePainter(
                  height: height,
                )),
        Container(
          key: widgetKey,
          width: 150,
          height: 150,
          child: InkWell(
            onTap: () {
              model.updateTodo(_todo);
              model.updatePreTodo(_todo);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MandalaGridScreen(
                    // todo: todo,
                    layer: 1, bloc: widget.bloc!,
                    //問題をtitleかtagsで分けるため
                  ),
                ),
              );
              model.notify();
            },
            onLongPress: () {
              setState(() {
                _tapid = _todo.id!;
                _taptag = _todo.tag! + _todo.id!;
              });
            },
            child: Card(
              color: _todo.tag!.contains(_taptag) || _todo.id == _tapid
                  ? Colors.blue
                  : Colors.white,
              child: Center(
                child: new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Text(
                    _todo.title!,
                    //"ウィジェットの位置 :${_key.currentContext!.findRenderObject() as RenderBox}",
                    // widgetKey.currentContext!.findRenderObject().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            _todo.tag!.contains(_taptag) || _todo.id == _tapid
                                ? Colors.white
                                : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  final double? height;
  final double? width;
  final double? path;

  LinePainter({this.height, this.width, this.path});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    //  Paint paint = Paint()
    // ..color = Colors.red
    // ..style = PaintingStyle.stroke
    // ..strokeWidth = 8.0;

    Path path = Path();
    path.moveTo(0, height!);
    path.quadraticBezierTo(
        size.width / 3, height!, size.width / 2, height! / 2);
    path.quadraticBezierTo((size.width * 2) / 3, 0, size.width, 0);
    canvas.drawPath(path, paint);

    // canvas.drawLine(
    //   Offset(size.width * 1, 0),
    //   Offset(0, height!),
    //   paint,
    // );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
