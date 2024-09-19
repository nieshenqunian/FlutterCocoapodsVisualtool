import 'package:flutter/material.dart';
import 'package:ly_cocoapods_visualtool/Model/cv_podInfoModel.dart';

typedef ItemNormalCallBack = void Function();

class CVMainListItem extends StatelessWidget {
  const CVMainListItem({required this.infoModel, this.deleteCallBack, this.switchCallBack, this.selectedCallBack, super.key});
  final CVPodInfoModel infoModel; 
  final void Function()? deleteCallBack;
  final void Function()? switchCallBack;
  final void Function()? selectedCallBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        if (selectedCallBack != null) selectedCallBack!() ;
      },
      child: ItemContent(infoModel: infoModel, deleteCallBack: deleteCallBack, switchCallBack: switchCallBack,)
    );
  }
}

class ItemContent extends StatelessWidget {
  const ItemContent({
    required this.infoModel,
    this.deleteCallBack,
    this.switchCallBack,
    super.key, 
  });
  final CVPodInfoModel infoModel;
  final void Function()? deleteCallBack;
  final void Function()? switchCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            Flexible(
              child: _columnWidget(context),
            ),
            const SizedBox(width: 10,)
          ],
        ),
      );
  }

  Widget _columnWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: _nameAndVersion()),
        _address(),
        _buttons(context),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            if (deleteCallBack != null) deleteCallBack!();
          },
          child: const Text('删除', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (switchCallBack != null) switchCallBack!();
          },
          child: const Text('切换版本', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
        )
      ],
    );
  }

  Widget _address() {
    return Row(
        children: [
          Flexible(
            child: Text(
              infoModel.address!, 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
              maxLines: 1,
            ),
          )
        ],
      );
  }

  Widget _nameAndVersion() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              infoModel.name!, 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              maxLines: 1
            ),
          ),
          const SizedBox(width: 10,),
          Text(
            infoModel.version!, 
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          )
        ],
      );
  }
}