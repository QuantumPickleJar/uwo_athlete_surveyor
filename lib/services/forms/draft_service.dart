import 'package:gsheets/gsheets.dart';
import 'package:uuid/uuid.dart';

/// models the drafted response for a form.  To keep things simple, initially we may clone the entire
/// form to store the student's responses, but eventually for performance we'll want to change this to
/// instead only be storing response content *per-[Question]*
class DraftService {
  final Worksheet _draftSheet;
  
  DraftService(this._draftSheet);

  Future<void> saveDraft(Uuid formUuid, String questionId, String draftData) async {
    // TODO: find the right cell based on formUuid and questionId and save draftData
    
  }

  Future<String> loadDraft(Uuid formUuid, String questionId) async {
    // TODO: retrieve draft data from the sheet
  }
}