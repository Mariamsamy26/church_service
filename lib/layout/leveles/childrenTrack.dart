import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../model/child.dart';
import '../../shared/components/custom_Card.dart';
import '../childDetailsScreen.dart';

class ChildrenTrack extends StatefulWidget {
  final DateTime initialDay; // Initial selected day
  final Function(DateTime) onDayChanged; // Callback to notify day change
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
  late DateTime selectedDay;


  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDay;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showDatePicker();
    // });
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDay) {
      setState(() {
        selectedDay = pickedDate;
      });
      widget.onDayChanged(pickedDate); // إعلام الشاشة الرئيسية بتغيير اليوم
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the selected date and a button to show the calendar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDay)}',
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _showDatePicker,
              ),
            ],
          ),
        ),

        // List of children that match the selected date
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.childrenData?.length ?? 0,
            itemBuilder: (context, index) {
              var child = widget.childrenData?[index];
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
                          ChildDetailsScreen(childData: child),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
