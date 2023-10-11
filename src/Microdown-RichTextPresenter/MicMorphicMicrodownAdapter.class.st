"
A morphic adapter for `MicrodownPresenter`
"
Class {
	#name : 'MicMorphicMicrodownAdapter',
	#superclass : 'MicMorphicTextAdapter',
	#category : 'Microdown-RichTextPresenter-Adapters',
	#package : 'Microdown-RichTextPresenter',
	#tag : 'Adapters'
}

{ #category : 'factory' }
MicMorphicMicrodownAdapter >> buildWidget [
	| newWidget |

	newWidget := super buildWidget.

	self composeOn: newWidget.
	self presenter whenDocumentChangedDo: [ :aDocument | self compose ].
	self presenter whenTextStylerChangedDo: [ :aStyler | self compose ].

	^ newWidget
]

{ #category : 'composing' }
MicMorphicMicrodownAdapter >> compose [

	self widgetDo: [ :w | self composeOn: w ]
]

{ #category : 'composing' }
MicMorphicMicrodownAdapter >> composeOn: aWidget [

	self presenter document ifNil: [ ^ self ].
	self presenter text: (MicRichTextComposer new
		textStyler: self presenter textStyler;
		asRichText: self presenter document)
]
