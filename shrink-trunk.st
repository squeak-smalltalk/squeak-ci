#('39Deprecated'
    '311Deprecated'
    '45Deprecated'
    'Nebraska'
    'SmallLand-ColorTheme'
    'ST80'
    'ST80Tools'
    'SystemReporter'
    'ToolBuilder-MVC'
    'Universes'
    'XML-Parser')
    do: [:pkgName|
        (MCPackage named: pkgName) unload.
        MCMcmUpdater disableUpdatesOfPackage: pkgName].

Smalltalk cleanUp.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
