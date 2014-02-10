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
            nextPutAll: w messageText; cr;
            flush.
        w resume].
FileStream stdout nextPutAll: 'ReleaseBuilder set'; cr; flush.
ToolSet default: StandardToolSet.

Smalltalk snapshot: true andQuit: true]
    on: Error do: [:e |
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; cr;
            nextPutAll: e messageText; cr;
            flush.
        e printVerboseOn: FileStream stderr.

        FileStream stderr nextPutAll: '========================='; cr; flush.
        (e isKindOf: MessageNotUnderstood) ifTrue:
            [FileStream stderr nextPutAll: ('Receiver: {1}' format: {e receiver printString}); cr; flush].
        e signalerContext in: [:problemPlace |
            (problemPlace stackOfSize: 1) do: [:ctx | ctx printOn: FileStream stderr]].
        FileStream stderr nextPutAll: '========================='; cr; flush.
        Smalltalk snapshot: false andQuitWithExitCode: 1].
