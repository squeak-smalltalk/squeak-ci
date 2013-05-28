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
    install.

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
