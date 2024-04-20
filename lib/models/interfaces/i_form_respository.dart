import "package:athlete_surveyor/models/forms/base_form.dart";

// Form repository interface
abstract class IFormRepository {
  Future<Form> createForm(Form form);
  Future<Form?> getFormById(String formId);
  Future<List<Form>> getAllForms();
  Future<void> updateForm(Form form);
  Future<void> deleteForm(String formId);
}