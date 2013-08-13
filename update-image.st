[| config manifest |
((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
ToolSet default: (Smalltalk at: #CommandLineToolSet).

"Until the far away day we unload Traits and Monticello from the base image, we need to ensure that Monticello still supports Traits."
Installer squeak
    project: 'trunk';
    install: 'MonticelloForTraits'.

MCMcmUpdater updateMissingPackages: false.
MCMcmUpdater defaultUpdateURL: 'http://source.squeak.org/trunk'.

"This comes from Utilities class >> #updateFromServer, but leaves off the #inform: call, which puts up a modal dialog. When running headless there's still a MorphicUIManager running"

"Only attempt to update if we have network connectivity. This lets build scripts
 work in an offline manner."
(NetNameResolver addressForName: 'www.google.com' timeout: 1)
    ifNotNil: [
       "Update the image by loading all pending updates from the server."
       "Flush all caches. If a previous download failed this is often helpful"
        MCFileBasedRepository flushAllCaches.
        config := MCMcmUpdater updateFromDefaultRepository.
        config ifNil: [
            Exception new signal: 'Unable to retrieve updates from remote repository.' translated].
        Utilities setSystemVersionFromConfig: config].
FileStream stdout
    nextPutAll: ('Updated to 4.5-', SystemVersion current highestUpdate printString);
    lf.

FileDirectory deleteFilePath: 'TrunkImage.version'.
FileStream fileNamed: 'TrunkImage.version' do: [:f | f nextPutAll: SystemVersion current highestUpdate printString; close].

manifest := (MCWorkingCopy allManagers asSortedCollection:
        [ :a :b | a package name <= b package name ]) collect:
            [:ea | ea description].

"Avoid trailing cruft if the manifest shrinks in length."
FileDirectory deleteFilePath: 'TrunkImage.manifest'.
FileStream fileNamed: 'TrunkImage.manifest' do: [:f |
    manifest do:
        [:s | f nextPutAll: s; nextPut: Character lf].
    f close].

FileStream stdout nextPutAll: 'Package manifest:'; nextPut: Character lf; flush.
manifest do: [:s | FileStream stdout nextPutAll: s; nextPut: Character lf; flush].

"Save the fully updated trunk image."
ToolSet default: (Smalltalk at: #StandardToolSet).
CommandLineToolSet unload.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ]]
    on: Error do: [|e|
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; lf;
            nextPutAll: e messageText; lf.
        Smalltalk snapshot: false andQuit: true].
