import 'dart:convert';
import 'dart:io';
import 'package:chatapp/student/pages/others/AnalysePg1.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//import 'package:project_placement_edge/pages/others/AnalysePg1.dart';



class Widget021 extends StatefulWidget {
  Widget021({Key? key}) : super(key: key);

  @override
  _Widget021State createState() => _Widget021State();
}

class _Widget021State extends State<Widget021> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isloading = false;
  File? fileToDisplay;

  Future<void> pickFile() async {
    try {
      setState(() {
        isloading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result!.files.isNotEmpty) {
        fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path!);

        // Call the function to upload the file
        await uploadFile(fileToDisplay!);
      } else {
        print('No file picked');
      }

      setState(() {
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.0.190:5000/upload'), // Modify this line
      );
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');

        String responseData = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseData);

      String message = jsonResponse['message'];
      dynamic resumeData = jsonResponse['resume_data'];

      print('File uploaded successfully: $message');
      // print('Resume data: $resumeData');
        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnalysePg1(resumeData: resumeData)),
              );
             
      } else {
        print('Failed to upload file');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(114.0),
        child: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Resume Analyser',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: false,
          backgroundColor: Color(0xFF22092C),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Upload Resume',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                pickFile();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: SizedBox(
                width: 25,
                height: 29,
                child: Image.asset(
                  'assets/images/upload_img.png',
                  fit: BoxFit.cover,
                  width: 25,
                  height: 29,
                ),
              ),
            ),
          ),
        //  if (pickedfile != null)
            // print("hello")
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AnalysePg1()),
          //     );
          //   },
          //   child: Text('Navigate to AnalysePg1'),
          // ),
          
        ],
      ),
    );
  }
}