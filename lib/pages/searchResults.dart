import 'package:flutter/material.dart';
import 'editDeckPage.dart';

class SearchResults extends StatefulWidget {
  final String searchInput;
  final Map decks;
  final List deckNames;
  final Map myDictionary;

  const SearchResults({
    super.key,
    required this.searchInput,
    required this.decks,
    required this.deckNames,
    required this.myDictionary
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search"),
      ),

      body: Column(
        children: [
          searchData(widget.searchInput)["length"] == 0
            ?
              Text("No results matched your search. Try checking your spelling.")
            :
              Expanded(
                child: ListView.builder(
                  itemCount: searchData(widget.searchInput)["length"],
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(20.0),
                    width: double.infinity,
                    child: 
                      searchData(widget.searchInput)["decks"].length > index
                        ?
                          // Make deck results
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            // Uses Material for InkWell and also better UI.
                            child: Material(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(5.0),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: EdgeInsets.all(0.0),
                                // Uses Stack so the practice button InkWell doesn't be weird with the card InkWell.
                                child: Stack(
                                  children: [
                                    // Positioned.fill so the whole card is clickable.
                                    Positioned.fill(
                                      child: InkWell(
                                        onTap: () {
                                          // Go to the page that shows all the vocab in this deck.
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditDeckPage(
                                                // Gives the page the data to show.
                                                deckName: searchData(widget.searchInput)["decks"][index],
                                                deckNames: widget.deckNames,
                                                deck: widget.decks[searchData(widget.searchInput)["decks"][index]],
                                                decks: widget.decks,
                                                myDictionary: widget.myDictionary
                                              )
                                            )
                                          );
                                        },
                                        child: SizedBox.expand() // Makes it so the InkWell takes up the whole Positioned.fill.
                                      )
                                    ),
                                    // IgnorePointer so that the title and description boxes don't block the InkWell.
                                    IgnorePointer(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(searchData(widget.searchInput)["decks"][index]),
                                            Text(widget.decks[searchData(widget.searchInput)["decks"][index]]["description"])
                                          ],
                                        )
                                      ),
                                    ),
                                    // The practice button at the top right of the card.
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: Text("Practice")
                                      )
                                    )
                                  ],
                                ),
                              )
                            )
                          )
                        :
                          searchData(widget.searchInput)["decks"].length == index
                            ?
                              // My Dictionary
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                // Uses Material for InkWell and also better UI.
                                child: Material(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(5.0),
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    // Uses Stack so the practice button InkWell doesn't be weird with the card InkWell.
                                    child: Stack(
                                      children: [
                                        // Positioned.fill so the whole card is clickable.
                                        Positioned.fill(
                                          child: InkWell(
                                            onTap: () {
                                              // Go to the page that shows all the vocab in this deck.
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditDeckPage(
                                                    // Gives the page the data to show.
                                                    deckName: "My Dictionary",
                                                    deckNames: widget.deckNames,
                                                    deck: widget.decks["My Dictionary"],
                                                    decks: widget.decks,
                                                    myDictionary: widget.myDictionary
                                                  )
                                                )
                                              );
                                            },
                                            child: SizedBox.expand() // Makes it so the InkWell takes up the whole Positioned.fill.
                                          )
                                        ),
                                        // IgnorePointer so that the title and description boxes don't block the InkWell.
                                        IgnorePointer(
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('"' + widget.searchInput.toString() + '"' + ' was found in deck "My Dictionary"')
                                              ],
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                )
                              )
                            :
                              // Vocab
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                // Uses Material for InkWell and also better UI.
                                child: Material(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(5.0),
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    // Uses Stack so the practice button InkWell doesn't be weird with the card InkWell.
                                    child: Stack(
                                      children: [
                                        // Positioned.fill so the whole card is clickable.
                                        Positioned.fill(
                                          child: InkWell(
                                            onTap: () {
                                              final String targetDeckName = searchData(widget.searchInput)["vocab"][index - (searchData(widget.searchInput)["decks"].length)][0].toString();
                                                
                                              // Go to the page that shows all the vocab in this deck.
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditDeckPage(
                                                    // Gives the page the data to show.
                                                    deckName: targetDeckName,
                                                    deckNames: widget.deckNames,
                                                    deck: widget.decks[targetDeckName],
                                                    decks: widget.decks,
                                                    myDictionary: widget.myDictionary
                                                  )
                                                )
                                              );
                                            },
                                            child: SizedBox.expand() // Makes it so the InkWell takes up the whole Positioned.fill.
                                          )
                                        ),
                                        // IgnorePointer so that the title and description boxes don't block the InkWell.
                                        IgnorePointer(
                                          child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('"' + widget.searchInput.toString() + '"' + ' was found in deck ' + '"' + searchData(widget.searchInput)["vocab"][index - (searchData(widget.searchInput)["decks"].length + 1)][0].toString() + '"')
                                              ],
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                )
                              )
                  )
                )
              )
        ],
      ),
    );
  }

  Map searchData(String searchInput) {
    // Scan deck names if there are decks created
    // Scan My Dictionary
    // Scan all decks (only if found in My Dictionary)

    Map<String, dynamic> results = {
      "decks": [],
      "My Dictionary": false,
      "vocab": [],
      "length": 0
    };

    for(var i = 1; i < widget.deckNames.length; i++) {
      if(widget.deckNames.length > 1) {
        String name = widget.deckNames[i].toString();

        if(name == searchInput.toString()) {
          results["decks"].add(searchInput);
          results["length"]++;
        }
      }
    }

    // FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS FIX THIS
    // Then add comments after
    var isSearchFound = false;
    for(var i = 0; i < widget.myDictionary.length; i++) {
      if(widget.myDictionary[i].contains(searchInput)) {
        isSearchFound = true;

        break;
      }
    }

    if(isSearchFound) {
      results["My Dictionary"] = true;
      results["length"]++;

      Map deck;
      for(var i = 0; i < widget.deckNames.length; i++) {
        deck = widget.decks[widget.deckNames[i]];

        for(var j = 0; j < deck["vocab"].length; j++) {
          if(deck["vocab"][j].contains(searchInput)) {
            results["vocab"].add([deck["name"], j, deck["vocab"][j].indexOf(searchInput)]);
            results["length"]++;
          }
        }
      }
    }

    return results;
  }
}