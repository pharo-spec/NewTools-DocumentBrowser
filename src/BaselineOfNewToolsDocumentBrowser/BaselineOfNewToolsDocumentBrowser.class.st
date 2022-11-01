Class {
	#name : #BaselineOfNewToolsDocumentBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewToolsDocumentBrowser
}

{ #category : #baselines }
BaselineOfNewToolsDocumentBrowser >> baseline: spec [
	<baseline>
	spec for: #common do: [
		
		spec
			package: #'Microdown-RichTextPresenter'
				"with: [ spec requires: #( #Microdown ) ]";
			package: #'Microdown-RichTextPresenter-Tests'
				with: [ spec requires: #( #'Microdown-RichTextPresenter' ) ];
				
			package: #'Microdown-DocumentBrowser'
				with: [ spec requires: #( #'Microdown-RichTextPresenter') ];
			package: #'Microdown-DocumentBrowser-Tests'
				with: [ spec requires: #( #'Microdown-DocumentBrowser' ) ].
				
		spec
			group: 'Core' with: #('#Microdown-RichTextPresenter' #'Microdown-DocumentBrowser');
			group: 'Tests' with: #('Core' #'Microdown-RichTextPresenter-Tests' #'Microdown-DocumentBrowser-Tests' );
			group: 'All' with: #('Core' 'Tests' ) ]
]
