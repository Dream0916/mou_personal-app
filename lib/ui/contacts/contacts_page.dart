import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/ui/base/base_widget.dart';
import 'package:mou_app/ui/contacts/components/contact_app_bar.dart';
import 'package:mou_app/ui/contacts/components/contact_item.dart';
import 'package:mou_app/ui/contacts/contacts_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';
import 'package:mou_app/utils/app_characters_vn_utils.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_constants.dart';
import 'package:mou_app/utils/app_font_size.dart';
import 'package:mou_app/utils/app_images.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatelessWidget {
  final List<Contact>? contactsSelected;

  const ContactsPage({this.contactsSelected});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ContactsViewModel>(
      viewModel: ContactsViewModel(
        contactRepository: Provider.of(context),
        contactDao: Provider.of(context),
      ),
      onViewModelReady: (viewModel) => viewModel..initData(contactsSelected ?? []),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(gradient: AppColors.bgGradient),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: <Widget>[
                ContactAppBar(
                  onSearchPressed: viewModel.search,
                  onAcceptPressed: () => Navigator.pop(
                    context,
                    viewModel.contactsSelected,
                  ),
                ),
                Image.asset(
                  AppImages.imgMouYellow,
                  height: 18,
                  color: const Color(0xFFCFCFCF),
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(context, viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ContactsViewModel viewModel) {
    return StreamBuilder<bool>(
      stream: viewModel.loadingSubject,
      builder: (context, snapShot) {
        final bool isLoading = snapShot.data ?? true;
        return StreamBuilder<List<Contact>>(
          stream: viewModel.filterContacts,
          builder: (context, snapShot) {
            final List<Contact>? contacts = snapShot.data ?? null;
            if (isLoading || contacts == null) {
              return const AppLoadingIndicator();
            } else {
              return StreamBuilder<List<Contact>>(
                stream: viewModel.contactsSelectedSubject,
                builder: (context, snapShot) {
                  return AnimationList(
                    duration: AppConstants.ANIMATION_LIST_DURATION,
                    reBounceDepth: AppConstants.ANIMATION_LIST_RE_BOUNCE_DEPTH,
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: contacts.map((contact) {
                      final Widget contactItem = ContactItem(
                        contact: contact,
                        isSelected: viewModel.checkSelected(contact),
                        onItemPressed: viewModel.setContactSelected,
                      );

                      final String firstCharName = contact.name?.split('').first ?? '';
                      String firstChar = VNCharacterUtils.removeAccents(firstCharName);

                      final int index = contacts.indexOf(contact);
                      if (index > 0) {
                        final Contact prevContact = contacts[index - 1];
                        final String prevFirstCharName = prevContact.name?.split('').first ?? '';
                        final String prevFirstChar =
                            VNCharacterUtils.removeAccents(prevFirstCharName);
                        if (prevFirstChar == firstChar) {
                          firstChar = '';
                        }
                      }
                      return firstChar.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30, top: 2),
                                  child: Text(
                                    firstChar.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: AppFontSize.textTitlePage,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                contactItem,
                              ],
                            )
                          : contactItem;
                    }).toList(),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
