Smalltalk at: #CommandLineToolSet ifAbsent: [
    [((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
    ToolSet default: (Smalltalk at: #CommandLineToolSet).]
        on: Error do: [:e|
            FileStream stderr
                nextPutAll: 'Exception ', e className, ' raised:'; lf;
                nextPutAll: e messageText; lf.
            Smalltalk snapshot: false andQuit: true]].
[FileStream stdout nextPutAll: 'release.st'; cr; flush.
ToolSet default: (Smalltalk at: #CommandLineToolSet).
ReleaseBuilder prepareNewBuild.
FileStream stdout nextPutAll: 'ReleaseBuilder set'; cr; flush.
ToolSet default: StandardToolSet.

Smalltalk snapshot: true andQuit: true]
    on: Error do: [:e|
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; lf;
            nextPutAll: e messageText; lf.
        Smalltalk snapshot: false andQuit: true].
