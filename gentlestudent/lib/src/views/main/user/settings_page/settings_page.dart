import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/main_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/constants/color_constants.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/settings_page/widgets/change_profile_picture_dialog.dart';
import 'package:gentlestudent/src/views/main/user/settings_page/widgets/location_permission_dialog.dart';
import 'package:gentlestudent/src/views/main/user/settings_page/widgets/sign_out_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _switchValue = false;

  void _changeTheme(bool balue) {
    setState(() {
      _switchValue = !_switchValue;
    });

    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Future<void> _changeProfilePicture(
    BuildContext context,
    ParticipantBloc bloc,
  ) async {
    ImageSource source = await showChangeProfilePictureDialog(context, bloc);
    if (source != null) {
      final image = await ImagePicker.pickImage(source: source);
      final isSucces = await bloc.changeProfilePicture(image);
      print(isSucces);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _switchValue = Theme.of(context).brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final _mainNavigationBloc = Provider.of<MainNavigationBloc>(context);
    final _oppNavBloc = Provider.of<OpportunityNavigationBloc>(context);
    final _participationBloc = Provider.of<ParticipationBloc>(context);
    final _assertionBloc = Provider.of<AssertionBloc>(context);

    return Scaffold(
      appBar: appBar("Instellingen"),
      body: Column(
        children: <Widget>[
          settingsListTile(
            "Wijzig profielfoto",
            () => _changeProfilePicture(context, _participantBloc),
          ),
          settingsListTile(
            "Donkere modus",
            (bool value) => _changeTheme(value),
            true,
          ),
          settingsListTile(
            "Sta locatie altijd toe",
            () => showLocationPermissionDialog(context),
          ),
          settingsListTile(
            "Meld af",
            () => showSignOutDialog(
              context,
              _participantBloc,
              _mainNavigationBloc,
              _oppNavBloc,
              _assertionBloc,
              _participationBloc,
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsListTile(String title, Function onPressed,
          [bool isSwitch = false]) =>
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black38
                  : primaryTextColor,
            ),
          ),
        ),
        child: ListTile(
          trailing: !isSwitch
              ? Icon(Icons.arrow_forward_ios)
              : Switch(
                  activeColor: Colors.lightBlue,
                  value: _switchValue,
                  onChanged: (bool value) => onPressed(value),
                ),
          title: Text(title),
          onTap: !isSwitch ? onPressed : () => onPressed(false),
        ),
      );
}