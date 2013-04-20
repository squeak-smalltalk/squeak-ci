Installer ss3
    project: 'ParsingDerivatives';
    install: 'ConfigurationOfParsingDerivatives'.
(Smalltalk at: #ConfigurationOfParsingDerivatives) loadDevelopment.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
