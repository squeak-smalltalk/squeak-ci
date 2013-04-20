HDTestReport runPackages: #(
    'Xtreams-CoreTests'
    'Xtreams-TerminalsTests'
    'Xtreams-TransformsTests'
    'Xtreams-SubstreamsTests'
    'Xtreams-ParsingTests'
"    'Xtreams-Xtras-'
    'Xtreams-XtrasTests'").

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
