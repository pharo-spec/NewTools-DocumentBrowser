Extension { #name : 'MicFileResourceReference' }

{ #category : '*NewTools-DocumentBrowser' }
MicFileResourceReference >> browserIcon [ 
	^ self isDirectory 
		ifTrue: [ self iconNamed: #packageColored]
		ifFalse: [ self iconNamed: #smallLeftFlush ]
]
