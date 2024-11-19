import 'package:flutter/material.dart';

import '../../model/child.dart';
import '../../shared/components/custom_Card.dart';
import '../details/childDetailsScreen.dart';
class ChildrenFind extends StatelessWidget {
  final List<ChildData>? childrenData;

  const ChildrenFind({Key? key, required this.childrenData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: childrenData?.length,
      itemBuilder: (context, index) {
        var child = childrenData?[index];
        return CustomCard(
            profileImage: child!.imgUrl.toString(),
            name: child.name!,
            phone: child.phone,
            id: child.id ?? "N/A",
            icon: Icons.info_rounded,
            iconFunction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        ChildDetailsScreen(childData: child)),
              );
            });
      },
    );
  }
}
