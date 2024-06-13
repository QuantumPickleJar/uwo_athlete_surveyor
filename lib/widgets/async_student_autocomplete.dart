import 'dart:async';
import 'package:athlete_surveyor/models/students_model.dart';
import 'package:athlete_surveyor/models/users/user_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    
/// Handles the fetching of the recipients that a staff can send an email to.
/// Features debouncing to limit network requests as well as error handling
/// (see https://api.flutter.dev/flutter/material/Autocomplete-class.html)
class AsyncStudentAutocomplete extends StatefulWidget {
  // final StudentsModel studentsModel;
  static const Duration debounceDuration = Duration(milliseconds: 500);
  const AsyncStudentAutocomplete({super.key});
  
  @override
  State<AsyncStudentAutocomplete> createState() => AsyncStudentAutocompleteState();
}

class AsyncStudentAutocompleteState extends State<AsyncStudentAutocomplete> {
  /// Debounced Student-returning function, that accepts a query as input
  late final _Debounceable<Iterable<Student>?, String> _debouncedSearch;

  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the service connected to the DB
  late Iterable<Student> _lastOptions; // = widget.studentsModel.students;

  // Whether to consider the fake network to be offline.
  bool _networkEnabled = true;

  // A network error was received on the most recent query.
  bool _networkError = false;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<Student>?> _search(String query) async {
    _currentQuery = query;
    /// get [StudentsModel] from the tree
    final studentsModel = Provider.of<StudentsModel>(context, listen: false);
    late final Iterable<Student> options; 
    try {
      /// get the students that will fill the dropdown (from [StudentsModel])
      
      
      if(query.contains('@')) {        /// if [query] contains an '@', look by email
        options = studentsModel.students.where((student) => 
          student.username.toLowerCase().contains(query.toLowerCase()));
      } else {                          /// otherwise assume name
        // options = await _FakeAPI.search(_currentQuery!, _networkEnabled);
        //options = await widget.studentsModel.userRepository.fetchStudentsFromDatabase();
        options = studentsModel.students.where(
          (student) => student.fullName.toLowerCase().contains(query.toLowerCase())
          );
      }
    } catch (error) {
      if (error is _NetworkException) {
      setState(() {
        _networkError = true;
      });
      if (studentsModel.students.isEmpty) {
        rethrow;
      } else {
        /// fallback to the local cache, if available
        return studentsModel.students;
        }
      }
    }

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;
    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<Student>?, String>(_search);
    /// load from the model into the widget's dropdown
    _lastOptions = Provider.of<StudentsModel>(context, listen: false)
                                            .students;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _networkEnabled
              ? 'Network is on, toggle to induce network errors.'
              : 'Network is off, toggle to allow requests to go through.',
        ),
        Switch(
          value: _networkEnabled,
          onChanged: (bool? value) {
            setState(() {
              _networkEnabled = !_networkEnabled;
            });
          },
        ),
        const SizedBox(
          height: 32.0,
        ),
        Autocomplete<Student>(
          fieldViewBuilder: (BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              decoration: InputDecoration(
                errorText:
                    _networkError ? 'Network error, please try again.' : null,
              ),
              controller: controller,
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) async {
            setState(() {
              _networkError = false;
            });
            final Iterable<Student>? options =
                await _debouncedSearch(textEditingValue.text);
            if (options == null) {
              return _lastOptions;
            }
            _lastOptions = options;
            return options;
          },
          onSelected: (Student selection) {
            debugPrint('You just selected ${selection.fullName}');
          },
        ),
      ],
    );
  }
}


typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
/// 
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(AsyncStudentAutocomplete.debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}

// An exception indicating that a network request has failed.
class _NetworkException implements Exception {
  const _NetworkException();
}
