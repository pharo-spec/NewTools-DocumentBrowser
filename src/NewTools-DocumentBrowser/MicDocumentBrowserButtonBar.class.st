"
I am a presenter combining two button bars, left and right, with a space inbetween.
Adding to the left side is done using `left:`, and the right side using `right:`
"
Class {
	#name : 'MicDocumentBrowserButtonBar',
	#superclass : 'SpPresenter',
	#instVars : [
		'left',
		'right'
	],
	#category : 'NewTools-DocumentBrowser-GUI',
	#package : 'NewTools-DocumentBrowser',
	#tag : 'GUI'
}

{ #category : 'initialization' }
MicDocumentBrowserButtonBar >> initializePresenters [

	super initializePresenters.
	left := self newButtonBar placeAtStart.
	right := self newButtonBar.
	self layout: (SpBoxLayout newHorizontal
		spacing: 5;
		borderWidth: 2;
		add: left;
		addLast: right;
		yourself)
]

{ #category : 'api - adding' }
MicDocumentBrowserButtonBar >> left: button [

	left add: button
]

{ #category : 'api - adding' }
MicDocumentBrowserButtonBar >> right: button [

	right add: button
]
