[Installer squeak
    project: 'trunk';
    addPackage: 'CommandLine';
    install.

FileStream stdout nextPutAll: 'release.st'; cr; flush.
ToolSet default: (Smalltalk at: #CommandLineToolSet).
[ReleaseBuilder prepareNewBuild]
    on: Warning do: [:w |
        FileStream stdout
            nextPutAll: 'Warning ', w className, ' raised:'; cr;
            nextPutAll: w messageTest; cr;
            flush.
        w resume].
FileStream stdout nextPutAll: 'ReleaseBuilder set'; cr; flush.
ToolSet default: StandardToolSet.

Smalltalk snapshot: true andQuit: true]
    on: Error do: [:e|
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; cr;
            nextPutAll: e messageText; lf.
        Smalltalk snapshot: false andQuitWithExitCode: 1].
