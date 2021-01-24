import 'package:flutter/material.dart';
import 'package:moction/Test/SubTest.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class SearchASub extends SearchDelegate<SubTest>
{

  List<SubTest> tools;
  // List<Patient> recentSearches;

  ThemeData themeData;

  SearchASub(this.tools,{this.themeData});




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
    final suggestions = query.isEmpty?this.tools: this.tools.where((t){
      return MoNotNull.boolean(t.toSearch().contains(query.toLowerCase()));
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: MoNotNull.widget(ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index){
            return suggestions[index].toSearchWidget(onTap(context,suggestions[index]));
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestions = query.isEmpty?this.tools: this.tools.where((t){
      return MoNotNull.boolean(t.toSearch().contains(query.toLowerCase()));
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: MoNotNull.widget(ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index){
            return suggestions[index].toSearchWidget(()=> onTap(context,suggestions[index]));
          })),
    );
  }


  onTap(context,SubTest tool)
  {
    super.close(context, tool);
  }


}