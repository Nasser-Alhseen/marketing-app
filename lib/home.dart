import 'dart:io';

import 'package:data_users/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as exc;
import 'app_styles.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.balance});
  int balance;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? FBID;

  TextEditingController fbid = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController about_me = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController birthdayYear = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController hometown = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController locale = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController relationship = TextEditingController();
  TextEditingController religion = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController limit = TextEditingController();
  List result = [];
  List<DataRow> dataRows = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    initial().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future initial() async {
    GetStorage s = GetStorage();
    s.write('balance', widget.balance);
  }

  Future getData() async {
    Dio dio = Dio();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = 'https://marketing-data.onrender.com/data/search';
    Map<String, dynamic> requestBody = {
      "FBID": fbid.text,
      "first_name": first_name.text,
      "last_name": last_name.text,
      "phone": phone.text,
      "work": work.text,
      "hometown": hometown.text,
      "location": location.text,
      "locale": locale.text,
      "relationship": relationship.text,
      "religion": religion.text,
      "about_me": about_me.text,
      "birthday": birthday.text,
      "birthdayYear": birthdayYear.text,
      "country": country.text,
      "education": education.text,
      "email": email.text,
      "gender": gender.text,
      "limit": limit.text,
      "emailid":prefs.getString("email")
    };
    print(requestBody);
    // Map requestBody = {"FBID": "100028524091148", "limit": 2, "emailid": "ali"};
    print(requestBody);
    var response;
    try {
      response = await dio.get(apiUrl, data: requestBody);
      if (response.statusCode == 200) {
        Map resdata={
          "data":response.data['data'],
          "balance":response.data['balance']
        };
        print('response' + resdata.toString());
        return resdata;
      } else {
        // Failed sign-in

        print('Response: ${response.data}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  Future getIds(List<String> ids) async {
    Dio dio = Dio();
    Map<String, dynamic> requestBody = {
      'ids': ids,
      "emailid": GetStorage().read('email')
    };
    print(requestBody);
    try {
      var res = await dio.post('https://marketing-data.onrender.com/data/ids',
          data: requestBody);
      if (res.statusCode == 200) {
        print(res.data['data']);
      } else {
        print('res');
      }
    } catch (e) {
      print('catch$e');
    }
  }

  Widget searchTile(TextEditingController controller, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.02,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label: ',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 233, 233, 233)),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<String> ids = [];
  @override
  Widget build(BuildContext context) {
    limit.text = '20';
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 37, 37),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 44, 40, 40),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        GetStorage s = GetStorage();
                        s.write('loggedin2', false);
                        Get.offAll(() => const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Your Balance is',
                  style: ralewayStyle.copyWith(
                    fontSize: 20.0,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.balance.toString(),
                  style: ralewayStyle.copyWith(
                    fontSize: 20.0,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Text(
          'Rateb For Marketing',
          style: ralewayStyle.copyWith(
            fontSize: 22.0,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search By: ',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        searchTile(fbid, 'Facebook Id'),
                        searchTile(phone, 'Phone'),
                        searchTile(first_name, 'First Name'),
                        searchTile(last_name, 'Last Name'),
                        searchTile(email, 'Email'),
                        searchTile(birthday, 'Birthday'),
                        // searchTile(birthdayYear, 'Birthday Year'),
                        searchTile(locale, 'Locale'),
                        searchTile(hometown, 'Home Town'),
                        searchTile(location, 'Location'),
                        searchTile(country, 'Country'),
                        // searchTile(work, 'Work'),
                        // searchTile(education, 'Education'),
                        // searchTile(relationship, 'Relationship'),
                        // searchTile(about_me, 'About Me'),
                        // searchTile(gender, 'Gender'),
                        searchTile(limit, 'Limit'),
                        const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (widget.balance > 0) {
                                  result = [];
                                  Map resMap = await getData();
                                  // if (widget.balance < result2.length) {
                                  //   result = [];
                                  //   for (int i = 0; i < widget.balance; i++) {
                                  //     result.add(result2[i]);
                                  //   }
                                  //   widget.balance = 0;
                                  // } else {
                                  //   result = result2;
                                  //   widget.balance -= result.length;
                                  // }
                                  result = resMap['data'];

                                  GetStorage s = GetStorage();
                                  s.write('balance', widget.balance);
                                  result = List.from(result);
                                  result.shuffle();

                                  setState(() {
                                    fbid.text = '';
                                    first_name.text = '';
                                    last_name.text = '';
                                    hometown.text = '';
                                    relationship.text = '';
                                    religion.text = '';
                                    work.text = '';
                                    phone.text = '';
                                    location.text = '';
                                    birthday.text = '';
                                    birthdayYear.text = '';
                                    hometown.text = '';
                                    about_me.text = '';
                                    email.text = '';
                                    education.text = '';
                                    locale.text = '';
                                    country.text = '';
                                    gender.text = '';
                                    dataRows = result.map((e) {
                                      return DataRow(cells: [
                                        DataCell(Text(e['FBID'].toString())),
                                        DataCell(Text(e['Phone'])),
                                        DataCell(Text(e['first_name'])),
                                        DataCell(Text(e['last_name'])),
                                      ]);
                                    }).toList();
                                  });
                                } else {
                                  Get.snackbar('Expired Balance',
                                      'recharge your balance',
                                      colorText: Colors.white);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 20)),
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Create a new Excel workbook
                                exc.Workbook workbook = exc.Workbook();

                                // Create a new Excel worksheet
                                exc.Worksheet sheet = workbook.worksheets[0];
                                sheet
                                    .getRangeByName('A1')
                                    .setText('Fcebook ID');
                                sheet
                                    .getRangeByName('B1')
                                    .setText('First Name');
                                sheet.getRangeByName('C1').setText('Last Name');
                                sheet.getRangeByName('D1').setText('Phone');
                                sheet.getRangeByName('E1').setText('BirthDay');
                                sheet
                                    .getRangeByName('F1')
                                    .setText('Birthday Year');
                                sheet.getRangeByName('H1').setText('Gender');
                                sheet.getRangeByName('I1').setText('Locale');
                                sheet.getRangeByName('J1').setText('HomeTown');
                                sheet.getRangeByName('K1').setText('Location');
                                sheet.getRangeByName('L1').setText('Country');
                                sheet.getRangeByName('M1').setText('Work');
                                sheet.getRangeByName('N1').setText('Education');
                                sheet
                                    .getRangeByName('O1')
                                    .setText('Relationship');
                                sheet.getRangeByName('P1').setText('Religion');
                                sheet.getRangeByName('Q1').setText('About Me');
                                sheet.getRangeByName('R1').setText('Email');
                                for (int i = 0; i < result.length; i++) {
                                  sheet
                                      .getRangeByName('A${i + 2}')
                                      .setText(result[i]['FBID']);
                                  sheet
                                      .getRangeByName('B${i + 2}')
                                      .setText(result[i]['first_name']);
                                  sheet
                                      .getRangeByName('C${i + 2}')
                                      .setText(result[i]['last_name']);
                                  sheet
                                      .getRangeByName('D${i + 2}')
                                      .setText(result[i]['Phone']);
                                  sheet
                                      .getRangeByName('E${i + 2}')
                                      .setText(result[i]['birthday']);
                                  // sheet
                                  //     .getRangeByName('F${i + 2}')
                                  //     .setText(result[i]['birthdayYear']);
                                  sheet
                                      .getRangeByName('H${i + 2}')
                                      .setText(result[i]['gender']);
                                  sheet
                                      .getRangeByName('I${i + 2}')
                                      .setText(result[i]['locale']);
                                  sheet
                                      .getRangeByName('J${i + 2}')
                                      .setText(result[i]['hometown']);
                                  sheet
                                      .getRangeByName('K${i + 2}')
                                      .setText(result[i]['location']);
                                  sheet
                                      .getRangeByName('L${i + 2}')
                                      .setText(result[i]['country']);
                                  // sheet
                                  //     .getRangeByName('M${i + 2}')
                                  //     .setText(result[i]['work']);
                                  // sheet
                                  //     .getRangeByName('N${i + 2}')
                                  //     .setText(result[i]['education']);
                                  // sheet
                                  //     .getRangeByName('O${i + 2}')
                                  //     .setText(result[i]['relationship']);
                                  // sheet
                                  //     .getRangeByName('P${i + 2}')
                                  //     .setText(result[i]['religion']);
                                  // sheet
                                  //     .getRangeByName('Q${i + 2}')
                                  //     .setText(result[i]['about_me']);
                                  sheet
                                      .getRangeByName('R${i + 2}')
                                      .setText(result[i]['email']);
                                  // Add data to the worksheet
                                }

                                // Save the workbook
                                List<int> bytes = workbook.saveAsStream();
                                workbook.dispose();

                                // Get the document directory
                                Directory directory =
                                    await getApplicationDocumentsDirectory();
                                String filePath =
                                    '${directory.path}/example.xlsx';

                                // Write the Excel file to disk
                                File file = File(filePath);
                                await file.writeAsBytes(bytes, flush: true);
                                await OpenFile.open(filePath);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 20)),
                              child: const Text(
                                'Excel File',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Search Using File: ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Select File: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    var result =
                                        await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      File file =
                                          File(result.files.single.path!);
                                      String content =
                                          await file.readAsString();
                                      ids = content.split('\n');
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)),
                                  child: const Text(
                                    'Select',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (widget.balance > 0) {
                                          List result2 = await getIds(ids);
                                          print(result2);
                                          if (widget.balance < result2.length) {
                                            for (int i = 0;
                                                i < widget.balance;
                                                i++) {
                                              result.add(result2[i]);
                                            }
                                            widget.balance = 0;
                                          } else {
                                            widget.balance -= result2.length;
                                            result = result2;
                                          }
                                          result = List.from(result);
                                          result.shuffle();

                                          GetStorage s = GetStorage();
                                          s.write('balance', widget.balance);
                                          dataRows = result.map((e) {
                                            return DataRow(cells: [
                                              DataCell(
                                                  Text(e['FBID'].toString())),
                                              DataCell(Text(e['Phone'])),
                                              DataCell(Text(e['first_name'])),
                                              DataCell(Text(e['last_name'])),
                                            ]);
                                          }).toList();
                                          setState(() {});
                                        } else {
                                          Get.snackbar('Expired Balance',
                                              'recharge your balance',
                                              colorText: Colors.white);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20)),
                                      child: const Text(
                                        'Search',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Create a new Excel workbook
                                        exc.Workbook workbook = exc.Workbook();

                                        // Create a new Excel worksheet
                                        exc.Worksheet sheet =
                                            workbook.worksheets[0];
                                        sheet
                                            .getRangeByName('A1')
                                            .setText('Fcebook ID');
                                        sheet
                                            .getRangeByName('B1')
                                            .setText('First Name');
                                        sheet
                                            .getRangeByName('C1')
                                            .setText('Last Name');
                                        sheet
                                            .getRangeByName('D1')
                                            .setText('Phone');
                                        sheet
                                            .getRangeByName('E1')
                                            .setText('BirthDay');
                                        sheet
                                            .getRangeByName('F1')
                                            .setText('Birthday Year');
                                        sheet
                                            .getRangeByName('H1')
                                            .setText('Gender');
                                        sheet
                                            .getRangeByName('I1')
                                            .setText('Locale');
                                        sheet
                                            .getRangeByName('J1')
                                            .setText('HomeTown');
                                        sheet
                                            .getRangeByName('K1')
                                            .setText('Location');
                                        sheet
                                            .getRangeByName('L1')
                                            .setText('Country');
                                        sheet
                                            .getRangeByName('M1')
                                            .setText('Work');
                                        sheet
                                            .getRangeByName('N1')
                                            .setText('Education');
                                        sheet
                                            .getRangeByName('O1')
                                            .setText('Relationship');
                                        sheet
                                            .getRangeByName('P1')
                                            .setText('Religion');
                                        sheet
                                            .getRangeByName('Q1')
                                            .setText('About Me');
                                        sheet
                                            .getRangeByName('R1')
                                            .setText('Email');
                                        for (int i = 0;
                                            i < result.length;
                                            i++) {
                                          sheet
                                              .getRangeByName('A${i + 2}')
                                              .setText(result[i]['FBID']);
                                          sheet
                                              .getRangeByName('B${i + 2}')
                                              .setText(result[i]['first_name']);
                                          sheet
                                              .getRangeByName('C${i + 2}')
                                              .setText(result[i]['last_name']);
                                          sheet
                                              .getRangeByName('D${i + 2}')
                                              .setText(result[i]['Phone']);
                                          sheet
                                              .getRangeByName('E${i + 2}')
                                              .setText(result[i]['birthday']);
                                          // sheet
                                          //     .getRangeByName('F${i + 2}')
                                          //     .setText(
                                          //         result[i]['birthdayYear']);
                                          sheet
                                              .getRangeByName('H${i + 2}')
                                              .setText(result[i]['gender']);
                                          sheet
                                              .getRangeByName('I${i + 2}')
                                              .setText(result[i]['locale']);
                                          sheet
                                              .getRangeByName('J${i + 2}')
                                              .setText(result[i]['hometown']);
                                          sheet
                                              .getRangeByName('K${i + 2}')
                                              .setText(result[i]['location']);
                                          sheet
                                              .getRangeByName('L${i + 2}')
                                              .setText(result[i]['country']);
                                          // sheet
                                          //     .getRangeByName('M${i + 2}')
                                          //     .setText(result[i]['work']);
                                          // sheet
                                          //     .getRangeByName('N${i + 2}')
                                          //     .setText(result[i]['education']);
                                          // sheet
                                          //     .getRangeByName('O${i + 2}')
                                          //     .setText(
                                          //         result[i]['relationship']);
                                          // sheet
                                          //     .getRangeByName('P${i + 2}')
                                          //     .setText(result[i]['religion']);
                                          // sheet
                                          //     .getRangeByName('Q${i + 2}')
                                          //     .setText(result[i]['about_me']);
                                          sheet
                                              .getRangeByName('R${i + 2}')
                                              .setText(result[i]['email']);
                                          // Add data to the worksheet
                                        }

                                        // Save the workbook
                                        List<int> bytes =
                                            workbook.saveAsStream();
                                        workbook.dispose();

                                        // Get the document directory
                                        Directory directory =
                                            await getApplicationDocumentsDirectory();
                                        String filePath =
                                            '${directory.path}/example.xlsx';

                                        // Write the Excel file to disk
                                        File file = File(filePath);
                                        await file.writeAsBytes(bytes,
                                            flush: true);
                                        await OpenFile.open(filePath);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20)),
                                      child: const Text(
                                        'Excel File',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // GridView(
                            //   shrinkWrap: true,
                            //   gridDelegate:
                            //       SliverGridDelegateWithMaxCrossAxisExtent(
                            //           maxCrossAxisExtent:
                            //               MediaQuery.of(context).size.height *
                            //                   0.2,
                            //           childAspectRatio: 3 / 1),
                            //   children: [
                            //     Container(
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'FBID: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Phone: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'First Name: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Last Name: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Email: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Birthday: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Birthday Year: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Gender: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Locale: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'HomeTown: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Location: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Country: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Work: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Expanded(
                            //         flex: 2,
                            //         child: Row(
                            //           children: [
                            //             const Text(
                            //               'Education: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //             Expanded(
                            //               flex: 1,
                            //               child: Checkbox(
                            //                   value: true,
                            //                   onChanged: (val) =>
                            //                       setState(() {})),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Relationship: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'Religion: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       child: Row(
                            //         children: [
                            //           const Expanded(
                            //             flex: 2,
                            //             child: Text(
                            //               'About me: ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16),
                            //             ),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Checkbox(
                            //                 value: true,
                            //                 onChanged: (val) =>
                            //                     setState(() {})),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DataTable(columns: const [
                                      DataColumn(
                                        label: Text('Id '),
                                      ),
                                      DataColumn(label: Text('Phone')),
                                      DataColumn(label: Text('First Name')),
                                      DataColumn(label: Text('Last Name')),
                                    ], rows: dataRows),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
