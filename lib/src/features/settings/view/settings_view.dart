import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/features/settings/viewmodel/settings_cubit.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage(name: 'SettingsRoute')
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<SettingsCubit>(context);
    _cubit.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.textTheme.labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: context.padding2,
        width: context.width,
        height: context.height,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  LocaleKeys.settings_distance_filter.tr(),
                  style: context.textTheme.bodyLarge,
                ),
                const Spacer(),
                SizedBox(
                  width: 100.w,
                  child: CustomDropdown<int>(
                    canCloseOutsideBounds: true,
                    closedFillColor: context.colorScheme.onPrimary,
                    expandedFillColor: context.colorScheme.onPrimary,
                    onChanged: (p0) => {},
                    initialItem: _cubit.distanceDropdownList[0],
                    items: _cubit.distanceDropdownList,
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  LocaleKeys.settings_select_location.tr(),
                  style: context.textTheme.bodyLarge,
                ),
                const Spacer(),
                SizedBox(
                  width: 150.w,
                  child: CustomDropdown<String>(
                    canCloseOutsideBounds: true,
                    closedFillColor: context.colorScheme.onPrimary,
                    expandedFillColor: context.colorScheme.onPrimary,
                    onChanged: (p0) => {},
                    initialItem: _cubit.locationDropdownList[0],
                    items: _cubit.locationDropdownList,
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  LocaleKeys.settings_change_language.tr(),
                  style: context.textTheme.bodyLarge,
                ),
                const Spacer(),
                SizedBox(
                  width: 120.w,
                  child: CustomDropdown<String>(
                    canCloseOutsideBounds: true,
                    closedFillColor: context.colorScheme.onPrimary,
                    expandedFillColor: context.colorScheme.onPrimary,
                    onChanged: (p0) => {},
                    initialItem: _cubit.languageDropdownList[0],
                    items: _cubit.languageDropdownList,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
