MCMcmUpdater updateMissingPackages: true.
Form openAsBackground: (FileDirectory default / '..' / 'resources/wallpaper.png') pathName.
Workspace allInstances do: [:w | w topView delete].
ReleaseBuilderFor4dot5 prepareNewBuild.
Smalltalk snapshot: true andQuit: true.
