import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/themeVM.dart';
import '../widgets/dashboard/menu.dart';

class SettingView extends StatefulWidget{
  const SettingView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingView();
  }

}
class _SettingView extends State<SettingView>{
  @override
  Widget build(BuildContext context) {
    bool light = context.watch<ThemeVM>().isDark;
    return Scaffold(
      appBar: AppBar(title: Text('Cài đặt',)),
      drawer: Drawer(child: Menu(),),
      body: ListView(
        children: [
          ExpansionTile(
            // collapsedBackgroundColor: Theme.of(context).colorScheme.onSurface,
            // backgroundColor: Theme.of(context).colorScheme.onSurface,
            leading: Icon(Icons.palette),
            title: Text('Giao diện'),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 28),
                child: SwitchListTile(
                  title: Text('Chế độ nền tối',),
                  value: light,
                  onChanged: (bool value){
                    ThemeVM().setTheme(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}