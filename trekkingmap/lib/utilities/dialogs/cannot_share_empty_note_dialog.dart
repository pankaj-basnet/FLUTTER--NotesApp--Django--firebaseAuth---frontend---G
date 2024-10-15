// import 'package:flutter/widgets.dart'; // not for BuildContext
import 'package:flutter/material.dart'; // pac--> BuildContext
import 'package:trekkingmap/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
