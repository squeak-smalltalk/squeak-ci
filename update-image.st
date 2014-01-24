[| config manifest |
Smalltalk at: #Log put: [:msg | | str |
    str := DateAndTime now printString, ': ', msg.
    FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
    Transcript cr; show: str].

"Until the far away day we unload Traits and Monticello from the base image,
 we need to ensure that Monticello still supports Traits."

Installer squeak
    project: 'trunk';
    addPackage: 'CommandLine';
    install.

ToolSet default: (Smalltalk at: #CommandLineToolSet).

MCMcmUpdater updateMissingPackages: true.
MCMcmUpdater defaultUpdateURL: 'http://source.squeak.org/trunk'.

"This comes from Utilities class >> #updateFromServer, but leaves off the
 #inform: call, which puts up a modal dialog. When running headless there's
 still a MorphicUIManager running"

"Only attempt to update if we have network connectivity. This lets build scripts
 work in an offline manner."
(NetNameResolver addressForName: 'www.google.com' timeout: 1)
    ifNotNil: [
       "Update the image by loading all pending updates from the server."
       "Flush all caches. If a previous download failed this is often helpful"
        MCFileBasedRepository flushAllCaches.
        config := [[MCMcmUpdater updateFromDefaultRepository]
                "There's no (#on:do){4+}"
                on: ProgressNotification do: [:e | Log value: e extraParam. e resume]]
            on: MCNoChangesException do: [:e | Log value: 'Caught a no changes and resuming'. e resume]
            on: ProgressInitiationException do: [:e | |s|
                "We have to reach into the exception because there is no #progressTitle
                 accessor. Even if there were, this script must work with images that
                 predate such an accessor."
                s := e instVarNamed: 'progressTitle'.
                s ifNotEmpty: [Log value: s].
                e resume]
            on: MCMergeResolutionRequest do: [:e |
                e merger conflicts do: [:conflict |
                Log value: 'Conflict; choosing remote:'.
                Log value: conflict summary asString.
                conflict chooseRemote.
                Log value: 'Resolved? ', conflict isResolved printString].
                e resume: true].
        config ifNil: [
            Exception new signal: 'Unable to retrieve updates from remote repository.' translated].
        config setSystemVersion].
Log value: 'Updated to 4.5-', SystemVersion current highestUpdate printString.

"Avoid trailing cruft if the file shrinks in length."
FileDirectory deleteFilePath: 'TrunkImage.version'.
FileStream fileNamed: 'TrunkImage.version' do: [:f | f nextPutAll: SystemVersion current highestUpdate printString; flush].

manifest := (MCWorkingCopy allManagers asSortedCollection:
        [ :a :b | a package name <= b package name ]) collect:
            [:ea | ea description].

"Avoid trailing cruft if the file shrinks in length."
FileDirectory deleteFilePath: 'TrunkImage.manifest'.
FileStream fileNamed: 'TrunkImage.manifest' do: [:f |
    manifest do:
        [:s | f nextPutAll: s; nextPut: Character lf].
    f flush].

Log value: 'Package manifest:'.
manifest do: [:s | Log value: s].

Smalltalk globals removeKey: #Log.
"Save the fully updated trunk image."
ToolSet default: (Smalltalk at: #StandardToolSet).
WorldState addDeferredUIMessage: [ Smalltalk snapshot: true andQuit: true ]]
    on: Error do: [Smalltalk snapshot: false andQuitWithExitCode: 1].
