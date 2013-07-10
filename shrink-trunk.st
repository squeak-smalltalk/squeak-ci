#('39Deprecated'
    '311Deprecated'
    '45Deprecated'
    'Nebraska'
    'SmallLand-ColorTheme'
    'ST80'
    'ST80Tools'
    'Universes'
    'XML-Parser')
    do: [:pkgName|
        (MCPackage named: pkgName) unload.
        MCMcmUpdater disableUpdatesOfPackage: pkgName].

Smalltalk cleanUp.
