import 'package:flutter/material.dart';

class AnalysePg1 extends StatefulWidget {
  final Map<String, dynamic> resumeData; // Define a field to hold the resume data

  AnalysePg1({Key? key, required this.resumeData}) : super(key: key);

  @override
  _AnalysePg1State createState() => _AnalysePg1State();
}

class _AnalysePg1State extends State<AnalysePg1> {
  double _accuracy = 0.0; // Define accuracy here

  @override
  void initState() {
    super.initState();
    _accuracy = widget.resumeData['rating'].toDouble(); // Get rating from resumeData
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
          backgroundColor: Color(0xFF22092C), // Set the background color using a hex value
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, top: 32, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 24, 0),
                  padding: const EdgeInsets.all(16),
                  height: 50,
                  width: 360,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.resumeData['name'],
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Your Email id is',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 24, 0),
                  padding: const EdgeInsets.all(16),
                  height: 50,
                  width: 360,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.resumeData['email'],
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Your Skills are',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 24, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.resumeData['skills'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 0.5),
                          ),
                        ),
                        child: Text(
                          widget.resumeData['skills'][index],
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Recommended Skills',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 24, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.resumeData['recommended_skills'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 0.5),
                          ),
                        ),
                        child: Text(
                          widget.resumeData['recommended_skills'][index],
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Rating',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Slider(
                  value: _accuracy,
                  min: 0.0,
                  max: 100.0,
                  divisions: 10, // Adjust for desired number of divisions
                  label: 'Accuracy: ${_accuracy.toStringAsFixed(1)}%',
                  activeColor: Color.fromARGB(255, 104, 6, 124), // Set filled track color
                  inactiveColor: Colors.grey, // Set track color
                  onChanged: (double newValue) {
                    setState(() {
                      _accuracy = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
