import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';

import '../../widgets/ui_elements/item_card.dart';

class InternshipJobsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InternshipJobsPageState();
  }
}

class _InternshipJobsPageState extends State<InternshipJobsPage> {
  Widget _buildJobsList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Future refreshJobs() {
        return model.fetchJobRefreshed().then((_) {
           model.fetchUsers();
           model.fetchUsersPhoto();
          Fluttertoast.showToast(msg: "Jobs Refreshed");
        });
      }

      for (var x = 0; x < model.allJobs.length; x++) {
        for (var y = 0; y < model.allUsersName.length; y++) {
          if (model.allJobs[x].userId == model.allUsersName[y].id) {
            model.allJobs[x].userName = model.allUsersName[y].userName;
          }
        }
      }
       for (var x = 0; x < model.allJobs.length; x++) {
        for (var y = 0; y < model.allUsersPhoto.length; y++) {
          if (model.allJobs[x].userId == model.allUsersPhoto[y].id) {
            model.allJobs[x].userPhotoUrl = model.allUsersPhoto[y].userPhotoUrl;
          }
        }
      }

      Widget content = Center(child: Text('No Jobs Found'));
      if (model.allJobs.length > 0 && !model.isLoading) {
        content = _Jobs(model.allJobs);
      } else if (model.isLoading) {
        content = Center(child: PlatformProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: refreshJobs,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: _buildJobsList());
  }
}

class _Jobs extends StatelessWidget {
  final List<Item> jobs;

  _Jobs(this.jobs);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        void favIconPressed(Item item) {
          model.favoriteJobStatus(item);
        }

        Widget jobsCard;
        if (jobs.length > 0) {
          jobsCard = ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ItemCard(jobs[index], favIconPressed),
            itemCount: jobs.length,
          );
        }
        return jobsCard;
      },
    );
  }
}
