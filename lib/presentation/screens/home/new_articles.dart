import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logss/presentation/blocs/Crud/crud_bloc.dart';
import 'package:logss/common/constants/color.dart';
import 'package:logss/common/constants/style.dart';
import 'package:logss/domain/model/user_details.dart';

class AddNotes extends StatelessWidget {
  final String? title;
  final String? content;
  final String? id;
  final String? imagePath;
  final bool isUpdate;
  const AddNotes(
      {this.title,
      this.content,
      this.id,
      this.imagePath,
      required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CrudBloc(),
      child: AddArticless(
        title: title,
        content: content,
        isUpdate: isUpdate,
        id: id,
        image: imagePath,
      ),
    );
  }
}

class AddArticless extends StatefulWidget {
  final String? title;
  final String? content;
  final String? id;
  final String? image;
  final bool isUpdate;
  const AddArticless({
    this.content,
    this.title,
    this.id,
    this.image,
    required this.isUpdate,
  });

  @override
  _AddArticlessState createState() => _AddArticlessState();
}

class _AddArticlessState extends State<AddArticless> {
  late final _titleController;
  late final _contentController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(ColorConstants.kBackgroundColor),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        backgroundColor: const Color(ColorConstants.kBackgroundColor),
        elevation: 0,
        title: widget.isUpdate ? Text("Update Articles") : Text("Add Articles"),
        actions: [
          if (!widget.isUpdate)
            IconButton(
              onPressed: () {
                BlocProvider.of<CrudBloc>(context).add(GetImage());
              },
              icon: const Icon(
                Icons.image,
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      cursorColor: Colors.pink,
                      style: StyleConstants.kTextStyle,
                      decoration: StyleConstants.kInput("Articles Titles"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: StyleConstants.kTextStyle,
                  cursorColor: Colors.pink,
                  decoration: StyleConstants.kInput("Articles Body"),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CrudBloc, CrudState>(
                builder: (context, state) {
                  if (state is CrudImage) {
                    var path = state.file;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: FileImage(path),
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        // Positioned(
                        //   top: 5,
                        //   right: 5,
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       FontAwesomeIcons.timesCircle,
                        //       size: 28,
                        //       color: Colors.white54,
                        //     ),
                        //   ),
                        // )
                      ],
                    );
                  } else if (state is CrudError) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<CrudBloc, CrudState>(
                builder: (context, state) {
                  if (state is CrudLoading) {
                    return StyleConstants.kLoadingButton();
                  } else if (state is CrudSuccess) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: StyleConstants.kButtonStyle,
                      onPressed: () {
                        if (_titleController.text.isEmpty ||
                            _contentController.text.isEmpty) {
                          return null;
                        } else {
                          var _bloc = BlocProvider.of<CrudBloc>(context);
                          widget.isUpdate
                              ? _bloc.add(
                                  UpdateArticles(
                                    authCredentials: AuthCredentials(
                                      title: _titleController.text,
                                      time: DateTime.now().toString(),
                                      content: _contentController.text,
                                      id: widget.id!,
                                      image: widget.image!,
                                    ),
                                  ),
                                )
                              : _bloc.add(
                                  AddArticles(
                                    authCredentials: AuthCredentials(
                                      title: _titleController.text,
                                      time: DateTime.now().toString(),
                                      content: _contentController.text,
                                    ),
                                  ),
                                );
                        }
                      },
                      child: StyleConstants.kButtonText(
                        widget.isUpdate ? "Update Articles" : "Add Articles",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
