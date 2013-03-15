| config |
MCMcmUpdater defaultUpdateURL: 'http://source.squeak.org/squeak44'.

"This comes from Utilities class >> #updateFromServer, but leaves off the #inform: call, which puts up a modal dialog. When running headless there's still a MorphicUIManager running"

"Update the image by loading all pending updates from the server."
"Flush all caches. If a previous download failed this is often helpful"
MCFileBasedRepository flushAllCaches.
config := MCMcmUpdater updateFromDefaultRepository.
config ifNil: [^self inform: 'Unable to retrieve updates from remote repository.' translated].
Utilities setSystemVersionFromConfig: config.

FileStream fileNamed: 'TrunkImage.version' do: [:f | f nextPutAll: SystemVersion current highestUpdate printString; close].

"Save the fully updated trunk image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
