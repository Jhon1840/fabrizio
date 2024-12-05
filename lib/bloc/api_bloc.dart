import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_event.dart';
import 'api_state.dart';
import '../models/api_model.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial()) {
    on<FetchData>(_onFetchData);
    on<AddData>(_onAddData);
    on<UpdateData>(_onUpdateData);
    on<DeleteData>(_onDeleteData);
  }

  final String _baseUrl = 'https://674869495801f5153590c2a3.mockapi.io/api/v1/renatoia';

  Future<void> _onFetchData(FetchData event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        emit(ApiLoaded(data.map((item) => ApiModel.fromJson(item)).toList()));
      } else {
        emit(ApiError('Failed to fetch data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ApiError('Error fetching data: ${e.toString()}'));
    }
  }

  Future<void> _onAddData(AddData event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.data.toJson()),
      );
      if (response.statusCode == 201) {
        add(FetchData());
      } else {
        emit(ApiError('Failed to add data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ApiError('Error adding data: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateData(UpdateData event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${event.data.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.data.toJson()),
      );
      if (response.statusCode == 200) {
        add(FetchData());
      } else {
        emit(ApiError('Failed to update data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ApiError('Error updating data: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteData(DeleteData event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/${event.id}'));
      if (response.statusCode == 200) {
        add(FetchData());
      } else {
        emit(ApiError('Failed to delete data: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ApiError('Error deleting data: ${e.toString()}'));
    }
  }
}