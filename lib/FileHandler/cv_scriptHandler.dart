import 'dart:ffi';
import 'dart:io';

enum CVScriptFunction {
  /// 打开文件夹
  openFolder,
  /// 创建PodFile
  createPodFile,
  /// 安装Pod
  installPod,
  /// 获取Pod信息
  requestPodInfo,
  /// 删除Pod
  deletePod
}

class CVScriptHandler {
  static Future<String> runScript(CVScriptFunction function, String? workingDirectory, List<String> params) async {
    workingDirectory = workingDirectory ?? '${Directory.current.path}/script'; 
    ProcessResult result = await Process.run(_scripts[function]!, params, runInShell: true, workingDirectory:workingDirectory);
    String rString = result.stdout;
    _logoutResult(result);
    return rString;
  }
  static _logoutResult(ProcessResult result) {
      print('Exit code: ${result.exitCode}');
      print('STDOUT: ${result.stdout}');
      print('STDERR: ${result.stderr}');
  }
  static final Map<CVScriptFunction, String> _scripts = {
    CVScriptFunction.openFolder: './cvOpenFIle.sh',
    CVScriptFunction.createPodFile: './cvPodinit.sh',
    CVScriptFunction.installPod: './cvInstallPod.sh',
    CVScriptFunction.requestPodInfo: './cvGetPodInfo.sh',
    CVScriptFunction.deletePod: './cvDeletePod.sh'
  };

}