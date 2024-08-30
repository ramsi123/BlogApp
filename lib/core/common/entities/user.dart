/// originally, this entity class and entities folder is located inside of the auth domain layer. but the problem is,
/// app_user_state.dart class is using this User entity, and that is not allowed. Core cannot depend on other features,
/// but other features can depend on core. so, the solution is to put the entities folder inside of the core folder,
/// so that entity class can be used across the project.
///
/// is it okay to move the entities from domain layer to core? because our domain layer doesn't have entities.
/// the answer is, it is okay.

class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}
