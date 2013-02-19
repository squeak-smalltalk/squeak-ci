Installer squeakmap
    update;
	addPackage: 'Fuel (1.8.1)';
    install.

HDTestReport runPackages: #('FuelTests' 'FuelTests-Collections' 'FuelTests-Streams').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
