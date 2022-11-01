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
				
			package: #'NewTools-DocumentBrowser'
				with: [ spec requires: #( #'Microdown-RichTextPresenter') ];
			package: #'NewTools-DocumentBrowser-Tests'
				with: [ spec requires: #( #'Microdown-DocumentBrowser' ) ].
				
		spec
			group: 'Core' with: #('#Microdown-RichTextPresenter' #'NewTools-DocumentBrowser');
			group: 'Tests' with: #('Core' #'Microdown-RichTextPresenter-Tests' #'NewTools-DocumentBrowser-Tests' );
			group: 'All' with: #('Core' 'Tests' ) ]
]
