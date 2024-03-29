import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

import 'package:flutter_typeahead_search/data.dart';

class MyCupertinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'flutter_typeahead demo',
      home: CupertinoPageScaffold(
        child: FavoriteCitiesPage(),
      ), //MyHomePage(),
    );
  }
}

class FavoriteCitiesPage extends StatefulWidget {
  @override
  _FavoriteCitiesPage createState() => _FavoriteCitiesPage();
}

class _FavoriteCitiesPage extends State<FavoriteCitiesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();
  String favoriteCity = 'Unavailable';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text('What is your favorite city?'),
            CupertinoTypeAheadFormField(
              getImmediateSuggestions: true,
              suggestionsBoxController: _suggestionsBoxController,
              textFieldConfiguration: CupertinoTextFieldConfiguration(
                controller: _typeAheadController,
              ),
              suggestionsCallback: (pattern) {
                return Future.delayed(
                  Duration(seconds: 1),
                  () => CitiesService.getSuggestions(pattern),
                );
              },
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    suggestion,
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                _typeAheadController.text = suggestion;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a city';
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            CupertinoButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    favoriteCity = _typeAheadController.text;
                  });
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Your favorite city is $favoriteCity!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
