import 'package:flutter/material.dart';

import '../../utils/constants/constants.dart';

class PendingApprovalWidget extends StatelessWidget {
  const PendingApprovalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
        child: Text('Pending Approvals Content', style: mediumtext),
      ),
    );
  }
}
