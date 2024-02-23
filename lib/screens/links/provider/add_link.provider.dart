import 'package:flutter/material.dart';
import 'package:linkdy/utils/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:linkdy/screens/links/provider/links.provider.dart';
import 'package:linkdy/screens/links/model/add_link.model.dart';

import 'package:linkdy/i18n/strings.g.dart';
import 'package:linkdy/utils/process_modal.dart';
import 'package:linkdy/models/data/post_bookmark.dart';
import 'package:linkdy/providers/router_provider.dart';
import 'package:linkdy/models/data/bookmarks.dart';
import 'package:linkdy/constants/enums.dart';
import 'package:linkdy/constants/regexp.dart';
import 'package:linkdy/models/api_response.dart';
import 'package:linkdy/models/data/check_bookmark.dart';
import 'package:linkdy/providers/api_client_provider.dart';

part 'add_link.provider.g.dart';

@riverpod
Future<ApiResponse<CheckBookmark>> checkBookmark(CheckBookmarkRef ref, String url) async {
  final result = await ref.watch(apiClientProviderProvider)!.fetchCheckAddBookmark(url: url);
  return result;
}

@riverpod
FutureOr<ApiResponse<Bookmark>> addBookmark(AddBookmarkRef ref, PostBookmark newBookmark) async {
  final result = await ref.watch(apiClientProviderProvider)!.fetchPostBookmark(newBookmark);
  return result;
}

@riverpod
class AddLink extends _$AddLink {
  @override
  AddLinkModel build() {
    return AddLinkModel(
      urlController: TextEditingController(),
      titleController: TextEditingController(),
      descriptionController: TextEditingController(),
      tags: [],
      notesController: TextEditingController(),
    );
  }

  void validateUrl(String value) {
    state.checkBookmark = null;
    state.checkBookmarkLoadStatus = null;
    if (Regexps.urlWithoutProtocol.hasMatch(value)) {
      state.urlError = null;
      ref.notifyListeners();
    } else {
      state.urlError = t.links.addLink.invalidUrl;
      ref.notifyListeners();
    }
  }

  void checkUrlDetails() async {
    if (state.urlError == null && state.urlController.text != "") {
      state.checkBookmarkLoadStatus = LoadStatus.loading;
      state.checkBookmark = null;
      ref.notifyListeners();
      final result = await ref.read(checkBookmarkProvider(state.urlController.text).future);
      if (result.successful == true) {
        state.checkBookmark = result.content;
        state.checkBookmarkLoadStatus = LoadStatus.loaded;
      } else {
        state.checkBookmarkLoadStatus = LoadStatus.error;
      }
      ref.notifyListeners();
    }
  }

  void updateMarkAsUnread(bool value) {
    state.markAsUnread = value;
    ref.notifyListeners();
  }

  void addBookmark() async {
    final newBookmark = PostBookmark(
      url: state.urlController.text,
      title: state.titleController.text != "" ? state.titleController.text : state.checkBookmark?.metadata?.title ?? '',
      description: state.descriptionController.text != ""
          ? state.descriptionController.text
          : state.checkBookmark?.metadata?.description ?? '',
      isArchived: false,
      unread: state.markAsUnread,
      shared: false,
      tagNames: [],
    );

    final processModal = ProcessModal();
    processModal.open(t.links.addLink.savingLink);

    final result = await ref.watch(addBookmarkProvider(newBookmark).future);

    processModal.close();

    if (result.successful == true) {
      ref.invalidate(linksRequestProvider);
      ref.watch(routerProvider).pop();
    } else {
      showSnacbkar(
        label: t.links.addLink.errorSavingLink,
        color: Colors.red,
      );
    }
  }
}
