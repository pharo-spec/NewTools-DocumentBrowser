Extension { #name : 'MicAbsoluteResourceReference' }

{ #category : '*NewTools-DocumentBrowser' }
MicAbsoluteResourceReference >> browserIcon [
	^ self iconNamed: #book
]

{ #category : '*NewTools-DocumentBrowser' }
MicAbsoluteResourceReference >> browserTitle [
	| title slashes |
	title := self uriString.
	slashes := title allRangesOfSubstring: '/'.
	slashes size <= 3 ifTrue: [ ^ title ].
	^ '...', (title 
		copyFrom: (slashes at: (slashes size - 2)) first
		to: title size)
]
