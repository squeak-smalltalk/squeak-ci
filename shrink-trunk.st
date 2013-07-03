#('39Deprecated' '311Deprecated' '45Deprecated' 'Nebraska' 'Universes' 'XML-Parser' 'SmallLand-ColorTheme' 'ST80' 'ST80Tools') do: [ :pkgName |
    (MCPackage named: pkgName) unload.
    MCMcmUpdater disableUpdatesOfPackage: pkgName].

Smalltalk cleanUp.
