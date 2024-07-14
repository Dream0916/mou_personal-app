import 'package:mou_app/core/databases/app_database.dart';
import 'package:mou_app/core/databases/dao/contact_dao.dart';
import 'package:mou_app/core/repositories/contact_repository.dart';
import 'package:mou_app/ui/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class ContactsViewModel extends BaseViewModel {
  final _contactsSubject = BehaviorSubject<List<Contact>>.seeded([]);
  final _contactsSelectedSubject = BehaviorSubject<List<Contact>>.seeded([]);
  final _querySubject = BehaviorSubject<String>.seeded('');

  final ContactRepository contactRepository;
  final ContactDao contactDao;

  ContactsViewModel({
    required this.contactRepository,
    required this.contactDao,
  });

  void initData(List<Contact> contactsSelected) async {
    _contactsSelectedSubject.add(contactsSelected);
    setLoading(true);
    final List<Contact> contactsLocal = await contactDao.getAllContacts();
    if (contactsLocal.isNotEmpty) {
      _contactsSubject.add(contactsLocal);
    } else {
      final response = await contactRepository.getAllContact();
      if (response.isSuccess) {
        final List<Contact> contacts = response.data ?? [];
        _contactsSubject.add(contacts);
      }
    }
    setLoading(false);
  }

  void setContactSelected(Contact contact) {
    final List<Contact> contactsSelected = _contactsSelectedSubject.value;
    int isExist = contactsSelected.indexWhere((item) => item.id == contact.id);
    if (isExist >= 0) {
      contactsSelected.removeAt(isExist);
    } else {
      contactsSelected.add(contact);
    }
    _contactsSelectedSubject.add(contactsSelected);
  }

  bool checkSelected(Contact contact) {
    final List<Contact> contactsSelected = _contactsSelectedSubject.value;
    if (contactsSelected.isEmpty) return false;
    return contactsSelected.indexWhere((item) => item.id == contact.id) >= 0;
  }

  void search(String text) => _querySubject.add(text);

  List<Contact> get contactsSelected => _contactsSelectedSubject.value;

  Stream<List<Contact>> get contactsSelectedSubject => _contactsSelectedSubject;

  Stream<List<Contact>> get filterContacts => CombineLatestStream.combine2(
        _contactsSubject,
        _querySubject,
        (contacts, query) {
          if (query.isEmpty) return contacts;
          return contacts
              .where((contact) =>
                  contact.name!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
      );

  @override
  void dispose() {
    _contactsSubject.close();
    _contactsSelectedSubject.close();
    _querySubject.close();
    super.dispose();
  }
}
