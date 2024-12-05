import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';
import '../models/api_model.dart';

class ScreenApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API CRUD')),
      body: BlocBuilder<ApiBloc, ApiState>(
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
                final item = ApiModel.fromJson(state.data[index]);
                return ListTile(
                  title: Text(item.firstName),
                  subtitle: Text(item.lastName),
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
                );
              },
            );
          } else if (state is ApiError) {
            return Center(child: Text('Error: ${state.message}'));
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

  void _showAddDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final edadController = TextEditingController();
    final deporteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Item'),
        content: Column(
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
              controller: edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deporteController,
              decoration: InputDecoration(labelText: 'Deporte'),
            ),
          ],
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
                edad: edadController.text,
                deporte: deporteController.text,
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
    final edadController = TextEditingController(text: item.edad);
    final deporteController = TextEditingController(text: item.deporte);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: Column(
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
              controller: edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deporteController,
              decoration: InputDecoration(labelText: 'Deporte'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ApiBloc>(context).add(UpdateData(ApiModel(
                id: item.id,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                childs: item.childs,
                edad: edadController.text,
                deporte: deporteController.text,
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