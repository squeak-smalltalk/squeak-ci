HDTestReport runPackages: #('FuelTests' 'FuelTests-Collections' 'FuelTests-Streams').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
