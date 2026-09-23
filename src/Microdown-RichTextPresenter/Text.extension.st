Extension { #name : 'Text' }

{ #category : '*Microdown-RichTextPresenter' }
Text >> inspectionRichText: aBuilder [
	<inspectorPresentationOrder: -1 title: 'RichText'>

	^ (aBuilder instantiate: MicTextPresenter) text: self
]
