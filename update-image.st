| config manifest |
((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
ToolSet default: (Smalltalk at: #CommandLineToolSet).

MCMcmUpdater updateMissingPackages: false.
MCMcmUpdater defaultUpdateURL: 'http://source.squeak.org/trunk'.

"This comes from Utilities class >> #updateFromServer, but leaves off the #inform: call, which puts up a modal dialog. When running headless there's still a MorphicUIManager running"

"Update the image by loading all pending updates from the server."
"Flush all caches. If a previous download failed this is often helpful"
MCFileBasedRepository flushAllCaches.
config := MCMcmUpdater updateFromDefaultRepository.
config ifNil: [^self inform: 'Unable to retrieve updates from remote repository.' translated].
Utilities setSystemVersionFromConfig: config.

FileStream fileNamed: 'TrunkImage.version' do: [:f | f nextPutAll: SystemVersion current highestUpdate printString; close].

manifest := (MCWorkingCopy allManagers asSortedCollection:
        [ :a :b | a package name <= b package name ]) collect:
            [:ea | ea description].

FileStream fileNamed: 'TrunkImage.manifest' do: [:f |
    manifest do:
        [:s | f nextPutAll: s; nextPut: Character lf].
    f close].

FileStream stdout nextPutAll: 'Package manifest:'; nextPut: Character lf; flush.
manifest do: [:s | FileStream stdout nextPutAll: s; nextPut: Character lf; flush].

"Save the fully updated trunk image."
ToolSet default: (Smalltalk at: #StandardToolSet).
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
