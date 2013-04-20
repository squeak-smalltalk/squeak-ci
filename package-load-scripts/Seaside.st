Installer squeaksource
    project: 'MetacelloRepository';
    install: 'ConfigurationOfOmniBrowser';
    install: 'ConfigurationOfSeaside30';
    install: 'ConfigurationOfMagritte3';
    install: 'ConfigurationOfMagritte3AddOns';
    install: 'ConfigurationOfPier3';
    install: 'ConfigurationOfPier3AddOns';
    yourself.

(Smalltalk at: #ConfigurationOfOmniBrowser) project stableVersion
    load: #(Dev).

((Smalltalk at: #ConfigurationOfSeaside30) project version: '3.0.8')
    load: #('OneClick' 'Development' 'WebClient-Seaside').

(Smalltalk at: #ConfigurationOfMagritte3) project stableVersion
    load: #('Seaside').
(Smalltalk at: #ConfigurationOfMagritte3AddOns) project stableVersion
    load: #('Magritte-Json' 'Magritte-JQuery').
(Smalltalk at: #ConfigurationOfPier3) project stableVersion
    load.

Installer ss3
    project: 'TwitterBootstrap';
    install: 'ConfigurationOfTwitterBootstrap';
    yourself.
((Smalltalk at: #ConfigurationOfTwitterBootstrap) project version: #development)
    load: 'All'.

Installer ss3
    project: 'Parasol';
    install: 'ConfigurationOfParasol';
    yourself.
((Smalltalk at: #ConfigurationOfParasol) project version: '0.9')
    load: #('dev').

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
