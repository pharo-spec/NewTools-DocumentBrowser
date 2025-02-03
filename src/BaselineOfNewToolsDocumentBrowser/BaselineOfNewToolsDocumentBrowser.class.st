Class {
	#name : #BaselineOfNewToolsDocumentBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewToolsDocumentBrowser
}

{ #category : #baselines }
BaselineOfNewToolsDocumentBrowser >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec
			baseline: 'Microdown'
			with: [
				spec
					repository: 'github://pillar-markup/Microdown:v2.4.1/src';
					loads: #('RichText') ].

		spec
			baseline: 'Iceberg'
			with: [ spec repository: 'github://pharo-vcs/Iceberg:v2.2.3' ].

		spec
			package: #'Microdown-RichTextPresenter'
				with: [ spec requires: #( #Microdown ) ];
			package: #'Microdown-RichTextPresenter-Tests'
				with: [ spec requires: #( #'Microdown-RichTextPresenter' ) ];

			package: #'NewTools-DocumentBrowser'
				with: [ spec requires: #( #'Microdown-RichTextPresenter' ) ];
			package: #'NewTools-DocumentBrowser-Tests'
				with: [ spec requires: #( #'NewTools-DocumentBrowser' ) ];

			package: #'NewTools-DocumentBrowser-GitHubResource'
				with: [ spec requires: #( #'NewTools-DocumentBrowser' #Iceberg) ];
			package: #'NewTools-DocumentBrowser-GitHubResource-Tests'
				with: [ spec requires: #( #'NewTools-DocumentBrowser' ) ].

		spec
			group: 'Core' with: #(#'Microdown-RichTextPresenter' #'NewTools-DocumentBrowser');
			group: 'Tests' with: #('Core' #'Microdown-RichTextPresenter-Tests' #'NewTools-DocumentBrowser-Tests' );
			group: 'RichTextPresenter' with: #(#'Microdown-RichTextPresenter' #'Microdown-RichTextPresenter-Tests');
			group: 'GitHubResource' with: #(#'NewTools-DocumentBrowser-GitHubResource' #'NewTools-DocumentBrowser-GitHubResource-Tests');
			group: 'Core+Tests' with: #('Core' 'Tests' )
		]
]
