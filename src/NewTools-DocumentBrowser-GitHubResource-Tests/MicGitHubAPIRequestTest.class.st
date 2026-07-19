Class {
	#name : 'MicGitHubAPIRequestTest',
	#superclass : 'TestCase',
	#category : 'NewTools-DocumentBrowser-GitHubResource-Tests',
	#package : 'NewTools-DocumentBrowser-GitHubResource-Tests'
}

{ #category : 'tests' }
MicGitHubAPIRequestTest >> testExtractRateInfoToleratesMissingRateLimitHeaders [

	| api response |
	api := MicGitHubAPI new.
	response := ZnResponse ok: (ZnEntity text: '').

	self shouldnt: [ api extractRateInfo: response ] raise: KeyNotFound
]

{ #category : 'tests' }
MicGitHubAPIRequestTest >> testNewApiDoesNotAuthenticateRequests [

	| api request |
	api := MicGitHubAPI new.
	api credentials: (IceTokenCredentials new
			 token: 'irrelevant';
			 yourself).
	request := (api newRequestTo: 'repos/pharo-project/pharo') request.

	self deny: (request headers includesKey: 'Authorization')
]
