Class {
	#name : 'MicPharoCommentResourceReferenceTest',
	#superclass : 'TestCase',
	#category : 'NewTools-DocumentBrowser-Tests-ResourceModel',
	#package : 'NewTools-DocumentBrowser-Tests',
	#tag : 'ResourceModel'
}

{ #category : 'tests' }
MicPharoCommentResourceReferenceTest >> testNewFromUri [
	| ref |
	ref := 'comment://class/Microdown' asMicResourceReference.
	self assert: ref class equals: MicPharoClassCommentResourceReference.
	
]

{ #category : 'tests' }
MicPharoCommentResourceReferenceTest >> testNewFromUri_hostError [
	self 
		should: [ 'comment://foo/Microdown' asMicResourceReference  ]
		raise:  MicResourceReferenceError  
	
	
]

{ #category : 'tests' }
MicPharoCommentResourceReferenceTest >> testNewFromUri_packageComment [
	| ref |
	ref := 'comment://package/Microdown' asMicResourceReference.
	self assert: ref class equals: MicPharoPackageCommentResourceReference.
	
]

{ #category : 'tests' }
MicPharoCommentResourceReferenceTest >> testNoBinaryReading [
	self 
		should: [ 'comment://class/Microdown' asMicResourceReference loadImage ]
		raise:  MicResourceReferenceError  
	
	
]
