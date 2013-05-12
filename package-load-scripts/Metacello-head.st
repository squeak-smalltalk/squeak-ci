"Get the Metacello configuration (for Squeak users)"
Installer gemsource
    addProject: 'metacello';
    addPackage: 'ConfigurationOfMetacello';
    install.

"Bootstrap Metacello 1.0-beta.32, using mcz files"
((Smalltalk at: #ConfigurationOfMetacello) project
  version: '1.0-beta.32') load.

"Load the Preview version of Metacello from GitHub"
(Smalltalk at: #Metacello) new
  configuration: 'MetacelloPreview';
  version: #stable;
  repository: 'github://dalehenrich/metacello-work:configuration';
  load.
