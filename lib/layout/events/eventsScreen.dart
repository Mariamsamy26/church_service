import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/event.dart';
import '../../shared/firebase/firebase_function.dart';
import '../../shared/components/appBar.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import 'addEventDialog.dart';
import 'camingScreen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    List<EventModel> fetchedEvents = await FirebaseService.getEvents();
    setState(() {
      events = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: 'أنشطة',
        iconApp: Icons.add,
        onPressedApp: () async {
          bool? added = await AddEventDialog.show(context);
          if (added == true) {
            loadEvents();
          }
        },
      ),
      body: events.isEmpty
          ? const Center(child: Text("لا توجد أحداث متاحة"))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                EventModel event = events[index];
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(event.date);
                return CustomCardListTile(
                  name: event.name,
                  subtitleData: formattedDate,
                  numCH: event.children.length,
                  icon: Icons.info,
                  iconFunction: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //   builder: (context) => CamingScreen(
                    //     event: event,
                    //     allChildren: FirebaseService().getAllChildren(),
                    //   ),
                    // ),
                    // );
                  },
                  showImage: false,
                  id: event.id,
                );
              },
            ),
    );
  }
}
