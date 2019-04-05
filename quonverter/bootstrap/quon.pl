use strict;
use Carp;
use Carp::Always;
sub greaterthan { $_[0] > $_[1] };
sub equalString { $_[0] eq $_[1] };
sub read_file { my $file = shift; $file || die "Empty file name!!!"; open my $fh, '<', $file or die; local $/ = undef; my $cont = <$fh>; close $fh; return $cont; }; 
sub write_file {my $file = shift; my $data = shift; $file || die "Empty file name!!!"; open my $fh, '<', $file or die; print $fh $data; close $fh; } 
sub stringConcatenate { $_[0] . $_[1]}
sub subtract { $_[0] - $_[1]}
sub andBool { $_[0] && $_[1]}
sub equal { $_[0] == $_[1]}
sub panic { carp @_; die "@_"}
sub intToString { return $_[0]}
sub character { return chr($_[0])}
sub getStringArray { my $index = shift; my $arr = shift; return $arr->[$index]}
use strict;
use Carp;
use Data::Dumper;
my $globalStackTrace = undef;
my $globalTrace = undef;
my $globalStepTrace = undef;
my $globalArgs = undef;
my $globalArgsCount = undef;
my $true = 1;

my $false = 0;
my $undef;

sub isNil {
    return !defined($_[0]);
}


#Forward declarations

sub add;
sub addf;
sub sub1;
sub add1;
sub clone;
sub newVoid;
sub cons;
sub stackDump;
sub car;
sub cdr;
sub isList;
sub emptyList;
sub isEmpty;
sub alistCons;
sub assoc;
sub equalBox;
sub displayList;
sub display;
sub boxType;
sub boxString;
sub boxSymbol;
sub boxBool;
sub boxInt;
sub assertType;
sub unBoxString;
sub unBoxSymbol;
sub unBoxBool;
sub unBoxInt;
sub stringify;
sub hasTag;
sub getTag;
sub getTagFail;
sub assocExists;
sub assocFail;
sub setTag;
sub filterVoid;
sub filterTokens;
sub finish_token;
sub readString;
sub readComment;
sub isWhiteSpace;
sub isLineBreak;
sub incForNewLine;
sub annotateReadPosition;
sub scan;
sub isOpenBrace;
sub openBrace;
sub isCloseBrace;
sub closeBrace;
sub sexprTree;
sub skipList;
sub readSexpr;
sub test0;
sub test1;
sub test2_do;
sub test2;
sub test3_do;
sub test3;
sub test4_do;
sub returnThis;
sub test4;
sub test5;
sub test6;
sub test7_do;
sub test7;
sub beer;
sub plural;
sub beers;
sub test8;
sub test9;
sub test10;
sub test12;
sub test13;
sub test15;
sub test16;
sub caar;
sub cadr;
sub caddr;
sub cadddr;
sub caddddr;
sub cddr;
sub first;
sub second;
sub third;
sub fourth;
sub fifth;
sub makeNode;
sub addToNode;
sub makeStatementNode;
sub astExpression;
sub astSubExpression;
sub astIf;
sub astSetStruct;
sub astSet;
sub astGetStruct;
sub astReturnVoid;
sub listLength;
sub astStatement;
sub astBody;
sub astFunction;
sub astFunctionList;
sub astFunctions;
sub loadLib;
sub astInclude;
sub astIncludeList;
sub astIncludes;
sub astStruct;
sub astType;
sub astTypeList;
sub astTypes;
sub ansiFunctionArgs;
sub declarationsof;
sub codeof;
sub functionNameof;
sub nodeof;
sub lineof;
sub subnameof;
sub nameof;
sub childrenof;
sub isNode;
sub truthy;
sub isNotFalse;
sub ansiLeaf;
sub ansiStructGetterExpression;
sub ansiExpression;
sub ansiRecurList;
sub isLeaf;
sub ansiSubExpression;
sub ansiIf;
sub ansiSetStruct;
sub ansiGetStruct;
sub ansiSet;
sub ansiStatement;
sub printIndent;
sub newLine;
sub ansiBody;
sub ansiDeclarations;
sub noStackTrace;
sub toStr;
sub ansiFunction;
sub ansiForwardDeclaration;
sub ansiForwardDeclarations;
sub ansiFunctions;
sub ansiIncludes;
sub listLast;
sub ansiTypeDecl;
sub ansiStructComponents;
sub ansiStruct;
sub ansiTypeMap;
sub ansiFuncMap;
sub ansiType;
sub ansiTypes;
sub ansiCompile;
sub concatLists;
sub alistKeys;
sub mergeIncludes;
sub merge_recur;
sub mergeInclude;
sub argList;
sub listReverse;
sub inList;
sub tron;
sub troff;
sub stron;
sub stroff;
sub numbers;
sub lexType;
sub perlLeaf;
sub perlStructGetterExpression;
sub perlExpression;
sub perlRecurList;
sub perlSubExpression;
sub perlIf;
sub perlSetStruct;
sub perlGetStruct;
sub perlSet;
sub assertNode;
sub perlStatement;
sub perlBody;
sub perlDeclarations;
sub perlFunction;
sub perlForwardDeclaration;
sub perlForwardDeclarations;
sub perlFunctions;
sub dollar;
sub atSym;
sub perlIncludes;
sub perlTypeDecl;
sub perlStructComponents;
sub perlStruct;
sub perlTypeMap;
sub perlConstMap;
sub perlFuncMap;
sub perlType;
sub perlTypes;
sub perlFunctionArgs;
sub perlCompile;
sub nodeFunctionArgs;
sub nodeLeaf;
sub nodeStructGetterExpression;
sub nodeExpression;
sub nodeRecurList;
sub nodeSubExpression;
sub nodeIf;
sub nodeSetStruct;
sub nodeGetStruct;
sub nodeSet;
sub nodeStatement;
sub nodeBody;
sub nodeDeclarations;
sub nodeFunction;
sub nodeForwardDeclaration;
sub nodeForwardDeclarations;
sub nodeFunctions;
sub nodeIncludes;
sub nodeTypeDecl;
sub nodeStructComponents;
sub nodeStruct;
sub nodeTypeMap;
sub nodeFuncMap;
sub nodeType;
sub nodeTypes;
sub nodeCompile;
sub start;

#End forward declarations



#Building function add from line: 19

sub add {
  my $a  = shift;
my $b  = shift;

  
if ($globalTrace) { printf("add at base.qon:19\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: add

  if ($globalTrace) {printf("Leaving \n")}

  return(subtract($a , subtract(0 , $b )));

}


#Building function addf from line: 20

sub addf {
  my $a  = shift;
my $b  = shift;

  
if ($globalTrace) { printf("addf at base.qon:20\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: addf

  if ($globalTrace) {printf("Leaving \n")}

  return(subf($a , subf(0 , $b )));

}


#Building function sub1 from line: 21

sub sub1 {
  my $a  = shift;

  
if ($globalTrace) { printf("sub1 at base.qon:21\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sub1

  if ($globalTrace) {printf("Leaving \n")}

  return(subtract($a , 1 ));

}


#Building function add1 from line: 22

sub add1 {
  my $a  = shift;

  
if ($globalTrace) { printf("add1 at base.qon:22\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: add1

  if ($globalTrace) {printf("Leaving \n")}

  return(add($a , 1 ));

}


#Building function clone from line: 24

sub clone {
  my $b  = shift;

  my $newb = undef ;

if ($globalTrace) { printf("clone at base.qon:24\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{typ} = $b->{typ};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{lis} = $b->{lis};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{str} = $b->{str};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{i} = $b->{i};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{lengt} = $b->{lengt};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: clone

  if ($globalTrace) {printf("Leaving \n")}

  return($newb );

}


#Building function newVoid from line: 36

sub newVoid {
  
  my $newb = undef ;

if ($globalTrace) { printf("newVoid at base.qon:36\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{voi} = $true ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newb->{typ} = "void" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: newVoid

  if ($globalTrace) {printf("Leaving \n")}

  return($newb );

}


#Building function cons from line: 44

sub cons {
  my $data  = shift;
my $l  = shift;

  my $p = undef ;

if ($globalTrace) { printf("cons at base.qon:44\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $p = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $p->{cdr} = $l ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $p->{car} = $data ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $p->{typ} = "list" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($p );

}


#Building function stackDump from line: 52

sub stackDump {
  
  
if ($globalTrace) { printf("stackDump at base.qon:52\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("" )
  ;

}


#Building function car from line: 57

sub car {
  my $l  = shift;

  
if ($globalTrace) { printf("car at base.qon:57\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  assertType("list" , $l )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("Cannot call car on empty list!\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    panic("Cannot call car on empty list!\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($undef );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil($l->{car})) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return($undef );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return($l->{car});

    };

  };

}


#Building function cdr from line: 70

sub cdr {
  my $l  = shift;

  
if ($globalTrace) { printf("cdr at base.qon:70\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  assertType("list" , $l )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("Attempt to cdr an empty list!!!!\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    panic("Attempt to cdr an empty list!!!!\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($undef );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($l->{cdr});

  };

}


#Building function isList from line: 80

sub isList {
  my $b  = shift;

  
if ($globalTrace) { printf("isList at base.qon:80\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return(equalString("list" , $b->{typ}));

  };

}


#Building function emptyList from line: 86

sub emptyList {
  
  
if ($globalTrace) { printf("emptyList at base.qon:86\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: emptyList

  if ($globalTrace) {printf("Leaving \n")}

  return($undef );

}


#Building function isEmpty from line: 88

sub isEmpty {
  my $b  = shift;

  
if ($globalTrace) { printf("isEmpty at base.qon:88\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($false );

  };

}


#Building function alistCons from line: 94

sub alistCons {
  my $key  = shift;
my $value  = shift;
my $alist  = shift;

  
if ($globalTrace) { printf("alistCons at base.qon:94\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: alistCons

  if ($globalTrace) {printf("Leaving \n")}

  return(cons(cons($key , $value ), $alist ));

}


#Building function assoc from line: 97

sub assoc {
  my $searchTerm  = shift;
my $l  = shift;

  my $elem = undef ;

if ($globalTrace) { printf("assoc at base.qon:97\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  assertType("list" , $l )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return(boxBool($false ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $elem = car($l );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    assertType("list" , $elem )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isEmpty($elem )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return(assoc($searchTerm , cdr($l )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( $false ) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("Comparing %s and %s\n" , $searchTerm , stringify(car($elem )))
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("" )
        ;

      };
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString($searchTerm , stringify(car($elem )))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        return($elem );

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        return(assoc($searchTerm , cdr($l )));

      };

    };

  };

}


#Building function equalBox from line: 116

sub equalBox {
  my $a  = shift;
my $b  = shift;

  
if ($globalTrace) { printf("equalBox at base.qon:116\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isList($b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($false );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("string" , boxType($a ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return(equalString(unBoxString($a ), stringify($b )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString("bool" , boxType($a ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        return(andBool(unBoxBool($a ), unBoxBool($b )));

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalString("symbol" , boxType($a ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalString("symbol" , boxType($b ))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return(equalString(unBoxSymbol($a ), unBoxSymbol($b )));

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return($false );

          };

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalString("int" , boxType($a ))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return(equal(unBoxInt($a ), unBoxInt($b )));

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return($false );

          };

        };

      };

    };

  };

}


#Building function displayList from line: 137

sub displayList {
  my $l  = shift;
my $indent  = shift;

  my $val = undef ;

if ($globalTrace) { printf("displayList at base.qon:137\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isList($l )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isEmpty($l )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

        
        return;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        $val = car($l );
        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( isList($val )) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("%s" , openBrace ())
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          displayList(car($l ), add1($indent ))
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("%s" , closeBrace ())
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          displayList(cdr($l ), add1($indent ))
          ;

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalString("string" , $val->{typ})) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("\"%s\" " , unBoxString($val ))
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("%s " , stringify($val ))
            ;

          };
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          displayList(cdr($l ), $indent )
          ;

        };

      };

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString("string" , $l->{typ})) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("\"%s\" " , unBoxString($l ))
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("%s " , stringify($l ))
        ;

      };

    };

  };

}


#Building function display from line: 167

sub display {
  my $l  = shift;

  
if ($globalTrace) { printf("display at base.qon:167\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("nil " )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isList($l )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("[" )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      displayList($l , 0 )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("]" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      displayList($l , 0 )
      ;

    };

  };

}


#Building function boxType from line: 181

sub boxType {
  my $b  = shift;

  
if ($globalTrace) { printf("boxType at base.qon:181\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b->{typ});

}


#Building function boxString from line: 183

sub boxString {
  my $s  = shift;

  my $b = undef ;

if ($globalTrace) { printf("boxString at base.qon:183\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{str} = $s ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{lengt} = length($s );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{typ} = "string" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b );

}


#Building function boxSymbol from line: 193

sub boxSymbol {
  my $s  = shift;

  my $b = undef ;

if ($globalTrace) { printf("boxSymbol at base.qon:193\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b = boxString($s );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{typ} = "symbol" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b );

}


#Building function boxBool from line: 198

sub boxBool {
  my $boo  = shift;

  my $b = undef ;

if ($globalTrace) { printf("boxBool at base.qon:198\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{boo} = $boo ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{typ} = "bool" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: boxBool

  if ($globalTrace) {printf("Leaving \n")}

  return($b );

}


#Building function boxInt from line: 207

sub boxInt {
  my $val  = shift;

  my $b = undef ;

if ($globalTrace) { printf("boxInt at base.qon:207\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{i} = $val ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{typ} = "int" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b );

}


#Building function assertType from line: 216

sub assertType {
  my $atype  = shift;
my $abox  = shift;

  
if ($globalTrace) { printf("assertType at base.qon:216\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($abox )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString($atype , "nil" )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

      
      return;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

      
      return;

    };

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString($atype , boxType($abox ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

      
      return;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("Assertion failure: provided value is not a '%s'!  It was actually:" , $atype )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      display($abox )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      panic("Invalid type!" )
      ;

    };

  };

}


#Building function unBoxString from line: 228

sub unBoxString {
  my $b  = shift;

  
if ($globalTrace) { printf("unBoxString at base.qon:228\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  assertType("string" , $b )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b->{str});

}


#Building function unBoxSymbol from line: 231

sub unBoxSymbol {
  my $b  = shift;

  
if ($globalTrace) { printf("unBoxSymbol at base.qon:231\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b->{str});

}


#Building function unBoxBool from line: 232

sub unBoxBool {
  my $b  = shift;

  
if ($globalTrace) { printf("unBoxBool at base.qon:232\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b->{boo});

}


#Building function unBoxInt from line: 233

sub unBoxInt {
  my $b  = shift;

  
if ($globalTrace) { printf("unBoxInt at base.qon:233\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  return($b->{i});

}


#Building function stringify from line: 235

sub stringify {
  my $b  = shift;

  
if ($globalTrace) { printf("stringify at base.qon:235\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return("nil" );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("string" , boxType($b ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return(unBoxString($b ));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString("bool" , boxType($b ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( unBoxBool($b )) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          return("true" );

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          return("false" );

        };

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalString("int" , boxType($b ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          return(intToString(unBoxInt($b )));

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalString("symbol" , boxType($b ))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return(unBoxSymbol($b ));

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            return(boxType($b ));

          };

        };

      };

    };

  };

}


#Building function hasTag from line: 257

sub hasTag {
  my $aBox  = shift;
my $key  = shift;

  
if ($globalTrace) { printf("hasTag at base.qon:257\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($aBox )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: hasTag

    if ($globalTrace) {printf("Leaving \n")}

    return($false );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: hasTag

    if ($globalTrace) {printf("Leaving \n")}

    return(isNotFalse(assoc(stringify($key ), $aBox->{tag})));

  };

}


#Building function getTag from line: 263

sub getTag {
  my $aBox  = shift;
my $key  = shift;

  
if ($globalTrace) { printf("getTag at base.qon:263\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: getTag

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc(stringify($key ), $aBox->{tag})));

}


#Building function getTagFail from line: 274

sub getTagFail {
  my $aBox  = shift;
my $key  = shift;
my $onFail  = shift;

  
if ($globalTrace) { printf("getTagFail at base.qon:274\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( hasTag($aBox , $key )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: getTagFail

    if ($globalTrace) {printf("Leaving \n")}

    return(getTag($aBox , $key ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: getTagFail

    if ($globalTrace) {printf("Leaving \n")}

    return($onFail );

  };

}


#Building function assocExists from line: 280

sub assocExists {
  my $key  = shift;
my $aBox  = shift;

  
if ($globalTrace) { printf("assocExists at base.qon:280\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($aBox )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: assocExists

    if ($globalTrace) {printf("Leaving \n")}

    return($false );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: assocExists

    if ($globalTrace) {printf("Leaving \n")}

    return(isNotFalse(assoc($key , $aBox )));

  };

}


#Building function assocFail from line: 288

sub assocFail {
  my $key  = shift;
my $aBox  = shift;
my $onFail  = shift;

  
if ($globalTrace) { printf("assocFail at base.qon:288\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( assocExists($key , $aBox )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: assocFail

    if ($globalTrace) {printf("Leaving \n")}

    return(assoc($key , $aBox ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: assocFail

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(boxString($key ), $onFail ));

  };

}


#Building function setTag from line: 296

sub setTag {
  my $key  = shift;
my $val  = shift;
my $aStruct  = shift;

  
if ($globalTrace) { printf("setTag at base.qon:296\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $aStruct->{tag} = alistCons($key , $val , $aStruct->{tag});
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: setTag

  if ($globalTrace) {printf("Leaving \n")}

  return($aStruct );

}


#Building function filterVoid from line: 306

sub filterVoid {
  my $l  = shift;

  my $token = undef ;

if ($globalTrace) { printf("filterVoid at base.qon:306\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterVoid

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token = car($l );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("void" , $token->{typ})) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterVoid

      if ($globalTrace) {printf("Leaving \n")}

      return(filterVoid(cdr($l )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterVoid

      if ($globalTrace) {printf("Leaving \n")}

      return(cons($token , filterVoid(cdr($l ))));

    };

  };

}


#Building function filterTokens from line: 318

sub filterTokens {
  my $l  = shift;

  my $token = undef ;

if ($globalTrace) { printf("filterTokens at base.qon:318\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterTokens

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token = car($l );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString(boxType($token ), "symbol" )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString("__LINE__" , stringify($token ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterTokens

        if ($globalTrace) {printf("Leaving \n")}

        return(cons(getTagFail($token , boxString("line" ), boxInt(-1 )), filterTokens(cdr($l ))));

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalString("__COLUMN__" , stringify($token ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterTokens

          if ($globalTrace) {printf("Leaving \n")}

          return(cons(getTagFail($token , boxString("column" ), boxInt(-1 )), filterTokens(cdr($l ))));

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterTokens

          if ($globalTrace) {printf("Leaving \n")}

          return(cons($token , filterTokens(cdr($l ))));

        };

      };

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: filterTokens

      if ($globalTrace) {printf("Leaving \n")}

      return(cons($token , filterTokens(cdr($l ))));

    };

  };

}


#Building function finish_token from line: 344

sub finish_token {
  my $prog  = shift;
my $start  = shift;
my $len  = shift;
my $line  = shift;
my $column  = shift;
my $filename  = shift;

  my $token = undef ;

if ($globalTrace) { printf("finish_token at base.qon:344\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan($len , 0 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token = boxSymbol(substr($prog , $start , $len ));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token->{tag} = alistCons(boxString("filename" ), boxString($filename ), alistCons(boxString("column" ), boxInt($column ), alistCons(boxString("line" ), boxInt($line ), alistCons(boxString("totalCharPos" ), boxInt($start ), $undef ))));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: finish_token

    if ($globalTrace) {printf("Leaving \n")}

    return($token );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: finish_token

    if ($globalTrace) {printf("Leaving \n")}

    return(newVoid ());

  };

}


#Building function readString from line: 359

sub readString {
  my $prog  = shift;
my $start  = shift;
my $len  = shift;

  my $token = "" ;

if ($globalTrace) { printf("readString at base.qon:359\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $token = substr($prog , sub1(add($start , $len )), 1 );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("\"" , $token )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readString

    if ($globalTrace) {printf("Leaving \n")}

    return(substr($prog , $start , sub1($len )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("\\" , $token )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readString

      if ($globalTrace) {printf("Leaving \n")}

      return(readString($prog , $start , add(2 , $len )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readString

      if ($globalTrace) {printf("Leaving \n")}

      return(readString($prog , $start , add1($len )));

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readString

    if ($globalTrace) {printf("Leaving \n")}

    return(readString($prog , $start , add1($len )));

  };

}


#Building function readComment from line: 370

sub readComment {
  my $prog  = shift;
my $start  = shift;
my $len  = shift;

  my $token = "" ;

if ($globalTrace) { printf("readComment at base.qon:370\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $token = substr($prog , sub1(add($start , $len )), 1 );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isLineBreak($token )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readComment

    if ($globalTrace) {printf("Leaving \n")}

    return(substr($prog , $start , sub1($len )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readComment

    if ($globalTrace) {printf("Leaving \n")}

    return(readComment($prog , $start , add1($len )));

  };

}


#Building function isWhiteSpace from line: 378

sub isWhiteSpace {
  my $s  = shift;

  
if ($globalTrace) { printf("isWhiteSpace at base.qon:378\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString(" " , $s )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isWhiteSpace

    if ($globalTrace) {printf("Leaving \n")}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("\n" , $s )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isWhiteSpace

      if ($globalTrace) {printf("Leaving \n")}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalString("\r" , $s )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isWhiteSpace

        if ($globalTrace) {printf("Leaving \n")}

        return($true );

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isWhiteSpace

        if ($globalTrace) {printf("Leaving \n")}

        return($false );

      };

    };

  };

}


#Building function isLineBreak from line: 392

sub isLineBreak {
  my $s  = shift;

  
if ($globalTrace) { printf("isLineBreak at base.qon:392\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("\n" , $s )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isLineBreak

    if ($globalTrace) {printf("Leaving \n")}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalString("\r" , $s )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isLineBreak

      if ($globalTrace) {printf("Leaving \n")}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isLineBreak

      if ($globalTrace) {printf("Leaving \n")}

      return($false );

    };

  };

}


#Building function incForNewLine from line: 399

sub incForNewLine {
  my $token  = shift;
my $val  = shift;

  
if ($globalTrace) { printf("incForNewLine at base.qon:399\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("\n" , stringify($token ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: incForNewLine

    if ($globalTrace) {printf("Leaving \n")}

    return(add1($val ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: incForNewLine

    if ($globalTrace) {printf("Leaving \n")}

    return($val );

  };

}


#Building function annotateReadPosition from line: 406

sub annotateReadPosition {
  my $filename  = shift;
my $linecount  = shift;
my $column  = shift;
my $start  = shift;
my $newBox  = shift;

  
if ($globalTrace) { printf("annotateReadPosition at base.qon:406\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: annotateReadPosition

  if ($globalTrace) {printf("Leaving \n")}

  return(setTag(boxString("filename" ), boxString($filename ), setTag(boxString("column" ), boxInt($column ), setTag(boxString("line" ), boxInt($linecount ), setTag(boxString("totalCharPos" ), boxInt($start ), $newBox )))));

}


#Building function scan from line: 418

sub scan {
  my $prog  = shift;
my $start  = shift;
my $len  = shift;
my $linecount  = shift;
my $column  = shift;
my $filename  = shift;

  my $token = undef ;
my $newString = "" ;
my $newBox = undef ;

if ($globalTrace) { printf("scan at base.qon:418\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( $false ) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("Scanning: line %d:%d\n" , $linecount , $column )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("" )
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(length($prog ), subtract($start , subtract(0 , $len )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token = boxSymbol(substr($prog , sub1(add($start , $len )), 1 ));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $token->{tag} = alistCons(boxString("totalCharPos" ), boxInt($start ), $undef );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isOpenBrace($token )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

      if ($globalTrace) {printf("Leaving \n")}

      return(cons(finish_token($prog , $start , sub1($len ), $linecount , $column , $filename ), cons(boxSymbol(openBrace ()), scan($prog , add1($start ), 1 , $linecount , add1($column ), $filename ))));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isCloseBrace($token )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

        if ($globalTrace) {printf("Leaving \n")}

        return(cons(finish_token($prog , $start , sub1($len ), $linecount , $column , $filename ), cons(annotateReadPosition($filename , $linecount , $column , $start , boxSymbol(closeBrace ())), scan($prog , add($start , $len ), 1 , $linecount , add1($column ), $filename ))));

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( isWhiteSpace(stringify($token ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

          if ($globalTrace) {printf("Leaving \n")}

          return(cons(finish_token($prog , $start , sub1($len ), $linecount , $column , $filename ), scan($prog , add($start , $len ), 1 , incForNewLine($token , $linecount ), 0 , $filename )));

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxSymbol(";" ), $token )) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

            if ($globalTrace) {printf("Leaving \n")}

            return(scan($prog , add($start , add1(add1(length(readComment($prog , add1($start ), $len ))))), 1 , add1($linecount ), 0 , $filename ));

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( equalBox(boxSymbol("\"" ), $token )) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

              $newString = readString($prog , add1($start ), $len );
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

              $newBox = annotateReadPosition($filename , $linecount , $column , $start , boxString($newString ));
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

              if ($globalTrace) {printf("Leaving \n")}

              return(cons($newBox , scan($prog , add($start , add1(add1(length($newString )))), 1 , $linecount , add1($column ), $filename )));

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

              if ($globalTrace) {printf("Leaving \n")}

              return(scan($prog , $start , subtract($len , -1 ), $linecount , add1($column ), $filename ));

            };

          };

        };

      };

    };

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: scan

  if ($globalTrace) {printf("Leaving \n")}

  return(emptyList ());

}


#Building function isOpenBrace from line: 459

sub isOpenBrace {
  my $b  = shift;

  
if ($globalTrace) { printf("isOpenBrace at base.qon:459\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxSymbol(openBrace ()), $b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isOpenBrace

    if ($globalTrace) {printf("Leaving \n")}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxSymbol("[" ), $b )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isOpenBrace

      if ($globalTrace) {printf("Leaving \n")}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isOpenBrace

      if ($globalTrace) {printf("Leaving \n")}

      return($false );

    };

  };

}


#Building function openBrace from line: 469

sub openBrace {
  
  
if ($globalTrace) { printf("openBrace at base.qon:469\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: openBrace

  if ($globalTrace) {printf("Leaving \n")}

  return("(" );

}


#Building function isCloseBrace from line: 471

sub isCloseBrace {
  my $b  = shift;

  
if ($globalTrace) { printf("isCloseBrace at base.qon:471\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxSymbol(closeBrace ()), $b )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isCloseBrace

    if ($globalTrace) {printf("Leaving \n")}

    return($true );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxSymbol("]" ), $b )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isCloseBrace

      if ($globalTrace) {printf("Leaving \n")}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isCloseBrace

      if ($globalTrace) {printf("Leaving \n")}

      return($false );

    };

  };

}


#Building function closeBrace from line: 481

sub closeBrace {
  
  
if ($globalTrace) { printf("closeBrace at base.qon:481\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: closeBrace

  if ($globalTrace) {printf("Leaving \n")}

  return(")" );

}


#Building function sexprTree from line: 483

sub sexprTree {
  my $l  = shift;

  my $b = undef ;

if ($globalTrace) { printf("sexprTree at base.qon:483\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sexprTree

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $b = car($l );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isOpenBrace($b )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sexprTree

      if ($globalTrace) {printf("Leaving \n")}

      return(cons(sexprTree(cdr($l )), sexprTree(skipList(cdr($l )))));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isCloseBrace($b )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sexprTree

        if ($globalTrace) {printf("Leaving \n")}

        return(emptyList ());

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sexprTree

        if ($globalTrace) {printf("Leaving \n")}

        return(setTag(boxString("line" ), getTagFail($b , boxString("line" ), boxInt(-1 )), cons($b , sexprTree(cdr($l )))));

      };

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("AAAAAA code should never reach here!\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: sexprTree

  if ($globalTrace) {printf("Leaving \n")}

  return(emptyList ());

}


#Building function skipList from line: 502

sub skipList {
  my $l  = shift;

  my $b = undef ;

if ($globalTrace) { printf("skipList at base.qon:502\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: skipList

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $b = car($l );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isOpenBrace($b )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: skipList

      if ($globalTrace) {printf("Leaving \n")}

      return(skipList(skipList(cdr($l ))));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isCloseBrace($b )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: skipList

        if ($globalTrace) {printf("Leaving \n")}

        return(cdr($l ));

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: skipList

        if ($globalTrace) {printf("Leaving \n")}

        return(skipList(cdr($l )));

      };

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("AAAAAA code should never reach here!\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: skipList

  if ($globalTrace) {printf("Leaving \n")}

  return(emptyList ());

}


#Building function readSexpr from line: 517

sub readSexpr {
  my $aStr  = shift;
my $filename  = shift;

  my $tokens = undef ;
my $as = undef ;

if ($globalTrace) { printf("readSexpr at base.qon:517\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tokens = emptyList ();
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tokens = filterTokens(filterVoid(scan($aStr , 0 , 1 , 0 , 0 , $filename )));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $as = sexprTree($tokens );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: readSexpr

  if ($globalTrace) {printf("Leaving \n")}

  return(car($as ));

}


#Building function test0 from line: 530

sub test0 {
  
  
if ($globalTrace) { printf("test0 at base.qon:530\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString(stringify(boxString("hello" )), stringify(boxString("hello" )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("0.  pass string compare works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("0.  pass string compare fails\n" )
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("0.  pass string compare works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("0.  pass string compare fails\n" )
    ;

  };

}


#Building function test1 from line: 545

sub test1 {
  
  
if ($globalTrace) { printf("test1 at base.qon:545\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("1.  pass Function call and print work\n" )
  ;

}


#Building function test2_do from line: 550

sub test2_do {
  my $message  = shift;

  
if ($globalTrace) { printf("test2_do at base.qon:550\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("2.  pass Function call with arg works: %s\n" , $message )
  ;

}


#Building function test2 from line: 554

sub test2 {
  
  
if ($globalTrace) { printf("test2 at base.qon:554\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  test2_do("This is the argument" )
  ;

}


#Building function test3_do from line: 556

sub test3_do {
  my $b  = shift;
my $c  = shift;

  
if ($globalTrace) { printf("test3_do at base.qon:556\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("3.1 pass Two arg call, first arg: %d\n" , $b )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("3.2 pass Two arg call, second arg: %s\n" , $c )
  ;

}


#Building function test3 from line: 562

sub test3 {
  
  
if ($globalTrace) { printf("test3 at base.qon:562\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  test3_do(42 , "Fourty-two" )
  ;

}


#Building function test4_do from line: 563

sub test4_do {
  
  
if ($globalTrace) { printf("test4_do at base.qon:563\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: test4_do

  if ($globalTrace) {printf("Leaving \n")}

  return("pass Return works" );

}


#Building function returnThis from line: 565

sub returnThis {
  my $returnMessage  = shift;

  
if ($globalTrace) { printf("returnThis at base.qon:565\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: returnThis

  if ($globalTrace) {printf("Leaving \n")}

  return($returnMessage );

}


#Building function test4 from line: 570

sub test4 {
  
  my $message = "fail" ;

if ($globalTrace) { printf("test4 at base.qon:570\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $message = test4_do ();
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("4.  %s\n" , $message )
  ;

}


#Building function test5 from line: 575

sub test5 {
  
  my $message = "fail" ;

if ($globalTrace) { printf("test5 at base.qon:575\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $message = returnThis("pass return passthrough string" );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("5.  %s\n" , $message )
  ;

}


#Building function test6 from line: 582

sub test6 {
  
  
if ($globalTrace) { printf("test6 at base.qon:582\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( $true ) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("6.  pass If statement works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("6.  fail If statement works\n" )
    ;

  };

}


#Building function test7_do from line: 590

sub test7_do {
  my $count  = shift;

  
if ($globalTrace) { printf("test7_do at base.qon:590\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $count = subtract($count , 1 );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan($count , 0 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $count = test7_do($count );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: test7_do

    if ($globalTrace) {printf("Leaving \n")}

    return($count );

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: test7_do

  if ($globalTrace) {printf("Leaving \n")}

  return($count );

}


#Building function test7 from line: 598

sub test7 {
  
  
if ($globalTrace) { printf("test7 at base.qon:598\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equal(0 , test7_do(10 ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("7.  pass count works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("7.  fail count fails\n" )
    ;

  };

}


#Building function beer from line: 606

sub beer {
  
  
if ($globalTrace) { printf("beer at base.qon:606\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 )
  ;

}


#Building function plural from line: 615

sub plural {
  my $num  = shift;

  
if ($globalTrace) { printf("plural at base.qon:615\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equal($num , 1 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: plural

    if ($globalTrace) {printf("Leaving \n")}

    return("" );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: plural

    if ($globalTrace) {printf("Leaving \n")}

    return("s" );

  };

}


#Building function beers from line: 620

sub beers {
  my $count  = shift;

  my $newcount = 0 ;

if ($globalTrace) { printf("beers at base.qon:620\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $newcount = subtract($count , 1 );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , $count , plural($count ), $count , plural($count ), $newcount , plural($newcount ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan($count , 1 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $count = beers($newcount );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: beers

    if ($globalTrace) {printf("Leaving \n")}

    return($count );

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: beers

  if ($globalTrace) {printf("Leaving \n")}

  return(0 );

}


#Building function test8 from line: 636

sub test8 {
  
  
if ($globalTrace) { printf("test8 at base.qon:636\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equal(subtract(subtract(2 , 1 ), subtract(3 , 1 )), -1 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("8.  pass Nested expressions work\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("8.  fail Nested expressions don't work\n" )
    ;

  };

}


#Building function test9 from line: 644

sub test9 {
  
  my $answer = -999999 ;

if ($globalTrace) { printf("test9 at base.qon:644\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $answer = subtract(subtract(20 , 1 ), subtract(3 , 1 ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equal($answer , 17 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("9.  pass arithmetic works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("9.  fail arithmetic\n" )
    ;

  };

}


#Building function test10 from line: 653

sub test10 {
  
  my $testString = "This is a test string" ;

if ($globalTrace) { printf("test10 at base.qon:653\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString($testString , unBoxString(car(cons(boxString($testString ), $undef ))))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("10. pass cons and car work\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("10. fail cons and car fail\n" )
    ;

  };

}


#Building function test12 from line: 663

sub test12 {
  
  my $b = undef ;

if ($globalTrace) { printf("test12 at base.qon:663\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b = {};
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $b->{str} = "12. pass structure accessors\n" ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , $b->{str})
  ;

}


#Building function test13 from line: 671

sub test13 {
  
  my $testString = "Hello from the filesystem!" ;
my $contents = "" ;

if ($globalTrace) { printf("test13 at base.qon:671\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  write_file("test.txt" , $testString )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $contents = read_file("test.txt" );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString($testString , $contents )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("13. pass Read and write files\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("13. fail Read and write files\n" )
    ;

  };

}


#Building function test15 from line: 683

sub test15 {
  
  my $a = "hello" ;
my $b = " world" ;
my $c = "" ;

if ($globalTrace) { printf("test15 at base.qon:683\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $c = stringConcatenate($a , $b );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString($c , "hello world" )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("15. pass String concatenate\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("15. fail String concatenate\n" )
    ;

  };

}


#Building function test16 from line: 693

sub test16 {
  
  my $assocCell1 = undef ;
my $assList = undef ;
my $assocCell2 = undef ;
my $assocCell3 = undef ;

if ($globalTrace) { printf("test16 at base.qon:693\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assocCell1 = cons(boxString("Hello" ), boxString("world" ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assocCell2 = cons(boxString("goodnight" ), boxString("moon" ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assList = cons($assocCell2 , emptyList ());
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assList = cons($assocCell1 , $assList );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $assList = cons($assocCell3 , $assList );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(cdr(assoc("Hello" , $assList )), boxString("world" ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("16.1 pass Basic assoc works\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("16.1 fail Basic assoc fails\n" )
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( andBool(andBool(equalBox(cdr(assoc("Hello" , $assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , $assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , $assList )), boxString("gozaimasu" )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("16.2 pass assoc list\n" )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("16.2 fail assoc list\n" )
    ;

  };

}


#Building function caar from line: 721

sub caar {
  my $l  = shift;

  
if ($globalTrace) { printf("caar at base.qon:721\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: caar

  if ($globalTrace) {printf("Leaving \n")}

  return(car(car($l )));

}


#Building function cadr from line: 722

sub cadr {
  my $l  = shift;

  
if ($globalTrace) { printf("cadr at base.qon:722\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: cadr

  if ($globalTrace) {printf("Leaving \n")}

  return(car(cdr($l )));

}


#Building function caddr from line: 723

sub caddr {
  my $l  = shift;

  
if ($globalTrace) { printf("caddr at base.qon:723\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: caddr

  if ($globalTrace) {printf("Leaving \n")}

  return(car(cdr(cdr($l ))));

}


#Building function cadddr from line: 724

sub cadddr {
  my $l  = shift;

  
if ($globalTrace) { printf("cadddr at base.qon:724\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: cadddr

  if ($globalTrace) {printf("Leaving \n")}

  return(car(cdr(cdr(cdr($l )))));

}


#Building function caddddr from line: 726

sub caddddr {
  my $l  = shift;

  
if ($globalTrace) { printf("caddddr at base.qon:726\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: caddddr

  if ($globalTrace) {printf("Leaving \n")}

  return(car(cdr(cdr(cdr(cdr($l ))))));

}


#Building function cddr from line: 730

sub cddr {
  my $l  = shift;

  
if ($globalTrace) { printf("cddr at base.qon:730\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: cddr

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(cdr($l )));

}


#Building function first from line: 731

sub first {
  my $l  = shift;

  
if ($globalTrace) { printf("first at base.qon:731\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: first

  if ($globalTrace) {printf("Leaving \n")}

  return(car($l ));

}


#Building function second from line: 732

sub second {
  my $l  = shift;

  
if ($globalTrace) { printf("second at base.qon:732\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: second

  if ($globalTrace) {printf("Leaving \n")}

  return(cadr($l ));

}


#Building function third from line: 733

sub third {
  my $l  = shift;

  
if ($globalTrace) { printf("third at base.qon:733\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: third

  if ($globalTrace) {printf("Leaving \n")}

  return(caddr($l ));

}


#Building function fourth from line: 734

sub fourth {
  my $l  = shift;

  
if ($globalTrace) { printf("fourth at base.qon:734\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: fourth

  if ($globalTrace) {printf("Leaving \n")}

  return(cadddr($l ));

}


#Building function fifth from line: 735

sub fifth {
  my $l  = shift;

  
if ($globalTrace) { printf("fifth at base.qon:735\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: fifth

  if ($globalTrace) {printf("Leaving \n")}

  return(caddddr($l ));

}


#Building function makeNode from line: 741

sub makeNode {
  my $name  = shift;
my $subname  = shift;
my $code  = shift;
my $children  = shift;

  
if ($globalTrace) { printf("makeNode at base.qon:741\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: makeNode

  if ($globalTrace) {printf("Leaving \n")}

  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail($code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString($name )), cons(cons(boxSymbol("subname" ), boxString($subname )), cons(cons(boxSymbol("code" ), $code ), alistCons(boxSymbol("children" ), $children , emptyList ())))))));

}


#Building function addToNode from line: 757

sub addToNode {
  my $key  = shift;
my $val  = shift;
my $node  = shift;

  
if ($globalTrace) { printf("addToNode at base.qon:757\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: addToNode

  if ($globalTrace) {printf("Leaving \n")}

  return(cons(boxSymbol("node" ), alistCons($key , $val , cdr($node ))));

}


#Building function makeStatementNode from line: 762

sub makeStatementNode {
  my $name  = shift;
my $subname  = shift;
my $code  = shift;
my $children  = shift;
my $functionName  = shift;

  
if ($globalTrace) { printf("makeStatementNode at base.qon:762\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: makeStatementNode

  if ($globalTrace) {printf("Leaving \n")}

  return(addToNode(boxSymbol("functionName" ), $functionName , makeNode($name , $subname , $code , $children )));

}


#Building function astExpression from line: 767

sub astExpression {
  my $tree  = shift;

  
if ($globalTrace) { printf("astExpression at base.qon:767\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isList($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astExpression

    if ($globalTrace) {printf("Leaving \n")}

    return(makeNode("expression" , "expression" , $undef , astSubExpression($tree )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astExpression

    if ($globalTrace) {printf("Leaving \n")}

    return(astSubExpression($tree ));

  };

}


#Building function astSubExpression from line: 775

sub astSubExpression {
  my $tree  = shift;

  
if ($globalTrace) { printf("astSubExpression at base.qon:775\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astSubExpression

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isList($tree )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astSubExpression

      if ($globalTrace) {printf("Leaving \n")}

      return(cons(astExpression(car($tree )), astSubExpression(cdr($tree ))));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astSubExpression

      if ($globalTrace) {printf("Leaving \n")}

      return(makeNode("expression" , "leaf" , $tree , $undef ));

    };

  };

}


#Building function astIf from line: 786

sub astIf {
  my $tree  = shift;
my $fname  = shift;

  
if ($globalTrace) { printf("astIf at base.qon:786\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astIf

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("statement" , "if" , $tree , cons(cons(astExpression(first($tree )), $undef ), cons(astBody(cdr(second($tree )), $fname ), cons(astBody(cdr(third($tree )), $fname ), $undef )))));

}


#Building function astSetStruct from line: 796

sub astSetStruct {
  my $tree  = shift;

  
if ($globalTrace) { printf("astSetStruct at base.qon:796\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astSetStruct

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("statement" , "structSetter" , $tree , astExpression(third($tree ))));

}


#Building function astSet from line: 801

sub astSet {
  my $tree  = shift;

  
if ($globalTrace) { printf("astSet at base.qon:801\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astSet

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("statement" , "setter" , $tree , astExpression(second($tree ))));

}


#Building function astGetStruct from line: 806

sub astGetStruct {
  my $tree  = shift;

  
if ($globalTrace) { printf("astGetStruct at base.qon:806\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astGetStruct

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("expression" , "structGetter" , $tree , $undef ));

}


#Building function astReturnVoid from line: 809

sub astReturnVoid {
  my $fname  = shift;

  
if ($globalTrace) { printf("astReturnVoid at base.qon:809\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astReturnVoid

  if ($globalTrace) {printf("Leaving \n")}

  return(makeStatementNode("statement" , "returnvoid" , $undef , $undef , $fname ));

}


#Building function listLength from line: 813

sub listLength {
  my $l  = shift;

  
if ($globalTrace) { printf("listLength at base.qon:813\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return(0 );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return(add1(listLength(cdr($l ))));

  };

}


#Building function astStatement from line: 821

sub astStatement {
  my $tree  = shift;
my $fname  = shift;

  
if ($globalTrace) { printf("astStatement at base.qon:821\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("if" ), car($tree ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

    if ($globalTrace) {printf("Leaving \n")}

    return(astIf(cdr($tree ), $fname ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxString("set" ), car($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

      if ($globalTrace) {printf("Leaving \n")}

      return(astSet(cdr($tree )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalBox(boxString("get-struct" ), car($tree ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("Choosing get-struct statement\n" )
        ;
        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

        if ($globalTrace) {printf("Leaving \n")}

        return(astGetStruct(cdr($tree )));

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalBox(boxString("set-struct" ), car($tree ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

          if ($globalTrace) {printf("Leaving \n")}

          return(astSetStruct(cdr($tree )));

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxString("return" ), car($tree ))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( equal(listLength($tree ), 1 )) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

              if ($globalTrace) {printf("Leaving \n")}

              return(astReturnVoid($fname ));

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

              if ($globalTrace) {printf("Leaving \n")}

              return(makeStatementNode("statement" , "return" , $tree , makeNode("expression" , "expression" , $tree , astExpression($tree )), $fname ));

            };

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStatement

            if ($globalTrace) {printf("Leaving \n")}

            return(makeStatementNode("statement" , "statement" , $tree , makeNode("expression" , "expression" , $tree , astExpression($tree )), $fname ));

          };

        };

      };

    };

  };

}


#Building function astBody from line: 851

sub astBody {
  my $tree  = shift;
my $fname  = shift;

  
if ($globalTrace) { printf("astBody at base.qon:851\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astBody

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astBody

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(astStatement(car($tree ), $fname ), astBody(cdr($tree ), $fname )));

  };

}


#Building function astFunction from line: 857

sub astFunction {
  my $tree  = shift;

  my $fname = undef ;

if ($globalTrace) { printf("astFunction at base.qon:857\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $fname = second($tree );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astFunction

  if ($globalTrace) {printf("Leaving \n")}

  return(alistCons(boxSymbol("line" ), getTag($fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second($tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth($tree ))), cons(cons(boxSymbol("intype" ), third($tree )), cons(cons(boxSymbol("outtype" ), car($tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth($tree )), $fname )), emptyList ()))))))));

}


#Building function astFunctionList from line: 878

sub astFunctionList {
  my $tree  = shift;

  
if ($globalTrace) { printf("astFunctionList at base.qon:878\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astFunctionList

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astFunctionList

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(astFunction(car($tree )), astFunctionList(cdr($tree ))));

  };

}


#Building function astFunctions from line: 888

sub astFunctions {
  my $tree  = shift;

  
if ($globalTrace) { printf("astFunctions at base.qon:888\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astFunctions

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("functions" , "functions" , $tree , astFunctionList(cdr($tree ))));

}


#Building function loadLib from line: 895

sub loadLib {
  my $path  = shift;

  my $programStr = "" ;
my $tree = undef ;
my $library = undef ;

if ($globalTrace) { printf("loadLib at base.qon:895\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $programStr = read_file($path );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tree = readSexpr($programStr , $path );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $library = alistCons(boxString("includes" ), astIncludes(first($tree )), alistCons(boxString("types" ), astTypes(second($tree )), alistCons(boxString("functions" ), astFunctions(third($tree )), $undef )));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: loadLib

  if ($globalTrace) {printf("Leaving \n")}

  return($library );

}


#Building function astInclude from line: 913

sub astInclude {
  my $tree  = shift;

  
if ($globalTrace) { printf("astInclude at base.qon:913\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astInclude

  if ($globalTrace) {printf("Leaving \n")}

  return(loadLib(stringify($tree )));

}


#Building function astIncludeList from line: 918

sub astIncludeList {
  my $tree  = shift;

  
if ($globalTrace) { printf("astIncludeList at base.qon:918\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astIncludeList

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astIncludeList

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(astInclude(car($tree )), astIncludeList(cdr($tree ))));

  };

}


#Building function astIncludes from line: 927

sub astIncludes {
  my $tree  = shift;

  
if ($globalTrace) { printf("astIncludes at base.qon:927\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astIncludes

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("includes" , "includes" , $tree , astIncludeList(cdr($tree ))));

}


#Building function astStruct from line: 935

sub astStruct {
  my $tree  = shift;

  
if ($globalTrace) { printf("astStruct at base.qon:935\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astStruct

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("type" , "struct" , $tree , $undef ));

}


#Building function astType from line: 940

sub astType {
  my $tree  = shift;

  
if ($globalTrace) { printf("astType at base.qon:940\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isList(cadr($tree ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astType

    if ($globalTrace) {printf("Leaving \n")}

    return(astStruct($tree ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astType

    if ($globalTrace) {printf("Leaving \n")}

    return(makeNode("type" , "type" , $tree , $undef ));

  };

}


#Building function astTypeList from line: 948

sub astTypeList {
  my $tree  = shift;

  
if ($globalTrace) { printf("astTypeList at base.qon:948\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astTypeList

    if ($globalTrace) {printf("Leaving \n")}

    return(emptyList ());

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astTypeList

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(astType(car($tree )), astTypeList(cdr($tree ))));

  };

}


#Building function astTypes from line: 956

sub astTypes {
  my $tree  = shift;

  
if ($globalTrace) { printf("astTypes at base.qon:956\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: astTypes

  if ($globalTrace) {printf("Leaving \n")}

  return(makeNode("types" , "types" , $tree , astTypeList(cdr($tree ))));

}


#Building function ansiFunctionArgs from line: 961

sub ansiFunctionArgs {
  my $tree  = shift;

  
if ($globalTrace) { printf("ansiFunctionArgs at base.qon:961\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(ansiTypeMap(first($tree )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(second($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil(cddr($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("," )
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiFunctionArgs(cddr($tree ))
    ;

  };

}


#Building function declarationsof from line: 972

sub declarationsof {
  my $ass  = shift;

  
if ($globalTrace) { printf("declarationsof at base.qon:972\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: declarationsof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("declarations" , cdr($ass ))));

}


#Building function codeof from line: 977

sub codeof {
  my $ass  = shift;

  
if ($globalTrace) { printf("codeof at base.qon:977\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: codeof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("code" , cdr($ass ))));

}


#Building function functionNameof from line: 980

sub functionNameof {
  my $ass  = shift;

  
if ($globalTrace) { printf("functionNameof at base.qon:980\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: functionNameof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("functionName" , cdr($ass ))));

}


#Building function nodeof from line: 984

sub nodeof {
  my $ass  = shift;

  
if ($globalTrace) { printf("nodeof at base.qon:984\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxBool($false ), assoc("node" , cdr($ass )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeof

    if ($globalTrace) {printf("Leaving \n")}

    return(boxBool($false ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeof

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assoc("node" , cdr($ass ))));

  };

}


#Building function lineof from line: 992

sub lineof {
  my $ass  = shift;

  
if ($globalTrace) { printf("lineof at base.qon:992\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxBool($false ), assoc("line" , cdr($ass )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lineof

    if ($globalTrace) {printf("Leaving \n")}

    return(boxInt(-1 ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lineof

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assoc("line" , cdr($ass ))));

  };

}


#Building function subnameof from line: 1000

sub subnameof {
  my $ass  = shift;

  
if ($globalTrace) { printf("subnameof at base.qon:1000\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: subnameof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("subname" , cdr($ass ))));

}


#Building function nameof from line: 1005

sub nameof {
  my $ass  = shift;

  
if ($globalTrace) { printf("nameof at base.qon:1005\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nameof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("name" , cdr($ass ))));

}


#Building function childrenof from line: 1010

sub childrenof {
  my $ass  = shift;

  
if ($globalTrace) { printf("childrenof at base.qon:1010\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: childrenof

  if ($globalTrace) {printf("Leaving \n")}

  return(cdr(assoc("children" , cdr($ass ))));

}


#Building function isNode from line: 1014

sub isNode {
  my $val  = shift;

  
if ($globalTrace) { printf("isNode at base.qon:1014\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($val )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNode

    if ($globalTrace) {printf("Leaving \n")}

    return($false );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isList($val )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalBox(boxSymbol("node" ), car($val ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNode

        if ($globalTrace) {printf("Leaving \n")}

        return($true );

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNode

        if ($globalTrace) {printf("Leaving \n")}

        return($false );

      };

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNode

      if ($globalTrace) {printf("Leaving \n")}

      return($false );

    };

  };

}


#Building function truthy from line: 1028

sub truthy {
  my $aVal  = shift;

  
if ($globalTrace) { printf("truthy at base.qon:1028\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: truthy

  if ($globalTrace) {printf("Leaving \n")}

  return(isNotFalse($aVal ));

}


#Building function isNotFalse from line: 1032

sub isNotFalse {
  my $aVal  = shift;

  
if ($globalTrace) { printf("isNotFalse at base.qon:1032\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString(boxType($aVal ), "bool" )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( unBoxBool($aVal )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNotFalse

      if ($globalTrace) {printf("Leaving \n")}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNotFalse

      if ($globalTrace) {printf("Leaving \n")}

      return($false );

    };

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isNotFalse

    if ($globalTrace) {printf("Leaving \n")}

    return($true );

  };

}


#Building function ansiLeaf from line: 1038

sub ansiLeaf {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiLeaf at base.qon:1038\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  display(ansiFuncMap(codeof($thisNode )))
  ;

}


#Building function ansiStructGetterExpression from line: 1041

sub ansiStructGetterExpression {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiStructGetterExpression at base.qon:1041\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("structGetter" ), subnameof($thisNode ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiGetStruct($thisNode , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiLeaf($thisNode , $indent )
    ;

  };

}


#Building function ansiExpression from line: 1047

sub ansiExpression {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiExpression at base.qon:1047\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isLeaf($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(ansiFuncMap(codeof($node )))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiSubExpression($node , $indent )
    ;

  };

}


#Building function ansiRecurList from line: 1053

sub ansiRecurList {
  my $expr  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiRecurList at base.qon:1053\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($expr )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiExpression(car($expr ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil(cdr($expr ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf(", " )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      ansiRecurList(cdr($expr ), $indent )
      ;

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function isLeaf from line: 1066

sub isLeaf {
  my $n  = shift;

  
if ($globalTrace) { printf("isLeaf at base.qon:1066\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: isLeaf

  if ($globalTrace) {printf("Leaving \n")}

  return(equalBox(boxString("leaf" ), subnameof($n )));

}


#Building function ansiSubExpression from line: 1070

sub ansiSubExpression {
  my $tree  = shift;
my $indent  = shift;

  my $thing = undef ;

if ($globalTrace) { printf("ansiSubExpression at base.qon:1070\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNode(childrenof($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      ansiSubExpression(childrenof($tree ), $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isLeaf($tree )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        display(ansiFuncMap(codeof($tree )))
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equal(1 , listLength(childrenof($tree )))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          display(codeof(car(childrenof($tree ))))
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxString("return" ), codeof(car(childrenof($tree ))))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("" )
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("()" )
            ;

          };

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          $thing = codeof(car(childrenof($tree )));
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxSymbol("get-struct" ), $thing )) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("%s->%s" , stringify(codeof(second(childrenof($tree )))), stringify(codeof(third(childrenof($tree )))))
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( equalBox(boxSymbol("new" ), $thing )) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof($tree )))))
              ;

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof($tree ))))))
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              ansiRecurList(cdr(childrenof($tree )), $indent )
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf(")" )
              ;

            };

          };

        };

      };

    };

  };

}


#Building function ansiIf from line: 1110

sub ansiIf {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiIf at base.qon:1110\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("if ( " )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiExpression(car(first(childrenof($node ))), 0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(") {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiBody(second(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("} else {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiBody(third(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("}" )
  ;

}


#Building function ansiSetStruct from line: 1123

sub ansiSetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiSetStruct at base.qon:1123\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s->%s = " , stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiExpression(childrenof($node ), $indent )
  ;

}


#Building function ansiGetStruct from line: 1134

sub ansiGetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiGetStruct at base.qon:1134\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s->%s" , stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;

}


#Building function ansiSet from line: 1144

sub ansiSet {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiSet at base.qon:1144\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s = " , stringify(first(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiExpression(childrenof($node ), $indent )
  ;

}


#Building function ansiStatement from line: 1152

sub ansiStatement {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiStatement at base.qon:1152\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("setter" ), subnameof($node ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiSet($node , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxString("structSetter" ), subnameof($node ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      ansiSetStruct($node , $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalBox(boxString("if" ), subnameof($node ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        ansiIf($node , $indent )
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalBox(boxString("returnvoid" ), subnameof($node ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("return" )
          ;

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          ansiExpression(childrenof($node ), $indent )
          ;

        };

      };

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(";\n" )
  ;

}


#Building function printIndent from line: 1172

sub printIndent {
  my $ii  = shift;

  
if ($globalTrace) { printf("printIndent at base.qon:1172\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan($ii , 0 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("  " )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(sub1($ii ))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  };

}


#Building function newLine from line: 1180

sub newLine {
  my $indent  = shift;

  
if ($globalTrace) { printf("newLine at base.qon:1180\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printIndent($indent )
  ;

}


#Building function ansiBody from line: 1185

sub ansiBody {
  my $tree  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("ansiBody at base.qon:1185\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent($indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiStatement(car($tree ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiBody(cdr($tree ), $indent )
    ;

  };

}


#Building function ansiDeclarations from line: 1199

sub ansiDeclarations {
  my $decls  = shift;
my $indent  = shift;

  my $decl = undef ;

if ($globalTrace) { printf("ansiDeclarations at base.qon:1199\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($decls )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $decl = car($decls );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s = " , stringify(ansiTypeMap(first($decl ))), stringify(second($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(ansiFuncMap(third($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(";\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiDeclarations(cdr($decls ), $indent )
    ;

  };

}


#Building function noStackTrace from line: 1213

sub noStackTrace {
  
  
if ($globalTrace) { printf("noStackTrace at base.qon:1213\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: noStackTrace

  if ($globalTrace) {printf("Leaving \n")}

  return(cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), $undef ))))))))))))))))))))))))));

}


#Building function toStr from line: 1242

sub toStr {
  my $thing  = shift;

  
if ($globalTrace) { printf("toStr at base.qon:1242\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: toStr

  if ($globalTrace) {printf("Leaving \n")}

  return(boxString(stringify($thing )));

}


#Building function ansiFunction from line: 1245

sub ansiFunction {
  my $node  = shift;

  my $name = undef ;

if ($globalTrace) { printf("ansiFunction at base.qon:1245\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $name = subnameof($node );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n\n//Building function %s from line: %s" , stringify($name ), stringify(getTag($name , boxString("line" ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine(0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(0 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr($node ))))), stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiFunctionArgs(cdr(assoc("intype" , cdr($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(") {" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiDeclarations(declarationsof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\nif (globalTrace)\n    printf(\"%s at %s:%s\\n\");\n" , stringify($name ), stringify(getTag($name , boxString("filename" ))), stringify(getTag($name , boxString("line" ))))
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {
    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiBody(childrenof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify($name ))
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n}\n" )
    ;

  };

}


#Building function ansiForwardDeclaration from line: 1279

sub ansiForwardDeclaration {
  my $node  = shift;

  
if ($globalTrace) { printf("ansiForwardDeclaration at base.qon:1279\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr($node ))))), stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiFunctionArgs(cdr(assoc("intype" , cdr($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(");" )
    ;

  };

}


#Building function ansiForwardDeclarations from line: 1291

sub ansiForwardDeclarations {
  my $tree  = shift;

  
if ($globalTrace) { printf("ansiForwardDeclarations at base.qon:1291\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiForwardDeclaration(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiForwardDeclarations(cdr($tree ))
    ;

  };

}


#Building function ansiFunctions from line: 1301

sub ansiFunctions {
  my $tree  = shift;

  
if ($globalTrace) { printf("ansiFunctions at base.qon:1301\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiFunction(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiFunctions(cdr($tree ))
    ;

  };

}


#Building function ansiIncludes from line: 1308

sub ansiIncludes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("ansiIncludes at base.qon:1308\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nvoid panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }" )
  ;

}


#Building function listLast from line: 1316

sub listLast {
  my $alist  = shift;

  
if ($globalTrace) { printf("listLast at base.qon:1316\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty(cdr($alist ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: listLast

    if ($globalTrace) {printf("Leaving \n")}

    return(car($alist ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: listLast

    if ($globalTrace) {printf("Leaving \n")}

    return(listLast(cdr($alist )));

  };

}


#Building function ansiTypeDecl from line: 1322

sub ansiTypeDecl {
  my $l  = shift;

  
if ($globalTrace) { printf("ansiTypeDecl at base.qon:1322\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(listLength($l ), 2 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s %s;\n" , stringify(second($l )), stringify(ansiTypeMap(listLast($l ))), stringify(first($l )))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s;\n" , stringify(ansiTypeMap(listLast($l ))), stringify(car($l )))
    ;

  };

}


#Building function ansiStructComponents from line: 1339

sub ansiStructComponents {
  my $node  = shift;

  
if ($globalTrace) { printf("ansiStructComponents at base.qon:1339\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiTypeDecl(car($node ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiStructComponents(cdr($node ))
    ;

  };

}


#Building function ansiStruct from line: 1347

sub ansiStruct {
  my $node  = shift;

  
if ($globalTrace) { printf("ansiStruct at base.qon:1347\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiStructComponents(cdr(car($node )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function ansiTypeMap from line: 1352

sub ansiTypeMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("ansiTypeMap at base.qon:1352\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), $undef ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( truthy(assoc(stringify($aSym ), $symMap ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: ansiTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assoc(stringify($aSym ), $symMap )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: ansiTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function ansiFuncMap from line: 1365

sub ansiFuncMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("ansiFuncMap at base.qon:1365\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("symbol" , boxType($aSym ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), $undef )))))));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( truthy(assoc(stringify($aSym ), $symMap ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: ansiFuncMap

      if ($globalTrace) {printf("Leaving \n")}

      return(cdr(assoc(stringify($aSym ), $symMap )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: ansiFuncMap

      if ($globalTrace) {printf("Leaving \n")}

      return($aSym );

    };

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: ansiFuncMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function ansiType from line: 1396

sub ansiType {
  my $node  = shift;

  
if ($globalTrace) { printf("ansiType at base.qon:1396\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(subnameof($node ), boxString("struct" ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\ntypedef struct %s {\n" , stringify(first(codeof($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiStruct(cdr(codeof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n} %s;\n" , stringify(first(codeof($node ))))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("typedef " )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiTypeDecl(codeof($node ))
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function ansiTypes from line: 1408

sub ansiTypes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("ansiTypes at base.qon:1408\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($nodes )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiType(car($nodes ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    ansiTypes(cdr($nodes ))
    ;

  };

}


#Building function ansiCompile from line: 1416

sub ansiCompile {
  my $filename  = shift;

  my $programStr = "" ;
my $tree = undef ;
my $program = undef ;

if ($globalTrace) { printf("ansiCompile at base.qon:1416\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $programStr = read_file($filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tree = readSexpr($programStr , $filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = alistCons(boxString("includes" ), astIncludes(first($tree )), alistCons(boxString("types" ), astTypes(second($tree )), alistCons(boxString("functions" ), astFunctions(third($tree )), $undef )));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = mergeIncludes($program );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiIncludes(cdr(assoc("includes" , $program )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiTypes(childrenof(cdr(assoc("types" , $program ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("Box* globalStackTrace = NULL;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , $program ))))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n\n//End forward declarations\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , $program ))))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n" )
  ;

}


#Building function concatLists from line: 1445

sub concatLists {
  my $seq1  = shift;
my $seq2  = shift;

  
if ($globalTrace) { printf("concatLists at base.qon:1445\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($seq1 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: concatLists

    if ($globalTrace) {printf("Leaving \n")}

    return($seq2 );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: concatLists

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(car($seq1 ), concatLists(cdr($seq1 ), $seq2 )));

  };

}


#Building function alistKeys from line: 1452

sub alistKeys {
  my $alist  = shift;

  
if ($globalTrace) { printf("alistKeys at base.qon:1452\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($alist )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: alistKeys

    if ($globalTrace) {printf("Leaving \n")}

    return($undef );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: alistKeys

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(car(car($alist )), alistKeys(cdr($alist ))));

  };

}


#Building function mergeIncludes from line: 1459

sub mergeIncludes {
  my $program  = shift;

  
if ($globalTrace) { printf("mergeIncludes at base.qon:1459\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: mergeIncludes

  if ($globalTrace) {printf("Leaving \n")}

  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , $program )))), $program ));

}


#Building function merge_recur from line: 1468

sub merge_recur {
  my $incs  = shift;
my $program  = shift;

  
if ($globalTrace) { printf("merge_recur at base.qon:1468\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(listLength($incs ), 0 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: merge_recur

    if ($globalTrace) {printf("Leaving \n")}

    return(mergeInclude(car($incs ), merge_recur(cdr($incs ), $program )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: merge_recur

    if ($globalTrace) {printf("Leaving \n")}

    return($program );

  };

}


#Building function mergeInclude from line: 1478

sub mergeInclude {
  my $inc  = shift;
my $program  = shift;

  my $newProgram = undef ;
my $oldfunctionsnode = undef ;
my $oldfunctions = undef ;
my $newfunctions = undef ;
my $newFunctionNode = undef ;
my $functions = undef ;
my $oldtypesnode = undef ;
my $oldtypes = undef ;
my $newtypes = undef ;
my $newTypeNode = undef ;
my $types = undef ;

if ($globalTrace) { printf("mergeInclude at base.qon:1478\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($inc )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: mergeInclude

    if ($globalTrace) {printf("Leaving \n")}

    return($program );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $functions = childrenof(cdr(assoc("functions" , $inc )));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $oldfunctionsnode = cdr(assoc("functions" , $program ));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $oldfunctions = childrenof($oldfunctionsnode );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $newfunctions = concatLists($functions , $oldfunctions );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), $newfunctions , cdr($oldfunctionsnode )));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $types = childrenof(cdr(assoc("types" , $inc )));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $oldtypesnode = cdr(assoc("types" , $program ));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $oldtypes = childrenof($oldtypesnode );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $newtypes = concatLists($types , $oldtypes );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $newTypeNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), $newtypes , cdr($oldtypesnode )));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $newProgram = alistCons(boxString("functions" ), $newFunctionNode , alistCons(boxString("types" ), $newTypeNode , alistCons(boxString("includes" ), cons(boxSymbol("includes" ), $undef ), $newProgram )));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: mergeInclude

    if ($globalTrace) {printf("Leaving \n")}

    return($newProgram );

  };

}


#Building function argList from line: 1532

sub argList {
  my $count  = shift;
my $pos  = shift;
my $args  = shift;

  
if ($globalTrace) { printf("argList at base.qon:1532\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan($count , $pos )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: argList

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(boxString(getStringArray($pos , $args )), argList($count , add1($pos ), $args )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: argList

    if ($globalTrace) {printf("Leaving \n")}

    return($undef );

  };

}


#Building function listReverse from line: 1544

sub listReverse {
  my $l  = shift;

  
if ($globalTrace) { printf("listReverse at base.qon:1544\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: listReverse

    if ($globalTrace) {printf("Leaving \n")}

    return($undef );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: listReverse

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(car($l ), listReverse(cdr($l ))));

  };

}


#Building function inList from line: 1550

sub inList {
  my $item  = shift;
my $l  = shift;

  
if ($globalTrace) { printf("inList at base.qon:1550\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($l )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    return($false );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(car($l ), $item )) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return($true );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      return(inList($item , cdr($l )));

    };

  };

}


#Building function tron from line: 1561

sub tron {
  
  
if ($globalTrace) { printf("tron at base.qon:1561\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalTrace = $true ;

}


#Building function troff from line: 1562

sub troff {
  
  
if ($globalTrace) { printf("troff at base.qon:1562\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalTrace = $false ;

}


#Building function stron from line: 1563

sub stron {
  
  
if ($globalTrace) { printf("stron at base.qon:1563\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalStepTrace = $true ;

}


#Building function stroff from line: 1564

sub stroff {
  
  
if ($globalTrace) { printf("stroff at base.qon:1564\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalStepTrace = $false ;

}


#Building function numbers from line: 4

sub numbers {
  my $num  = shift;

  
if ($globalTrace) { printf("numbers at perl.qon:4\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(0 , $num )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: numbers

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(boxString("-" ), $undef ));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: numbers

    if ($globalTrace) {printf("Leaving \n")}

    return(cons(boxString(stringify(boxInt($num ))), numbers(sub1($num ))));

  };

}


#Building function lexType from line: 11

sub lexType {
  my $abox  = shift;

  
if ($globalTrace) { printf("lexType at perl.qon:11\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("string" , boxType($abox ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lexType

    if ($globalTrace) {printf("Leaving \n")}

    return("string" );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(boxString(substr(stringify($abox ), 0 , 1 )), numbers(9 ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lexType

      if ($globalTrace) {printf("Leaving \n")}

      return("number" );

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lexType

      if ($globalTrace) {printf("Leaving \n")}

      return("symbol" );

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: lexType

  if ($globalTrace) {printf("Leaving \n")}

  return("symbol" );

}


#Building function perlLeaf from line: 23

sub perlLeaf {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlLeaf at perl.qon:23\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("symbol" , lexType(codeof($thisNode )))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s" , dollar ())
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("" )
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  display(perlFuncMap(codeof($thisNode )))
  ;

}


#Building function perlStructGetterExpression from line: 32

sub perlStructGetterExpression {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlStructGetterExpression at perl.qon:32\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("structGetter" ), subnameof($thisNode ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlGetStruct($thisNode , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlLeaf($thisNode , $indent )
    ;

  };

}


#Building function perlExpression from line: 38

sub perlExpression {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlExpression at perl.qon:38\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isLeaf($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlLeaf($node , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlSubExpression($node , $indent )
    ;

  };

}


#Building function perlRecurList from line: 44

sub perlRecurList {
  my $expr  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlRecurList at perl.qon:44\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($expr )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlExpression(car($expr ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil(cdr($expr ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf(", " )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      perlRecurList(cdr($expr ), $indent )
      ;

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function perlSubExpression from line: 55

sub perlSubExpression {
  my $tree  = shift;
my $indent  = shift;

  my $thing = undef ;

if ($globalTrace) { printf("perlSubExpression at perl.qon:55\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNode(childrenof($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      perlSubExpression(childrenof($tree ), $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isLeaf($tree )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        printf("%s" , dollar ())
        ;
        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        display(perlFuncMap(codeof($tree )))
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equal(1 , listLength(childrenof($tree )))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          display(codeof(car(childrenof($tree ))))
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxString("return" ), codeof(car(childrenof($tree ))))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("" )
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("()" )
            ;

          };

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          $thing = codeof(car(childrenof($tree )));
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxSymbol("get-struct" ), $thing )) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("%s%s->{%s}" , dollar (), stringify(codeof(second(childrenof($tree )))), stringify(codeof(third(childrenof($tree )))))
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( equalBox(boxSymbol("new" ), $thing )) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("{}" )
              ;

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("%s(" , stringify(perlFuncMap(codeof(car(childrenof($tree ))))))
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              perlRecurList(cdr(childrenof($tree )), $indent )
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf(")" )
              ;

            };

          };

        };

      };

    };

  };

}


#Building function perlIf from line: 93

sub perlIf {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlIf at perl.qon:93\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("if ( " )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlExpression(car(first(childrenof($node ))), 0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(") {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlBody(second(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("} else {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlBody(third(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("}" )
  ;

}


#Building function perlSetStruct from line: 106

sub perlSetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlSetStruct at perl.qon:106\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s->{%s} = " , dollar (), stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlExpression(childrenof($node ), $indent )
  ;

}


#Building function perlGetStruct from line: 113

sub perlGetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlGetStruct at perl.qon:113\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s->{%s}" , dollar (), stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;

}


#Building function perlSet from line: 118

sub perlSet {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlSet at perl.qon:118\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s = " , dollar (), stringify(first(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlExpression(childrenof($node ), $indent )
  ;

}


#Building function assertNode from line: 124

sub assertNode {
  my $node  = shift;

  
if ($globalTrace) { printf("assertNode at perl.qon:124\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNode($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    panic("Not a node!" )
    ;

  };

}


#Building function perlStatement from line: 131

sub perlStatement {
  my $node  = shift;
my $indent  = shift;

  my $functionName = undef ;

if ($globalTrace) { printf("perlStatement at perl.qon:131\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  assertNode($node )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("setter" ), subnameof($node ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlSet($node , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxString("structSetter" ), subnameof($node ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      perlSetStruct($node , $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalBox(boxString("if" ), subnameof($node ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        perlIf($node , $indent )
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalBox(boxString("returnvoid" ), subnameof($node ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          $functionName = functionNameof($node );
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("\n#Returnvoid\n" )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("return" )
          ;

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxString("return" ), subnameof($node ))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            $functionName = functionNameof($node );
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( inList($functionName , noStackTrace ())) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("" )
              ;

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("\n#standard return: %s\n" , stringify($functionName ))
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              newLine($indent )
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("%s%s%s" , "if (" , dollar (), "globalTrace) {printf(\"Leaving \\n\")}\n" )
              ;

            };
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            newLine($indent )
            ;
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            perlExpression(childrenof($node ), $indent )
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( inList($functionName , noStackTrace ())) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("" )
              ;

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("\n#standard expression\n" )
              ;

            };
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            newLine($indent )
            ;
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            perlExpression(childrenof($node ), $indent )
            ;
            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            newLine($indent )
            ;

          };

        };

      };

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(";\n" )
  ;

}


#Building function perlBody from line: 180

sub perlBody {
  my $tree  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("perlBody at perl.qon:180\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent($indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s%s%s" , "if (" , dollar (), "globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlStatement(car($tree ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlBody(cdr($tree ), $indent )
    ;

  };

}


#Building function perlDeclarations from line: 190

sub perlDeclarations {
  my $decls  = shift;
my $indent  = shift;

  my $decl = undef ;

if ($globalTrace) { printf("perlDeclarations at perl.qon:190\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($decls )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $decl = car($decls );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("my %s%s = " , dollar (), stringify(second($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(perlConstMap(third($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(";\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlDeclarations(cdr($decls ), $indent )
    ;

  };

}


#Building function perlFunction from line: 201

sub perlFunction {
  my $node  = shift;

  my $name = undef ;

if ($globalTrace) { printf("perlFunction at perl.qon:201\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $name = subnameof($node );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n\n#Building function %s from line: %s" , stringify($name ), stringify(getTag($name , boxString("line" ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine(0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(0 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("sub %s" , stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(" {" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlFunctionArgs(cdr(assoc("intype" , cdr($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlDeclarations(declarationsof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\nif (%sglobalTrace) { printf(\"%s at %s:%s\\n\") }\n" , dollar (), stringify(subnameof($node )), stringify(getTag($name , boxString("filename" ))), stringify(getTag($name , boxString("line" ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList($name , noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlBody(childrenof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList($name , noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n}\n" )
    ;

  };

}


#Building function perlForwardDeclaration from line: 233

sub perlForwardDeclaration {
  my $node  = shift;

  
if ($globalTrace) { printf("perlForwardDeclaration at perl.qon:233\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\nsub %s" , stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(";" )
    ;

  };

}


#Building function perlForwardDeclarations from line: 243

sub perlForwardDeclarations {
  my $tree  = shift;

  
if ($globalTrace) { printf("perlForwardDeclarations at perl.qon:243\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlForwardDeclaration(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlForwardDeclarations(cdr($tree ))
    ;

  };

}


#Building function perlFunctions from line: 251

sub perlFunctions {
  my $tree  = shift;

  
if ($globalTrace) { printf("perlFunctions at perl.qon:251\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlFunction(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlFunctions(cdr($tree ))
    ;

  };

}


#Building function dollar from line: 258

sub dollar {
  
  
if ($globalTrace) { printf("dollar at perl.qon:258\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: dollar

  if ($globalTrace) {printf("Leaving \n")}

  return(character(36 ));

}


#Building function atSym from line: 261

sub atSym {
  
  
if ($globalTrace) { printf("atSym at perl.qon:261\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: atSym

  if ($globalTrace) {printf("Leaving \n")}

  return(character(64 ));

}


#Building function perlIncludes from line: 265

sub perlIncludes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("perlIncludes at perl.qon:265\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s\n" , "use strict;" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s\n" , "use Carp;" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  dollar ()
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s\n" , "use Carp::Always;" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub greaterthan { " , dollar (), "_[0] > " , dollar (), "_[1] };" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub equalString { " , dollar (), "_[0] eq " , dollar (), "_[1] };" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("sub read_file { my %sfile = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; local %s/ = undef; my %scont = <%sfh>; close %sfh; return %scont; }; \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ())
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("sub write_file {my %sfile = shift; my %sdata = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; print %sfh %sdata; close %sfh; } \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ())
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub stringConcatenate { " , dollar (), "_[0] . " , dollar (), "_[1]}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub subtract { " , dollar (), "_[0] - " , dollar (), "_[1]}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub andBool { " , dollar (), "_[0] && " , dollar (), "_[1]}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub equal { " , dollar (), "_[0] == " , dollar (), "_[1]}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s\n" , "sub panic { carp " , atSym (), "_; die \"" , atSym (), "_\"}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("sub intToString { return %s_[0]}\n" , dollar ())
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("sub character { return chr(%s_[0])}\n" , dollar ())
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s%s%s%s%s%s\n" , "sub getStringArray { my " , dollar (), "index = shift; my " , dollar (), "arr = shift; return " , dollar (), "arr->[" , dollar (), "index]}" )
  ;

}


#Building function perlTypeDecl from line: 299

sub perlTypeDecl {
  my $l  = shift;

  
if ($globalTrace) { printf("perlTypeDecl at perl.qon:299\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(listLength($l ), 2 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s %s;\n" , stringify(second($l )), stringify(perlTypeMap(listLast($l ))), stringify(first($l )))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s;\n" , stringify(perlTypeMap(listLast($l ))), stringify(car($l )))
    ;

  };

}


#Building function perlStructComponents from line: 317

sub perlStructComponents {
  my $node  = shift;

  
if ($globalTrace) { printf("perlStructComponents at perl.qon:317\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlTypeDecl(car($node ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlStructComponents(cdr($node ))
    ;

  };

}


#Building function perlStruct from line: 323

sub perlStruct {
  my $node  = shift;

  
if ($globalTrace) { printf("perlStruct at perl.qon:323\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlStructComponents(cdr(car($node )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function perlTypeMap from line: 326

sub perlTypeMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("perlTypeMap at perl.qon:326\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), $undef ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( truthy(assoc(stringify($aSym ), $symMap ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assoc(stringify($aSym ), $symMap )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function perlConstMap from line: 338

sub perlConstMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("perlConstMap at perl.qon:338\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("symbol" , boxType($aSym ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $symMap = alistCons(boxSymbol("false" ), boxSymbol("0" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), $undef ));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlConstMap

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assocFail(stringify($aSym ), $symMap , $aSym )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlConstMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function perlFuncMap from line: 348

sub perlFuncMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("perlFuncMap at perl.qon:348\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("symbol" , boxType($aSym ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("substr" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), $undef ))))))));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlFuncMap

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assocFail(stringify($aSym ), $symMap , $aSym )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: perlFuncMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function perlType from line: 365

sub perlType {
  my $node  = shift;

  
if ($globalTrace) { printf("perlType at perl.qon:365\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(subnameof($node ), boxString("struct" ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\ntypedef struct %s {\n" , stringify(first(codeof($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlStruct(cdr(codeof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n} %s;\n" , stringify(first(codeof($node ))))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("typedef " )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlTypeDecl(codeof($node ))
    ;

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function perlTypes from line: 376

sub perlTypes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("perlTypes at perl.qon:376\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($nodes )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlType(car($nodes ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlTypes(cdr($nodes ))
    ;

  };

}


#Building function perlFunctionArgs from line: 382

sub perlFunctionArgs {
  my $tree  = shift;

  
if ($globalTrace) { printf("perlFunctionArgs at perl.qon:382\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s%s" , "my " , dollar ())
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(second($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(" = shift;\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    perlFunctionArgs(cddr($tree ))
    ;

  };

}


#Building function perlCompile from line: 392

sub perlCompile {
  my $filename  = shift;

  my $programStr = "" ;
my $tree = undef ;
my $program = undef ;

if ($globalTrace) { printf("perlCompile at perl.qon:392\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $programStr = read_file($filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tree = readSexpr($programStr , $filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = alistCons(boxString("includes" ), astIncludes(first($tree )), alistCons(boxString("types" ), astTypes(second($tree )), alistCons(boxString("functions" ), astFunctions(third($tree )), $undef )));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = mergeIncludes($program );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlIncludes(cdr(assoc("includes" , $program )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlTypes(childrenof(cdr(assoc("types" , $program ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("use strict;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("use Carp;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("use Data::Dumper;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "globalStackTrace = undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "globalTrace = undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "globalStepTrace = undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "globalArgs = undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "globalArgsCount = undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s\n" , "my " , dollar (), "true = 1;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "false = 0;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "my " , dollar (), "undef;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s" , "\nsub isNil {\n    return !defined(" , dollar (), "_[0]);\n}\n\n\n#Forward declarations\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , $program ))))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n\n#End forward declarations\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , $program ))))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(";\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s" , dollar (), "globalArgs = [ 1, " , atSym (), "ARGV];" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s%s%s%s" , dollar (), "globalArgsCount = scalar(" , atSym (), "ARGV)+1;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("start();" )
  ;

}


#Building function nodeFunctionArgs from line: 4

sub nodeFunctionArgs {
  my $tree  = shift;

  
if ($globalTrace) { printf("nodeFunctionArgs at node.qon:4\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(second($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil(cddr($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("," )
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeFunctionArgs(cddr($tree ))
    ;

  };

}


#Building function nodeLeaf from line: 12

sub nodeLeaf {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeLeaf at node.qon:12\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  display(nodeFuncMap(codeof($thisNode )))
  ;

}


#Building function nodeStructGetterExpression from line: 15

sub nodeStructGetterExpression {
  my $thisNode  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeStructGetterExpression at node.qon:15\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("structGetter" ), subnameof($thisNode ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeGetStruct($thisNode , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeLeaf($thisNode , $indent )
    ;

  };

}


#Building function nodeExpression from line: 21

sub nodeExpression {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeExpression at node.qon:21\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isLeaf($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(nodeFuncMap(codeof($node )))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeSubExpression($node , $indent )
    ;

  };

}


#Building function nodeRecurList from line: 27

sub nodeRecurList {
  my $expr  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeRecurList at node.qon:27\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($expr )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeExpression(car($expr ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNil(cdr($expr ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf(", " )
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      nodeRecurList(cdr($expr ), $indent )
      ;

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function nodeSubExpression from line: 40

sub nodeSubExpression {
  my $tree  = shift;
my $indent  = shift;

  my $thing = undef ;

if ($globalTrace) { printf("nodeSubExpression at node.qon:40\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( isNode(childrenof($tree ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      nodeSubExpression(childrenof($tree ), $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( isLeaf($tree )) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        display(nodeFuncMap(codeof($tree )))
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equal(1 , listLength(childrenof($tree )))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          display(codeof(car(childrenof($tree ))))
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxString("return" ), codeof(car(childrenof($tree ))))) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("" )
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("()" )
            ;

          };

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          $thing = codeof(car(childrenof($tree )));
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

          if ( equalBox(boxSymbol("get-struct" ), $thing )) {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

            printf("%s.%s" , stringify(codeof(second(childrenof($tree )))), stringify(codeof(third(childrenof($tree )))))
            ;

          } else {            if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

            if ( equalBox(boxSymbol("new" ), $thing )) {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("{}" )
              ;

            } else {              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf("%s(" , stringify(nodeFuncMap(codeof(car(childrenof($tree ))))))
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              nodeRecurList(cdr(childrenof($tree )), $indent )
              ;
              if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

              printf(")" )
              ;

            };

          };

        };

      };

    };

  };

}


#Building function nodeIf from line: 80

sub nodeIf {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeIf at node.qon:80\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("if ( " )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeExpression(car(first(childrenof($node ))), 0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(") {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeBody(second(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("} else {" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeBody(third(childrenof($node )), add1($indent ))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("}" )
  ;

}


#Building function nodeSetStruct from line: 93

sub nodeSetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeSetStruct at node.qon:93\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s.%s = " , stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeExpression(childrenof($node ), $indent )
  ;

}


#Building function nodeGetStruct from line: 104

sub nodeGetStruct {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeGetStruct at node.qon:104\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s.%s" , stringify(first(codeof($node ))), stringify(second(codeof($node ))))
  ;

}


#Building function nodeSet from line: 114

sub nodeSet {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeSet at node.qon:114\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine($indent )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s = " , stringify(first(codeof($node ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeExpression(childrenof($node ), $indent )
  ;

}


#Building function nodeStatement from line: 122

sub nodeStatement {
  my $node  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeStatement at node.qon:122\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalBox(boxString("setter" ), subnameof($node ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeSet($node , $indent )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( equalBox(boxString("structSetter" ), subnameof($node ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      nodeSetStruct($node , $indent )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

      if ( equalBox(boxString("if" ), subnameof($node ))) {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

        nodeIf($node , $indent )
        ;

      } else {        if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

        if ( equalBox(boxString("returnvoid" ), subnameof($node ))) {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          printf("return" )
          ;

        } else {          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          newLine($indent )
          ;
          if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

          nodeExpression(childrenof($node ), $indent )
          ;

        };

      };

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf(";\n" )
  ;

}


#Building function nodeBody from line: 143

sub nodeBody {
  my $tree  = shift;
my $indent  = shift;

  
if ($globalTrace) { printf("nodeBody at node.qon:143\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent($indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s" , "if (globalStepTrace) {console.log(new Error(\"StepTrace \\n\"));}\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeStatement(car($tree ), $indent )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeBody(cdr($tree ), $indent )
    ;

  };

}


#Building function nodeDeclarations from line: 157

sub nodeDeclarations {
  my $decls  = shift;
my $indent  = shift;

  my $decl = undef ;

if ($globalTrace) { printf("nodeDeclarations at node.qon:157\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($decls )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $decl = car($decls );
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("var %s = " , stringify(second($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    display(nodeFuncMap(third($decl )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(";\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeDeclarations(cdr($decls ), $indent )
    ;

  };

}


#Building function nodeFunction from line: 172

sub nodeFunction {
  my $node  = shift;

  my $name = undef ;

if ($globalTrace) { printf("nodeFunction at node.qon:172\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $name = subnameof($node );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n\n//Building function %s from line: %s" , stringify($name ), stringify(getTag($name , boxString("line" ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  newLine(0 )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(0 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("function %s(" , stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeFunctionArgs(cdr(assoc("intype" , cdr($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(") {" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    newLine(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeDeclarations(declarationsof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\nif (globalTrace)\n    {printf(\"%s at %s:%s\\n\");}\n" , stringify($name ), stringify(getTag($name , boxString("filename" ))), stringify(getTag($name , boxString("line" ))))
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {
    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeBody(childrenof($node ), 1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( inList(toStr($name ), noStackTrace ())) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\nif (globalTrace)\n    {printf(\"Leaving %s\\n\");}\n" , stringify($name ))
      ;

    };
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n}\n" )
    ;

  };

}


#Building function nodeForwardDeclaration from line: 205

sub nodeForwardDeclaration {
  my $node  = shift;

  
if ($globalTrace) { printf("nodeForwardDeclaration at node.qon:205\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isNil($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n%s %s(" , stringify(nodeTypeMap(cdr(assoc("outtype" , cdr($node ))))), stringify(subnameof($node )))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeFunctionArgs(cdr(assoc("intype" , cdr($node ))))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf(");" )
    ;

  };

}


#Building function nodeForwardDeclarations from line: 217

sub nodeForwardDeclarations {
  my $tree  = shift;

  
if ($globalTrace) { printf("nodeForwardDeclarations at node.qon:217\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeForwardDeclaration(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeForwardDeclarations(cdr($tree ))
    ;

  };

}


#Building function nodeFunctions from line: 227

sub nodeFunctions {
  my $tree  = shift;

  
if ($globalTrace) { printf("nodeFunctions at node.qon:227\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($tree )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeFunction(car($tree ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeFunctions(cdr($tree ))
    ;

  };

}


#Building function nodeIncludes from line: 235

sub nodeIncludes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("nodeIncludes at node.qon:235\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function read_file(filename) {return fs.readFileSync(filename);}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function write_file(filename, data) {fs.writeFileSync(filename, data);}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "var util = require('util');\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function printf() {process.stdout.write(util.format.apply(this, arguments));}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "var fs = require('fs');\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function equalString(a,b) {return a.toString()===b.toString() }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function panic(s){console.trace(s);process.exit(1);}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function dump(s){console.log(s)}" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function sub(a, b) { return a - b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function mult(a, b) { return a * b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function greaterthan(a, b) { return a > b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function subf(a, b) { return a - b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function multf(a, b) { return a * b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function greaterthanf(a, b) { return a > b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function equal(a, b) { return a == b; }\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function andBool(a, b) { return a == b;}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function string_length(s) { return s.length;}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function stringConcatenate(a, b) { return a + b}\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function intToString(a) {}\n\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function gc_malloc( size ) {\nreturn {};\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function makeArray(length) {\n   return [];\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function at(arr, index) {\n  return arr[index];\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function setAt(array, index, value) {\n    array[index] = value;\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function getStringArray(index, strs) {\nreturn strs[index];\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "var NULL = null;" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "var globalArgs;\nvar globalArgsCount;\nvar globalTrace = false;\nvar globalStepTrace = false;" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "function character(num) {}" )
  ;

}


#Building function nodeTypeDecl from line: 268

sub nodeTypeDecl {
  my $l  = shift;

  
if ($globalTrace) { printf("nodeTypeDecl at node.qon:268\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(listLength($l ), 2 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s %s;\n" , stringify(second($l )), stringify(nodeTypeMap(listLast($l ))), stringify(first($l )))
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printIndent(1 )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("%s %s;\n" , stringify(nodeTypeMap(listLast($l ))), stringify(car($l )))
    ;

  };

}


#Building function nodeStructComponents from line: 285

sub nodeStructComponents {
  my $node  = shift;

  
if ($globalTrace) { printf("nodeStructComponents at node.qon:285\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($node )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeTypeDecl(car($node ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeStructComponents(cdr($node ))
    ;

  };

}


#Building function nodeStruct from line: 293

sub nodeStruct {
  my $node  = shift;

  
if ($globalTrace) { printf("nodeStruct at node.qon:293\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeStructComponents(cdr(car($node )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function nodeTypeMap from line: 298

sub nodeTypeMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("nodeTypeMap at node.qon:298\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), $undef ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( truthy(assoc(stringify($aSym ), $symMap ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return(cdr(assoc(stringify($aSym ), $symMap )));

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeTypeMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function nodeFuncMap from line: 311

sub nodeFuncMap {
  my $aSym  = shift;

  my $symMap = undef ;

if ($globalTrace) { printf("nodeFuncMap at node.qon:311\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( equalString("symbol" , boxType($aSym ))) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), $undef )))))));
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( truthy(assoc(stringify($aSym ), $symMap ))) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeFuncMap

      if ($globalTrace) {printf("Leaving \n")}

      return(cdr(assoc(stringify($aSym ), $symMap )));

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeFuncMap

      if ($globalTrace) {printf("Leaving \n")}

      return($aSym );

    };

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: nodeFuncMap

    if ($globalTrace) {printf("Leaving \n")}

    return($aSym );

  };

}


#Building function nodeType from line: 341

sub nodeType {
  my $node  = shift;

  
if ($globalTrace) { printf("nodeType at node.qon:341\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

  
  return;

}


#Building function nodeTypes from line: 345

sub nodeTypes {
  my $nodes  = shift;

  
if ($globalTrace) { printf("nodeTypes at node.qon:345\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( isEmpty($nodes )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#Returnvoid

    
    return;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeType(car($nodes ))
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    nodeTypes(cdr($nodes ))
    ;

  };

}


#Building function nodeCompile from line: 353

sub nodeCompile {
  my $filename  = shift;

  my $programStr = "" ;
my $tree = undef ;
my $program = undef ;

if ($globalTrace) { printf("nodeCompile at node.qon:353\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $programStr = read_file($filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $tree = readSexpr($programStr , $filename );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = alistCons(boxString("includes" ), astIncludes(first($tree )), alistCons(boxString("types" ), astTypes(second($tree )), alistCons(boxString("functions" ), astFunctions(third($tree )), $undef )));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $program = mergeIncludes($program );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeIncludes(cdr(assoc("includes" , $program )))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeTypes(childrenof(cdr(assoc("types" , $program ))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\nvar globalStackTrace = NULL;\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\nfunction isNil(p) {\n    return p == NULL;\n}\n\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  nodeFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , $program ))))))
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("\n" )
  ;
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

  printf("%s" , "start();\n" )
  ;

}


#Building function start from line: 4

sub start {
  
  my $runTests = 0 ;
my $cmdLine = undef ;
my $filename = undef ;
my $runPerl = 0 ;

if ($globalTrace) { printf("start at compiler.qon:4\n") }
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $cmdLine = listReverse(argList($globalArgsCount , 0 , $globalArgs ));
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( greaterthan(listLength($cmdLine ), 1 )) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $filename = second($cmdLine );

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    $filename = boxString("compiler.qon" );

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $runTests = inList(boxString("--test" ), $cmdLine );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $runPerl = inList(boxString("--perl" ), $cmdLine );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalTrace = inList(boxString("--trace" ), $cmdLine );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  $globalStepTrace = inList(boxString("--steptrace" ), $cmdLine );
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

  if ( $runTests ) {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test0 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test1 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test2 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test3 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test4 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test5 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test6 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test7 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test8 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test9 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test10 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test12 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test13 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test15 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    test16 ()
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    printf("\n\nAfter all that hard work, I need a beer...\n" )
    ;
    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

    beers(9 )
    ;

  } else {    if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

    if ( $runPerl ) {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      perlCompile(unBoxString($filename ))
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\n" )
      ;

    } else {      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      ansiCompile(unBoxString($filename ))
      ;
      if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard expression

      printf("\n" )
      ;

    };

  };
  if ($globalStepTrace) {printf("StepTrace %s:%d\n", __FILE__, __LINE__)}

#standard return: start

  if ($globalTrace) {printf("Leaving \n")}

  return(0 );

}
;
$globalArgs = [ 1, @ARGV];$globalArgsCount = scalar(@ARGV)+1;
start();
