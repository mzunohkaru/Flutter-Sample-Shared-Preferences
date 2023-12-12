import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_sample/utils/user_simple_preferences.dart';
import 'package:shared_sample/widget/button_widget.dart';
import 'package:shared_sample/widget/pets_buttons_widget.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class UserPage extends StatefulWidget {
  final String idUser;

  const UserPage({
    Key? key,
    this.idUser = "",
  }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  late bool isOn;
  List<String> pets = [];
  late DateTime setDate;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    name = UserSimplePreferences.getUsername() ?? '';
    isOn = UserSimplePreferences.getSwitch() ?? true;
    pets = UserSimplePreferences.getPets() ?? [];
    setDate = UserSimplePreferences.getBirthday() ?? DateTime.now();
    if (UserSimplePreferences.getImage() != null) {
      String? imagePath = UserSimplePreferences.getImage();
      imageFile = File(imagePath!);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('SharedPreferences'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 32),
              buildName(),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              buildSwitch(),
              const SizedBox(height: 12),
              buildPets(),
              const SizedBox(height: 12),
              buildDateTimeButton(),
              const SizedBox(height: 12),
              buildImage(),
              const SizedBox(height: 32),
              buildButton(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );

  Widget buildName() => buildTitle(
        title: 'Name',
        child: TextFormField(
          initialValue: name,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Name',
          ),
          onChanged: (name) => setState(() => this.name = name),
          // 自動保存
          // onChanged: (name) async {
          //   await UserSimplePreferences.setUsername(name);
          // },
        ),
      );

  Widget buildSwitch() => buildTitle(
        title: 'On / Off',
        child: CupertinoSwitch(
          value: isOn,
          onChanged: (value) => setState(() => isOn = value),
        ),
      );

  Widget buildPets() => buildTitle(
        title: 'Pets',
        child: PetsButtonsWidget(
          pets: pets,
          onSelectedPet: (pet) => setState(
              () => pets.contains(pet) ? pets.remove(pet) : pets.add(pet)),
        ),
      );

  Widget buildDateTimeButton() => buildTitle(
        title: 'birthday',
        child: ElevatedButton(
          onPressed: () {
            picker.DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                onChanged: (_) {},
                onConfirm: (date) => setState(() => setDate = date),
                minTime: DateTime.now(),
                maxTime: DateTime(2030, 6, 7, 05, 09),
                currentTime: DateTime.now(),
                locale: picker.LocaleType.jp);
          },
          child: Text(
            DateFormat('yyyy年M月d日(EEEE)h時m分').format(setDate),
          ),
        ),
      );

  Widget buildImage() => buildTitle(
        title: '画像保存',
        child: IconButton(
          onPressed: getImage,
          icon: imageFile != null
              ? Image.file(imageFile!)
              : const Icon(
                  Icons.image,
                  size: 80,
                ),
        ),
      );

  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await UserSimplePreferences.saveUsername(name);
        await UserSimplePreferences.saveSwitch(isOn);
        await UserSimplePreferences.savePets(pets);
        await UserSimplePreferences.saveBirthday(setDate);
        if (imageFile != null) {
          await UserSimplePreferences.saveImage(imageFile!.path);
        }
      });

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      imageFile = File(pickerFile.path);
      setState(() {});
    }
  }
}
