// ---------------- IMPORTING THINGS ----------------

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ---------------- MAIN WIDGET ----------------

/// Creates the state for the widgets.
/// The widgets will be stateful widgets.
class EditDeckPage extends StatefulWidget {
  final String deckName;
  final Map deck;
  final Map myDictionary;

  /// This tells the page what information to fetch from the other page.
  /// If you look at vocab.dart, you will notice them where the Navigator switches to this page.
  const EditDeckPage({
    super.key,
    required this.deckName,
    required this.deck,
    required this.myDictionary
  });

  @override
  State<EditDeckPage> createState() => _EditDeckPageState();
}

// ---------------- PAGE LAYOUT & DATA ----------------

class _EditDeckPageState extends State<EditDeckPage> {

  // DATA

  /// This TextEditingController stores information for the character TextField when the user adds new vocab.
  late final TextEditingController character = TextEditingController();
  /// This TextEditingController stores information for the pinyin (pronounciation) TextField when the user adds new vocab.
  late final TextEditingController pinyin = TextEditingController();
  /// This TextEditingController stored information for the meaning TextField when the user adds new vocab.
  late final TextEditingController meaning = TextEditingController();

  // WIDGETS

  @override
  Widget build(BuildContext context) {
    // This widget IS the page. It's the blank screen that everything sits on.
    return Scaffold(
      // This is the header of the page.
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.deckName),
      ),

      /// Simple logic check to see if we are rendering the My Dictionary deck or just a random custom deck.
      /// If it is the My Dictionary deck, we don't want to be able to add vocab.
      floatingActionButton: widget.deckName == "My Dictionary"
        ? null
        // This is the button on the bottom right. It's used to add new vocab.
        : FloatingActionButton(
            onPressed: () {
              // Make a popup so the user can enter the data for the new vocab.
              showDialog(
                context: context, builder: (dialogContext) => Dialog(
                  child: Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // Restrict card height to height of children.
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // The input for the character.
                        TextField(
                          controller: character,
                          decoration: InputDecoration(
                            hintText: "character"
                          ),
                        ),
                        // The input for the pinyin (pronounciation).
                        TextField(
                          controller: pinyin,
                          decoration: InputDecoration(
                            hintText: "pronounciation"
                          ),
                        ),
                        // The input for the meaning.
                        TextField(
                          controller: meaning,
                          decoration: InputDecoration(
                            hintText: "meaning"
                          ),
                        ),
                        // The save button. This is what actually creates the data.
                        TextButton(
                          onPressed: () {
                            // Get the input data and put it in a list, then add that list to the deck's vocab.
                            // This list simply stores the vocab word as 3 parts: character, pinyin, meaning.
                            final vocabEntry = [character.text, pinyin.text, meaning.text];
                            widget.deck["vocab"].add(vocabEntry);

                            // Check if vocabEntry isn't already in My Dictionary.
                            // If it isn't, then add vocabEntry to My Dictionary.
                            if(!widget.myDictionary["vocab"].any((vocab) => listEquals(vocab, vocabEntry))) {
                              widget.myDictionary["vocab"].add(vocabEntry);
                            }

                            // Update page. 
                            setState(() {});

                            character.clear();
                            pinyin.clear();
                            meaning.clear();

                            // Close popup.
                            Navigator.pop(dialogContext);
                          },
                          child: Text("Save")
                        )
                      ],
                    ),
                  ),
                )
              );
            },
            child: Icon(Icons.add), // Big + icon.
      ),

      // Uses Column because we want a vertical layout.
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            // Header of vocab list. Makes something that looks like this:
            // Word        Pronounciation          Meaning
            // ...         ...                     ...
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Word")
                ),
                Expanded(
                  flex: 1,
                  child: Text("Pronounciation")
                ),
                Expanded(
                  flex: 1,
                  child: Text("Meaning")
                )
              ],
            ),
          ),

          /// Simple logic check to see if the vocab list is empty or not.
          /// If it is empty, we don't want to try to render it. That would cause an error.
          /// Otherwise, since it isn't empty, we do want to render it.
          widget.deck["vocab"].isEmpty
            ?
              /// Simple logic check to see if we are in My Dictionary or a random custom one.
              /// If in My Dictionary, creating vocab isn't possible, so we need a different message.
              widget.deckName == "My Dictionary"
                ?
                  // Prompt user to start adding vocab, but specialized for My Dictionary.
                  Text("My Dictionary is empty. When you start creating vocab it'll show up here!")
                :
                  // Prompt user to start adding vocab.
                  Text("Vocab deck is empty. Click the + button to start adding vocab!")
            :
              // Uses Expanded to avoid errors from empty space.
              Expanded(
                // ListView.builder to automatically generate vocab list.
                child: ListView.builder(
                  itemCount: widget.deck["vocab"].length, // The number of vocab this deck has.
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(20.0),
                    // Uses IntrinsicHeight to ensure the Stack is big enough to fit all children.
                    child: IntrinsicHeight(
                      // Uses stack so that the delete button floats over the vocab.
                      // Helpful if meaning gets too long.
                      child: Stack(
                        children: [
                          // Uses Row so that the items are in a nice horizontal layout.
                          Row(
                            children: [
                              // Uses Expanded so the Texts can be evenly spread out across the entire width of the Row.
                              Expanded(
                                flex: 1,
                                child: Text(widget.deck["vocab"][index][0].toString()), // item 0 is the character.
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(widget.deck["vocab"][index][1].toString()), // item 1 is the pinyin.
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(widget.deck["vocab"][index][2].toString()), // item 2 is the meaning.
                              ),
                            ],
                          ),

                          if(widget.deckName == "My Dictionary")
                            Material(
                              color: Colors.transparent,
                            )
                          else
                            // Uses Align to position the delete button.
                            Align(
                              alignment: AlignmentGeometry.topRight,
                              // Uses Material for better UI.
                              child: Material(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                elevation: 2.5,
                                borderRadius: BorderRadius.circular(5),
                                // The delete button.
                                child: IconButton(
                                  onPressed: () {
                                    widget.myDictionary["vocab"].removeWhere((vocab) => listEquals(vocab, widget.deck["vocab"][index])); // Removes vocab from My Dictionary.

                                    widget.deck["vocab"].removeAt(index); // Removes this vocab data from the deck.

                                    // Update page.
                                    setState(() {});
                                  },
                                  // Trash can icon.
                                  icon: Icon(Icons.delete),
                                )
                              )
                            )
                        ]
                      )
                    )
                  )
                )
              )
        ],
      ),
    );
  }

  // ---------------- CLOSING THE PAGE ----------------

  @override
  void dispose() {
    // Dispose of TextEditingControllers for optimized performance.
    character.dispose();
    pinyin.dispose();
    meaning.dispose();
    super.dispose();
  }
}