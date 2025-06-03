import 'dart:async';

import 'package:flutter/material.dart';

class DetailedCardScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String slogan;
  final int second;

  final String username;
  final String usermail;

  DetailedCardScreen({
    required this.imageUrl,
    required this.name,
    required this.slogan,
    required this.second,
    required this.username,
    required this.usermail,
  });

  @override
  State<DetailedCardScreen> createState() => _DetailedCardScreenState();
}

class _DetailedCardScreenState extends State<DetailedCardScreen> {
  late int _secondsRemaining;
  late bool _isCounting;
  late bool _exerciseCompleted;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.second;
    _isCounting = false;
    _exerciseCompleted = false;
  }

  void _startCounting(){
    setState(() {
      _isCounting = true;
    });

    const oneSec = Duration(seconds: 1);

    Timer.periodic(oneSec, (timer) {
      if(_secondsRemaining == 0){
        setState(() {
          _isCounting = false;
          _exerciseCompleted = true;
          timer.cancel();
        });
      }else{
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _loadExerciseCompletionState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Details"),
      ), // AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Text('Welcome, ${widget.username}'),
          SizedBox(
            height: 10,
          ),
          Text('Welcome, ${widget.usermail}'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(widget.imageUrl),
            ), // Padding
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold), // TextStyle
                ), // Text
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.slogan,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 8,
                ),
                _isCounting
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                            value: (_secondsRemaining / widget.second),
                            strokeWidth: 10,
                            backgroundColor: Colors.grey,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.blue),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '$_secondsRemaining seconds',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 16.0,
                      ),
                _exerciseCompleted
                    ?  Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _startCounting();
                            },
                            child: const Text('Restart'),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Exercise Completed',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _startCounting();
                        },
                        child: Text(
                          _isCounting ? 'Counting down...' : 'Start Counting'
                        ),
                      ),

                // ElevatedButton
              ],
            ),
          ), // Column, Padding
        ],
      ), // Column
    ); // Scaffold
  }
}
