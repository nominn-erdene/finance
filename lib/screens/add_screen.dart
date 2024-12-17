import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDate {
  String name;
  String fee;
  Timestamp time;
  String image;

  AddDate({
    required this.name,
    required this.fee,
    required this.time,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fee': fee,
      'time': time,
      'image': image,
    };
  }

  factory AddDate.fromMap(Map<String, dynamic> map) {
    return AddDate(
      name: map['name'],
      fee: map['fee'],
      time: map['time'],
      image: map['image'],
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime date = DateTime.now();
  String? selctedItem;
  String? selctedItemi;
  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  List<Map<String, String>> items = [];
  final List<String> incomeExpense = ['Орлого', 'Зарлага'];

  @override
  void initState() {
    super.initState();
    amountFocusNode.addListener(() => setState(() {}));
    fetchExpenses();
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchExpenses() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Expenses').get();

      final List<Map<String, String>> fetchedItems =
          querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'] as String,
          'image': doc['image'] as String,
        };
      }).toList();

      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch expenses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: mainContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Container mainContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 520,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          buildDropdownField(
            label: "Гүйлгээний нэр",
            value: selctedItem,
            items: items,
            onChanged: (value) => setState(() => selctedItem = value),
          ),
          const SizedBox(height: 30),
          buildTextField(
            label: "Үнийн дүн",
            controller: amountController,
            focusNode: amountFocusNode,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          buildDropdownField(
            label: "Орлого/Зарлага",
            value: selctedItemi,
            items: incomeExpense.map((e) => {'name': e}).toList(),
            onChanged: (value) => setState(() => selctedItemi = value),
          ),
          const SizedBox(height: 30),
          dateSelector(),
          const Spacer(),
          saveButton(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  GestureDetector saveButton() {
    return GestureDetector(
      onTap: () async {
        if (selctedItem == null || selctedItemi == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fill all fields')),
          );
          return;
        }

        var newEntry = AddDate(
          name: selctedItem!,
          fee: amountController.text,
          time: Timestamp.fromDate(date),
          image:
              items.firstWhere((item) => item['name'] == selctedItem)['image']!,
        );

        String collectionName =
            selctedItemi == 'Income' ? 'Incomes' : 'Expenses';

        try {
          await FirebaseFirestore.instance
              .collection(collectionName)
              .add(newEntry.toMap());
          Navigator.of(context).pop();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: $e')),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: const Text(
          'Нэмэх',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['name'],
              child: Row(
                children: [
                  if (item['image'] != null)
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.network(item['image']!),
                    ),
                  const SizedBox(width: 10),
                  Text(item['name']!, style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }).toList(),
          hint: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Widget dateSelector() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newDate != null) {
            setState(() => date = newDate);
          }
        },
        child: Text(
          'Date: ${date.year}/${date.month}/${date.day}',
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  Widget backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Нэмэх',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: label,
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Color(0xff368983)),
          ),
        ),
      ),
    );
  }
}
