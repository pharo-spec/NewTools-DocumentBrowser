Class {
	#name : 'MicrodownSpecComponentTest',
	#superclass : 'TestCase',
	#category : 'Microdown-RichTextPresenter-Tests',
	#package : 'Microdown-RichTextPresenter-Tests'
}

{ #category : 'tests' }
MicrodownSpecComponentTest >> testComponent [

	| comp |
	comp := MicrodownSpecComponentForTest new.
	comp open.
	comp setDoc2.
	self assert: comp mdPresenter text asString trim equals: 'Header 2'.
	comp window close
]
