(Installer repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/') 
    project: 'main';
    package: 'ConfigurationOfFuel';
    install.


[(Smalltalk at: #ConfigurationOfFuel) loadBleedingEdge] on: Warning do: [:w | w resume].

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
