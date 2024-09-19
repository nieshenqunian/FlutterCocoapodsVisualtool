import 'dart:async';
import 'package:ly_cocoapods_visualtool/Model/cv_podInfoModel.dart';

class CVFileHandleStream {
  StreamController<CVFileHandleResult> controller = StreamController<CVFileHandleResult>();

  Stream stream() {
    return controller.stream;
  }

  emptyFileStream() {
    CVFileHandleResult result = _handleResult(HandleNode.noXcodeproj);
    next(result);
  }

  emptyPodFile(HandleNode node) {
    CVFileHandleResult result = _handleResult(node);
    next(result);
  }

  podListStream(List<CVPodInfoModel> podsList) {
    CVFileHandleResult result = _handleResult(HandleNode.allIncluded);
    result.podInfoList = podsList;
    next(result);
  }

  next(CVFileHandleResult result) {
    controller.sink.add(result);
  }
  
  close() {
    controller.sink.close();
  }

  nextError(Error error) {
    controller.sink.addError(error);
  }

  CVFileHandleResult _handleResult(HandleNode node) {
    CVFileHandleResult result = CVFileHandleResult();
    result.handleNode = node;
    return result;
  }
}