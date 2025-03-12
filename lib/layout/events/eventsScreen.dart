import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/childEvent.dart';
import '../../model/event.dart';
import '../../shared/components/custem_showDialog.dart';
import '../../shared/firebase/firebase_function.dart';
import '../../shared/components/appBar.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import 'addEventDialog.dart';
import 'camingScreen.dart';
import 'selectedToCamingScreen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventModel> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      List<EventModel> fetchedEvents = await FirebaseService.getEvents();
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading events: $e');
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
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
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return CustomShowDialog(
                              title: event.name,
                              firstText: 'عيالنا',
                              secondText: 'الي جاي ',
                              frisIcon: Icons.group_add_rounded,
                              secIcon: Icons.group,
                              onFirstPressed: () async {
                                Navigator.pop(context);
                                // الانتظار حتى تنتهي العملية في SelectedToCamingScreen
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedToCamingScreen(
                                      event: event,
                                      allChildrenStream:
                                          FirebaseService().getAllChildren(),
                                    ),
                                  ),
                                );
                                loadEvents();
                              },
                              onSecondPressed: () async {
                                Navigator.pop(context);
                                try {
                                  List<ChildEvent> children =
                                      await FirebaseService.getChildrenInEvent(
                                          event.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CamingScreen(
                                        event: event,
                                        CamingChildrenStream: children,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'حدث خطأ أثناء تحميل الأطفال: $e')),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                      showImage: false,
                      id: event.id,
                    );
                  },
                ),
    );
  }
}
