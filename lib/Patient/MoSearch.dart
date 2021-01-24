import 'package:flutter/material.dart';
import 'package:moction/Patient/Patient.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class MoSearch extends SearchDelegate<Patient>
{

  List<Patient> patients;
  // List<Patient> recentSearches;
  String mode;
  ThemeData themeData;

  MoSearch(this.patients,this.mode,{this.themeData});




  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions

    return [
      new IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation
        ),
        onPressed: (){
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final suggestions = query.isEmpty?this.patients: this.patients.where((p){
      return MoNotNull.boolean(p.toSearch().contains(query.toLowerCase()));
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: MoNotNull.widget(ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index){
            return suggestions[index].toWidget(context,mode: this.mode,isSearching: true);
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestions = query.isEmpty?this.patients: this.patients.where((p){
      return MoNotNull.boolean(p.toSearch().contains(query.toLowerCase()));
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: MoNotNull.widget(ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index){
        return suggestions[index].toWidget(context,mode: this.mode,isSearching: true);
      })),
    );
  }




}