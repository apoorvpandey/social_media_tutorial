import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigate_to_next_screen/response_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Entries> _listOfData = [];
  bool _isLoading = true;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error))
                : ListView.builder(
                    itemCount: _listOfData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                              _listOfData[index].category ?? 'No Category'),
                          subtitle: Text(_listOfData[index].description ??
                              'No Description'));
                    }));
  }

  @override
  initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final endPoint = Uri.parse('https://api.publicapis.org/entries');
      final response = await http.get(endPoint);
      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          ResponseModel responseModel = ResponseModel.fromJson(decodedResponse);
          _listOfData.addAll(responseModel.entries!);
          log(decodedResponse.toString());
        } else {
          throw Exception('Failed to load data');
        }
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }
}
