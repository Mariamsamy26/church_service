import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../../model/PaymentInstallment.dart';
import '../../model/child.dart';
import '../../model/childEvent.dart';
import '../../model/event.dart';

class FirebaseService {
  Map<int, List<ChildData>> childrenByLevel = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add child data to Firestore
  Future<void> addChildData(ChildData childModel) async {
    try {
      String collectionName = 'Level_${childModel.level}_${childModel.gender}';
      var docRef = await _firestore
          .collection(collectionName)
          .doc(childModel.id)
          .set(childModel.toJson());
      print('Child data added with id: ${childModel.id}');
    } catch (e) {
      print('Error adding child data: $e');
    }
  }

  // Save child data with age calculation in a separate thread using compute
  Future<void> saveChildData({
    required String name,
    required DateTime bDay,
    required int level,
    required String phone,
    required String gender,
    required String notes,
    String? imgUrl,
  }) async {
    String collectionName = 'Level_${level}_$gender';
    var docRef = _firestore.collection(collectionName).doc();

    // Create the ChildData object without the age property (age is not stored now)
    ChildData newAccount = ChildData(
      id: docRef.id,
      name: name,
      bDay: bDay,
      level: level,
      gender: gender,
      notes: notes,
      imgUrl: imgUrl ??
          (gender == 'G'
              ? 'assets/images/profileG.png'
              : 'assets/images/profileB.png'),
      att: [],
      phone: phone,
    );

    await addChildData(newAccount);
  }

  // edi child data with age calculation in a separate thread using compute
  Future<void> editChildData({
    required String? id,
    required String name,
    required DateTime bDay,
    required int level,
    required String phone,
    required String gender,
    required String notes,
    String? imgUrl,
  }) async {
    String collectionName = 'Level_${level}_$gender';
    var docRef = _firestore.collection(collectionName).doc(id);

    await docRef.update({
      'name': name,
      'bDay': bDay,
      'level': level,
      'gender': gender,
      'notes': notes,
      // 'imgUrl': imgUrl ?? (gender == 'G' ? 'assets/images/profileG.png' : 'assets/images/profileB.png'),
      'att': [],
      'phone': phone,
    });
  }

  // Get children gender
  Stream<List<ChildData>> getChildrenByGender(String gender) {
    List<int> levels = [1, 2, 3];
    return Rx.combineLatestList(
      levels.map((level) {
        String collectionName = 'Level_${level}_$gender';
        return _firestore.collection(collectionName).snapshots().map(
              (querySnapshot) => querySnapshot.docs
                  .map((doc) => ChildData.fromJson(doc.data()))
                  .where((child) => child.name != null)
                  .toList(),
            );
      }),
    ).map((listOfLists) {
      var children = listOfLists.expand((list) => list).toList();

      children.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return children;
    });
  }

  Stream<List<ChildData>> getAllChildren() {
    List<int> levels = [1, 2, 3];
    List<String> genders = ["G", "B"];

    return Rx.combineLatestList(
      levels
          .map((level) {
            return genders.map((gender) {
              String collectionName = 'Level_${level}_$gender';
              return _firestore.collection(collectionName).snapshots().map(
                    (querySnapshot) => querySnapshot.docs
                        .map((doc) => ChildData.fromJson(doc.data()))
                        .where((child) => child.name != null)
                        .toList(),
                  );
            }).toList();
          })
          .expand((list) => list)
          .toList(),
    ).map((listOfLists) {
      var children = listOfLists.expand((list) => list).toList();

      children.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return children;
    });
  }

  // Get children by level and gender
  Stream<List<ChildData>> getChildrenByLevelAndGender(
      int level, String gender) {
    String collectionName = 'Level_${level}_$gender';
    return _firestore.collection(collectionName).snapshots().map(
      (querySnapshot) {
        var children = querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data()))
            .where((child) => child.name != null)
            .toList();

        children.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return children;
      },
    );
  }

  // Get children by birth month
  Stream<List<ChildData>> bDChildrenByLevelAndGender({
    required int level,
    required String gender,
    required String monthStr,
  }) {
    String collectionName = 'Level_${level}_$gender';
    int month = int.tryParse(monthStr) ?? 0;

    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        return querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data()))
            .where((child) => child.bDay != null && child.bDay!.month == month)
            .toList();
      },
    );
  }

  // Delete child by ID
  Future<void> deleteChildrenById({
    required int level,
    required String gender,
    required String? id,
  }) {
    String collectionName = 'Level_${level}_$gender';

    return _firestore.collection(collectionName).doc(id).delete();
  }

  // Save attendance for a child
  Future<void> saveAttendance({
    required String? childId,
    required int level,
    required String gender,
    required DateTime attendanceDate,
    required bool state,
  }) async {
    try {
      String collectionName = 'Level_${level}_$gender';
      var docRef = _firestore.collection(collectionName).doc(childId);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        List<DateTime> currentAttendance = data['att'] != null
            ? (data['att'] as List)
                .map((e) => (e as Timestamp).toDate())
                .toList()
            : [];

        if (state) {
          if (currentAttendance.any((date) =>
          date.year == attendanceDate.year &&
              date.month == attendanceDate.month &&
              date.day == attendanceDate.day)) {
            print("Attendance already exists for $childId on $attendanceDate");
            return;
          }
          currentAttendance.add(attendanceDate);
        } else {
          currentAttendance.removeWhere((date) =>
          date.year == attendanceDate.year &&
              date.month == attendanceDate.month &&
              date.day == attendanceDate.day);
        }

        // Ensure data is updated correctly
        await docRef.update({
          'att': currentAttendance.map((e) => Timestamp.fromDate(e)).toList(),
        });

        print(
            "Attendance ${state ? 'added' : 'removed'} for $childId on ${attendanceDate.toLocal()}");
      } else {
        print("Child document with ID $childId does not exist.");
      }
    } catch (e) {
      print("Error saving attendance: $e");
    }
  }

  Stream<List<ChildData>> trakingChildren({
    required int level,
    required String gender,
    required String monthStr,
    required DateTime attendanceDate,
  }) {
    String collectionName = 'Level_${level}_$gender';
    int month = int.tryParse(monthStr) ?? 0;

    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        return querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data()))
            .where((child) {
          bool isInMonth =
              month == 0 || (child.bDay != null && child.bDay!.month == month);

          bool isAbsentOnDate = !child.att.any((attendanceDateInAtt) {
            return attendanceDateInAtt.year == attendanceDate.year &&
                attendanceDateInAtt.month == attendanceDate.month &&
                attendanceDateInAtt.day == attendanceDate.day;
          });

          return isInMonth && isAbsentOnDate;
        }).toList();
      },
    );
  }

  //EVENT
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> addEvent({
    required String name,
    required double price,
    required String location,
    required String details,
    required DateTime date,
    required List<ChildEvent> children,
  }) async {
    try {
      await firestore.collection("Event").add({
        "name": name,
        "price": price,
        "location": location,
        "details": details,
        "date": date,
        "children": children.map((child) => child.toJson()).toList(),
      });
    } catch (e) {
      throw Exception("Error adding event: $e");
    }
  }

  static Future<void> updateEventPayment({
    required String eventId,
    required String childId,
    required String namebasoon,
    required double amountPaid,
    required DateTime paymentDate,
    required double remainingAmount, // إضافة remainingAmount
  }) async {
    try {
      double totalPrice = await getPriceByEventId(eventId);
      double totalPaid = await getTotalPaid(eventId, childId);

      final paymentInstallment = PaymentInstallment(
        amountPaid: amountPaid,
        remainingAmount: remainingAmount,
        paymentDate: paymentDate,
        namebasoon: namebasoon,
      );

      DocumentSnapshot eventSnapshot =
          await firestore.collection("Event").doc(eventId).get();

      if (eventSnapshot.exists) {
        var children = eventSnapshot['children'];
        var childIndex =
            children.indexWhere((child) => child['childId'] == childId);

        if (childIndex != -1) {
          var child = children[childIndex];
          ChildEvent childEvent = ChildEvent.fromJson(child);
          childEvent.installments.add(paymentInstallment);
          children[childIndex] = childEvent.toJson();

          await firestore.collection("Event").doc(eventId).update({
            "children": children,
          });
        } else {
          ChildEvent newChildEvent = ChildEvent(
            childId: childId,
            installments: [paymentInstallment],
            totalPrice: totalPrice,
          );
          children.add(newChildEvent.toJson());

          await firestore.collection("Event").doc(eventId).update({
            "children": children,
          });
        }
      }
    } catch (e) {
      throw Exception("Error updating event payment: $e");
    }
  }

  static Future<double> getTotalPaid(String eventId, String childId) async {
    double totalPaid = 0.0;
    try {
      DocumentSnapshot eventSnapshot =
          await firestore.collection("Event").doc(eventId).get();

      if (eventSnapshot.exists) {
        var children = eventSnapshot['children'];
        var child = children.firstWhere(
          (child) => child['childId'] == childId,
          orElse: () => null,
        );

        if (child != null) {
          List<dynamic> installments = child['installments'] ?? [];
          totalPaid = installments.fold(
            0.0,
            (sum, item) => sum + (item['amountPaid'] as double),
          );
        }
      }
    } catch (e) {
      throw Exception("Error fetching total paid: $e");
    }
    return totalPaid;
  }

  static double getRemainingAmount(
      {required double totalPaid,
      required double totalPrice,
      required double amountPaid}) {
    double remainingAmount = totalPrice - (totalPaid + amountPaid);
    return remainingAmount;
  }

  static Future<double> getPriceByEventId(String eventId) async {
    try {
      DocumentSnapshot eventSnapshot =
          await firestore.collection("Event").doc(eventId).get();

      if (eventSnapshot.exists) {
        return eventSnapshot['price'] ?? 0.0;
      }
    } catch (e) {
      throw Exception("Error fetching price: $e");
    }
    return 0.0;
  }

  static Future<List<EventModel>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("Event")
          .orderBy("date", descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        return EventModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }
}
