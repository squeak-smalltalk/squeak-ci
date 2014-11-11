"(Installer monticello mc: (MCHttpRepository new location: 'http://source.squeak.org/FFI'))
    addPackage: 'FFI-Pools-eem.3.mcz';
    addPackage: 'FFI-Kernel-tbn.25.mcz';
    addPackage: 'FFI-Unix-tbn.3.mcz';
    install."

Installer squeaksource
    project: 'Xtreams';
    addPackage: 'Xtreams-Support-nice.12.mcz';
    addPackage: 'Xtreams-Core-nice.20.mcz';
    addPackage: 'Xtreams-Terminals-nice.31.mcz';
    addPackage: 'Xtreams-TerminalsFileDirectory-nice.2.mcz';
    addPackage: 'Xtreams-Transforms-nice.25.mcz';
    addPackage: 'Xtreams-Substreams-nice.20.mcz';
    addPackage: 'Xtreams-Parsing-cwp.6.mcz';
    " --- tests follow --- "
    addPackage: 'Xtreams-CoreTests-nice.20.mcz';
    addPackage: 'Xtreams-TerminalsTests-nice.17.mcz';
    addPackage: 'Xtreams-TerminalsFileDirectoryTests-nice.1.mcz';
    addPackage: 'Xtreams-TransformsTests-fbs.15.mcz';
    addPackage: 'Xtreams-SubstreamsTests-nice.13.mcz';
    addPackage: 'Xtreams-ParsingTests-cwp.5.mcz';
     " --- following require FFI --- "
"     addPackage: 'Xtreams-Xtras-MartinKobetic.23.mcz';
     addPackage: 'Xtreams-XtrasTests-MartinKobetic.3.mcz'"
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
