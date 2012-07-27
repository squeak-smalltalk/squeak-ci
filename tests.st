HDTestReport runPackages: #(

	'HelpSystem-Tests'
	

	
).

"Save and Quit"
WorldState addDeferredUIMessage: [
	SmalltalkImage current snapshot: true andQuit: true ].