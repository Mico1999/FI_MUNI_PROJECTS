import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/common/widget/poster.dart';

class CelebrityEditPage extends StatefulWidget {
  final Celebrity? celebrity;
  final celebrityService = GetIt.I.get<CelebrityService>();
  final storageService = GetIt.I.get<FireStorage>();

  CelebrityEditPage({super.key, required this.celebrity});

  @override
  State<CelebrityEditPage> createState() => _CelebrityEditPage();
}

class _CelebrityEditPage extends State<CelebrityEditPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _aboutSectionController = TextEditingController();
  final _birthDayController = TextEditingController();
  final _deathController = TextEditingController();
  final _imagePicker = ImagePicker();
  String _avatar = "";
  DateTime _birthDay = DateTime.now();
  DateTime _died = DateTime.now();

  @override
  void initState() {
    // birthday field must be always filled
    _birthDayController.text = DateTime.now().toString().split(" ")[0];

    if (widget.celebrity != null) {
      _firstNameController.text = widget.celebrity!.firstName;
      _lastNameController.text = widget.celebrity!.lastName;
      _aboutSectionController.text = widget.celebrity!.about;
      _birthDayController.text =
          widget.celebrity!.birthDay.toString().split(" ")[0];
      _avatar = widget.celebrity!.avatar;
      _birthDay = widget.celebrity!.birthDay;
      if (widget.celebrity!.died != null) {
        _died = widget.celebrity!.died!;
        _deathController.text = widget.celebrity!.died.toString().split(" ")[0];
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return PageTemplate(
      title: (widget.celebrity == null)
          ? "Create Celebrity"
          : "${widget.celebrity!.firstName} ${widget.celebrity!.lastName}",
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Poster(posterUrl: _avatar, height: 230.0),
            ),
            _buildSaveButton(),
            _buildTextField("First Name", _firstNameController),
            _buildTextField("Last Name", _lastNameController),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: _buildBirthDayPicker()),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Flexible(child: _buildDeathPicker())
                ],
              ),
            ),
            _buildTextField("About", _aboutSectionController),
            _buildImagePicker("Avatar:", Icons.image_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        onPressed: () async {
          final died = _deathController.text.isEmpty ? null : _died;

          if (widget.celebrity == null) {
            final celebrity = Celebrity(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                birthDay: _birthDay,
                died: died,
                about: _aboutSectionController.text,
                avatar: _avatar,
                movieIdsWithRole: null,
                id: null);
            await widget.celebrityService.add(celebrity);
          } else {
            await widget.celebrityService.updateCelebrity(
                widget.celebrity!.id!,
                _firstNameController.text,
                _lastNameController.text,
                _aboutSectionController.text,
                _avatar,
                _birthDay,
                died);
          }

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, "/");
          }
        },
        icon: const Icon(
          Icons.save,
          size: 35,
        ),
        label: const Text("Save"));
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$hint:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(hintText: hint),
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDayPicker() {
    return TextField(
      controller: _birthDayController,
      decoration: const InputDecoration(
        labelText: "BirthDay",
        filled: true,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final birthDay = await showDatePicker(
            context: context,
            initialDate: (widget.celebrity == null)
                ? _birthDay
                : widget.celebrity!.birthDay,
            firstDate: DateTime(1900),
            lastDate: DateTime.now());

        if (birthDay != null) {
          setState(() {
            _birthDay = birthDay;
            _birthDayController.text = birthDay.toString().split(" ")[0];
          });
        }
      },
    );
  }

  Widget _buildDeathPicker() {
    return TextField(
      controller: _deathController,
      decoration: InputDecoration(
        labelText: "Death",
        filled: true,
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _deathController.clear();
              _died = DateTime.now();
            });
          },
          tooltip: "Clear date",
          icon: const Icon(
            Icons.cancel_outlined,
          ),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? deathDate;
        if (widget.celebrity != null) {
          if (widget.celebrity!.died != null) {
            deathDate = widget.celebrity!.died!;
          }
        }
        final death = await showDatePicker(
            context: context,
            initialDate: (deathDate != null) ? deathDate : _died,
            firstDate: DateTime(1900),
            lastDate: DateTime.now());

        if (death != null) {
          setState(() {
            _died = death;
            _deathController.text = death.toString().split(" ")[0];
          });
        }
      },
    );
  }

  Widget _buildImagePicker(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text(text),
          TextButton(
            onPressed: () async {
              final image =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              widget.storageService.uploadImageFile(image);
              setState(() {
                _avatar = image.name;
              });
            },
            child: Icon(
              icon,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
