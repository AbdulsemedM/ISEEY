import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TermsCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({super.key, required this.onChanged});

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 0, 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: AppColors.mainTextColorWhite,
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isAgree = !isAgree;
              widget.onChanged(isAgree);
            });
          },
          child: Row(
            children: [
              isAgree
                  ? Image.asset(AssetsConstant.selectedCheckbox, width: 20, height: 20)
                  : Image.asset(AssetsConstant.unselectedCheckbox, width: 20, height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text.rich(
                    TextSpan(
                      text: L10n.current.sign_up_terms_of_use_agreement_text + ' ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: AppColors.mainTextColorWhite,
                      ),
                      children: <WidgetSpan>[
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => launchURL("https://iseey.app/privacy/"),
                            child: GlobalWidgets.setText(
                              L10n.current.sign_up_terms_of_use_title,
                              textAlign: TextAlign.left,
                              strTextColor: AppColors.strMainTextColorWhite,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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