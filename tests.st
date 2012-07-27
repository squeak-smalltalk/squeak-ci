| fileName |

HDTestReport runPackages: #(

	'HelpSystem-Tests'
	'ToolsTest-Browser'
	
).

fileName := [:s | ((s splitBy: FileDirectory pathNameDelimiter asString) last splitBy: '.') first].

"Save and Quit"
WorldState addDeferredUIMessage: [
	SmalltalkImage current
		saveAs: ('{1}-{2}.image' format: {fileName value: SmalltalkImage current imageName. DateAndTime now printString});
		snapshot: true andQuit: true ]. "It seems lame to double-save the image. Do we HAVE to snapshot?"