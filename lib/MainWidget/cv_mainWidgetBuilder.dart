import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ly_cocoapods_visualtool/BlackPage/cv_black.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_fileHandler.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_fileStoreTool.dart';
import 'package:ly_cocoapods_visualtool/FileHandler/cv_scriptHandler.dart';
import 'package:ly_cocoapods_visualtool/Items/cv_mainListItem.dart';
import 'package:ly_cocoapods_visualtool/Model/cv_podInfoModel.dart';
import 'package:ly_cocoapods_visualtool/Toast/cv_toast.dart';

class CVMainWidgetBuilder extends StatefulWidget {
  const CVMainWidgetBuilder({super.key});

  @override
  State<CVMainWidgetBuilder> createState() => _CVMainWidgetBuilderState();
}

class _CVMainWidgetBuilderState extends State<CVMainWidgetBuilder> {
  CVFileHandler fileHandler = CVFileHandler();
  Stream ?fileHandleStream;
  @override
  void setState(VoidCallback fn) {
    
    super.setState(fn);
  }
  @override
  void initState() {
    fileHandleStream = fileHandler.stream.stream();
    fileHandler.initDatas();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fileHandleStream,
      builder: (context, snapshot) {
        return _mainWidget(context, snapshot);
      },
    );
  }

  Widget _mainWidget(BuildContext context, AsyncSnapshot snapshot) {
    CVFileHandleResult result =  CVFileHandleResult();
    result.handleNode = HandleNode.allIncluded;
    if (snapshot.hasData) {
      result = snapshot.data;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: _settingWidget(result.handleNode!),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                EasyLoading.show(status: 'loading...');
                fileHandler.refreshFileList();
              },
            ),
          ],
          title: const Text('Pods 可视化工具'),
        ),
        body: _materialBody(context, snapshot),
        floatingActionButton: _installPodWidget(result.handleNode!),
      ),
      builder: EasyLoading.init(),
    );
  }

  Widget _materialBody(BuildContext context, AsyncSnapshot snapshot) {
    EasyLoading.dismiss();
    if (snapshot.hasData) {
      CVFileHandleResult result = snapshot.data;
      if (result.handleNode == HandleNode.noXcodeproj) {          
        return _blackWidget();
      }else if (result.handleNode == HandleNode.noPodFile) {
        return _emptyWidget();
      }else if (result.handleNode == HandleNode.allIncluded) {
        return GridView.count(
          padding: const EdgeInsets.all(20),
          childAspectRatio: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: List.generate(result.podInfoList!.length, (index) {
            CVPodInfoModel pod = result.podInfoList![index];
            return CVMainListItem(
              infoModel: pod, 
              deleteCallBack: () => _showDeletePodDialog(context, pod.name!),
              switchCallBack: () => _showVersionSwitchDialog(context, pod.name!),
              selectedCallBack: () {
                CVFileStoreTool.podDirectoryPath().then((value) {
                    String tString = '${value!}/Pods/${pod.name!}';
                    CVScriptHandler.runScript(CVScriptFunction.openFolder, null, [tString]);
                });
              },
            );
          }),
        );
      }
    }
    return CVBlack(fileHandler);
  }

  _showDeletePodDialog(BuildContext context, String podName) {
    showDialog (
      barrierDismissible: false,
      context: context,
      builder: (_) {
          return AlertDialog(
            title: const Text("确认删除当前Pod库?"),
            actions: [
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.pop(context);
                  EasyLoading.show(status: 'loading...');
                  fileHandler.deletePodLibrary(podName).then(
                    (value) {
                      EasyLoading.dismiss();
                      if (value == true) {
                        showCVToast(context, "$podName卸载成功");
                      }
                    }
                  );
                },
              ),
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  Widget _emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('还没有Pod文件', style: TextStyle(fontSize: 20),),
          TextButton(
            onPressed: () {
              CVFileHandler().createNewPodFile().then((value) {
                fileHandler.refreshFileList();
              });
            }, child: const Text('添加', style: TextStyle(fontSize: 16),))
        ],
      )
    );
  }

  Widget _blackWidget() {
    return CVBlack(fileHandler);
  }

  Widget? _settingWidget(HandleNode node) {
    if (node == HandleNode.noXcodeproj) return null;
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        _showInstallPodDialog(context);
      },
    );
  }

  Widget? _installPodWidget(HandleNode node) {
    if (node == HandleNode.noXcodeproj || node == HandleNode.noPodFile) return null;
    return FloatingActionButton(
      onPressed: () {
        _showInputDialog(context);
      },
      tooltip: '安装Pod库',
      child: const Icon(Icons.add),
    );
  }

  _showVersionSwitchDialog(BuildContext context, String podName) {
    final TextEditingController podVersionC = TextEditingController();

    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ 
              TextField(
                controller: podVersionC,
                decoration: const InputDecoration(hintText: '版本号，不指定默认用最新版本。'),
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                EasyLoading.show(status: 'loading...');
                  fileHandler.installPodLibrary(podName, podVersionC.text).then(
                    (value) {
                      EasyLoading.dismiss();
                      if (value == true) {
                        showCVToast(context, "$podName版本更新成功");
                      }
                    }
                  );
                  Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        );   
      }
    );
  }

  _showInputDialog(BuildContext context) {
    final TextEditingController podNameC = TextEditingController();
    final TextEditingController podVersionC = TextEditingController();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ 
              TextField(
                controller: podNameC,
                decoration: const InputDecoration(hintText: '输入要安装的Pod库名称'),
              ),
              TextField(
                controller: podVersionC,
                decoration: const InputDecoration(hintText: 'Pod库版本号。不指定默认用最新版本'),
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                String name = podNameC.text;
                String version = podVersionC.text;
                if (name != "") {
                  EasyLoading.show(status: 'loading...');
                  fileHandler.installPodLibrary(name, version).then(
                    (value) {
                      EasyLoading.dismiss();
                      if (value == true) {
                        showCVToast(context, "$name安装成功");
                      }
                    }
                  );
                  Navigator.pop(context);
                }
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  _showInstallPodDialog(BuildContext context) {
    fileHandler.curPodDirectoryPath().then((value) {
      showDialog (
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("当前工程目录"),
            content: SizedBox(
              width: double.infinity,
              child: Text(value as String),
            ),
            actions: [
              TextButton(
                child: const Text('更新'),
                onPressed: () {
                  CVFileHandler.chooseTargetFile().then((value) {
                    if (value != null) {
                      Navigator.pop(context);
                      EasyLoading.show(status: 'loading...');
                      fileHandler.saveFilePath(value.toString());
                    }
                  });
                },
              ),
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    });
  }
}