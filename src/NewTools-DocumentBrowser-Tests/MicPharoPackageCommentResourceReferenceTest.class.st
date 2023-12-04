Class {
	#name : 'MicPharoPackageCommentResourceReferenceTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedComment'
	],
	#category : 'NewTools-DocumentBrowser-Tests-ResourceModel',
	#package : 'NewTools-DocumentBrowser-Tests',
	#tag : 'ResourceModel'
}

{ #category : 'running' }
MicPharoPackageCommentResourceReferenceTest >> setUp [
	super setUp.
	savedComment := self class package packageComment.
]

{ #category : 'running' }
MicPharoPackageCommentResourceReferenceTest >> tearDown [ 
	self class package packageComment: savedComment.
	super tearDown
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testContents [
	| ref |
	ref := 'comment://package/Microdown' asMicResourceReference.
	self assert: ref contents equals: 'Microdown' asPackage packageComment.
	self assert: ref contents notEmpty
	
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testIsPackage [
	self assert: 'comment://package/Microdown' asMicResourceReference isPackage.
	self assert: 'comment://package/Microdown-RichTextComposer' asMicResourceReference isPackage.
	self deny: 'comment://package/Microdown-Core' asMicResourceReference isPackage.
	self deny: 'comment://package/Microup' asMicResourceReference isPackage.
	
	
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testIsTag [

	self deny: 'comment://package/Microdown' asMicResourceReference isTag.
	self assert: 'comment://package/Microdown?tag=Core' asMicResourceReference isTag.
	self assert: 'comment://package/Microdown-RichTextComposer?tag=Table-Support' asMicResourceReference isTag.
	self deny: 'comment://package/Calypso-SystemPlugins-ClassScripts' asMicResourceReference isTag
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testKind [

	self assert: 'comment://package/Microdown*' asMicResourceReference kind equals: #prefix.
	self assert: 'comment://package/Microdown' asMicResourceReference kind equals: #package.
	self assert: 'comment://package/Microdown?tag=Core' asMicResourceReference kind equals: #tag.
	self assert: 'comment://package/Microdown-RichTextComposer?tag=Table-Support' asMicResourceReference kind equals: #tag
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testLoadDirectory [
	| ref dir |
	ref := 'comment://package/Microdown' asMicResourceReference.
	dir := ref loadChildren.
	self assert: dir notEmpty.
	self assert: (dir allSatisfy: [ :r |r class = MicPharoPackageCommentResourceReference  ] ).
	self assert: (dir first uri segments first beginsWith: 'Microdown')
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testLoadDirectory_emptyPrefix [

	| dir prefixes |
	dir := 'comment://package/' asMicResourceReference loadChildren.
	self assert: (dir size between: 100 and: 200).
	"check that four known prefises are in the found set."
	prefixes := dir collect: [ :ref | ref packageName ].
	self assertEmpty: #( AST Collections Refactoring Iceberg ) \ prefixes.
	self assert: (prefixes noneSatisfy: [ :prefix | prefix includes: $- ])
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testLoadDirectory_package [

	| ref dir |
	ref := 'comment://package/Microdown?kind=package'
		       asMicResourceReference.
	dir := ref loadChildren.
	"Expect Extension and Manifest tags removed"
	self assert: dir size equals: 'Microdown' asPackage tags size - 2.
	self assert: (dir allSatisfy: [ :r |
			 r class = MicPharoPackageCommentResourceReference ]).
	self assert: (dir allSatisfy: [ :r | r packageName = 'Microdown' ]).
	self assert: (dir allSatisfy: [ :r | r kind = #tag ])
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testLoadDirectory_prefix [

	| dir |
	dir := 'comment://package/NewTools-DocumentBrowser' asMicResourceReference loadChildren.

	self assert: (dir allSatisfy: [ :r | r packageName = 'NewTools-DocumentBrowser' ]).
	self assertCollection: (dir collect: [ :ref | ref tagName ]) hasSameElements: #( 'BlockModel' 'Deprecated' 'GUI' 'ResourceModel' )
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testLoadDirectory_withTag [

	| ref dir |
	ref := 'comment://package/NewTools-DocumentBrowser-Tests?tag=ResourceModel' asMicResourceReference.
	dir := ref loadChildren.
	self assert: dir notEmpty.
	self assert: (dir allSatisfy: [ :r | r class = MicPharoClassCommentResourceReference ]).
	self assert: (dir anySatisfy: [ :aRef | aRef uri segments first = self class name ])
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testNewFromUri [
	| ref |
	ref := 'comment://package/Microdown' asMicResourceReference.
	self assert: ref class equals: MicPharoPackageCommentResourceReference.
	
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testPackageCommentWrite [
	| ref myName |
	myName := self class package name.
	ref := ('comment://package/', myName) asMicResourceReference.
	ref contents: 'Writing to comment'.
	self assert: self class package packageComment equals: 'Writing to comment'
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testPackageComment_NotThere [
	 self assert: 'comment://package/Microdownnnnn' asMicResourceReference contents equals: ''
	
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testPackageName [

	| ref |
	ref := 'comment://package/Microdown' asMicResourceReference.
	self assert: ref packageName equals: 'Microdown'
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testPackageNameWithTag [

	| ref |
	ref := 'comment://package/Microdown?tag=Core' asMicResourceReference.
	self assert: ref packageName equals: 'Microdown'.
	self assert: ref tagName equals: 'Core'
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testReducePackageNameToLevel [
	 | dummy |
	dummy := MicPharoPackageCommentResourceReference new.
	self assert: (dummy reducePackageName: '' toLevel: -1) equals: ''.
	self assert: (dummy reducePackageName: 'aaa-bbb-ccc' toLevel: 0) equals: 'aaa'.
	self assert: (dummy reducePackageName: 'aaa-bbb-ccc' toLevel: 1) equals: 'aaa-bbb'.
	self assert: (dummy reducePackageName: 'aaa-bbb-ccc' toLevel: 2) equals: 'aaa-bbb-ccc'
]

{ #category : 'tests' }
MicPharoPackageCommentResourceReferenceTest >> testSetup [

	| ref |
	ref := 'comment://package/Microdown' asMicResourceReference.
	self assert: ref class equals: MicPharoPackageCommentResourceReference.
	self assert: ref packageName equals: 'Microdown'
]
