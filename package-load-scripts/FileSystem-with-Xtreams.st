(Installer wiresong project: 'mc')
  addPackage: 'FS-Core';
  addPackage: 'FS-Disk';
  addPackage: 'FS-Memory';
  addPackage: 'FS-Zip';
  addPackage: 'FS-FileStream';
  addPackage: 'FS-Xtreams';
  addPackage: 'FS-Tests-Core';
  addPackage: 'FS-Tests-Zip';
  addPackage: 'FS-Tests-Disk';
  addPackage: 'FS-Tests-FileStream';
  addPackage: 'FS-Tests-Xtreams';
  install.

Installer squeaksource
    project: 'Xtreams';
    addPackage: 'Xtreams-Support-nice.11.mcz';
    addPackage: 'Xtreams-Core-nice.20.mcz';
    addPackage: 'Xtreams-Terminals-nice.31.mcz';
    addPackage: 'Xtreams-TerminalsFileSystem-nice.1.mcz';
    addPackage: 'Xtreams-Transforms-nice.23.mcz';
    addPackage: 'Xtreams-Substreams-nice.19.mcz';
    addPackage: 'Xtreams-Parsing-cwp.6.mcz';
    " --- tests follow --- "
    addPackage: 'Xtreams-CoreTests-nice.19.mcz';
    addPackage: 'Xtreams-TerminalsTests-nice.14.mcz';
    addPackage: 'Xtreams-TerminalsFileSystemTests-nice.14.mcz';
    addPackage: 'Xtreams-TransformsTests-nice.14.mcz';
    addPackage: 'Xtreams-SubstreamsTests-nice.13.mcz';
    addPackage: 'Xtreams-ParsingTests-cwp.5.mcz';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
