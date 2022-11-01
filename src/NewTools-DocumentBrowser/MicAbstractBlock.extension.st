Extension { #name : #MicAbstractBlock }

{ #category : #'*NewTools-DocumentBrowser' }
MicAbstractBlock >> canSave [
	"Called by the document browser. Polymorphic with MicResourceReferences"
	^ false
]

{ #category : #'*NewTools-DocumentBrowser' }
MicAbstractBlock >> contents [
	"polymorphic with MicResourceReference - returns the source code of me - here generated"
	^ 'You cannot edit subsections of a document.
Select the whole document for editing'
]

{ #category : #'*NewTools-DocumentBrowser' }
MicAbstractBlock >> isHeader [
	^ false
]

{ #category : #'*NewTools-DocumentBrowser' }
MicAbstractBlock >> loadMicrodown [
	"polymorphic with resource references"
	^ self
]
