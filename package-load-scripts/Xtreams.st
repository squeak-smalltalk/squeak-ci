"(Installer monticello mc: (MCHttpRepository new location: 'http://source.squeak.org/FFI'))
    addPackage: 'FFI-Kernel-eem.24.mcz';
    addPackage: 'FFI-Pools-eem.3.mcz';
    addPackage: 'FFI-Unix-tbn.3.mcz';
    install."

Installer squeaksource
    project: 'Xtreams';
    install: 'Xtreams-Support-nice.10.mcz';
    install: 'Xtreams-Core-nice.18.mcz';
    install: 'Xtreams-Terminals-nice.27.mcz';
    install: 'Xtreams-Transforms-nice.21.mcz';
    install: 'Xtreams-Substreams-nice.16.mcz';
    install: 'Xtreams-Parsing-Martin Kobetic.2.mcz';
    " --- tests follow --- "
    install: 'Xtreams-CoreTests-nice.19.mcz';
    install: 'Xtreams-TerminalsTests-nice.14.mcz';
    install: 'Xtreams-TransformsTests-nice.11.mcz';
    install: 'Xtreams-SubstreamsTests-nice.10.mcz';
    install: 'Xtreams-ParsingTests-nice.1.mcz'";"
     " --- following require FFI --- "
"     install: 'Xtreams-Xtras-MartinKobetic.23.mcz';
     install: 'Xtreams-XtrasTests-MartinKobetic.2.mcz'".

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
