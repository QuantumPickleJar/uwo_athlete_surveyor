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

}