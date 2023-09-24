import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vistas_amatista/blocs/group_blocs/group_menu/group_menu_bloc.dart';
import 'package:vistas_amatista/models/contact.dart';
import 'package:vistas_amatista/resources/colors/default_theme.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_appbar.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_button.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_formfield.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_list_item_card.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_pop_up_menu.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_snackbar.dart';
import 'package:vistas_amatista/resources/custom_widgets/msos_text.dart';

/* Vista de configuración para el disparador/activador de alerta provocado
por una desconexión a internet.*/

class GroupMenuScreen extends StatelessWidget {
  const GroupMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Obtaining screen dimensions for easier to read code.
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height - 60;
    MSosPopUpMenu popUpFlushMenu;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    popUpFlushMenu = MSosPopUpMenu(context, formKey: formKey, formChildren: const [
      MSosText("Nombre:"),
      MSosFormField(),
      MSosText("Teléfono"),
      MSosFormField(inputType: TextInputType.phone),
    ]);

    return BlocBuilder<GroupMenuBloc, GroupMenuState>(
      builder: (context, state) {
        // We read if either is the Edition Screen or the Creation Screen
        bool isEdition = state.isGroupEditionContext;
        // Inicialization of some variables for widgets that need re renderization to work

        return Scaffold(
          resizeToAvoidBottomInset: true, //Used to not resize when keyboard appears
          appBar: MSosAppBar(title: isEdition ? "Editar Grupo" : "Crear Grupo", icon: Icons.crisis_alert),
          body: Container(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, screenWidth * 0.08, 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          MSosText(
                            isEdition ? state.group!.name : "Nuevo Grupo",
                            style: MSosText.subtitleStyle,
                            icon: Icons.add_circle_rounded,
                          ),
                          const SizedBox(height: 20),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const MSosText("Nombre del Grupo"),
                            MSosFormField(initialValue: isEdition ? state.group!.name : "Nuevo Grupo"),
                            const SizedBox(height: 10),
                            const MSosText("Lista de contactos"),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: state.group!.contacts.length * 70,
                              child: ListView.separated(
                                itemCount: state.group!.contacts.length,
                                separatorBuilder: (BuildContext context, int index) => const Divider(
                                  height: 8,
                                  color: MSosColors.white,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  // We get the contact from the map list contained by group under the name of contacts
                                  Contact contact = Contact.fromJson(state.group!.contacts[index]);
                                  return MSosListItemCard(title: contact.name, callback: () {});
                                },
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.person_add_rounded),
                                onPressed: () {
                                  if (state.group!.contacts.length > 5) {
                                    MSosSnackBar.showInfoMessage(context,
                                        message: "Solo puedes añadir un máximo de 5 contactos", title: "Lo sentimos...");
                                  } else {
                                    // ignore: avoid_single_cascade_in_expression_statements
                                    popUpFlushMenu.showPopUpMenu(context);
                                  }
                                },
                                color: MSosColors.white,
                                style: IconButton.styleFrom(
                                    elevation: 2,
                                    shadowColor: MSosColors.grayLight,
                                    backgroundColor: state.group!.contacts.length <= 5 ? MSosColors.blue : MSosColors.grayLight)),
                            const SizedBox(height: 10),
                            MSosButton(
                              text: "Guardar",
                              style: MSosButton.smallButton,
                              color: MSosColors.blue,
                              callbackFunction: () {
                                //TODO: Guardad la configuración en SharedPreferences y en Firebase
                              },
                            )
                          ])
                        ]),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  TextFormField getFormField(String text) {
    return TextFormField(
      initialValue: text,
      style: const TextStyle(color: Colors.white),
      maxLength: 100,
      maxLines: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
          fillColor: Colors.white10,
          filled: true,
          icon: Icon(
            Icons.label,
            color: Colors.grey[500],
          ),
          border: const UnderlineInputBorder(),
          helperText: "Helper Text",
          helperStyle: const TextStyle(color: Colors.grey),
          labelText: "Label Text",
          labelStyle: const TextStyle(color: Colors.grey)),
    );
  }
}