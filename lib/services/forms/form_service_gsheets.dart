import 'package:athlete_surveyor/models/student_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:gsheets/gsheets.dart';
import 'package:uuid/uuid.dart';

@Deprecated('This is only to be used when (and if) we\'re ready to switch' +
'from storing forms on cockroach to storing them in a google sheet')
class FormService {
  final GSheets gsheets;
  final Spreadsheet spreadsheet;
  late Worksheet formSheet;

  FormService(this.gsheets, String spreadsheetId, this.spreadsheet) {
    _init(spreadsheetId);
  }

  Future<void> _init(String spreadsheetId) async {
    spreadsheet = await gsheets.spreadsheet(spreadsheetId);
    formSheet = await _getSheet('Forms');
  }
  /// individual sheet within the whole Workfile
  Future<Worksheet> _getSheet(String title) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }


  Future<void> writeQuestion(Question question, Uuid, formUuid) async {
      /// Ex:
   ///   await formSheet.values.appendRow([
   ///   formUuid,
   ///   question.ordinal.toString(),
   ///   question.header,
   ///   question.content,
   ///   question.res_required.toString(),
   ///   question.resFormat.widgetType.toString(),
   ///   question.linkedFile?.path ?? ''
   /// ]);
  }

  /// Called when updates to the form's responses have been made 
  @override 
  void saveForm() {
    /// if local cache used, persist any updates to it 
    /// 
    /// Student's responses are stored in a table using the question's id )(PK) 
  
    /// and user's id as an FK (parameter?), if there's any draft there, get them.
    /// Otherwise, (temporarily, until "production" release) we create a new draft 
    /// to store the response until the user withdraws focus from the [Question], 
    /// prompting the draft to be updated.  
    /// 
  }

  /// using the supplied [formUuid] as an indexing key of sorts, queries the spreadsheet
  /// accordingly so that the content can be loaded for a **specific student**
  StudentForm? loadForm(Uuid formUuid) {
    // TODO: implement loadForm
    /// List<Question>? questions = (get from query);
    
    /// based on questions, load into a [StudentForm]
  }

  // Example helper methods (to be implemented)
  Map<String, dynamic>? _fetchFormData(Uuid formUuid) {
    // Implementation to fetch form data
  }

  /// handles the saving of a draft, called when either:
  /// - a form's content is modified in any way (staff only)
  /// - a question's response has been marked complete/hits next
  /// - a question's unfinished response has been modified, update draft
  void _saveFormData(StudentForm form) {
    // Implementation to save form data
  }

}