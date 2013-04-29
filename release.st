((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
ToolSet default: (Smalltalk at: #CommandLineToolSet).

MCMcmUpdater updateMissingPackages: true.
Form openAsBackground: (FileDirectory default / '..' / 'resources/wallpaper.png') pathName.
Workspace allInstances do: [:w | w topView delete].
ReleaseBuilderFor4dot5 prepareNewBuild.
ToolSet default: StandardToolSet.
Smalltalk snapshot: true andQuit: true.
