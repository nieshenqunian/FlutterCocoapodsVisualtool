import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_fileHandle_stream.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_fileStoreTool.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_scriptHandler.dart';
import 'package:ly_cocoapods_visualtool/Model/cv_podInfoModel.dart';
import 'package:path/path.dart' as p;        


class CVFileHandler {
  CVFileHandleStream stream = CVFileHandleStream();
  initDatas() async {
    String? path = await curPodDirectoryPath();
    _handleFilePath(path);
  }

  static Future<String?> chooseTargetFile() {
    return getDirectoryPath();
  }

  Future<String?> curPodDirectoryPath() async {
    return await CVFileStoreTool.podDirectoryPath();
  }

  refreshFileList() async {
    String? path = await curPodDirectoryPath();
    _handleFilePath(path);
  }

  saveFilePath(String? path) async {
    if (path == null || path == "") return false;
    await CVFileStoreTool.savePodDirectoryPath(path);
    _handleFilePath(path);
  }

  Future<bool> deletePodLibrary(String podName) async {
    String? path = await curPodDirectoryPath();
    String rString = await CVScriptHandler.runScript(CVScriptFunction.deletePod, null, [path!, podName]);
    if (rString == "1") {
      refreshFileList();
      return true;
    }
    return false;
  }

  Future<bool> installPodLibrary(String podName, String podVersion) async {
    String? path = await curPodDirectoryPath();
    String rString = await CVScriptHandler.runScript(CVScriptFunction.installPod, null, [path!, podName, podVersion]);
    if (rString == "1") {
      refreshFileList();
      return true;
    }
    return false;
  }

  _handleFilePath(String ?path) async {
    if (path == null) {
      stream.emptyFileStream();
      return;
    }
    HandleNode handleNode = await _directoryHandleStream(path);
    if (handleNode == HandleNode.allIncluded) {
      String rString = await CVScriptHandler.runScript(CVScriptFunction.requestPodInfo, null, [path]);
      final jsonResponse = json.decode(rString);
      List<CVPodInfoModel> list = jsonResponse.map<CVPodInfoModel>((i) => CVPodInfoModel.fromJson(i)).toList();
      stream.podListStream(list);
    }else {
      stream.emptyPodFile(handleNode);
    }
  }


  Future<Stream<HandleNode>> handleFileDirectory(String? path) async {
    Stream<HandleNode> handleStream = Stream.fromFuture(_directoryHandleStream(path));
    return handleStream;
  }

  Future<bool> createNewPodFile() async {
    String? path = await curPodDirectoryPath();
    await CVScriptHandler.runScript(CVScriptFunction.createPodFile, null, [path!]);
    return true;
  }

  Future<HandleNode> _directoryHandleStream(String? path) async {
    if (path == null || await _findTargetFile(path, '.xcodeproj') == false) return HandleNode.noXcodeproj;
    if (await _findTargetDocument(path, 'Podfile') == false) return HandleNode.noPodFile;
    if (await _findTargetDocument(path, 'Pods') == false) return HandleNode.noPodsDirectory;
    return HandleNode.allIncluded;
  }

  Future<bool> _findTargetFile(String path, String target) async {
    Stream<FileSystemEntity> fileList = Directory(path).list();
    await for(FileSystemEntity file in fileList) {
      if (target == p.extension(file.path)) return true;
    }
    return false;
  }

  Future<bool> _findTargetDocument(String path, String target) async {
    Stream<FileSystemEntity> fileList = Directory(path).list();
    await for(FileSystemEntity file in fileList) {
      List<String> segList = file.uri.pathSegments;
      String lastObj = segList.last;
      if (lastObj == '' && segList.length > 1) lastObj = segList[segList.length - 2];
      if (lastObj == target) return true;
    }
    return false;
  }
  
}


