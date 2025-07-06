import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/Table/view/widgets/table_user_item.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/generated/l10n.dart';

class TableListItem extends StatelessWidget {
  final CheckIns result;

  const TableListItem({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
        depth: -3,
        lightSource: LightSource.top,
        color: AppColors.listBoxBackgroundColor,
        border: NeumorphicBorder(
          color: AppColors.innerShadowColor,
          width: 1,
        ),
        shadowDarkColor: AppColors.innerShadowColor,
        shadowLightColorEmboss: Colors.transparent,
        shadowDarkColorEmboss: AppColors.innerShadowColor,
      ),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 80,
                child: GlobalWidgets.setText(
                  L10n.current.table_list_table_number('\n', result.iId),
                  textAlign: TextAlign.center,
                  fontSize: 20,
                  maxLine: 2,
                  strTextColor: AppColors.strMainTextColorWhite,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.listBoxBackgroundColor,
                      AppColors.mainTextColorWhite,
                      AppColors.listBoxBackgroundColor,
                    ],
                  ),
                ),
                width: 1,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: List<Widget>.generate(
                      result.users.length,
                      (int index) => TableUserItem(
                        user: result.users[index],
                        showDivider: index != 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}