"
I am a browser of collections of microdown documents.

I am work in progress, but reasonable functional.

I open by `MicDocumentBrowser class >> #open`, or a specific document using: `MicDocumentBrowser class >> #openDocument:` which takes a `MicAbsoluteResourceReference` or a `String URI` as argument. 

Editing is done using the little edit flag in the lower right corner - there is currently no keyboard shortcut for this.
I can save some documents, but not all. I can save documents on files, and package/class comments. In particular I **cannot** save to github or the web. Saving is done on the save button when it is not greyed out.

I open with some documents being loaded, those are currently defined in `MicDocumentBrowser >>#defaultDocumentRoots`. 

The roots loaded at the moment is:
- all class and package comments in the Microdown project (read and write)
- all docs found on github relating to Microdown (read-only as one do not write to github)
- all doc(s) folders found in iceberg workspace (read and write). This will be the th doc-folders of projects known by iceberg.
## Auto saving
Moving to an other document or closing the browser will save changes made in source

## Preventing cyclic events
In order to prevent cycles in the events, all methods called through gui actions are garding some parts of their actions with a check on the variable `disabledEvents'. 
"
Class {
	#name : 'MicDocumentBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'spButtonBar',
		'spDocumentList',
		'spRendering',
		'spSource',
		'saveButton',
		'documentRoots',
		'documentModel',
		'layoutModel',
		'disableEvents'
	],
	#classVars : [
		'Browser'
	],
	#category : 'NewTools-DocumentBrowser-GUI',
	#package : 'NewTools-DocumentBrowser',
	#tag : 'GUI'
}

{ #category : 'services menu' }
MicDocumentBrowserPresenter class >> fileReaderServicesForFile: fullName suffix: suffix [
	<fileService>
	suffix = 'md' ifFalse:[^ #() ].
	^ { self serviceOpenMicrodownDocument  }
]

{ #category : 'services menu' }
MicDocumentBrowserPresenter class >> itemsForDirectory: aFileDirectory [
	<directoryService>
	
	^ { self serviceOpenMicrodownDirectory }
]

{ #category : 'opening' }
MicDocumentBrowserPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Documentation Browser')
		parent: #Help;
		order: 1;
		action: [ self open ];
		iconName: #smallHelp;
		help: 'Explore a list of available documentation.';
		withSeparatorAfter
]

{ #category : 'instance creation' }
MicDocumentBrowserPresenter class >> open [
	"I ensure the browser to be open. If no browser exist, I instantiate one"
	<script>
	Browser ifNil: [ Browser := self new ].
	(Browser owner isNil or: [ Browser owner isClosed ])
		ifTrue: [ Browser open ].
	
	
]

{ #category : 'opening' }
MicDocumentBrowserPresenter class >> openDocument: aMicResourceReferenceOrString [
	"I open microdown documents. If an existing browser instance is present, add the reference to the browser.
	I am called when following links in rich text to microdown documents, but can also be used as api method."
	
	<richtextlinkpresenter: #md>
	self open.
	Browser addRoot: (aMicResourceReferenceOrString isString
		ifTrue: [ aMicResourceReferenceOrString asMicResourceReference  ]
		ifFalse: [aMicResourceReferenceOrString ])
]

{ #category : 'class initialization' }
MicDocumentBrowserPresenter class >> reset [
	<script>
	Browser ifNil: [ ^ self ].
	Browser owner ifNil: [ Browser := nil. ^ self ].
	Browser owner close.
	Browser := nil.
]

{ #category : 'services menu' }
MicDocumentBrowserPresenter class >> serviceOpenMicrodownDirectory [
	"Answer the service of opening a file-contents browser"

	^ (SimpleServiceEntry
		provider: self 
		label: 'Open Microdown document'
		selector: #openDocument:
		description: 'Open a this document in Microdown Document Browser'
		buttonLabel: 'Microdown')
		argumentGetter: [ :file| file fullName]
]

{ #category : 'services menu' }
MicDocumentBrowserPresenter class >> serviceOpenMicrodownDocument [
	"Answer the service of opening a file-contents browser"

	^ (SimpleServiceEntry
		provider: self 
		label: 'Open Microdown document'
		selector: #openDocument:
		description: 'Open a this document in Microdown Document Browser'
		buttonLabel: 'Microdown')
		argumentGetter: [ :file| file fullName]
]

{ #category : 'navigation' }
MicDocumentBrowserPresenter >> addRoot: document [
	"Add document to the documents list and select it. If already in the list, just select it"
	| toSelect |
	"Notice, once equals is defined for resource references this code should make use of it"
	toSelect := self documentRoots 
		detect: [ :root | root uri = document uri ] 
		ifNone: [self documentRoots add: document. document].
	self disableEventsDuring: [
		spDocumentList roots: self documentRoots.
		spDocumentList selection selectItem: toSelect].
	self documentSelected: document
		
	
	
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> cancelSourceChange [
	"called by whenResetDo: on spSource "
	disableEvents ifTrue: [ ^ self ].
	documentModel isDirty ifFalse: [ ^ self ].

	self disableEventsDuring: [ 
		documentModel source: nil.
		self showSourceNotDirty.
		spSource 
			text: documentModel source]
]

{ #category : 'navigation' }
MicDocumentBrowserPresenter >> childrenOf: aNode [
	"I am a utility method to find children in a node"
	(aNode isKindOf: MicElement)
		ifTrue: [ ^ aNode subsections children].
	aNode loadChildren
		ifNotEmpty: [ :children |  ^ children sort: [:a :b | (self displayStringOf: a) < (self displayStringOf: b)] ]
		ifEmpty: [ 
			[ ^ self childrenOf: (MicSectionBlock fromRoot: aNode loadMicrodown) ] 
			on: Error  
			do: [ ^ #() ]]
	
]

{ #category : 'initialization' }
MicDocumentBrowserPresenter >> connectPresenters [
	"Listen to gui input"
	spDocumentList 
		whenSelectionChangedDo: [ :selection | self newSelection: selection selectedItem ].
	spSource 
		whenSubmitDo: [:text|  self saveSource ];
		whenResetDo: [ :text | self cancelSourceChange ];
		whenTextChangedDo: [ :newSource | self setSource: newSource ]
]

{ #category : 'private' }
MicDocumentBrowserPresenter >> defaultDocumentRoots [
	"By default include the pharo doc and the docs of loaded projects"
	^ ({'github://pharo-project/pharo/doc'}, 
		self loadedDocsInWorkspace  )
			collect: #asMicResourceReference
]

{ #category : 'layout' }
MicDocumentBrowserPresenter >> defaultLayout [

	^ self topLayout
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> disableEventsDuring: aBlock [
	| old | 
	"The clue of old is to allow multible nested diableEventsDuring calls
	and only the outermost will reset back to the default false value"
	old := disableEvents.
	disableEvents := true.
	aBlock ensure: [ disableEvents := old ]
]

{ #category : 'navigation' }
MicDocumentBrowserPresenter >> displayIconOf: aNode [
	"Utility method to put icons on the document list"
	(aNode isKindOf: MicElement) ifTrue: [ ^ self iconNamed: #smallLeftFlush ].
	^ aNode browserIcon
]

{ #category : 'navigation' }
MicDocumentBrowserPresenter >> displayStringOf: aNode [
	"Utility method to generate the titles used in document list"
	(aNode isKindOf: MicSectionBlock) ifTrue: [ ^ (Microdown asRichText: aNode header) asString trim ].
	^aNode browserTitle
]

{ #category : 'private' }
MicDocumentBrowserPresenter >> documentRoots [
	^ documentRoots 
		ifNil: [ documentRoots := self defaultDocumentRoots asOrderedCollection  ].
]

{ #category : 'navigation' }
MicDocumentBrowserPresenter >> documentSelected: document [
	"document is newly selected, and should be rendered. If source is showing, set it as well"
	documentModel save.
	documentModel resourceReference: document.
	documentModel resourceReference ifNil: [ ^ self ].
	spRendering document: documentModel document.
	spRendering selectionInterval: (1 to: 0).
	self updateSourcePresenter.
	self owner title:
		(self displayStringOf: documentModel resourceReference)
]

{ #category : 'initialization' }
MicDocumentBrowserPresenter >> initialize [
	"Initialize my models first"
	documentModel := MicDocumentBrowserModel new.
	layoutModel := MicDocumentBrowserLayoutModel new.
	disableEvents := false.
	super initialize
]

{ #category : 'initialization' }
MicDocumentBrowserPresenter >> initializeButtons [
	"initialize the button bar"
	spButtonBar := self instantiate: MicDocumentBrowserButtonBar.
	spButtonBar
		left: (spButtonBar newCheckBox
			label: 'Show List';
			state: layoutModel showDocumentList;
			whenChangedDo: [ :val | self setListShowing: val ]);
		right: (spButtonBar newDropList
			help: 'source view';
			items: layoutModel sourceModes;
			whenSelectedItemChangedDo: [ :item | self setSourceMode: item ]);
		right: (saveButton := spButtonBar newButton
			label: 'Save';
			state: layoutModel showSource;
			action: [ self saveSource ]);
		right: (spButtonBar newCheckBox
			label: 'Show Source';
			state: layoutModel showSource;
			whenChangedDo: [ :val | self setSourceShowing: val ])
]

{ #category : 'initialization' }
MicDocumentBrowserPresenter >> initializePresenters [

	super initializePresenters.

	spDocumentList := self newTree.
	spDocumentList
		roots: self documentRoots;
		children: [ :aNode | self childrenOf: aNode ];
		display: [ :aNode | self displayStringOf: aNode ];
		displayIcon: [ :aNode | self displayIconOf: aNode ].
	spRendering := self instantiate: MicrodownPresenter.
	spSource := self newText.
	self initializeButtons
]

{ #category : 'initialization' }
MicDocumentBrowserPresenter >> initializeWindow: aWindowPresenter [
	"Adds window closing behaviour"
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		initialExtent: 1000@600;
		title: 'Microdown document browser'.
	aWindowPresenter
		whenOpenedDo: [ Browser := self ];
		whenClosedDo: [
			self saveSource.
			Browser := nil ]
]

{ #category : 'private' }
MicDocumentBrowserPresenter >> loadedDocsInWorkspace [
	"I return all the doc folders which exist in the local iceberg repository"
	| iceRepository githubUsers |
	iceRepository := FileLocator localDirectory / 'iceberg'.
	iceRepository exists ifFalse: [ ^ #() ].
	githubUsers := iceRepository directories.
	^ ((githubUsers collect: [ :userDir | userDir directories ]) flattened
		collect: [ :project | project directories ]) flattened
		select: [ :dir | #('doc' 'docs' 'documentation') includes: dir basename asLowercase ]
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> newSelection: selection [
	"I am called when a user selects a new element in spDocumentList"
	disableEvents ifTrue: [ ^ self ].
	self documentSelected: selection
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> saveSource [
	"called by save button or accept in spSource"
	| path sourceSelection sourceScroll |
	disableEvents ifTrue: [ ^ self ].
	documentModel isDirty ifFalse: [ ^ self ].
	self disableEventsDuring: [ 
		documentModel
			source: spSource text;
			save.
		self showSourceNotDirty.
		spRendering document: documentModel document.
		"Sync the views"
		path := spDocumentList selection selectedPath.
		sourceSelection := spSource selectionInterval.
		sourceScroll := spSource adapter widget scrollPane vScrollbarValue.
		spDocumentList roots: self documentRoots.
		spDocumentList
			expandPath: path;
			selectPath: path.
		spSource selectionInterval: sourceSelection.
		spSource adapter setScrollValue: 0 @ sourceScroll.
		spRendering adapter setScrollValue: 0 @ sourceScroll.
		spSource takeKeyboardFocus ]
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> setListShowing: aBoolean [
	"Change layout to include the document list or not"
	layoutModel showDocumentList: aBoolean.
	self disableEventsDuring: [ self setTopLayout ] 
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> setSource: newSource [
	"called by changes to spSource"
	disableEvents ifTrue: [ ^ self ].
	documentModel source: newSource.
	self showSourceDirty
	
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> setSourceMode: sourceMode [
	"Change the layout as how spRendering and spSource are placed"
	layoutModel sourceMode: sourceMode.
	self disableEventsDuring: [ self setTopLayout  ]
]

{ #category : 'events' }
MicDocumentBrowserPresenter >> setSourceShowing: showSource [
	"change layout to include spSource or not"
	layoutModel showSource: showSource.
	self disableEventsDuring: [
		self setTopLayout.
		self updateSourcePresenter]
]

{ #category : 'layout' }
MicDocumentBrowserPresenter >> setTopLayout [
	"I set the layout of the browser. The dynamic part of the layout is done by layoutModel"
	self layout: self topLayout
]

{ #category : 'dirty indication' }
MicDocumentBrowserPresenter >> showSourceDirty [
	spSource removeStyle: 'notDirty'; addStyle: 'dirty'
]

{ #category : 'dirty indication' }
MicDocumentBrowserPresenter >> showSourceNotDirty [
	spSource removeStyle: 'dirty'; addStyle: 'notDirty'
]

{ #category : 'layout' }
MicDocumentBrowserPresenter >> topLayout [

	^ SpBoxLayout newTopToBottom
		add: (layoutModel
			layoutList: spDocumentList
			rendering: spRendering
			source: spSource);
		add: spButtonBar expand: false;
		yourself
]

{ #category : 'updating' }
MicDocumentBrowserPresenter >> updateSourcePresenter [
	""
	layoutModel showSource ifTrue: [
		self disableEventsDuring: [
			spSource
				editable: documentModel canSave;
				text: (documentModel source ifNil: [ '' ]).
			spSource adapter color: (documentModel canSave
					 ifTrue: [ self theme backgroundColor ]
					 ifFalse: [ self theme lightBaseColor ]).
			self showSourceNotDirty ] ]
]
