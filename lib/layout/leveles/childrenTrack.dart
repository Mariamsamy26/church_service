import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/child.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import '../../shared/style/color_manager.dart';
import '../details/childDetailsScreen.dart';

class ChildrenTrack extends StatefulWidget {
  final DateTime initialDay;
  final Function(DateTime) onDayChanged;
  final List<ChildData>? childrenData;

  const ChildrenTrack({
    super.key,
    required this.onDayChanged,
    required this.childrenData,
    required this.initialDay,
  });

  @override
  State<ChildrenTrack> createState() => _ChildrenTrackState();
}

class _ChildrenTrackState extends State<ChildrenTrack> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDay;
  }

  Future<void> _showDatePicker() async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.liteblueGray,
              onSurface: ColorManager.scondeColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.liteblueGray,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (chosenDate != null && chosenDate != selectedDate) {
      setState(() {
        selectedDate = chosenDate;
      });
      widget.onDayChanged(chosenDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.calendar_month_sharp,
                      color: ColorManager.liteblueGray,
                      size: 35,
                    ),
                    onPressed: _showDatePicker,
                  ),
                  Text(
                    '${DateFormat('dd/MM/yyyy').format(selectedDate)}  : الغياب يوم   ',
                    style: FontForm.TextStyle30bold,
                  ),
                ],
              ),
            ),
            widget.childrenData == null || widget.childrenData!.isEmpty
                ? Center(
                    child: Text(
                      "مفيش غياب اليوم ده \n😎",
                      style: FontForm.TextStyle50bold,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.childrenData!.length,
                    itemBuilder: (context, index) {
                      var child = widget.childrenData![index];
                      return CustomCardListTile(
                        profileImage: child.imgUrl.toString(),
                        name: child.name!,
                        phone: child.phone,
                        id: child.id ?? "N/A",
                        icon: Icons.info_rounded,
                        iconFunction: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChildDetailsScreen(childData: child),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
