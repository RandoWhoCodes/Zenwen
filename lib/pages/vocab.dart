// ---------------- IMPORTING THINGS ----------------

import 'package:flutter/material.dart';
import 'editDeckPage.dart';
import 'searchResults.dart';

// ---------------- MAIN WIDGET ----------------

/// Creates the state for the widgets.
/// The widgets will be stateful widgets.
class Vocab extends StatefulWidget {
  const Vocab({super.key});

  @override
  State<Vocab> createState() => _VocabState();
}

// ---------------- PAGE LAYOUT & DATA ----------------

class _VocabState extends State<Vocab> {

  // DATA

  /// deckTemplate is the basic data for each deck.
  /// When new decks are created, the vocab list is empty. It only has value here for readability.
  Map<String, dynamic> deckTemplate = {
    "name": "Example",
    "description": "Example deck",
    "vocab": [["吗", "ma", "y/n?"]]
  };
  /// decks is the actual Map that stores all the data for every deck.
  /// decks starts with the My Dictionary deck already in it.
  /// The My Dictionary deck is a deck containing all the vocab the user ever creates.
  /// The My Dictionary deck can not be deleted.
  Map<String, dynamic> decks = {
    "My Dictionary": {
      "name": "My Dictionary",
      "description": "This deck is a list of all vocab you create in your other decks.",
      "vocab": []
    }
  };
  /// deckNames is a lo=ist containing all the names for the decks.
  /// The values in deckNames correspond to the keys of all the objects in decks.
  /// deckNames is used mainly in ListView.builders for referencing data in decks using decks[deckNames[index]][...]
  /// deckNames is preloaded with "My Dictionary" because the My Dictionary deck is automatically created at start.
  var deckNames = ["My Dictionary"];

  /// titleController is the TextEditingController for the TextField for the title when the user is creating a new deck.
  late final TextEditingController titleController = TextEditingController();
  /// descriptionController is the TextEditingController for the TextField for the description when the user is creating a new deck.
  late final TextEditingController descriptionController = TextEditingController();
  /// searchController is the TextEditingController for the search bar.
  late final TextEditingController searchController = TextEditingController();

  /// This runs once when the program starts.
  /// Currently I don't run anything, but I added this just in case I need it moving forward.
  @override
  void initState() {
    super.initState();
  }

  // WIDGETS

  @override
  Widget build(BuildContext context) {
    // This widget IS the page. It's the default blank screen that everything sits on.
    return Scaffold(
      // This is the AppBar, the header of the page.
      appBar: AppBar(
        centerTitle: true,
        title: Text("Vocab"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search"
                  ),
                )
              ),
              IconButton(
                onPressed: () {
                  final searchInput = searchController.text;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResults(
                        searchInput: searchInput,
                        decks: decks,
                        deckNames: deckNames,
                        myDictionary: decks["My Dictionary"],
                      )
                    )
                  );
                },
                icon: Icon(Icons.search_rounded)
              )
            ],
          )
        )
      ),

      // This FloatingActionButton makes the big button at the bottom right of the page.
      // Using this because it makes sense with the layout.
      // The benefit of using a FloatingActionButton is that it floats over all other objects on the page.
      floatingActionButton: FloatingActionButton(
        // All we want for this button to look like is a big + symbol
        child: Icon(Icons.add),
        onPressed: () {
          // Create a popup box where users can enter a title and description for their new vocab deck.
          // Also have a save button at the bottom.
          showDialog(context: context, builder: (dialogContext) => Dialog(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Restrict height to height of children.
                children: [
                  // Input for deck title.
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "title"
                    ),
                  ),
                  // Input for deck description.
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "description"
                    ),
                  ),
                  // Save button.
                  // Creates the new deck and exits the popup.
                  TextButton(
                    onPressed: () {
                      // Retreive data from the input boxes.
                      final String enteredTitle = titleController.text;
                      final String enteredDescription = descriptionController.text;
                      // Create new deck based on retrieved data.
                      decks[enteredTitle] = {
                        "name": enteredTitle,
                        "description": enteredDescription,
                        "vocab": []
                      };
                      deckNames.add(enteredTitle);

                      setState(() {}); // Updates page.

                      // Clear input data.
                      titleController.clear();
                      descriptionController.clear();

                      // Close popup.
                      Navigator.pop(dialogContext);
                    },
                    child: Text("Save")
                  )
                ],
              ),
            ),
          ));
        }
      ),

      // Since this is a list and designed for mobile devices, we use a vertical layout.
      body: Column(
        children: [
          // This container is at the top of the page.
          // It is the My Dictionary deck card.
          // Seperate from the other cards because it's easier to modify and code if it's outside the ListView.builder.
          Container(
            margin: EdgeInsets.all(20.0),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              // Uses Material so the InkWell works.
              // Also to have better UI.
              child: Material(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  // Use a Stack so that the practice button InkWell doesn't conflict with the card InkWell.
                  child: Stack(
                    children: [
                      // Positioned.fill so that the entire card is clickable.
                      Positioned.fill(
                        // This InkWell takes the user to the page containing all the vocab.
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDeckPage(
                                  // These are so that the page knows what data to show.
                                  deckName: "My Dictionary",
                                  deckNames: deckNames,
                                  deck: decks["My Dictionary"],
                                  decks: decks,
                                  myDictionary: decks["My Dictionary"]
                                )
                              )
                            );
                          },
                          child: SizedBox.expand() // Makes it so the InkWell takes up the entire Positioned.fill.
                        )
                      ),
                      // Make it so that the title and description text boxes don't block the previous InkWell.
                      IgnorePointer(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(decks["My Dictionary"]["name"]),
                              Text(decks["My Dictionary"]["description"])
                            ],
                          )
                        ),
                      ),
                      // Practice button at top right.
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
          ),

          // Handle case where user hans't made any decks yet.
          // Uses 1 rather than 0 because we want to ignore the My Dictionary deck.
          deckNames.length == 1
            ?
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("You don't have any vocab decks. Click the + button to start creating decks!")
              )
            :
              // Use Expanded so there isn't an error regarding empty space.
              Expanded(
                // ListView.builder because we gotta automatically generate the decks.
                child: ListView.builder(
                  itemCount: deckNames.length - 1, // 1 less than total number of decks to ignore My Dictionary.
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(20.0),
                    width: double.infinity,
                    // Use a Row so that there is the deck card and the delete button.
                    child: Row(
                      children: [
                        // Uses Expanded so it takes up the whole width.
                        Expanded(
                          child: Padding(
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
                                                // index + 1 to skip My Dictionary.
                                                deckName: deckNames[index + 1],
                                                deckNames: deckNames,
                                                deck: decks[deckNames[index + 1]],
                                                decks: decks,
                                                myDictionary: decks["My Dictionary"]
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
                                            // index + 1 to skip My Dictionary.
                                            Text(decks[deckNames[index + 1]]["name"]),
                                            Text(decks[deckNames[index + 1]]["description"])
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
                        ),
                        // This is the delete button next to the deck card.
                        // Uses Material for InkWell and better UI.
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          elevation: 2.5,
                          child: IconButton(
                            onPressed: () {
                              // index + 1 to skip My Dictionary
                              decks.remove(deckNames[index + 1]);
                              deckNames.removeAt(index + 1);

                              setState(() {});
                            },
                            icon: Icon(Icons.delete) // Trash can icon
                          )
                        )
                      ]
                    )
                  ),
                )
              )
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}