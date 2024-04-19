import 'package:gsheets/gsheets.dart';
import 'package:uuid/uuid.dart';

/// models the drafted response for a form.  To keep things simple, initially we may clone the entire
/// form to store the student's responses, but eventually for performance we'll want to change this to
/// instead only be storing response content *per-[Question]*
class DraftService {
  final Worksheet draftSheet;
  
  DraftService(this.draftSheet);

  Future<void> saveDraft(Uuid formUuid, String questionId, String draftData) async {
    // TODO: TEST THIS 
    // find the right cell based on formUuid and questionId and save draftData
    final row = await draftSheet.values.rowByKey(formUuid.toString() + questionId, fromColumn: 1);
    
    if (row == null) {
      // Append new draft
      await draftSheet.values.appendRow([formUuid, questionId, draftData]);
    } else {
      // TODO: Update existing draft
      // await draftSheet.values.insertValue(draftData, column: 3, row: row);
    }
  }

  Future<String> loadDraft(Uuid formUuid, String questionId) async {
    // TODO: retrieve draft data from the sheet
  }
}