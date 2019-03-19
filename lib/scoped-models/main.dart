import 'package:scoped_model/scoped_model.dart';

import './connected_items.dart';
import './user_profile.dart';
import './products_model.dart';
import './accommodation_model.dart';
import './internshipjobs_model.dart';
import './events_model.dart';
import './agent_model.dart';

class MainModel extends Model
    with
        ConnectedItemsModel,
        UserModel,
        UserProfileModel,
        AgentModel,
        ProductsModel,
        AccommodationModel,
        InternshipJobModel,
        EventsModel,
        UtilityModel {}
