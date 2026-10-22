import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => DisplayScreenState();
}

class DisplayScreenState extends State<DisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ฟังก์ชันลบข้อมูลออกจาก Firestore
  Future<void> deleteStudent(String documentId) async {
    await _firestore.collection('student').doc(documentId).delete();
  }

  // หน้าต่างยืนยันการลบข้อมูล (ข้อ 29)
  Future<void> showDeleteConfirmation(String documentId) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบข้อมูล'),
          content: const Text('คุณต้องการลบข้อมูลจริงๆ ใช่ไหมครับ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await deleteStudent(documentId);
                Navigator.pop(context);
              },
              child: const Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันและหน้าต่างสำหรับแก้ไขข้อมูล (ข้อ 30)
  Future<void> showEditDialog(
      String documentId, Map<String, dynamic> currentData) async {
    final editFormKey = GlobalKey<FormState>();
    final fnameController = TextEditingController(text: currentData['fname']);
    final lnameController = TextEditingController(text: currentData['lname']);
    final emailController = TextEditingController(text: currentData['email']);
    final scoreController = TextEditingController(text: currentData['score']);

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แก้ไขข้อมูลนักเรียน'),
          content: Form(
            key: editFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: fnameController,
                    decoration: const InputDecoration(labelText: 'ชื่อ'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'กรุณากรอกชื่อ' : null,
                  ),
                  TextFormField(
                    controller: lnameController,
                    decoration: const InputDecoration(labelText: 'นามสกุล'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'กรุณากรอกนามสกุล' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'อีเมล์'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'กรุณากรอกอีเมล์' : null,
                  ),
                  TextFormField(
                    controller: scoreController,
                    decoration: const InputDecoration(labelText: 'คะแนน'),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'กรุณากรอกคะแนน' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editFormKey.currentState!.validate()) {
                  await _firestore.collection('student').doc(documentId).update({
                    'fname': fnameController.text,
                    'lname': lnameController.text,
                    'email': emailController.text,
                    'score': scoreController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('บันทึกการแก้ไข'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายงานคะแนนสอบ"),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("student").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final data = document.data() as Map<String, dynamic>;

              return Container(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                      child: Text(data["score"] ?? ""),
                    ),
                  ),
                  title: Text("${data["fname"]} ${data["lname"]}"),
                  subtitle: Text(data["email"] ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ปุ่มแก้ไขข้อมูล (ข้อ 30)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await showEditDialog(document.id, data);
                        },
                      ),
                      // ปุ่มลบข้อมูล (ข้อ 29)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await showDeleteConfirmation(document.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}