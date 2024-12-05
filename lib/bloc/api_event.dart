import '../models/api_model.dart';

abstract class ApiEvent {}

class FetchData extends ApiEvent {}

class AddData extends ApiEvent {
  final ApiModel data;
  AddData(this.data);
}

class UpdateData extends ApiEvent {
  final ApiModel data;
  UpdateData(this.data);
}

class DeleteData extends ApiEvent {
  final String id;
  DeleteData(this.id);
}