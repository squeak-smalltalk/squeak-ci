HDTestReport runPackages: #('FS-Tests-Core' 'FS-Tests-Zip' 'FS-Tests-Disk' 'FS-Tests-FileStream').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
