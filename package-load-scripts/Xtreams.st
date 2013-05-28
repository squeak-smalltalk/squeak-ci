"(Installer monticello mc: (MCHttpRepository new location: 'http://source.squeak.org/FFI'))
    addPackage: 'FFI-Kernel-eem.24.mcz';
    addPackage: 'FFI-Pools-eem.3.mcz';
    addPackage: 'FFI-Unix-tbn.3.mcz';
    install."

Installer squeaksource
    project: 'Xtreams';
    addPackage: 'Xtreams-Support-nice.10.mcz';
    addPackage: 'Xtreams-Core-nice.18.mcz';
    addPackage: 'Xtreams-Terminals-nice.27.mcz';
    addPackage: 'Xtreams-Transforms-nice.21.mcz';
    addPackage: 'Xtreams-Substreams-nice.16.mcz';
    addPackage: 'Xtreams-Parsing-Martin Kobetic.2.mcz';
    " --- tests follow --- "
    addPackage: 'Xtreams-CoreTests-nice.19.mcz';
    addPackage: 'Xtreams-TerminalsTests-nice.14.mcz';
    addPackage: 'Xtreams-TransformsTests-nice.11.mcz';
    addPackage: 'Xtreams-SubstreamsTests-nice.10.mcz';
    addPackage: 'Xtreams-ParsingTests-nice.1.mcz';
     " --- following require FFI --- "
"     addPackage: 'Xtreams-Xtras-MartinKobetic.23.mcz';
     addPackage: 'Xtreams-XtrasTests-MartinKobetic.2.mcz'"
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
