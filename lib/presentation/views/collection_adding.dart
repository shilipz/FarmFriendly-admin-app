import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class AddCollection extends StatefulWidget {
  const AddCollection({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCollectionState createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
  FarmNames? selectedFarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightgreen,
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Text("Today's Area", style: commonHeading),
            lheight,
            SizedBox(
              child: Image.asset('assets/202203310807-main.jpg'),
            ),
            lheight,
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Farm Name'),
                  FarmDropdown(
                    selectedFarm: selectedFarm,
                    onFarmChanged: (newFarm) {
                      setState(() {
                        selectedFarm = newFarm;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmDropdown extends StatefulWidget {
  final FarmNames? selectedFarm;
  final void Function(FarmNames?) onFarmChanged;

  FarmDropdown({
    this.selectedFarm,
    required this.onFarmChanged,
    Key? key,
  }) : super(key: key);

  @override
  _FarmDropdownState createState() => _FarmDropdownState();
}

class _FarmDropdownState extends State<FarmDropdown> {
  late FarmNames? _selectedFarm;

  @override
  void initState() {
    super.initState();
    _selectedFarm = widget.selectedFarm;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openFarmSelectionDialog,
      child: Row(
        children: <Widget>[
          Text(_selectedFarm != null
              ? _farmToString(_selectedFarm!)
              : 'Select Farm'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _openFarmSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Farm'),
          content: Column(
            children: FarmNames.values.map((farm) {
              int index = farm.index;
              return CheckboxListTile(
                title: Text(_farmToString(farm)),
                value: _selectedFarm?.index == index,
                onChanged: (bool? value) {
                  setState(() {
                    if (value!) {
                      _selectedFarm = farm;
                    } else {
                      _selectedFarm = null;
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.onFarmChanged(_selectedFarm);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _farmToString(FarmNames farm) {
    switch (farm) {
      case FarmNames.farm1:
        return "Dennis's Farm";
      case FarmNames.farm2:
        return "Shilpa's Farm";
      case FarmNames.farm3:
        return "Niraj's Farm";
      case FarmNames.farm4:
        return "Aromal's Farm";
      case FarmNames.farm5:
        return "Theertha's Farm";
      case FarmNames.farm6:
        return "Beema's Farm";
    }
  }
}

enum FarmNames {
  farm1,
  farm2,
  farm3,
  farm4,
  farm5,
  farm6,
}
