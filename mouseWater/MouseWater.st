Smalltalk addSubspace: #MouseWater!
Namespace current: MouseWater!

"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

BLOX.BLOXBrowser.NamespaceBrowser subclass: #MWBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MWBrowser comment: 
nil!

!MouseWater.MWBrowser methodsFor: 'accessing'!

addSubNamespace: aString
 
   aString = '' ifTrue: [ ^self ].
   curNamespace addSubspace: aString asSymbol.
   self updateNamespaceList!

classSelection: assoc 
    "assoc contains current class selection.  Find the class associated with 
     the selected string in shownClasses dictionary.  Save the class in the 
     instance variable, curClass.  Update other related instance variables.  Since
     the other panes in the browser descend from the class, the instance variables
     associated with each pane must be nilled out.  Send update messages to the
     data object"

    curClass := (assoc isNil or: [assoc value isNil]) 
		ifTrue: [nil]
		ifFalse: [shownClasses at: assoc value].

"    textView object: curClass."

    curSelector := nil.
    curCategory := nil.
    textMode := #source.
    self
	changeState: #methodCategories;
	changeState: #methods.
    self changeState: #text.
    Primitive updateViews
!

compile: aString from: aView 
    "Compile aString derived from the text pane (aView).  The way aString is 
     compiled depends on the text mode"

    | aClass |
    curClass isNil ifTrue: [^aView beep].

    "If the text in the text pane is method source code, compile it"
    (curSelector notNil or: [textMode == #addMethod]) 
	ifTrue: [^self compileMethod: aString for: aView].

    textMode == #comment 
	ifTrue: 
	    [curClass comment: aString.
	    ^aString].

    "Otherwise, evaluate the text.  If no method source is displayed, then
     aString is evaluated independently.  If the string constitutes a legal
     class definition, the class is returned in aClass"
'Evaluating code' printNl.
    curClass environment whileCurrentDo: [
        aClass := Behavior evaluate: aString ifError: [:file :line :msg | ^nil].
    ].

    aClass isClass ifFalse: [^self].

    "If ClassHierarchyBrowser is modified, force an immediate exit
     because this method context is still referencing it by the old memory
     model"
    (self isKindOf: aClass) | (aClass == curClass) 
	ifTrue: [^self].

    curClass := aClass.
  "  textView object: curClass."

    "Update class pane"
    (classList includes: aClass) 
	ifTrue: 
	    ["If the class already exists, inform the class pane indirectly
	      through the change/update mechanism that the selection only
	      needs to be updated"

	    self classList: classList message: #newClassSelection]

	ifFalse:
	    ["If the class does not exist, update instance variables
	     and inform the affected panes through the change/update mechanism"

	    self updateClassList].

    textMode := #source!

indentString
    ^''!

namespaceString
    "Return name of selected class indented by 'n' spaces, where 'n' is the number
     of class' superclasses"

    | spaces |
    curNamespace isNil ifTrue: [^nil].
    byCategory ifTrue: [^curNamespace].
    spaces := String new: curNamespace allSuperspaces size.
    spaces atAllPut: Character space.
"    ^spaces , curNamespace name"
    ^curNamespace name!

readNamespaces
    | stack top indent namespace subspaces |
    stack := OrderedCollection new.
    namespacesMap := Dictionary new: 17.
    namespaces := OrderedCollection new.
    subspaces := {Smalltalk} , RootNamespace allInstances.
    
    [subspaces isNil 
	ifFalse: 
	    [top := stack 
			addLast: (subspaces asSortedCollection: [:a :b | a name <= b name])].
    [top isEmpty] whileTrue: 
	    [stack removeLast.
	    stack isEmpty ifTrue: [^self].
	    top := stack last].
    namespace := top removeFirst.
    subspaces := namespace subspaces.
   "indent := String new: stack size - 1 withAll: Character space."
	indent := ''.
    namespacesMap at: indent , namespace name put: namespace.
    namespaces add: indent , namespace name] 
	    repeat!

removeClass: aSoftError 
    "Remove selected class from system"

    | badClasses assoc classes cancel |
    curClass isNil ifTrue: [aSoftError error: 'You attempted to delete no class'.^nil].
    curClass subclasses isEmpty 
	ifFalse: [aSoftError error: 'Must delete subclasses first'.^nil].


    "If there are any instance of curClass, disallow curClass to be removed.  Force
     a garbage collection to get rid of unreferenced instances"
    (curClass instanceCount > 0 and: 
	    [ObjectMemory compact.
	    curClass instanceCount > 0]) 
	ifTrue: [aSoftError error: 'Cannot remove because class has instances.'.^nil].

    "Search system for all external references to class "
    badClasses := {curClass.  curClass class}.
    assoc := curClass environment associationAt: curClass name.

    Class allSubclassesDo:
	[:subclass | 
	    (badClasses includes: subclass) 
		ifFalse: 
		    [(subclass instanceClass whichSelectorsReferTo: assoc) do: 
			    [:sel | 
			    "Ignore references in transitory selector -- executeStatements"
			    sel ~= #executeStatements 
				ifTrue: 
				    [^aSoftError error: 'External references remain to class which is to be deleted']].

		    (subclass whichSelectorsReferTo: assoc) do: 
			    [:sel | 
			    "Ignore references in transitory selector -- executeStatements"

			    sel ~= #executeStatements 
				ifTrue: 
				    [^aSoftError error: 'External references remain to class which is to be deleted']]]].

    curClass allSuperclassesDo: [:each |
	each removeSubclass: curClass.
	each class removeSubclass: curClass class ].

    "Update namespace"
    curClass environment removeKey: curClass name asSymbol.
    self updateClassList.
    self classSelection: nil
!

renameClass: aString
    "Rename currently selected class"

    | methods oldName newName prompter oldAssoc |
    curClass isNil ifTrue: [^'You must select a class before trying to rename it'].
    oldName := curClass name.
    ( aString isNil)
	ifTrue: [^self]
	ifFalse: 
	    [newName := prompter response asSymbol.
	    (newName at: 1) isUppercase 
		ifFalse: 
		    [^self error: 'Class name should begin with 
				   an uppercase letter'].
	    (curClass environment includesKey: newName) 
		ifTrue: [^self error: newName , ' already exists']].

    "Save old Association"
    oldAssoc := curClass environment associationAt: oldName.

    "Rename the class now"
    curClass setName: newName asSymbol.

    "Fix up namespace"
    curClass environment at: curClass name put: oldAssoc value.
    curClass environment removeKey: oldName.

    "Notify programmer of all references to renamed class"
   "methods := SortedCollection new.
    CompiledMethod allInstancesDo: 
	    [:method | 
	    (method refersTo: oldAssoc) ifTrue: [methods add: method]].
    methods isEmpty 
	ifFalse: 
	    [ModalDialog new 
		alertMessage: 'Rename all references to 
		    class ' , oldName 
			, Character nl , 'to the new name: ' 
			, newNameundefined variable listView referenced
		in: listView.
	    MethodSetBrowser new 
		openOn: methods
		title: 'References to ' , oldName
		selection: oldName]."

    "Update class list"
    self updateClassList
!

text
    "Return a text string depending on the text mode (textMode) of the data object"

    | aStream count |
    textMode == #addClass 
	ifTrue: [^self getAddClassTemplate].

    curClass isNil 
	ifTrue: 
	    ["If no class is selected, return empty string "

	    ^String new: 0].

    textMode == #comment 
	ifTrue: 
	    ["Return comment associated with selected class"

	    ^self getClass comment isNil
		ifTrue: ['']
		ifFalse: [curClass comment]].

    textMode == #addMethod 
	ifTrue: [ ^self getClass -> self getAddMethodTemplate].

    curSelector isNil 
	ifTrue: 
	    [aStream := WriteStream on: (String new: 0).
	    curClass fileOutDeclarationOn: aStream.
	    ^aStream contents].
    "Display method source for selected class"
    "^self getClass -> (self getClass sourceCodeAt: curSelector)"
    ^self getClass sourceCodeAt: curSelector!

textMode: aSymbol
textMode := aSymbol! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.WebServer subclass: #MWServer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MWServer comment: 
nil!

!MouseWater.MWServer class methodsFor: 'initialising'!

start
    "Watch out!! Security hole, they could steal /etc/passwd!!"
    "WebServer publishMyFileSystem"

    | handler a b c|
	a := Smalltalk at: #nodes ifAbsent: [ nil].
	( a isNil )
	ifTrue:[ b := OrderedCollection new. Smalltalk at: #nodes put: b. a :=b.
	b := RootNode new.
	b contents: 'Root Node'.
	b title: 'Root Node'.
	c := a at: 1 ifAbsent: [nil].
	( c isNil )
	ifTrue: [ a add: b]
	ifFalse: [a at:1 put: b.].].
	a := Smalltalk at: #users ifAbsent: [ nil].
	( a isNil )
	ifTrue: [
	b := IdentityDictionary new.
	Smalltalk at: #users put: b.
	c := MouseWater.User new.
	c name: #Jepri.
	c password: 'Fanta'.
	b at: #Jepri put: c.
	c := MouseWater.User new.
	c name: #AnonyMous.
	c password: ''.
	b at: #AnonyMous put: c.
	].
Smalltalk at: #trans put: OrderedCollection new.
 a:=Smalltalk at: #trans.  
Transcript message: a -> #add:.
    self terminateServer: 8080.

    "Add a file server on a particular directory."
    handler := (self initializeServer: 8080) handler.
    handler addComponent: (STTFileWebServer named: 'disk'
                directory: '/').
  handler addComponent: (MyServlet named: 'classbrowser' ).
handler addComponent: (CodeCompiler named: 'CodeCompiler').
handler addComponent: (NameSpaceServlet named: 'MangleNameSpace').
handler addComponent: (MangleClassServlet named: 'mangleclass').
handler addComponent: (NodeServlet named: 'node').
handler addComponent: (TranscriptServlet named: 'transcript').
handler addComponent: (LoginServlet named: 'login').
handler addComponent: (ExamineProcessServlet named: 'examineprocess').! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

Smalltalk.Object subclass: #Node
	instanceVariableNames: 'contents parent children ctime mtime title '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.Node comment: 
nil!

!MouseWater.Node class methodsFor: 'initialising'!

new
"Initialise 2"
|r|
r := super new.
r init.
^r! !

!MouseWater.Node methodsFor: 'accessing'!

addChild: aNode
children add: aNode.!

asHTML
| content nodes |
nodes := Smalltalk at: #nodes.
content := '<div style="padding-left: 1em">', self openNodeHTML.
content := content, self contents, '</td><td><a href="/node?action=Preview&parent=', ( nodes indexOf: self ) displayString, '">Reply</a><br><a href="/node?action=Preview&parent=', ( nodes indexOf: self ) displayString, '">Edit</a>'.
content := content, self closeNodeHTML.
children do: [ :ea | content := content, ea asHTML]. 
content := content, '</div>'.
^content!

closeNodeHTML
|content|
content := '</td></tr></table>'.
^content!

contents
^contents!

contents: aString
contents := aString.!

init
children := OrderedCollection new.!

openNodeHTML
| content |
content := '<table border=1 style="margin-left: 1em" ><tr><td colspan=2>', self title, '</td></tr><tr><td width=90%>'.
^content!

parent
^parent!

parent: aNode
parent := aNode.
^parent!

title
^title!

title: aString
title := aString.
! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

Node subclass: #RootNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.RootNode comment: 
nil!

!MouseWater.RootNode methodsFor: 'responses'!

asHTML
| content nodes |
nodes := Smalltalk at: #nodes.
content := '<ul>'.
children do: [ :ea | (ea isNil) ifFalse: [ (ea title isNil) ifFalse: [ 
content := content, '<li>'.
content := content, '<a href="/node?index=', (nodes indexOf: ea) displayString, '">', (ea title), '</a>'.

]. ].].
content := content, '</ul>'.
content := content, '<a href="/node?action=Preview&parent=1">Add</a> a node.'.
^content! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #CodeCompiler
	instanceVariableNames: 'authoriser '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.CodeCompiler comment: 
nil!

!MouseWater.CodeCompiler class methodsFor: 'initialising'!

parent: aString
    "Comment describing purpose and answered value."
    | temporary variables |

! !

!MouseWater.CodeCompiler methodsFor: 'responses'!

authorizer
    ^authoriser!

authorizer: aWebAuthorizer
    authoriser := aWebAuthorizer.
 
!

loginID: aLoginID password: aPassword
    self authorizer: (WebAuthorizer loginID: aLoginID password: aPassword)!

respondTo:  aRequest
    "Comment describing purpose and answered value."
   | response auth |
auth := WebAuthorizer loginID: 'test' password: 'test'.
 auth
	authorize: aRequest
	in: self
	ifAuthorized: [ 'Authorised!' printNl.
response := CodeCompilerResponse new: aRequest.
response respondTo: aRequest.
^response].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #ExamineProcessServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.ExamineProcessServlet comment: 
nil!

!MouseWater.ExamineProcessServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | r oop |
oop := aRequest postDataAt: #oop ifAbsent: [ nil ].
(oop isNil)
ifTrue: [
r := MouseWater.StatisticResponse new.

r respondTo: aRequest.
^r.
].
r := ExamineProcess new.

r respondTo: aRequest.
^r.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #LoginServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.LoginServlet comment: 
nil!

!MouseWater.LoginServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | users user response  name password |
name := aRequest postDataAt: #name ifAbsent: [ nil].
password := aRequest postDataAt: #password ifAbsent: [ nil ].

( name isNil)
ifTrue: [
response := LoginResponse new.
response respondTo: aRequest.
^response]
ifFalse: [ 
users := Smalltalk at: #users ifAbsent: [nil].
user := users at: name asSymbol.
(user password asString = password asString)
ifTrue: [
response := FlavourResponse new.
response addCookie: 'AuthenToken' value: user newToken.
response flavour: 'LoggedIn'.
response respondTo: aRequest.
^response]
ifFalse: [
response := LoginResponse new.
response respondTo: aRequest.
^response
].
].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #MangleClassServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MangleClassServlet comment: 
nil!

!MouseWater.MangleClassServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response |

response := MangleClassResponse new: aRequest.
response respondTo: aRequest.
^response! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #MyServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MyServlet comment: 
nil!

!MouseWater.MyServlet class methodsFor: 'initialising'!

parent: aString
    "Why the hell am I getting calls to the class that are called parent?."
   ! !

!MouseWater.MyServlet methodsFor: 'initialising'!

parent: aString
    "Comment describing purpose and answered value."
  ! !

!MouseWater.MyServlet methodsFor: 'responding'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response |

response := MyResponse new.
response respondTo: aRequest.
^response! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #NameSpaceServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.NameSpaceServlet comment: 
nil!

!MouseWater.NameSpaceServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response |

response := MangleNameSpace new: aRequest.
response sendHeader; sendBody.
^response! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #NodeServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.NodeServlet comment: 
nil!

!MouseWater.NodeServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response index val comp testval err msg |
val := aRequest postDataAt: #action ifAbsent: [ nil ].
'Starting node servlet' printNl.
(val isNil)
ifTrue: [
response := NodeResponse new.
response respondTo: aRequest.
^response
].
( val match: 'Preview')
ifTrue: [
response := AddNodeResponse new.
response respondTo: aRequest.
^response
].
( val match: 'Create')
ifTrue: [
'Creating ' printNl.
response := CreateNodeResponse new.
response respondTo: aRequest.
^response
].

msg := 'I couldnt find an action to do.  I accept "Preview", "Create", or nothing at all, but you sent "', val, '".'.
err := ErrorResponse new: msg.
err respondTo: aRequest.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #TranscriptServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.TranscriptServlet comment: 
nil!

!MouseWater.TranscriptServlet class methodsFor: 'responses'!

respondTo: aRequest
   | stream a |
    stream := aRequest stream.

    aRequest pageFollows.
    a:=Smalltalk at: #trans.
    a do: [ :ea | stream nextPutAll: ea. stream nextPutAll: '<br>'.].! !

!MouseWater.TranscriptServlet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response |

response := TranscriptResponse new.
response respondTo: aRequest.
^response! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.FileWebServer subclass: #WorkSheet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.WorkSheet comment: 
nil!

!MouseWater.WorkSheet methodsFor: 'responses'!

respondTo:  aRequest
    "Comment describing purpose and answered value."
    | response |

response := WorkSheetResponse new.
response respondTo: aRequest.
^response! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

Smalltalk.Object subclass: #SoftError
	instanceVariableNames: 'message position '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.SoftError comment: 
nil!

!MouseWater.SoftError methodsFor: 'accessing'!

displayError: aString
    "Comment describing purpose and answered value."
    message := aString!

displayError: aString At: aNumber
    "Comment describing purpose and answered value."
  position := aNumber.
  self displayError: aString.!

displayError: aString at: aNumber
    "Comment describing purpose and answered value."
  position := aNumber.
  self displayError: aString.!

message
    "Comment describing purpose and answered value."
   ^message!

position
"Display the line number that the error occurred on"
^position! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NetClients.WikiWorks.WebResponse subclass: #MWResponse
	instanceVariableNames: 'isNodelet user '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MWResponse comment: 
nil!

!MouseWater.MWResponse class methodsFor: 'initialising'!

new
    "Comment describing purpose and answered value."
   | r |

r := super new.
r init.
^r!

new: aRequest
    "Comment describing purpose and answered value."
   | r |

r := super new.
r init: aRequest.
^r! !

!MouseWater.MWResponse methodsFor: 'accessing'!

isNodelet
^isNodelet!

setNodelet: aBoolean
isNodelet := aBoolean.! !

!MouseWater.MWResponse methodsFor: 'initialising'!

init
    "Comment describing purpose and answered value."

super init.
isNodelet := false.!

init: aRequest
    "Comment describing purpose and answered value."
| token users |
    responseStream := aRequest stream.
    request := aRequest.
isNodelet := false.

"Find the user corresponding to the AuthenToken in the request"
token := aRequest cookie: #AuthenToken.
users := Smalltalk at: #users.
( token isNil )
ifTrue: [
user := users at: #AnonyMous.]
ifFalse: [
( 'Searching for token: ', token) printNl.
users do: [ :ea | |tok | 
 tok := ea authenToken. 
( tok isNil )
ifFalse: [
( 'Comparing ', tok asString, ' and ', token asString) printNl.
( tok asString match: token asString) ifTrue: [ 
( 'Found user: ', ea name) printNl.
user := ea].].].
].

( user isNil ) ifTrue: [ user := users at: #AnonyMous].! !

!MouseWater.MWResponse methodsFor: 'responses'!

closeHTML
self << '</td></tr></table><BR><HR><BR><span name="pageFootLine" style="font-weight: normal; font-size: 0.5em">MouseWater is collaborative coding effort that just happens to look like a website.</span>'.!

closeNodelet
self << '<HR><BR>'.!

openHTML
self << '<span name="pageTitle" style="font-weight: bold; font-size: 1.5em">MouseWater</span>'.
self << '<BR><div style="background-color: #DDFFFF">
<a href="/node" style="margin: 3em">Nodes </a> 
<a href="/classbrowser" style="margin: 3em"> Class Browser </a> 
<a href="/transcript" style="margin: 3em"> Transcript </a> 
<a href="/examineprocess" style="margin: 3em"> Process Manager </a> 
</div><BR>'.
self << '<table border=1 width=100%><TR><td width=80% valign=top>'.!

openNodelet
self << '<HR><BR>'.!

respondBody: aRequest
"Responds like a respondTo:,  but does not print a HTTP header.  Use where you have already sent one response with respondTo:"
    responseStream := aRequest stream.
    request := aRequest.
    self notModified
	ifTrue: [ self sendNotModifiedResponse ]
	ifFalse: [
	    aRequest isHead ifFalse: [ self sendPage ]
	].

    responseStream := request := nil!

respondTo: aRequest
self init: aRequest.
   " self notModified
	ifTrue: [ self sendNotModifiedResponse ]
	ifFalse: ["
	    self sendHeader.
	    aRequest isHead ifFalse: [ self sendPage ].
	"]."

    responseStream := request := nil!

sendPage
| r |
self openHTML.
self sendBody.
self sendSideBarStart.

self openNodelet.
r := UserDetailsResponse new: request.
r setNodelet: true.
r sendBody.
self closeNodelet.

self openNodelet.
r := TranscriptResponse new: request.
r setNodelet: true.
r sendBody.
self closeNodelet.

self openNodelet.
r := StatisticResponse new: request.
r setNodelet: true.
r sendBody.
self closeNodelet.

self closeHTML.!

sendSideBarStart
self << '</td><td width=20%>'.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #CodeBrowserResponse
	instanceVariableNames: 'selectedNamespace codebrowser selectedClass selectedMethod selectedCategory methods meta '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.CodeBrowserResponse comment: 
nil!

!MouseWater.CodeBrowserResponse class methodsFor: 'initialising'!

new: aRequest
"New: contains routines to read data from the request, and initialises a MWBrowser and preps it for use."
| b |

b := super new: aRequest.
b init: aRequest.
^b
! !

!MouseWater.CodeBrowserResponse methodsFor: 'initialising'!

init: aWebRequest
| b request |
super init: aWebRequest.
request := aWebRequest.
b:= MWBrowser new.
b byCategory: false.
b  updateClassList.
selectedNamespace := request postDataAt: #namespace ifAbsent: [ nil ].
b namespaceSelection: [ selectedNamespace ].
selectedClass := request postDataAt: #class ifAbsent: [ nil ].
selectedCategory := request postDataAt: #category ifAbsent: [ nil ].
selectedMethod := request postDataAt: #method ifAbsent: [ nil ].
meta := request postDataAt: #meta ifAbsent: [ nil ].
( meta isNil ) ifTrue: [ meta := 'false' ].
( meta match: 'True' )
ifTrue: [meta := true.]
ifFalse: [meta := false].
b meta: meta.
b classSelection: [ selectedClass ].
b methodCategory: selectedCategory.
b methodCategories.
methods := b methods.
( selectedMethod isNil ) ifFalse: [
b method: [selectedMethod asSymbol].].
codebrowser := b.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #ClassViewerResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.ClassViewerResponse comment: 
nil!

!MouseWater.ClassViewerResponse methodsFor: 'responses'!

sendBody
	"I output the HTML for all the classes for the selected namespace"
| namespaces b selectedNamespace selectedClass a |
selectedNamespace := request postDataAt: #namespace ifAbsent: [ nil ].
( selectedNamespace isNil )
ifFalse: [
selectedClass := request postDataAt: #class ifAbsent: [ nil ].
( selectedClass isNil )
	ifTrue: [self << 'Please select a class from the list below'.]
	ifFalse: [
self << '<P>Viewing class: <strong>'. self << selectedClass. self << '</strong></p><P>'.
self << '<form action=/mangleclass>'.
self << '<input type=hidden name=namespace value='. 
self << selectedNamespace. self << '><input type=hidden name=class value="'.self << selectedClass. self <<'"><input type=hidden name=template value=newclass><input type=hidden name=mode value=addClass><input type=submit name=action value="Delete class"><input type=submit name=action value="Add Subclass"></form>'.
].
self << '</p><p>'.
b:= MWBrowser new.
b byCategory: false.
b  updateClassList.
b namespaceSelection: [ selectedNamespace ].
b  updateClassList.
a := b classList.
a do: [ :ea | 
	self linkTo: [self<< '/classbrowser'.  self << '?namespace='. self << selectedNamespace. self << '&class='. self << ea] titled: [self<<ea].
	self << ' ....'.
].


self << '</p><P>'.
].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #CodeCompilerResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.CodeCompilerResponse comment: 
nil!

!MouseWater.CodeCompilerResponse methodsFor: 'responses'!

sendBody
    "Compiles the code passed in 'code' and returns error messages, if any."
|  code err  c  mode|
code := request postDataAt: #code ifAbsent: [ nil ].
mode := request postDataAt: #mode ifAbsent: [ nil ].
self << '<h1>Compiling</h1> Received code: <P>'.
c := CodeEditorResponse new: request. c sendBody.
self << '<P> Now compiling for class: '.
self << selectedClass.
self << ' and category: '.
self << selectedCategory.
self << ' and for method: '.
self << selectedMethod.
err := SoftError new.
( mode isNil) ifFalse: [codebrowser textMode: mode asSymbol.].
codebrowser compile: code from: err.
self << '<P>Error response was: '. self << err message. self << ' at line '. self << err position.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #CodeEditorResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.CodeEditorResponse comment: 
nil!

!MouseWater.CodeEditorResponse methodsFor: 'responses'!

sendBody
	"I output the HTML for a code editing window, with correct links to the code compiler"
| code b err code template mode |

template := request postDataAt: #template ifAbsent: [ nil ].
mode := request postDataAt: #mode ifAbsent: [nil].
code := request postDataAt: #code ifAbsent: [ nil ].
self << '<h6>Editing Code</h6>'.
self << '<form action="/CodeCompiler">'.
self << '<P>Namespace: <input type=text name="namespace" value="'.
self << selectedNamespace. self << '">'.
( selectedClass isNil ) ifFalse: [
self << '<P>Class: <input type=text name="class" value="'.
self << selectedClass. self << '">'.].
( selectedCategory isNil ) ifFalse: [
self << '<P>Method Category: <input type=text name="category" value="'.
self << selectedCategory. self << '">'.].
( selectedMethod isNil ) ifFalse: [
self << '<input type=hidden name="method" value="'.
self << selectedMethod. self << '">'.].
meta ifTrue:  [ self << '<input type=hidden name="meta" value="True">'.].
( mode isNil ) ifFalse: [ 
self << '<input type=hidden name="mode" value="'.
self << mode. self << '">'.].
self << '</p>'.
self <<  '<textarea cols=80 rows=25 name="code">'.
(template isNil)
ifTrue: [
(code isNil)
ifTrue:  [ self << codebrowser text]
ifFalse: [ self << code.].
]
ifFalse: [
(template match: 'newclass')
ifTrue: [ self << codebrowser getAddClassTemplate].
].
self << '</tex'. self << 'tarea>'.
self << '<P><input type=submit value="Accept">'.
self << '</form>'.!

test
    "Comment describing purpose and answered value."
   ^'<h1>test</h1>'! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #MangleClassResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MangleClassResponse comment: 
nil!

!MouseWater.MangleClassResponse methodsFor: 'responses'!

sendBody
	"I add, delete and reparent classes"
|  b a val response  msg err newclass sfterr  |
selectedNamespace := request postDataAt: #namespace ifAbsent: [ nil ].
( selectedNamespace isNil  |  selectedClass isNil )
	ifTrue: [self << 'You have to give me a class and a namespace so I can perform an action on it'.].
newclass := request postDataAt: #newclass ifAbsent: [ nil ].

val := request postDataAt: #action ifAbsent: [ nil ].
(val isNil) ifTrue:[
msg := 'I couldnt find an action to do.  I accept "Rename", "Add" and "Delete", but you sent nothing.'.
err := ErrorResponse new: msg.
err respondTo: request.
^nil
].
(val match: 'Add Subclass')
ifTrue: [
response := CodeEditorResponse new.
response respondBody: request.
^response
].
( val match: 'Delete class')
ifTrue: [
sfterr := SoftError new.
codebrowser removeClass: sfterr.
response := ErrorResponse new: sfterr message.
response respondBody: request.
^response
].
( val match: 'Rename')
ifTrue: [
codebrowser renameClass: newclass.
response := SuccessResponse new: 'The class "', selectedClass, '" was renamed to "', newclass, '".'.
response respondBody: request.
^response
].

msg := 'I couldnt find an action to do.  I accept "Rename", "Add" and "Delete", but you sent "', val, '".'.
err := ErrorResponse new: msg.
err respondTo: request.
! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #MangleNameSpace
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MangleNameSpace comment: 
nil!

!MouseWater.MangleNameSpace methodsFor: 'responses'!

sendBody
	"I attempt to carry out the action in the action parameter, and print out the result"
| action newspace c |
action := request postDataAt: #action ifAbsent: [ nil ].
newspace := request postDataAt: #newnamespace ifAbsent: [ nil ].
( action isNil ) ifTrue: [ self << 'No action specified, please try again'.^nil].
"( action similarityTo: 'delete' )
ifTrue:[ ^nil ]."
c := action similarityTo: 'add'. 
( c = 0)
ifTrue: [codebrowser addSubNamespace: newspace. self << 'Success' ].

"( action similarityTo: 'rename')
ifTrue: [ ^nil]." ! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #MessageCategoryViewer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MessageCategoryViewer comment: 
nil!

!MouseWater.MessageCategoryViewer methodsFor: 'responses'!

sendBody
    "Comment describing purpose and answered value."
|catSet listmethods sendmeta |
( selectedClass isNil ) ifFalse: [
( selectedNamespace isNil) ifTrue: [ self << 'Error, class requested but namespace is nil, so I dont know where to find it'. ^nil. ].].
"codebrowser classSelection: [ selectedClass ]."

self << '<p>'.
self << '<P>Selected method category: <strong>'. self << selectedCategory. self << '</strong></p>'.
listmethods := [ :ea | 
self linkTo: [
self<< '/classbrowser'.
self << '?namespace='. 
self << selectedNamespace.
self << '&class='. 
self << selectedClass. 
self << '&category='. 
self << ea. 
self << '&meta='. 
self << sendmeta. 
] titled: [self<<ea].
self << '....'.
].
self << '<table><tr><td>Instance Methods</td><td>Class Methods</td></tr><tr><td>'.
catSet := codebrowser methodCategories.
catSet do: listmethods.
self << '</td><td>'.
codebrowser meta: true. sendmeta := 'True'.
catSet := codebrowser methodCategories.
catSet do: listmethods.
self << '</td></tr></table>'.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #MethodResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MethodResponse comment: 
nil!

!MouseWater.MethodResponse methodsFor: 'responses'!

sendBody
	"I output all the methods for the selected classe and namespace namespace"
( selectedCategory isNil )
ifFalse: [
( methods isNil )
ifFalse: [
self << '<p>'.
self << '<P>Selected '. meta ifTrue: [ self << ' class ' ]. self << ' method: <strong>'. self << selectedMethod. self << '</strong></p>'.
methods do: [ :ea | 
self linkTo: [
self<< '/classbrowser'. 
self << '?namespace='. 
self << selectedNamespace.
self << '&class='. 
self << selectedClass. 
self << '&category='. 
self << selectedCategory. 
meta ifTrue: [ self << '&meta=True'.  ].
self << '&method='. 
self << ea asString. ] titled: [self<<ea].
self << '....'.
].
].
].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

CodeBrowserResponse subclass: #NameSpaceViewerResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.NameSpaceViewerResponse comment: 
nil!

!MouseWater.NameSpaceViewerResponse methodsFor: 'responses'!

sendBody
	"I output the HTML for all the available namespaces"
| namespaces b|

( selectedNamespace isNil )
	ifTrue: [ self << 'Please select a namespace to browse from the list below'.]
	ifFalse: [
self << '<P>Viewing namespace: <strong>'. self << selectedNamespace. self << '</strong></p><P>'.
self << '<form action=/MangleNameSpace>'.
self linkTo: [ self << '/MangleNameSpace?namespace='. self << selectedNamespace. self << '&action=delete'.] titled: [ self << 'Delete '. ]. self << ' current namespace ('. self << selectedNamespace. self << ') or '.
self << ' add a sub-namespace to '.self << selectedNamespace. self << '<input type=hidden name=action value=add><input type=hidden name=namespace value="'. self << selectedNamespace. self << '"><input type=text name=newnamespace value="NewNameSpace"><input type=submit></form>'.
].
self << '</p><p>'.
namespaces := codebrowser namespaceList.
namespaces do: [ :ea | 
	self linkTo: [self<< '/classbrowser'. self << '?namespace='. self << ea] titled: [self<<ea].
	self << ' ....'.
].
self << '</p><P>'.
! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #ErrorResponse
	instanceVariableNames: 'message '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.ErrorResponse comment: 
nil!

!MouseWater.ErrorResponse class methodsFor: 'initialising'!

new: aString
|r|
r := super new.
r init: aString.
^r! !

!MouseWater.ErrorResponse methodsFor: 'initialising'!

init: aString
message := aString! !

!MouseWater.ErrorResponse methodsFor: 'responses'!

sendBody
|message|
self << message! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #ExamineProcess
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.ExamineProcess comment: 
nil!

!MouseWater.ExamineProcess methodsFor: 'responding'!

sendBody
| oop r |

oop := request postDataAt: #oop ifAbsent: [nil].
( oop isNil )
ifTrue: [
r := StatisticResponse new.
r setNodelet: self isNodelet.
r respondTo: request.
].
Process allInstances do: [ :ea |
( oop asInteger = ea asOop )
ifTrue: [
self << 'Name: '; << ea name.
self << '<BR>Priority: '; << ea priority.
self << '<BR>Context: '; << ea suspendedContext.
self << '<BR>'.
( ea isActive ) ifTrue: [ self << '<LI>Running'].
( ea isReady ) ifTrue: [ self << '<LI>Ready'].
( ea isSuspended ) ifTrue: [ self << '<LI>Suspended'].
( ea isTerminated ) ifTrue: [ self << '<LI>Terminated'].
( ea isWaiting ) ifTrue: [ self << '<LI>Waiting'].
].
].
! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #FlavourResponse
	instanceVariableNames: 'flavour '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.FlavourResponse comment: 
nil!

!MouseWater.FlavourResponse methodsFor: 'accessing'!

flavour: aString
flavour := aString.!

sendBody

( flavour match: 'LoggedIn' )
ifTrue: [
self << 'Congratulations, you have successfully logged in'.].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #LoginResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.LoginResponse comment: 
nil!

!MouseWater.LoginResponse methodsFor: 'responses'!

sendBody

self << '<P>Login</p><form action=/login>Login: <input type=text name=name value="Username"><BR>Password: <input type=password name=password><br><input type=submit value=Login >'.^nil.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #MyResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.MyResponse comment: 
nil!

!MouseWater.MyResponse methodsFor: 'responses'!

hello
^'hello'!

sendBody
    "Comment describing purpose and answered value."
| b a url data catSet selectedCategory methodDict selectedMethod namespaces selectedNamespace c | 
b:= MWBrowser new.
b byCategory: false.


c := NameSpaceViewerResponse new: request. c sendBody.
self << 'Here'.
self << '<p>'.
url := URL new.
url path: request location; host: 'localhost'; port: 8080.
data := request postDataAt: #class ifAbsent: [ nil ].
selectedNamespace := request postDataAt: #namespace ifAbsent: [ nil ].

b  updateClassList.
b namespaceSelection: [ selectedNamespace ].
selectedCategory := request postDataAt: #category ifAbsent: [ nil ].
selectedMethod := request postDataAt: #method ifAbsent: [ nil ].

c := ClassViewerResponse new: request. c sendBody.

c := MessageCategoryViewer new: request. c sendBody.

c := MethodResponse new: request. c sendBody.

c := CodeEditorResponse new: request. c sendBody.!

sendPage
self openHTML.
self sendBody.
self closeHTML.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #NodeResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.NodeResponse comment: 
nil!

!MouseWater.NodeResponse methodsFor: 'initialising'!

init: aWebRequest
| index title request  |
super init: aWebRequest.
request := aWebRequest.
! !

!MouseWater.NodeResponse methodsFor: 'responses'!

sendBody
|index title|
index := request postDataAt: #index ifAbsent: [ nil ].
title := request postDataAt: #title ifAbsent: [ nil ].
( index isNil ) ifTrue: [ index := '1']. 
(index isNil ) ifFalse: [ | num nodes node | num := index asNumber. nodes:= Smalltalk at: #nodes. node := nodes at: num. self << node asHTML. node printNl].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NodeResponse subclass: #AddNodeResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.AddNodeResponse comment: 
nil!

!MouseWater.AddNodeResponse methodsFor: 'responses'!

sendBody
    "Comment describing purpose and answered value."
    | parentidx nodes val |
val := request postDataAt: #parent ifAbsent: [ nil ].
'Starting addnode sendbody' printNl.
( val isNil ) ifFalse: [
parentidx := val asNumber.
nodes:= Smalltalk at: #nodes.
( parentidx positive ) ifTrue: [ 
| node | 
node := nodes at: parentidx. self << node asHTML. node printNl.
self << '<form action=/node ><input type=hidden name=parent value='. self << parentidx. self << '>'.
self << '<h5>Respond to this node</h5>'.
self << '<input type=text name=title value="title"><br><textarea name=content cols=80 rows=25></textarea><br><input type=submit name=action value="Preview">'.
self << '<input type=submit name=action value="Create">'.
].].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

NodeResponse subclass: #CreateNodeResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.CreateNodeResponse comment: 
nil!

!MouseWater.CreateNodeResponse methodsFor: 'responses'!

sendBody
| val title content node nodes parentidx pnode |
val := request postDataAt: #parent ifAbsent: [ nil ].
( val isNil ) ifFalse: [
parentidx := val asNumber.
title := request postDataAt: #title ifAbsent: [ 'Untitled Node' ].
content := request postDataAt: #content ifAbsent: [ nil ].
nodes:= Smalltalk at: #nodes.
pnode := nodes at: parentidx.
node := Node new.
node contents: content.
node parent: pnode.
node title: title.
nodes add: node.
pnode addChild: node.
self << 'Success!'.
].
! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #StatisticResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.StatisticResponse comment: 
nil!

!MouseWater.StatisticResponse methodsFor: 'responses'!

sendBody
|o a| 
o:= ObjectMemory current. 
self << 'Scavenges before tenuring: '.
self << o scavengesBeforeTenuring asInteger.
self << '<br>Alloc Failures: '; << o allocFailures.
a := o fixedSpaceSize asInteger.
a := a/1024/1024.
a := a asInteger.
self << '<br>Fixed Space: '; << a; << 'Mib'.
self << '<br>Fixed Space Used: '; << ((o fixedSpaceUsedBytes)/1024/1024) asInteger; << 'Mib'.
self << '<br>Time To Compact: '; << o timeToCompact asInteger; << 'ms'.
self << '<br>Time To Collect: '; << o timeToCollect asInteger; << 'ms'.
self << '<br>Time To Scavenge: '; << o timeToScavenge asInteger; << 'ms'.
self << '<br>'.
( self isNodelet )
ifTrue: [ self << '<br>Processes: '; <<Process allInstances size.]
ifFalse: [
Process allInstances do: [:ea | self << '<br><li>'; << '<a href="/examineprocess?oop='; << ea asOop; << '">'; << ea name; << '</a> in context '; << ea suspendedContext ].
].! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #SuccessResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.SuccessResponse comment: 
nil!

!MouseWater.SuccessResponse methodsFor: 'responses'!

sendBody
|message|
self << message! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #TranscriptResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.TranscriptResponse comment: 
nil!

!MouseWater.TranscriptResponse class methodsFor: 'responses'!

sendBody
  | stream a |


    a:=Smalltalk at: #trans.
    a do: [ :ea | stream nextPutAll: ea. stream nextPutAll: '<br>'.].! !

!MouseWater.TranscriptResponse methodsFor: 'responses'!

sendBody
  | a |
    a:=Smalltalk at: #trans.

self << '<PRE>'.
( self isNodelet )
ifFalse: [

    a do: [ :ea | self <<   ea. ].
]
ifTrue: [ | maxitems |
( a size < 30 ) ifTrue: [ maxitems := a size] ifFalse: [ maxitems:=30].
    1 to: maxitems do: [ :ea | |b|
 b :=  (a size) - maxitems + ea.
 self << (a at: b)
].
].
self << '</pre>'.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

MWResponse subclass: #UserDetailsResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.UserDetailsResponse comment: 
nil!

!MouseWater.UserDetailsResponse methodsFor: 'responses'!

sendBody
self << 'Name: '; << user name.! !


"Filed out from GNU Smalltalk version 2.1.2 on 3-Oct-2003  19:29:44"!

Smalltalk.Object subclass: #User
	instanceVariableNames: 'name password currentURL currentLocation homePage xp level godMode title authenToken '
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

MouseWater.User comment: 
nil!

!MouseWater.User methodsFor: 'accessing'!

authenToken
^authenToken!

name
^name.!

name: aString
name := aString.!

newToken
| r  t|
r := Random next displayString.
t := name, r.
authenToken := t.
^t!

password
^password.!

password: aString
password := aString.! !


Namespace current: Smalltalk!
