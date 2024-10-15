
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ResizedImage;
import 'package:image_picker/image_picker.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> chipList;
  final Function(List<String>, List<ResizedImage.Image>) onSelectionChanged;

  MultiSelectChip(this.chipList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChip = List();
  List<ResizedImage.Image> selectedImage = List();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChipList(),
    );
  }

  List _buildChipList() {
    List<Widget> choices = List();

    widget.chipList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyleData.boldBeyaz,
          backgroundColor: ColorData.renkKirmizi,
          selectedColor: ColorData.renkKoyuYesil,
          selected: selectedChip.contains(item),
          onSelected: (selected) {
            _pickProfileImage(item);
          },
        ),
      ));
    });
    return choices;
  }

  void _pickProfileImage(String item) async {
    final imageSource = await showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
              body: "Devam etmek için seçim yapınız.",
              buttonText: "Galeriden Seç",
              button2Text: "Fotoğraf Çek",
              dialogKind: "ImagePick",
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        ResizedImage.Image image = ResizedImage.decodeImage(file.readAsBytesSync());
        ResizedImage.Image thumb = ResizedImage.copyResize(image,height: 720,width: -1);
        setState(() {
          if (selectedChip.contains(item)) selectedChip.remove(item);
          selectedChip.add(item);

          selectedImage.add(thumb);
          widget.onSelectionChanged(selectedChip, selectedImage);
        });
      }
    }
  }
}
