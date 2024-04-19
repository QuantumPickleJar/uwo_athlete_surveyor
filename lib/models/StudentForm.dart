import 'package:athlete_surveyor/models/interfaces/IGenericForm.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:uuid/uuid.dart';

/// A concrete implementation of [IGenericForm], tailored for what students will see.
/// This includes the loading of a form to *take* a survey, as well as the ability to 
/// use the data to render thumbnails (possibly)
/// 
/// Key differences from the [StaffForm] include:
/// Rather than performing sequential *UPDATES* to a form (even if they are spaced out/ use
/// a separate sheet for drafting) to reflect modifications, the form's content is fetched 
/// and cached to the device as a draft FormResult so that the student can return to finish 
/// questions later. 
/// 
/// The nested [ResponseType] is intended be read by something on the UI layer to provide
/// a widget based on the question being viewed.
class StudentForm implements IGenericForm {
  // would a local instance of the form be good to have here?

  

  /// Called when updates to the form's responses have been made 
  @override 
  void saveForm() {
    /// if local cache used, persist any updates to it 
    /// 
    /// (this probably happens in a service, but good to have it noted anyway:)
    /// Student's responses are stored in a table using the question's id )(PK) 
    /// and user's id as an FK (parameter?), if there's any draft there, get them.
    /// Otherwise, (temporarily, until "production" release) we create a new draft 
    /// to store the response until the user withdraws focus from the [Question], 
    /// prompting the draft to be updated.  
    /// 
  }

  /// TODO: verify accuracy of this desc with GPT
  /// using the supplied [formUuid] as an indexing key of sorts, queries the spreadsheet
  /// accordingly so that the content can be loaded 
  @override
  List<Question> loadForm(Uuid formUuid) {
    // TODO: implement loadForm
  
  }
}