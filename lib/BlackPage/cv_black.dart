import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_fileHandler.dart';
import 'package:ly_cocoapods_visualtool/Toast/cv_toast.dart';

const String selectBtnText = '选   取';
const String blackPromptText = '选取或者直接拖入工程目录';
const String dragImportFileError = '暂不支持多文路径添加！';

class CVBlack extends StatelessWidget {
  CVBlack(this.fileHandler, {super.key});
  final CVFileHandler fileHandler;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        DropTarget(
          onDragDone: (details) {
            if (details.files.length > 1) {
              showCVToast(context, dragImportFileError);
              return;
            }
            XFile detail = details.files.first;
            _saveFile(detail.path);
          },
          onDragEntered: (details) {
            print('$details');
          },
          onDragExited: (details) {
            print('$details');
          },
          child: Container(
            color: Colors.white,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue)),
              onPressed: () {
                getDirectoryPath().then((value) {
                  _saveFile(value);
                });
              },
              child: const Text(selectBtnText, style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20,),
            const Text(blackPromptText)
          ],
        ),
      ],
      );
  }

  _saveFile(String? path) {
    fileHandler.saveFilePath(path);
  }

}