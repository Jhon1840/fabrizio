import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';
import '../models/api_model.dart';
import 'dart:convert';

class ScreenApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API CRUD')),
      body: BlocConsumer<ApiBloc, ApiState>(
        listener: (context, state) {
          if (state is ApiError) {
            _showResultDialog(context, 'Error', state.message);
          } else if (state is ApiLoaded) {
            _showResultDialog(context, 'Success', 'Operation completed successfully');
          }
        },
        builder: (context, state) {
          if (state is ApiInitial) {
            BlocProvider.of<ApiBloc>(context).add(FetchData());
            return Center(child: CircularProgressIndicator());
          } else if (state is ApiLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ApiLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return ListTile(
                  title: Text('${item.firstName} ${item.lastName}'),
                  subtitle: Text('Email: ${item.email ?? "N/A"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(context, item.id),
                      ),
                    ],
                  ),
                  onTap: () => _showItemDetails(context, item),
                );
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, ApiModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Item Details'),
        content: SingleChildScrollView(
          child: Text(
            JsonEncoder.withIndent('  ').convert(item.toJson()),
            style: TextStyle(fontFamily: 'Courier'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ApiBloc>(context).add(AddData(ApiModel(
                id: '',
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                childs: [],
                email: emailController.text,
                password: passwordController.text,
              )));
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ApiModel item) {
    final firstNameController = TextEditingController(text: item.firstName);
    final lastNameController = TextEditingController(text: item.lastName);
    final emailController = TextEditingController(text: item.email);
    final passwordController = TextEditingController(text: item.password);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ApiBloc>(context).add(UpdateData(item.copyWith(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                password: passwordController.text,
              )));
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ApiBloc>(context).add(DeleteData(id));
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

