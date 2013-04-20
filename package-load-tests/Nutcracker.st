HDTestReport runPackages: #('AlgebraicDataType-Tests' 'EitherTests' 'MaybeTests' 'MonadTests' 'PersistentUnionFind-Tests' 'Unification-Tests' 'Unification-Tests-Destructuring').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
