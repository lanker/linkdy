import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkdy/providers/router_provider.dart';
import 'package:linkdy/router/paths.dart';

import 'package:linkdy/widgets/section_label.dart';
import 'package:linkdy/widgets/custom_list_tile.dart';

import 'package:linkdy/providers/app_info_provider.dart';
import 'package:linkdy/utils/open_url.dart';
import 'package:linkdy/constants/strings.dart';
import 'package:linkdy/constants/urls.dart';
import 'package:linkdy/i18n/strings.g.dart';
import 'package:linkdy/providers/api_client_provider.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.settings),
      ),
      body: ListView(
        children: [
          SectionLabel(label: t.settings.appSettings),
          CustomListTile(
            icon: Icons.palette_rounded,
            title: t.settings.customization.customization,
            subtitle: t.settings.customizationDescription,
            onTap: () => ref.read(routerProvider).push(RoutesPaths.customization),
          ),
          CustomListTile(
            icon: Icons.settings_rounded,
            title: t.settings.generalSettings,
            subtitle: t.settings.generalSettingsDescription,
          ),
          FilledButton.icon(
            onPressed: () => ref.read(apiClientProviderProvider.notifier).disconnectApiClient(),
            icon: const Icon(Icons.clear_rounded),
            label: Text(
              t.settings.disconnectFromServer,
            ),
          ),
          SectionLabel(label: t.settings.aboutApp),
          CustomListTile(
            title: t.settings.appVersion,
            subtitle: ref.watch(appInfoProvider).version,
          ),
          CustomListTile(
            title: t.settings.createdBy,
            subtitle: Strings.createdBy,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // if (Platform.isAndroid)
                //   IconButton(
                //     onPressed: () => openUrl(Urls.playStore),
                //     icon: SvgPicture.asset(
                //       'assets/resources/google-play.svg',
                //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                //       width: 30,
                //       height: 30,
                //     ),
                //     tooltip: t.settings.visitGooglePlay,
                //   ),
                IconButton(
                  onPressed: () => openUrl(Urls.gitHubRepo),
                  icon: SvgPicture.asset(
                    'assets/resources/github.svg',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    width: 30,
                    height: 30,
                  ),
                  tooltip: t.settings.visitGitHubRepo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
