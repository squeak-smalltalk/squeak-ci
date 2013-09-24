[((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
ToolSet default: (Smalltalk at: #CommandLineToolSet).

MCMcmUpdater updateMissingPackages: true.
Form openAsBackground: (FileDirectory default / '..' / 'resources' / 'wallpaper.png') pathName.
Workspace allInstances do: [:w | w topView delete].
ReleaseBuilder prepareNewBuild.
ToolSet default: StandardToolSet.
CommandLineToolSet unload.

Smalltalk snapshot: true andQuit: true]
    on: Error do: [:e|
        FileStream stderr
            nextPutAll: 'Exception ', e className, ' raised:'; lf;
            nextPutAll: e messageText; lf.
        Smalltalk snapshot: false andQuitWithExitCode: 1].
