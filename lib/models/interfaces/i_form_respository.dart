// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import "package:athlete_surveyor/models/forms/base_form.dart";

// Form repository interface
abstract class IFormRepository {
  Future<GenericForm> createForm(GenericForm form);
  Future<GenericForm?> getFormById(String formId);
  Future<List<GenericForm>> getAllForms();
  Future<void> updateForm(GenericForm form);
  Future<void> deleteForm(String formId);
}