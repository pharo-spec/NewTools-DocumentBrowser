"
A style contributor for the document browser, it adds specific styles to be used by `MicDocumentBrowser` in the context of the `StPharoApplication`.
"
Class {
	#name : #MicDocumentBrowserStyleContributor,
	#superclass : #StPharoStyleContributor,
	#category : #'NewTools-DocumentBrowser-GUI'
}

{ #category : #styles }
MicDocumentBrowserStyleContributor >> styleSheetContribution [

	^ SpStyleVariableSTONReader fromString: '.application [
    .dirty [ Container { #borderColor: #red, #borderWidth: 1 } ],
    .notDirty [ Container { #borderColor: #transparent, #borderWidth: 1 } ] ]'
]
