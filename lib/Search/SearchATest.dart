import 'package:flutter/material.dart';
import 'package:moction/Test/Test.dart';
import 'package:moction/MoWidgets/MoNotNull.dart';

class SearchATest extends SearchDelegate<Test>
{

  List<Test> tools;
  // List<Patient> recentSearches;

  ThemeData themeData;

  String mode;

  bool isFromShowTests;

  SearchATest(this.tools,this.mode,{this.themeData,this.isFromShowTests});




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
            if(MoNotNull.boolean(this.isFromShowTests)&&suggestions[index].isPrivate()){
              return SizedBox();
            }
            return suggestions[index].toShowTestsWidget(context,mode,closeSearch: ()=>this.closeSearch(context,index));
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
            if(MoNotNull.boolean(this.isFromShowTests)&&suggestions[index].isPrivate()){
              return SizedBox();
            }
            return suggestions[index].toShowTestsWidget(context,mode,closeSearch: ()=>this.closeSearch(context,index));
          })),
    );
  }


  closeSearch(BuildContext context,int index)
  {
    this.close(context, tools[index]);
  }






}