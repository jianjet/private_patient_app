import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  Widget _callIconImage(){
    return Container(
      margin: const EdgeInsets.all(1),
      height: 180,
      width: 180,
      child: Image.asset(
        "./image/call.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _stateChannelName(){
    return TextField(
      controller: _channelController,
      decoration: InputDecoration(
        errorText: _validateError ? 'Channel name is mandatory' : null,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1)
        ),
        hintText: 'Channel name'
      ),
    );
  }

  Widget _broadOrAud(ClientRole role, String roleText){
    return RadioListTile(
      title: Text(roleText),
      value: role, 
      groupValue: _role, 
      onChanged: (ClientRole? value){
        setState(() {
          _role = value;
        });
      }
    );
  }

  Widget _joinButton(){
    return ElevatedButton(
      onPressed: _onJoin,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40)
      ), 
      child: const Text('Join'),
    );
  }

  Future<void> _onJoin() async {
    setState(() {
      _channelController.text.isEmpty ? _validateError=true : _validateError=false;
    });
    if (_channelController.text.isNotEmpty){
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => Call(
            channelName: _channelController.text,
            role: _role,
          ),
        )
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString()); //see whether the request is allowed or not
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                _callIconImage(),
                const SizedBox(height: 20),
                _stateChannelName(),
                _broadOrAud(ClientRole.Broadcaster, 'Broadcaster'),
                _broadOrAud(ClientRole.Audience, 'Audience'),
                _joinButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}