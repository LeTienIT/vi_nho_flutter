import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/db_constants.dart';
import '../viewmodels/settingVM.dart';
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
            initiallyExpanded: true,
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
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 28),
                child: Builder(
                  builder: (context) {
                    final settingVM = context.watch<SettingVM>();

                    final showTitle = (settingVM.getSync(SettingKey.showChartTitle) ?? 'true') == 'true';

                    return SwitchListTile(
                      title: Text('Hiển thị % trong biểu đồ'),
                      value: showTitle,
                      onChanged: (bool value) {
                        context.read<SettingVM>().setBool(SettingKey.showChartTitle, value);
                      },
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 28),
                child: Builder(
                  builder: (context) {
                    final settingVM = context.watch<SettingVM>();

                    final showTotalIn = (settingVM.getSync(SettingKey.showTotalIn) ?? 'true') == 'true';

                    return SwitchListTile(
                      title: Text('Hiển thị đường thu trong biểu đồ'),
                      value: showTotalIn,
                      onChanged: (bool value) {
                        context.read<SettingVM>().setBool(SettingKey.showTotalIn, value);
                      },
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}