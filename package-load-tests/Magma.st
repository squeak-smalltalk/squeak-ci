HDTestReport runPackages: #('Ma-Collections-Dictionarys'
    'Ma-Serializer-Tests-SUnit tests'
"    'Ma-Client-Server-Tester-Tests'"
    'WriteBarrier-Tests'
"    'Magma-Tester-SUnit tests'").

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
