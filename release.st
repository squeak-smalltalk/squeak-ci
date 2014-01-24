[Installer squeak
    project: 'trunk';
    addPackage: 'CommandLine';
    install.

FileStream stdout nextPutAll: 'release.st'; cr; flush.
ToolSet default: (Smalltalk at: #CommandLineToolSet).
ReleaseBuilder prepareNewBuild.
FileStream stdout nextPutAll: 'ReleaseBuilder set'; cr; flush.
ToolSet default: StandardToolSet.

Smalltalk snapshot: true andQuit: true]
    on: Error do: [:e|
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; lf;
            nextPutAll: e messageText; lf.
        Smalltalk snapshot: false andQuitWithErrorCode: 1].
