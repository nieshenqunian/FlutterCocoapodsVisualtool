enum HandleNode {
  /// 没有工程目录
  noXcodeproj,
  /// 没有PodFile文件
  noPodFile,
  /// 没有Pods文件夹
  noPodsDirectory,
  /// 都存在 
  allIncluded,
}

class CVPodInfoModel {
  String ?name;
  String ?version;
  String ?address;
  String changeVersion = '切换版本';
  String delete = '删除'; 

  // factory CVPodInfoModel.create(String name, String version, String address) {
  //   CVPodInfoModel model = CVPodInfoModel();
  //   model.name = model.cleanString(name);
  //   model.version = model.cleanString(version);
  //   model.address = model.cleanString(address);
  //   return model;
  // }

  CVPodInfoModel.fromJson(Map<String, dynamic> json) {
     name = json['name'];
     version = json['version'];
     address = json['address'] != null ? json['address'].toString() : '';
  }

  String cleanString(String str) {
    return str.replaceAll(RegExp(r'\n'), '');
  }
}

class CVFileHandleResult {
  List<CVPodInfoModel> ?podInfoList;
  HandleNode? handleNode;
}