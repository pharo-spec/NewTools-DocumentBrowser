"
I am a presenter for a microdown document.

The document rendered into a Text in the document: method.

It is possible to control various aspects of the Text generation using a `MicTextStyler` instance.
"
Class {
	#name : 'MicrodownPresenter',
	#superclass : 'MicTextPresenter',
	#instVars : [
		'#document => ObservableSlot',
		'#textStyler => ObservableSlot'
	],
	#category : 'Microdown-RichTextPresenter-Widgets',
	#package : 'Microdown-RichTextPresenter',
	#tag : 'Widgets'
}

{ #category : 'specs' }
MicrodownPresenter class >> adapterName [

	^ #MicMorphicMicrodownAdapter
]

{ #category : 'instance creation' }
MicrodownPresenter class >> open [

	<script>
	(self new document: MicTextPresenter cheetSheet) open
]

{ #category : 'api' }
MicrodownPresenter >> document [

	^ document
]

{ #category : 'api' }
MicrodownPresenter >> document: aNode [

	document := aNode
]

{ #category : 'api' }
MicrodownPresenter >> documentFromString: aString [

	self document: (self parserClass parse: aString)
	
		
]

{ #category : 'private' }
MicrodownPresenter >> parserClass [
	^ Microdown
]

{ #category : 'api' }
MicrodownPresenter >> textStyler [

	^ textStyler ifNil: [ textStyler := MicTextStyler new ]
]

{ #category : 'api' }
MicrodownPresenter >> textStyler: styler [

	textStyler := styler
]

{ #category : 'api - events' }
MicrodownPresenter >> whenDocumentChangedDo: aBlock [

	self property: #document whenChangedDo: aBlock
]

{ #category : 'api - events' }
MicrodownPresenter >> whenTextStylerChangedDo: aBlock [

	self property: #textStyler whenChangedDo: aBlock
]
