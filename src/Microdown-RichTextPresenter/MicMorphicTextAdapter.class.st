"
I am an adapter used by `MicTextPresenter` to connect to a `MicScrolledTextMorph`.

## Implementation
My primary method is `buildWidget` which creates an instance of `SpRichTextMorph`. 
My model (inherited instance variable) is a `SpRichTextPresenter`. 

Perhaps in the future the methods for menu and shiftMenu should be forwarded to the presenter.
"
Class {
	#name : #MicMorphicTextAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#instVars : [
		'scalingImageIndexes'
	],
	#category : #'Microdown-RichTextPresenter-Adapters'
}

{ #category : #factory }
MicMorphicTextAdapter >> buildWidget [
	| newWidget |

	newWidget := (MicScrolledTextMorph  on: self)
		beReadOnly;
		beWrapped;
		enabled: self enabled;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		hScrollbarShowWhenNeeded;
		getSelectionSelector: #readSelection;
		setSelectionSelector: #setSelection:;
		getTextSelector: #getText;
		setTextSelector: #accept:notifying:;
		yourself.

	self setEnabled: self presenter isEnabled to: newWidget.

	self setText: self presenter text to: newWidget.
	self presenter whenTextChangedDo: [ :text |
		self setText: text to: newWidget ].

	self presenter selectionInterval
		ifNotNil: [  :anInterval | self selectionInterval: anInterval].
	self presenter whenSelectionChangedDo: [ :selectionInterval |
		self selectionInterval: selectionInterval ].

	^ newWidget
]

{ #category : #'morph->presenter' }
MicMorphicTextAdapter >> getText [
	"called by morph to get text from model"
	^ model text
]

{ #category : #initialization }
MicMorphicTextAdapter >> initialize [

	super initialize.
	scalingImageIndexes := Array new
]

{ #category : #'morph->presenter' }
MicMorphicTextAdapter >> menu [
	^ nil.
]

{ #category : #rendering }
MicMorphicTextAdapter >> renderWidth: renderWidth [

	"I am called by the morph directly to recompute image sizes"
	self scalingImageIndexes do: [ :index |
		(self presenter text
			attributeAt: index ofKind: MicScalingTextAnchor)
			targetWidth: renderWidth ]
]

{ #category : #'presenter->morph' }
MicMorphicTextAdapter >> scalingImageIndexes [

	^ scalingImageIndexes
]

{ #category : #'presenter->morph' }
MicMorphicTextAdapter >> selectionInterval [
	"called by the presenter to get the selection in the morph"
	^ self widget selectionInterval
]

{ #category : #'presenter->morph' }
MicMorphicTextAdapter >> selectionInterval: anInterval [
	"called by presenter to set selection in morph"

	self widgetDo: [ :w | w setTextAreaSelection: anInterval ]
]

{ #category : #factory }
MicMorphicTextAdapter >> setEnabled: aBoolean to: aWidget [

	aWidget enabled: aBoolean
]

{ #category : #initialization }
MicMorphicTextAdapter >> setScrollValue: aValue [

	self widgetDo: [ :w | 
		w scrollPane
			hScrollbarValue: aValue x;
			vScrollbarValue: aValue y;
			updateScrollbars ]
]

{ #category : #'morph->presenter' }
MicMorphicTextAdapter >> setSelection: interval [
	"Called when a selection happens in the widget"
	self model selectionInterval: interval
]

{ #category : #'presenter->morph' }
MicMorphicTextAdapter >> setText: aText [
	"called by presenter to set text in morph"
	self widgetDo: [ :w |self setText: aText to: w ]
]

{ #category : #'presenter->morph' }
MicMorphicTextAdapter >> setText: aText to: aWidget [
	"called by presenter to set text in morph"

	scalingImageIndexes := (1 to: aText size)
		select: [ :idx |
			((aText at: idx) = Character home)
			and: [ (aText attributeAt: idx ofKind: MicScalingTextAnchor) notNil ] ].

	aWidget
		setText: aText;
		resetState
]

{ #category : #'morph->presenter' }
MicMorphicTextAdapter >> shiftMenu [
	^ nil.
]
