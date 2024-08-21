import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Video List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List videos = [];
  final TextEditingController controller = TextEditingController();
  String singer = '';

  void fetchVideos() async {
    final apiKey = 'AIzaSyA8G80kVHyGPRuxC9-hBRLf0eHS9bvaLhc';
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$singer&type=video&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videos = data['items'];
      });
    } else {
      setState(() {
        videos = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm bài hát trên YouTube'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nhập tên ca sĩ',
              ),
              onSubmitted: (value) {
                setState(() {
                  singer = value;
                  fetchVideos();
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  singer = controller.text;
                  fetchVideos();
                });
              },
              child: Text('Tìm kiếm'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  final videoTitle = video['snippet']['title'];
                  final videoID = video['id']['videoId'];
                  final videoThumbnailUrl =
                  video['snippet']['thumbnails']['medium']['url'];
                  return ListTile(
                    leading: Image.network(videoThumbnailUrl),
                    title: Text(videoTitle),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
