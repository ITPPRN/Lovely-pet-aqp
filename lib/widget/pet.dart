import 'package:flutter/material.dart';
import 'package:lovly_pet_app/widget/add_pet.dart';

class PetList extends StatefulWidget {
  const PetList({super.key});

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  void navigateAddPet() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AddPet();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('ddddd'),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        navigateAddPet();
      },
      child: const Icon(Icons.add), // ใส่ไอคอนในปุ่ม
    );
  }
}
