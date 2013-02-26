Installer squeakmap
    update;
	addPackage: 'Fuel (1.9)';
    install.

HDTestReport runPackages: #('FuelTests' 'FuelTests-Collections' 'FuelTests-Streams').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
