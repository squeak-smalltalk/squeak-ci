| manifest |

ToolSet default: (Smalltalk at: #CommandLineToolSet).

FileStream stdout nextPutAll: 'Package manifest:'; nextPut: Character lf; flush.
manifest := (MCWorkingCopy allManagers asSortedCollection:
        [ :a :b | a package name <= b package name ]) collect:
            [:ea | ea description].
manifest do: [:s | FileStream stdout nextPutAll: s; nextPut: Character lf; flush].

"Quit without saving"
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
