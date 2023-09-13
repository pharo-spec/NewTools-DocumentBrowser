"
My prime purpose it to allow access to the package comment.

My uri syntax is: `comment://package/{packageName}`.

We can also create an URI to a package tag with this syntax: `comment://package/{packageName}?tag={tagName}`.

## loadMicrodown

My `loadMicrodown` returns the package comment of the package named packageName or empty text if packageName is not a package or if the package has no comment. Notice, `loadMicrodown` will return the synthesized comment (created by the class side method `buildMicroDownUsing:withComment:`)

When packageName is a package, my two methods `contents` and `contents:` reads and writes the contents of the package comment.

## loadDirectory

My 'loadDirectory' has been designed to provide a deep directory. 

Most class package names are of the form 'aaa-bbb-ccc-ddd'. A call to `loadDirectory` with categoryName being 'aaa' will give children 'aaa-xxx','aaa-yyy','aaa-zzz'. A call with 'aaa-bbb' will return children 'aaa-bbb-xxx', 'aaa-bbb-yyy' etc.

### Details

In `comment://package/packageName`, packageName can be one of two cases:
* A package name, with children being the tags or classes if the package has no tags
* A package name prefix of the form 'AI-Algorithms' wich is neither a package or a tag in a package, with children being those categories of which 'AI-Algorithms' is a prefix.

A special case is somewhat common, for example 'Microdown' is both a package name and a prefix for other packages.
In this case, the prefix 'Microdown' takes precedence  over package, and `comment://package/Microdown` has as children those categories prefixed my 'Microdown' _and_ the Microdown package.

In case the URI point a tag, the children are the classes in the tag.

"
Class {
	#name : #MicPharoPackageCommentResourceReference,
	#superclass : #MicPharoCommentResourceReference,
	#instVars : [
		'kind',
		'packageName',
		'tagName'
	],
	#category : #'NewTools-DocumentBrowser-ResourceModel'
}

{ #category : #private }
MicPharoPackageCommentResourceReference >> browserIcon [
	self kind = #prefix ifTrue: [ ^ self iconNamed: #group ].
	self kind = #package ifTrue: [ ^ self iconNamed: #package ].
	self kind = #tag ifTrue: [ ^ self iconNamed: #blank ].
	^ self iconNamed: #error
]

{ #category : #'document browser' }
MicPharoPackageCommentResourceReference >> browserTitle [

	kind = 'prefix' ifTrue: [ ^ self packageName , '*' ].
	^ self packageName
]

{ #category : #testing }
MicPharoPackageCommentResourceReference >> canSave [
	"return true if I implement contents: "

	^ self isPackage
]

{ #category : #private }
MicPharoPackageCommentResourceReference >> childrenOfAllPackages [
	"I return the children of 'comment://package/' "

	^ (self packageOrganizer packageNames
		   reject: [ :package | package beginsWith: 'BaselineOf' ]
		   thenCollect: [ :package | self reducePackgeName: package ]) asSet asArray sort collect: [ :package |
		  ('comment://package/' , package) asMicResourceReference ]
]

{ #category : #initialization }
MicPharoPackageCommentResourceReference >> childrenOfPackage [
	"I assume I am a package, return my tags"

	| tags |
	tags := self package classTags reject: [ :tag | #( Manifest Extensions ) includes: tag name ].
	^ (tags asArray sorted: #name ascending) collect: [ :tag | ('comment://package/' , self packageName , '?tag=' , tag name) asMicResourceReference ]
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> childrenOfPackagePrefix [
	"I am a prefix of a set of packages, 
	my children are those packages with one more depth in their name"

	self packageName ifEmpty: [ ^ self childrenOfAllPackages ].
	^ self packageOrganizer packageName
		  select: [ :package | package beginsWith: self packageName ]
		  thenCollect: [ :package | ('comment://package/' , package) asMicResourceReference ]
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> childrenOfPackageWithTag [
	"In case I matche a package tag, children are the classes under that tag"

	^ ((self packageOrganizer packageNamed: self packageName ifAbsent: [ ^ #(  ) ])
		classTagNamed: self tagName ifAbsent: [ #(  ) ]) classes
			collect: [ :class | ('comment://class/' , class name) asMicResourceReference ]
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> contents [

	[ ^ self package packageComment ]
		on: NotFound
		do: [ ^ '' ]
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> contents: aNewComment [

	[ ^ self package packageComment: aNewComment ]
		on: NotFound
		do: [ MicResourceReferenceError signal: 'No package named ' , self packageName ]
]

{ #category : #testing }
MicPharoPackageCommentResourceReference >> isPackage [

	self packageName asPackageIfAbsent: [ ^ false ].
	^ true
]

{ #category : #testing }
MicPharoPackageCommentResourceReference >> isTag [
	"return true if I am tag inside a package"

	^ self kind = #tag
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> kind [

	^ kind
]

{ #category : #'private - utilities' }
MicPharoPackageCommentResourceReference >> level [
	"return the number of '-' in package name"

	self packageName ifEmpty: [ ^ -1 ].
	^ self packageName occurrencesOf: $-
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> loadChildren [
	kind = #prefix ifTrue: [ ^ self childrenOfPackagePrefix  ].
	kind = #package ifTrue: [ ^ self childrenOfPackage  ].
	kind = #tag ifTrue: [ ^ self childrenOfPackageWithTag  ].
	MicResourceReferenceError signal: 'Unknow kind in ', self uri printString.
]

{ #category : #loading }
MicPharoPackageCommentResourceReference >> loadMicrodown [
	"I override to provide the comment produced by beautifulComments"

	| builder |
	self isPackage ifFalse: [ ^ Microdown parse: 'No documentation for tags or package prefixes' ].
	builder := Microdown builder.
	self package buildMicroDownUsing: builder withComment: self contents.
	^ Microdown parse: builder contents
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> package [

	^ self packageName asPackage
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> packageName [

	^ packageName
]

{ #category : #'private - utilities' }
MicPharoPackageCommentResourceReference >> reducePackageName: aString toLevel: level [
	"a package name aaa-bbb-ccc-ddd reduced to level 0 is aaa, reduced to 2 is aaa-bbb-ccc"

	| parts |
	parts := aString splitOn: $-.
	^ (parts first: level + 1) joinUsing: $-
]

{ #category : #'private - utilities' }
MicPharoPackageCommentResourceReference >> reducePackgeName: aPackageName [

	^ self reducePackageName: aPackageName toLevel: self level + 1
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> tagName [
	^ tagName
]

{ #category : #accessing }
MicPharoPackageCommentResourceReference >> uri: aUri [
	"the uri is on the form commet://package/packageName - 
	packageName can be a prefix of a full package name"

	super uri: aUri.
	packageName := aUri segments
		               ifNil: [ '*' ]
		               ifNotNil: [ :segments | segments first ].
	kind := (packageName endsWith: '*')
		        ifTrue: [
			        packageName := packageName withoutSuffix: '*'.
			        #prefix ]
		        ifFalse: [
			        aUri queryAt: #tag ifPresent: [ :value | tagName := value ].

			        self tagName
				        ifNil: [ #package ]
				        ifNotNil: [ #tag ] ]
]
