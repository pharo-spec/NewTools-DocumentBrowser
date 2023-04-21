IceRepository registry copy
	select: [ :each | #('Microdown' 'NewTools-DocumentationReader' 'DocumentBrowser' 'NewTools-DocumentBrowser') includes: each name ]
	thenDo: [ :aRepository | aRepository forget ].

#( 'BaselineOfNewToolsDocumentBrowser' 'BaselineOfMicrodownDev' 'BaselineOfMicrodown' 'BaselineOfNewToolsDocumentationReader' 'BaselineOfBeautifulComments'
'NewTools-DocumentBrowser' 'NewTools-DocumentBrowser-Tests' 'NewTools-DocumentBrowser-GitHubResource' 'NewTools-DocumentBrowser-GitHubResource-Tests' 
'Microdown' 'Microdown-Tests' 'Microdown-MicrodownRichTextComposer' 'Microdown-RichTextComposer' 'Microdown-ResolvePath' 'Microdown-ResolvePath-Tests' 
'NewTools-DocumentationReader' 'NewTools-DocumentationReader-Tests' 'BeautifulComments') do: [ :each | 
	(RPackageOrganizer default packageNamed: each ifAbsent: [ nil ]) 
		ifNotNil: [ :aPackage | aPackage removeFromSystem ] ]
