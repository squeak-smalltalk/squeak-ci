#('39Deprecated' '311Deprecated' '45Deprecated' 'Nebraska' 'Universes' 'XML-Parser') do: [ :pkgName |
    (MCPackage named: pkgName) unload.
    MCMcmUpdater disableUpdatesOfPackage: pkgName].

Smalltalk cleanUp.
