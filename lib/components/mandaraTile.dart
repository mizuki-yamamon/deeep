// import 'package:deep/components/todo_edit/todo_edit_view.dart';
// import 'package:deep/components/todo_list/layer_view.dart';
// import 'package:deep/components/todo_list/mandala_grid.dart';
// import 'package:deep/models/todo.dart';
// import 'package:deep/repositories/todo_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MandaraTiles extends StatelessWidget {
//   final Todo todo;
//   final List<Todo> todos;
//   // final List<Todo> allTodos;
//   final int index;

//   MandaraTiles(
//     Key key,
//     this.todo,
//     this.todos,
//     // this.allTodos,
//     this.index,
//   ) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _bloc = Provider.of<TodoBloc>(context, listen: false);
//     return Hero(
//       tag: 'tag' + todo.id!,
//       child: new Card(
//         color: index == 4 ? Colors.blue : Colors.white,
//         child: new InkWell(
//           // onForcePressStart: (a) {
//           //   Provider.of<TriggerData>(context, listen: false).trigger = true;
//           // },
//           // onLongPressEnd: (a) {
//           //   Provider.of<TriggerData>(context, listen: false).trigger = false;
//           // },

//           onDoubleTap: () {
//             print(todo.number);
//             print(todo.tag);

//             if (todo.title!.isEmpty) {
//               showModalBottomSheet(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(20.0),
//                           topLeft: Radius.circular(20.0))),
//                   backgroundColor: Colors.white,
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) {
//                     return TodoEditView(
//                       number: todo.number,
//                       //todoList: todos,
//                       todoBloc: _bloc,
//                       todo: todo,
//                       label: todo.tag,
//                     );
//                   });

//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) => TodoEditView(
//               //               number: todo.number,
//               //               //todoList: todos,
//               //               todoBloc: _bloc,
//               //               todo: todo,
//               //               label: todo.tag,
//               //             )));
//             } else if (index == 4) {
//               Navigator.pop(context);
//             } else {
//               if (todo.model == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => LayerView(
//                       todo: todo, layer: 1, // bloc: _bloc,
//                       //問題をtitleかtagsで分けるため
//                     ),
//                   ),
//                 );
//               } else if (todo.model == 1) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => MandalaGridScreen(
//                       todo: todo, layer: 1, bloc: _bloc,
//                       //問題をtitleかtagsで分けるため
//                     ),
//                   ),
//                 );
//               }
//               //
//             }

//             // }
//           },
//           onTap: () {
//             print(todo.number);
//             showModalBottomSheet(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(20.0),
//                         topLeft: Radius.circular(20.0))),
//                 backgroundColor: Colors.white,
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (context) {
//                   return TodoEditView(
//                     number: todo.number,
//                     //todoList: todos,
//                     todoBloc: _bloc,
//                     todo: todo,
//                     label: todo.tag,
//                   );
//                 });
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) => TodoEditView(
//             //               number: todo.number,
//             //               //todoList: todos,
//             //               todoBloc: _bloc,
//             //               todo: todo,
//             //               label: todo.tag,
//             //             )));
//           },
//           child: new Center(
//             child: new Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: new Text(
//                   todo.title!,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: index == 4 ? Colors.white : Colors.black),
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
// }
