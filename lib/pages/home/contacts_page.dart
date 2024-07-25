import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/contacts_bloc.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/pages/home/qr_scanner_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/images.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactsBloc(),
      child: Scaffold(
        appBar: buildDefaultAppBar(
            context: context,
            title: "Contacts",
            iconPath: kAddContactIcon,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRScannerPage()));
            }),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: kMarginMedium3),
          child: Column(
            children: [
              SizedBox(
                height: kMarginMedium,
              ),

              /// Search Bar
              SearchFieldView(),

              SizedBox(
                height: kMarginMedium3,
              ),

              /// Contact List
              Expanded(child: ContactListView())
            ],
          ),
        ),
      ),
    );
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ContactsBloc, List<UserVO>>(
      selector: (context, bloc) => bloc.contacts,
      builder: (context, contacts, child) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kMarginMedium),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F9C9C9C),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(kMarginMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kMarginXLarge2),
                      child: Image.network(
                        contacts[index].profileImage ?? "",
                        height: kMarginXLarge2,
                        width: kMarginXLarge2,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kGreyTextColor,
                          height: kMarginXLarge2,
                          width: kMarginXLarge2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kMarginMedium,
                    ),
                    Text(
                      contacts[index].name ?? "",
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: kTextRegular2X,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: kMarginMedium,
                ),
            itemCount: contacts.length);
      },
    );
  }
}

class SearchFieldView extends StatelessWidget {
  const SearchFieldView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: kMarginMedium2, vertical: kMargin12),
        fillColor: kPrimaryColor.withOpacity(0.21),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kMargin5),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kMargin5),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        prefixIcon: const Icon(CupertinoIcons.search),
        suffixIcon: InkWell(onTap: () {}, child: const Icon(Icons.clear)),
        hintText: "Search",
        hintStyle: TextStyle(
          color: kPrimaryColor.withOpacity(0.5),
          fontSize: kTextRegular2X,
        ),
      ),
    );
  }
}
