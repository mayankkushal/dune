import 'package:dune/controllers/main_env_controller.dart';
import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvironmentSection extends StatelessWidget {
  final MainEnvController envController = MainEnvController.to;
  final MainTabController tabController = MainTabController.to;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SidebarTitle("Environment"),
        InkWell(
          onTap: () => tabController.addEnvPage(envController.global),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Text('Globals'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    envController.createEnvironment();
                  },
                  icon: Icon(Icons.add))
            ],
          ),
        ),
        Expanded(
          child: GetBuilder<MainEnvController>(
              builder: (_) => envController.envs.length > 0
                  ? ListView.builder(
                      controller: ScrollController(),
                      itemCount: envController.envs.length,
                      itemBuilder: itemBuilder,
                      physics: ClampingScrollPhysics(),
                    )
                  : Text('Create an evironment')),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    var item = envController.envs[index];
    return InkWell(
        onTap: () => tabController.addEnvPage(item),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name),
                Row(
                  children: [
                    Checkbox(
                        value: !item.disabled,
                        onChanged: (value) {
                          value = value as bool;
                          envController.markActive(item);
                        }),
                    IconButton(
                        onPressed: () => envController.deleteEnvironment(item),
                        icon: Icon(Icons.delete_outline)),
                  ],
                )
              ],
            )));
  }
}
