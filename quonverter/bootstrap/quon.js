function read_file(filename) {return fs.readFileSync(filename);}
function write_file(filename, data) {fs.writeFileSync(filename, data);}
var util = require('util');
function printf() {process.stdout.write(util.format.apply(this, arguments));}
var fs = require('fs');
function equalString(a,b) {return a.toString()===b.toString() }
function panic(s){console.trace(s);process.exit(1);}
function dump(s){console.log(s)}function sub(a, b) { return a - b; }
function mult(a, b) { return a * b; }
function greaterthan(a, b) { return a > b; }
function subf(a, b) { return a - b; }
function multf(a, b) { return a * b; }
function greaterthanf(a, b) { return a > b; }
function equal(a, b) { return a == b; }
function andBool(a, b) { return a == b;}
function string_length(s) { return s.length;}
function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};
function stringConcatenate(a, b) { return a + b}
function intToString(a) {}


function gc_malloc( size ) {
return {};
}

function makeArray(length) {
   return [];
}

function at(arr, index) {
  return arr[index];
}

function setAt(array, index, value) {
    array[index] = value;
}

function getStringArray(index, strs) {
return strs[index];
}

var NULL = null;var globalArgs;
var globalArgsCount;
var globalTrace = false;
var globalStepTrace = false;function character(num) {}
var globalStackTrace = NULL;

function isNil(p) {
    return p == NULL;
}



//Building function add from line: 19

function add(a ,b ) {
  
if (globalTrace)
    {printf("add at base.qon:19\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(sub(a , sub(0 , b )));

if (globalTrace)
    {printf("Leaving add\n");}

}


//Building function addf from line: 20

function addf(a ,b ) {
  
if (globalTrace)
    {printf("addf at base.qon:20\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(subf(a , subf(0 , b )));

if (globalTrace)
    {printf("Leaving addf\n");}

}


//Building function sub1 from line: 21

function sub1(a ) {
  
if (globalTrace)
    {printf("sub1 at base.qon:21\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(sub(a , 1 ));

if (globalTrace)
    {printf("Leaving sub1\n");}

}


//Building function add1 from line: 22

function add1(a ) {
  
if (globalTrace)
    {printf("add1 at base.qon:22\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(add(a , 1 ));

if (globalTrace)
    {printf("Leaving add1\n");}

}


//Building function clone from line: 24

function clone(b ) {
  var newb = NULL ;

if (globalTrace)
    {printf("clone at base.qon:24\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb = makeBox ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.typ = b.typ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.tag = b.tag;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.lis = b.lis;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.str = b.str;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.i = b.i;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.lengt = b.lengt;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(newb );

if (globalTrace)
    {printf("Leaving clone\n");}

}


//Building function newVoid from line: 38

function newVoid() {
  var newb = NULL ;

if (globalTrace)
    {printf("newVoid at base.qon:38\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb = makeBox ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.voi = true ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newb.typ = "void" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(newb );

if (globalTrace)
    {printf("Leaving newVoid\n");}

}


//Building function cons from line: 47

function cons(data ,l ) {
  var p = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  p = makePair ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  p.cdr = l ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  p.car = data ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  p.typ = "list" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(p );

}


//Building function stackDump from line: 55

function stackDump() {
  
if (globalTrace)
    {printf("stackDump at base.qon:55\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("" );

if (globalTrace)
    {printf("Leaving stackDump\n");}

}


//Building function nop from line: 60

function nop() {
  
if (globalTrace)
    {printf("nop at base.qon:60\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("" );

if (globalTrace)
    {printf("Leaving nop\n");}

}


//Building function car from line: 63

function car(l ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assertType("list" , l , 65 , "base.qon" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Cannot call car on empty list!\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Cannot call car on empty list!\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(l.car)) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(NULL );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(l.car);

    };

  };

}


//Building function cdr from line: 76

function cdr(l ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assertType("list" , l , 78 , "base.qon" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Attempt to cdr an empty list!!!!\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Attempt to cdr an empty list!!!!\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(l.cdr);

  };

}


//Building function isList from line: 86

function isList(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(equalString("list" , b.typ));

  };

}


//Building function emptyList from line: 93

function emptyList() {
  
if (globalTrace)
    {printf("emptyList at base.qon:93\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(NULL );

if (globalTrace)
    {printf("Leaving emptyList\n");}

}


//Building function isEmpty from line: 95

function isEmpty(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  };

}


//Building function listLength from line: 101

function listLength(l ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(0 );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(add1(listLength(cdr(l ))));

  };

}


//Building function alistCons from line: 110

function alistCons(key ,value ,alist ) {
  
if (globalTrace)
    {printf("alistCons at base.qon:110\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cons(cons(key , value ), alist ));

if (globalTrace)
    {printf("Leaving alistCons\n");}

}


//Building function assoc from line: 113

function assoc(searchTerm ,l ) {
  var elem = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assertType("list" , l , 115 , "base.qon" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(boxBool(false ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    elem = car(l );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    assertType("list" , elem , 121 , "base.qon" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isEmpty(elem )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(assoc(searchTerm , cdr(l )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( false ) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("Comparing %s and %s\n" , searchTerm , stringify(car(elem )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("" );

      };
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString(searchTerm , stringify(car(elem )))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(elem );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(assoc(searchTerm , cdr(l )));

      };

    };

  };

}


//Building function equalBox from line: 132

function equalBox(a ,b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isList(b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("string" , boxType(a ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(equalString(unBoxString(a ), stringify(b )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("bool" , boxType(a ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(andBool(unBoxBool(a ), unBoxBool(b )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalString("symbol" , boxType(a ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalString("symbol" , boxType(b ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(equalString(unBoxSymbol(a ), unBoxSymbol(b )));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(false );

          };

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalString("int" , boxType(a ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(equal(unBoxInt(a ), unBoxInt(b )));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(false );

          };

        };

      };

    };

  };

}


//Building function displayList from line: 153

function displayList(l ,indent ) {
  var val = NULL ;

if (globalTrace)
    {printf("displayList at base.qon:153\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isList(l )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isEmpty(l )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return;

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        val = car(l );
        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( isList(val )) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("%s" , openBrace ());
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          displayList(car(l ), add1(indent ));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("%s" , closeBrace ());
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          displayList(cdr(l ), indent );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalString("string" , val.typ)) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("\"%s\" " , unBoxString(val ));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("%s " , stringify(val ));

          };
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          displayList(cdr(l ), indent );

        };

      };

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("string" , l.typ)) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("\"%s\" " , unBoxString(l ));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("%s " , stringify(l ));

      };

    };

  };

if (globalTrace)
    {printf("Leaving displayList\n");}

}


//Building function display from line: 181

function display(l ) {
  
if (globalTrace)
    {printf("display at base.qon:181\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("nil " );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isList(l )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("[" );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      displayList(l , 0 );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("]" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      displayList(l , 0 );

    };

  };

if (globalTrace)
    {printf("Leaving display\n");}

}


//Building function boxType from line: 193

function boxType(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b.typ);

}


//Building function makeBox from line: 194

function makeBox() {
  var b = NULL ;

if (globalTrace)
    {printf("makeBox at base.qon:194\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = {};
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.tag = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.car = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.cdr = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.lis = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.typ = "None - error!" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b );

if (globalTrace)
    {printf("Leaving makeBox\n");}

}


//Building function makePair from line: 205

function makePair() {
  
if (globalTrace)
    {printf("makePair at base.qon:205\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeBox ());

if (globalTrace)
    {printf("Leaving makePair\n");}

}


//Building function boxString from line: 211

function boxString(s ) {
  var b = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = makeBox ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.str = s ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.lengt = string_length(s );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.typ = "string" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b );

}


//Building function boxSymbol from line: 221

function boxSymbol(s ) {
  var b = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = boxString(s );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.typ = "symbol" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b );

}


//Building function boxBool from line: 230

function boxBool(boo ) {
  var b = NULL ;

if (globalTrace)
    {printf("boxBool at base.qon:230\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = makeBox ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.boo = boo ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.typ = "bool" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b );

if (globalTrace)
    {printf("Leaving boxBool\n");}

}


//Building function boxInt from line: 239

function boxInt(val ) {
  var b = NULL ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = makeBox ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.i = val ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.typ = "int" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b );

}


//Building function assertType from line: 248

function assertType(atype ,abox ,line ,file ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(abox )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString(atype , "nil" )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return;

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return;

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString(atype , boxType(abox ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return;

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("Assertion failure at line %d, in file %s: provided value is not a '%s'!  It was actually (%s):" , line , file , atype , abox.typ);
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      display(abox );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      panic("Invalid type!" );

    };

  };

}


//Building function unBoxString from line: 260

function unBoxString(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assertType("string" , b , 261 , "base.qon" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b.str);

}


//Building function unBoxSymbol from line: 263

function unBoxSymbol(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b.str);

}


//Building function unBoxBool from line: 264

function unBoxBool(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b.boo);

}


//Building function unBoxInt from line: 265

function unBoxInt(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(b.i);

}


//Building function stringify_rec from line: 267

function stringify_rec(b ) {
  
if (globalTrace)
    {printf("stringify_rec at base.qon:267\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return("" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringify_rec(cdr(b )))));

  };

if (globalTrace)
    {printf("Leaving stringify_rec\n");}

}


//Building function stringify from line: 279

function stringify(b ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return("()" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("string" , boxType(b ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(unBoxString(b ));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("bool" , boxType(b ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( unBoxBool(b )) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return("true" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return("false" );

        };

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalString("int" , boxType(b ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(intToString(unBoxInt(b )));

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalString("symbol" , boxType(b ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(unBoxSymbol(b ));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalString("list" , boxType(b ))) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(stringConcatenate("(" , stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringConcatenate(stringify_rec(cdr(b )), ")" )))));

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(stringConcatenate("Unsupported type: " , boxType(b )));

            };

          };

        };

      };

    };

  };

}


//Building function hasTag from line: 310

function hasTag(aBox ,key ) {
  
if (globalTrace)
    {printf("hasTag at base.qon:310\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(aBox )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(isNotFalse(assoc(stringify(key ), aBox.tag)));

  };

if (globalTrace)
    {printf("Leaving hasTag\n");}

}


//Building function getTag from line: 316

function getTag(aBox ,key ) {
  
if (globalTrace)
    {printf("getTag at base.qon:316\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( false ) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Getting %s from: " , stringify(key ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(alistKeys(aBox.tag));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc(stringify(key ), aBox.tag)));

if (globalTrace)
    {printf("Leaving getTag\n");}

}


//Building function getTagFail from line: 328

function getTagFail(aBox ,key ,onFail ) {
  
if (globalTrace)
    {printf("getTagFail at base.qon:328\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( hasTag(aBox , key )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(getTag(aBox , key ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(onFail );

  };

if (globalTrace)
    {printf("Leaving getTagFail\n");}

}


//Building function assocExists from line: 334

function assocExists(key ,aBox ) {
  
if (globalTrace)
    {printf("assocExists at base.qon:334\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(aBox )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(isNotFalse(assoc(key , aBox )));

  };

if (globalTrace)
    {printf("Leaving assocExists\n");}

}


//Building function assocFail from line: 342

function assocFail(key ,aBox ,onFail ) {
  
if (globalTrace)
    {printf("assocFail at base.qon:342\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( assocExists(key , aBox )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(assoc(key , aBox ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxString(key ), onFail ));

  };

if (globalTrace)
    {printf("Leaving assocFail\n");}

}


//Building function setTag from line: 350

function setTag(key ,val ,aStruct ) {
  
if (globalTrace)
    {printf("setTag at base.qon:350\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  aStruct.tag = alistCons(key , val , aStruct.tag);
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(aStruct );

if (globalTrace)
    {printf("Leaving setTag\n");}

}


//Building function filterVoid from line: 360

function filterVoid(l ) {
  var token = NULL ;

if (globalTrace)
    {printf("filterVoid at base.qon:360\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token = car(l );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("void" , token.typ)) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(filterVoid(cdr(l )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(token , filterVoid(cdr(l ))));

    };

  };

if (globalTrace)
    {printf("Leaving filterVoid\n");}

}


//Building function filterTokens from line: 372

function filterTokens(l ) {
  var token = NULL ;

if (globalTrace)
    {printf("filterTokens at base.qon:372\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token = car(l );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString(boxType(token ), "symbol" )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("__LINE__" , stringify(token ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(cons(getTagFail(token , boxString("line" ), boxInt(-1 )), filterTokens(cdr(l ))));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalString("__COLUMN__" , stringify(token ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(cons(getTagFail(token , boxString("column" ), boxInt(-1 )), filterTokens(cdr(l ))));

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalString("__FILE__" , stringify(token ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(cons(getTagFail(token , boxString("filename" ), boxString("Unknown file" )), filterTokens(cdr(l ))));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(cons(token , filterTokens(cdr(l ))));

          };

        };

      };

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(token , filterTokens(cdr(l ))));

    };

  };

if (globalTrace)
    {printf("Leaving filterTokens\n");}

}


//Building function finish_token from line: 406

function finish_token(prog ,start ,len ,line ,column ,filename ) {
  var token = NULL ;

if (globalTrace)
    {printf("finish_token at base.qon:406\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(len , 0 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token = boxSymbol(sub_string(prog , start , len ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token.tag = alistCons(boxString("filename" ), boxString(filename ), alistCons(boxString("column" ), boxInt(column ), alistCons(boxString("line" ), boxInt(line ), alistCons(boxString("totalCharPos" ), boxInt(start ), NULL ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(token );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(newVoid ());

  };

if (globalTrace)
    {printf("Leaving finish_token\n");}

}


//Building function readString from line: 421

function readString(prog ,start ,len ) {
  var token = "" ;

if (globalTrace)
    {printf("readString at base.qon:421\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  token = sub_string(prog , sub1(add(start , len )), 1 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("\"" , token )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(sub_string(prog , start , sub1(len )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("\\" , token )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(readString(prog , start , add(2 , len )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(readString(prog , start , add1(len )));

    };

  };

if (globalTrace)
    {printf("Leaving readString\n");}

}


//Building function readComment from line: 432

function readComment(prog ,start ,len ) {
  var token = "" ;

if (globalTrace)
    {printf("readComment at base.qon:432\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  token = sub_string(prog , sub1(add(start , len )), 1 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isLineBreak(token )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(sub_string(prog , start , sub1(len )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(readComment(prog , start , add1(len )));

  };

if (globalTrace)
    {printf("Leaving readComment\n");}

}


//Building function isWhiteSpace from line: 440

function isWhiteSpace(s ) {
  
if (globalTrace)
    {printf("isWhiteSpace at base.qon:440\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(" " , s )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("\t" , s )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("\n" , s )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(true );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalString("\r" , s )) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(true );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(false );

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving isWhiteSpace\n");}

}


//Building function isLineBreak from line: 457

function isLineBreak(s ) {
  
if (globalTrace)
    {printf("isLineBreak at base.qon:457\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("\n" , s )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalString("\r" , s )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(false );

    };

  };

if (globalTrace)
    {printf("Leaving isLineBreak\n");}

}


//Building function incForNewLine from line: 464

function incForNewLine(token ,val ) {
  
if (globalTrace)
    {printf("incForNewLine at base.qon:464\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("\n" , stringify(token ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(add1(val ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(val );

  };

if (globalTrace)
    {printf("Leaving incForNewLine\n");}

}


//Building function annotateReadPosition from line: 471

function annotateReadPosition(filename ,linecount ,column ,start ,newBox ) {
  
if (globalTrace)
    {printf("annotateReadPosition at base.qon:471\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(setTag(boxString("filename" ), boxString(filename ), setTag(boxString("column" ), boxInt(column ), setTag(boxString("line" ), boxInt(linecount ), setTag(boxString("totalCharPos" ), boxInt(start ), newBox )))));

if (globalTrace)
    {printf("Leaving annotateReadPosition\n");}

}


//Building function scan from line: 483

function scan(prog ,start ,len ,linecount ,column ,filename ) {
  var token = NULL ;
var newString = "" ;
var newBox = NULL ;

if (globalTrace)
    {printf("scan at base.qon:483\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( false ) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Scanning: line %d:%d\n" , linecount , column );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(string_length(prog ), sub(start , sub(0 , len )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token = boxSymbol(sub_string(prog , sub1(add(start , len )), 1 ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    token.tag = alistCons(boxString("totalCharPos" ), boxInt(start ), NULL );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isOpenBrace(token )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(boxSymbol(openBrace ()), scan(prog , add1(start ), 1 , linecount , add1(column ), filename ))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isCloseBrace(token )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(annotateReadPosition(filename , linecount , column , start , boxSymbol(closeBrace ())), scan(prog , add(start , len ), 1 , linecount , add1(column ), filename ))));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( isWhiteSpace(stringify(token ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), scan(prog , add(start , len ), 1 , incForNewLine(token , linecount ), 0 , filename )));

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxSymbol(";" ), token )) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(scan(prog , add(start , add1(add1(string_length(readComment(prog , add1(start ), len ))))), 1 , add1(linecount ), 0 , filename ));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalBox(boxSymbol("\"" ), token )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              newString = readString(prog , add1(start ), len );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              newBox = annotateReadPosition(filename , linecount , column , start , boxString(newString ));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(cons(newBox , scan(prog , add(start , add1(add1(string_length(newString )))), 1 , linecount , add1(column ), filename )));

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(scan(prog , start , sub(len , -1 ), linecount , add1(column ), filename ));

            };

          };

        };

      };

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  };

if (globalTrace)
    {printf("Leaving scan\n");}

}


//Building function isOpenBrace from line: 523

function isOpenBrace(b ) {
  
if (globalTrace)
    {printf("isOpenBrace at base.qon:523\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxSymbol(openBrace ()), b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxSymbol("[" ), b )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(false );

    };

  };

if (globalTrace)
    {printf("Leaving isOpenBrace\n");}

}


//Building function openBrace from line: 531

function openBrace() {
  
if (globalTrace)
    {printf("openBrace at base.qon:531\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return("(" );

if (globalTrace)
    {printf("Leaving openBrace\n");}

}


//Building function isCloseBrace from line: 533

function isCloseBrace(b ) {
  
if (globalTrace)
    {printf("isCloseBrace at base.qon:533\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxSymbol(closeBrace ()), b )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxSymbol("]" ), b )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(false );

    };

  };

if (globalTrace)
    {printf("Leaving isCloseBrace\n");}

}


//Building function closeBrace from line: 543

function closeBrace() {
  
if (globalTrace)
    {printf("closeBrace at base.qon:543\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(")" );

if (globalTrace)
    {printf("Leaving closeBrace\n");}

}


//Building function sexprTree from line: 545

function sexprTree(l ) {
  var b = NULL ;

if (globalTrace)
    {printf("sexprTree at base.qon:545\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    b = car(l );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isOpenBrace(b )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(sexprTree(cdr(l )), sexprTree(skipList(cdr(l )))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isCloseBrace(b )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(emptyList ());

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(setTag(boxString("line" ), getTagFail(b , boxString("line" ), boxInt(-1 )), cons(b , sexprTree(cdr(l )))));

      };

    };

  };

if (globalTrace)
    {printf("Leaving sexprTree\n");}

}


//Building function skipList from line: 564

function skipList(l ) {
  var b = NULL ;

if (globalTrace)
    {printf("skipList at base.qon:564\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    b = car(l );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isOpenBrace(b )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(skipList(skipList(cdr(l ))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isCloseBrace(b )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(cdr(l ));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(skipList(cdr(l )));

      };

    };

  };

if (globalTrace)
    {printf("Leaving skipList\n");}

}


//Building function readSexpr from line: 579

function readSexpr(aStr ,filename ) {
  var tokens = NULL ;
var as = NULL ;

if (globalTrace)
    {printf("readSexpr at base.qon:579\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tokens = emptyList ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tokens = filterTokens(filterVoid(scan(aStr , 0 , 1 , 0 , 0 , filename )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  as = sexprTree(tokens );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(as ));

if (globalTrace)
    {printf("Leaving readSexpr\n");}

}


//Building function caar from line: 589

function caar(l ) {
  
if (globalTrace)
    {printf("caar at base.qon:589\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(car(l )));

if (globalTrace)
    {printf("Leaving caar\n");}

}


//Building function cadr from line: 590

function cadr(l ) {
  
if (globalTrace)
    {printf("cadr at base.qon:590\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(cdr(l )));

if (globalTrace)
    {printf("Leaving cadr\n");}

}


//Building function caddr from line: 591

function caddr(l ) {
  
if (globalTrace)
    {printf("caddr at base.qon:591\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(cdr(cdr(l ))));

if (globalTrace)
    {printf("Leaving caddr\n");}

}


//Building function cadddr from line: 592

function cadddr(l ) {
  
if (globalTrace)
    {printf("cadddr at base.qon:592\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(cdr(cdr(cdr(l )))));

if (globalTrace)
    {printf("Leaving cadddr\n");}

}


//Building function caddddr from line: 593

function caddddr(l ) {
  
if (globalTrace)
    {printf("caddddr at base.qon:593\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(cdr(cdr(cdr(cdr(l ))))));

if (globalTrace)
    {printf("Leaving caddddr\n");}

}


//Building function cddr from line: 594

function cddr(l ) {
  
if (globalTrace)
    {printf("cddr at base.qon:594\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(cdr(l )));

if (globalTrace)
    {printf("Leaving cddr\n");}

}


//Building function first from line: 595

function first(l ) {
  
if (globalTrace)
    {printf("first at base.qon:595\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(car(l ));

if (globalTrace)
    {printf("Leaving first\n");}

}


//Building function second from line: 596

function second(l ) {
  
if (globalTrace)
    {printf("second at base.qon:596\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cadr(l ));

if (globalTrace)
    {printf("Leaving second\n");}

}


//Building function third from line: 597

function third(l ) {
  
if (globalTrace)
    {printf("third at base.qon:597\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(caddr(l ));

if (globalTrace)
    {printf("Leaving third\n");}

}


//Building function fourth from line: 598

function fourth(l ) {
  
if (globalTrace)
    {printf("fourth at base.qon:598\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cadddr(l ));

if (globalTrace)
    {printf("Leaving fourth\n");}

}


//Building function fifth from line: 599

function fifth(l ) {
  
if (globalTrace)
    {printf("fifth at base.qon:599\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(caddddr(l ));

if (globalTrace)
    {printf("Leaving fifth\n");}

}


//Building function makeNode from line: 605

function makeNode(name ,subname ,code ,children ) {
  
if (globalTrace)
    {printf("makeNode at base.qon:605\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ())))))));

if (globalTrace)
    {printf("Leaving makeNode\n");}

}


//Building function addToNode from line: 621

function addToNode(key ,val ,node ) {
  
if (globalTrace)
    {printf("addToNode at base.qon:621\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cons(boxSymbol("node" ), alistCons(key , val , cdr(node ))));

if (globalTrace)
    {printf("Leaving addToNode\n");}

}


//Building function makeStatementNode from line: 626

function makeStatementNode(name ,subname ,code ,children ,functionName ) {
  
if (globalTrace)
    {printf("makeStatementNode at base.qon:626\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(addToNode(boxSymbol("functionName" ), functionName , makeNode(name , subname , code , children )));

if (globalTrace)
    {printf("Leaving makeStatementNode\n");}

}


//Building function astExpression from line: 631

function astExpression(tree ) {
  
if (globalTrace)
    {printf("astExpression at base.qon:631\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isList(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(makeNode("expression" , "expression" , NULL , astSubExpression(tree )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(astSubExpression(tree ));

  };

if (globalTrace)
    {printf("Leaving astExpression\n");}

}


//Building function astSubExpression from line: 639

function astSubExpression(tree ) {
  
if (globalTrace)
    {printf("astSubExpression at base.qon:639\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isList(tree )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(astExpression(car(tree )), astSubExpression(cdr(tree ))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(makeNode("expression" , "leaf" , tree , NULL ));

    };

  };

if (globalTrace)
    {printf("Leaving astSubExpression\n");}

}


//Building function astIf from line: 650

function astIf(tree ,fname ) {
  
if (globalTrace)
    {printf("astIf at base.qon:650\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("then" ), car(second(tree )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nop ();

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Error at %s:%s!  If statement is missing the true branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Missing true branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("else" ), car(third(tree )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nop ();

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("Error at %s:%s!  If statement is missing the false branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Missing false branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), NULL ), cons(astBody(cdr(second(tree )), fname ), cons(astBody(cdr(third(tree )), fname ), NULL )))));

if (globalTrace)
    {printf("Leaving astIf\n");}

}


//Building function astSetStruct from line: 671

function astSetStruct(tree ) {
  
if (globalTrace)
    {printf("astSetStruct at base.qon:671\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));

if (globalTrace)
    {printf("Leaving astSetStruct\n");}

}


//Building function astSet from line: 676

function astSet(tree ) {
  
if (globalTrace)
    {printf("astSet at base.qon:676\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));

if (globalTrace)
    {printf("Leaving astSet\n");}

}


//Building function astGetStruct from line: 681

function astGetStruct(tree ) {
  
if (globalTrace)
    {printf("astGetStruct at base.qon:681\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeNode("expression" , "structGetter" , tree , NULL ));

if (globalTrace)
    {printf("Leaving astGetStruct\n");}

}


//Building function astReturnVoid from line: 684

function astReturnVoid(fname ) {
  
if (globalTrace)
    {printf("astReturnVoid at base.qon:684\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeStatementNode("statement" , "returnvoid" , NULL , NULL , fname ));

if (globalTrace)
    {printf("Leaving astReturnVoid\n");}

}


//Building function astStatement from line: 688

function astStatement(tree ,fname ) {
  
if (globalTrace)
    {printf("astStatement at base.qon:688\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("if" ), car(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(astIf(cdr(tree ), fname ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxString("set" ), car(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(astSet(cdr(tree )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxString("get-struct" ), car(tree ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("Choosing get-struct statement\n" );
        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(astGetStruct(cdr(tree )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalBox(boxString("set-struct" ), car(tree ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          return(astSetStruct(cdr(tree )));

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), car(tree ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equal(listLength(tree ), 1 )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(astReturnVoid(fname ));

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              return(makeStatementNode("statement" , "return" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));

            };

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            return(makeStatementNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));

          };

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving astStatement\n");}

}


//Building function astBody from line: 718

function astBody(tree ,fname ) {
  
if (globalTrace)
    {printf("astBody at base.qon:718\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(astStatement(car(tree ), fname ), astBody(cdr(tree ), fname )));

  };

if (globalTrace)
    {printf("Leaving astBody\n");}

}


//Building function linePanic from line: 724

function linePanic(line ,message ) {
  
if (globalTrace)
    {printf("linePanic at base.qon:724\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("line %s: %s\n" , line , message );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  panic(message );

if (globalTrace)
    {printf("Leaving linePanic\n");}

}


//Building function astFunction from line: 730

function astFunction(tree ) {
  var line = "" ;
var file = "" ;
var fname = NULL ;

if (globalTrace)
    {printf("astFunction at base.qon:730\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  fname = second(tree );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  line = stringify(getTag(fname , boxString("line" )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  file = stringify(getTag(fname , boxString("filename" )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(1 , listLength(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    linePanic(line , "Malformed function, seems to be empty" );

  } else {
  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(2 , listLength(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    linePanic(line , "Malformed function, expected function name" );

  } else {
  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(3 , listLength(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    linePanic(line , "Malformed function, expected argument list" );

  } else {
  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(4 , listLength(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    linePanic(line , "Malformed function, expected variable declarations" );

  } else {
  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(5 , listLength(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    linePanic(line , "Malformed function, expected body" );

  } else {
  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )), fname )), emptyList ()))))))));

if (globalTrace)
    {printf("Leaving astFunction\n");}

}


//Building function astFunctionList from line: 760

function astFunctionList(tree ) {
  
if (globalTrace)
    {printf("astFunctionList at base.qon:760\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));

  };

if (globalTrace)
    {printf("Leaving astFunctionList\n");}

}


//Building function astFunctions from line: 768

function astFunctions(tree ) {
  
if (globalTrace)
    {printf("astFunctions at base.qon:768\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("functions" ), car(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Functions section not found!  Every program must have a function section, even if you don't define any functions, although that is a rather pointless program.  Your function section should look like:'\n\n(return_type function_name (arg1 arg2 arg3 ...) (declare types) (body (statement)(statement)))\n\n\nThe function section must be directly after the types section." );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  };

if (globalTrace)
    {printf("Leaving astFunctions\n");}

}


//Building function loadLib from line: 776

function loadLib(path ) {
  var programStr = "" ;
var tree = NULL ;
var library = NULL ;

if (globalTrace)
    {printf("loadLib at base.qon:776\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(path );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , path );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = macrowalk(tree );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(library );

if (globalTrace)
    {printf("Leaving loadLib\n");}

}


//Building function astInclude from line: 792

function astInclude(tree ) {
  
if (globalTrace)
    {printf("astInclude at base.qon:792\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(loadLib(stringify(tree )));

if (globalTrace)
    {printf("Leaving astInclude\n");}

}


//Building function astIncludeList from line: 795

function astIncludeList(tree ) {
  
if (globalTrace)
    {printf("astIncludeList at base.qon:795\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));

  };

if (globalTrace)
    {printf("Leaving astIncludeList\n");}

}


//Building function astIncludes from line: 802

function astIncludes(tree ) {
  
if (globalTrace)
    {printf("astIncludes at base.qon:802\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("includes" ), car(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree ))));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  };

if (globalTrace)
    {printf("Leaving astIncludes\n");}

}


//Building function astStruct from line: 810

function astStruct(tree ) {
  
if (globalTrace)
    {printf("astStruct at base.qon:810\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(makeNode("type" , "struct" , tree , NULL ));

if (globalTrace)
    {printf("Leaving astStruct\n");}

}


//Building function astType from line: 813

function astType(tree ) {
  
if (globalTrace)
    {printf("astType at base.qon:813\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isList(cadr(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(astStruct(tree ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(makeNode("type" , "type" , tree , NULL ));

  };

if (globalTrace)
    {printf("Leaving astType\n");}

}


//Building function astTypeList from line: 819

function astTypeList(tree ) {
  
if (globalTrace)
    {printf("astTypeList at base.qon:819\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(emptyList ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));

  };

if (globalTrace)
    {printf("Leaving astTypeList\n");}

}


//Building function astTypes from line: 825

function astTypes(tree ) {
  
if (globalTrace)
    {printf("astTypes at base.qon:825\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("types" ), car(tree ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Types section not found!  Every program must have a types section, even if you don't define any types" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(boxString("Fuck java" ));

  };

if (globalTrace)
    {printf("Leaving astTypes\n");}

}


//Building function declarationsof from line: 835

function declarationsof(ass ) {
  
if (globalTrace)
    {printf("declarationsof at base.qon:835\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("declarations" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving declarationsof\n");}

}


//Building function codeof from line: 838

function codeof(ass ) {
  
if (globalTrace)
    {printf("codeof at base.qon:838\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("code" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving codeof\n");}

}


//Building function functionNameof from line: 841

function functionNameof(ass ) {
  
if (globalTrace)
    {printf("functionNameof at base.qon:841\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("functionName" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving functionNameof\n");}

}


//Building function nodeof from line: 844

function nodeof(ass ) {
  
if (globalTrace)
    {printf("nodeof at base.qon:844\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(boxBool(false ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc("node" , cdr(ass ))));

  };

if (globalTrace)
    {printf("Leaving nodeof\n");}

}


//Building function lineof from line: 850

function lineof(ass ) {
  
if (globalTrace)
    {printf("lineof at base.qon:850\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxBool(false ), assoc("line" , cdr(ass )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(boxInt(-1 ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc("line" , cdr(ass ))));

  };

if (globalTrace)
    {printf("Leaving lineof\n");}

}


//Building function subnameof from line: 856

function subnameof(ass ) {
  
if (globalTrace)
    {printf("subnameof at base.qon:856\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("subname" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving subnameof\n");}

}


//Building function nameof from line: 859

function nameof(ass ) {
  
if (globalTrace)
    {printf("nameof at base.qon:859\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("name" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving nameof\n");}

}


//Building function childrenof from line: 862

function childrenof(ass ) {
  
if (globalTrace)
    {printf("childrenof at base.qon:862\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cdr(assoc("children" , cdr(ass ))));

if (globalTrace)
    {printf("Leaving childrenof\n");}

}


//Building function isNode from line: 866

function isNode(val ) {
  
if (globalTrace)
    {printf("isNode at base.qon:866\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(val )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isList(val )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxSymbol("node" ), car(val ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(true );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(false );

      };

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(false );

    };

  };

if (globalTrace)
    {printf("Leaving isNode\n");}

}


//Building function truthy from line: 880

function truthy(aVal ) {
  
if (globalTrace)
    {printf("truthy at base.qon:880\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(isNotFalse(aVal ));

if (globalTrace)
    {printf("Leaving truthy\n");}

}


//Building function isNotFalse from line: 884

function isNotFalse(aVal ) {
  
if (globalTrace)
    {printf("isNotFalse at base.qon:884\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(boxType(aVal ), "bool" )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( unBoxBool(aVal )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(false );

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(true );

  };

if (globalTrace)
    {printf("Leaving isNotFalse\n");}

}


//Building function isLeaf from line: 891

function isLeaf(n ) {
  
if (globalTrace)
    {printf("isLeaf at base.qon:891\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(equalBox(boxString("leaf" ), subnameof(n )));

if (globalTrace)
    {printf("Leaving isLeaf\n");}

}


//Building function printIndent from line: 896

function printIndent(ii ) {
  
if (globalTrace)
    {printf("printIndent at base.qon:896\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(ii , 0 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("  " );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(sub1(ii ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  };

if (globalTrace)
    {printf("Leaving printIndent\n");}

}


//Building function newLine from line: 904

function newLine(indent ) {
  
if (globalTrace)
    {printf("newLine at base.qon:904\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printIndent(indent );

if (globalTrace)
    {printf("Leaving newLine\n");}

}


//Building function noStackTrace from line: 908

function noStackTrace() {
  
if (globalTrace)
    {printf("noStackTrace at base.qon:908\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), NULL ))))))))))))))))))))))))));

if (globalTrace)
    {printf("Leaving noStackTrace\n");}

}


//Building function toStr from line: 937

function toStr(thing ) {
  
if (globalTrace)
    {printf("toStr at base.qon:937\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(boxString(stringify(thing )));

if (globalTrace)
    {printf("Leaving toStr\n");}

}


//Building function listLast from line: 940

function listLast(alist ) {
  
if (globalTrace)
    {printf("listLast at base.qon:940\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(cdr(alist ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(car(alist ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(listLast(cdr(alist )));

  };

if (globalTrace)
    {printf("Leaving listLast\n");}

}


//Building function treeCompile from line: 947

function treeCompile(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("treeCompile at base.qon:947\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(tree );

if (globalTrace)
    {printf("Leaving treeCompile\n");}

}


//Building function astBuild from line: 953

function astBuild(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("astBuild at base.qon:953\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = mergeIncludes(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(program );

if (globalTrace)
    {printf("Leaving astBuild\n");}

}


//Building function astCompile from line: 970

function astCompile(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("astCompile at base.qon:970\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = astBuild(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n" );

if (globalTrace)
    {printf("Leaving astCompile\n");}

}


//Building function concatLists from line: 977

function concatLists(seq1 ,seq2 ) {
  
if (globalTrace)
    {printf("concatLists at base.qon:977\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(seq1 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(seq2 );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));

  };

if (globalTrace)
    {printf("Leaving concatLists\n");}

}


//Building function alistKeys from line: 983

function alistKeys(alist ) {
  
if (globalTrace)
    {printf("alistKeys at base.qon:983\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(alist )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(car(car(alist )), alistKeys(cdr(alist ))));

  };

if (globalTrace)
    {printf("Leaving alistKeys\n");}

}


//Building function mergeIncludes from line: 989

function mergeIncludes(program ) {
  
if (globalTrace)
    {printf("mergeIncludes at base.qon:989\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program ));

if (globalTrace)
    {printf("Leaving mergeIncludes\n");}

}


//Building function merge_recur from line: 996

function merge_recur(incs ,program ) {
  
if (globalTrace)
    {printf("merge_recur at base.qon:996\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(listLength(incs ), 0 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(mergeInclude(car(incs ), merge_recur(cdr(incs ), program )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(program );

  };

if (globalTrace)
    {printf("Leaving merge_recur\n");}

}


//Building function mergeInclude from line: 1004

function mergeInclude(inc ,program ) {
  var newProgram = NULL ;
var oldfunctionsnode = NULL ;
var oldfunctions = NULL ;
var newfunctions = NULL ;
var newFunctionNode = NULL ;
var functions = NULL ;
var oldtypesnode = NULL ;
var oldtypes = NULL ;
var newtypes = NULL ;
var newTypeNode = NULL ;
var types = NULL ;

if (globalTrace)
    {printf("mergeInclude at base.qon:1004\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(inc )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(program );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    functions = childrenof(cdr(assoc("functions" , inc )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    oldfunctionsnode = cdr(assoc("functions" , program ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    oldfunctions = childrenof(oldfunctionsnode );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newfunctions = concatLists(functions , oldfunctions );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newfunctions , cdr(oldfunctionsnode )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    types = childrenof(cdr(assoc("types" , inc )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    oldtypesnode = cdr(assoc("types" , program ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    oldtypes = childrenof(oldtypesnode );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newtypes = concatLists(types , oldtypes );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newTypeNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newtypes , cdr(oldtypesnode )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newProgram = alistCons(boxString("functions" ), newFunctionNode , alistCons(boxString("types" ), newTypeNode , alistCons(boxString("includes" ), cons(boxSymbol("includes" ), NULL ), newProgram )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(newProgram );

  };

if (globalTrace)
    {printf("Leaving mergeInclude\n");}

}


//Building function macrowalk from line: 1058

function macrowalk(l ) {
  var val = NULL ;

if (globalTrace)
    {printf("macrowalk at base.qon:1058\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isList(l )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString(stringConcatenate("box" , "List" ), stringify(car(l )))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(car(doBoxList(cdr(l ))));

      } else {
      };
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString(stringConcatenate("string" , "List" ), stringify(car(l )))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        return(car(doStringList(cdr(l ))));

      } else {
      };
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cons(macrowalk(car(l )), macrowalk(cdr(l ))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(l );

    };

  };

if (globalTrace)
    {printf("Leaving macrowalk\n");}

}


//Building function doBoxList from line: 1100

function doBoxList(l ) {
  
if (globalTrace)
    {printf("doBoxList at base.qon:1100\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxSymbol("nil" ), NULL ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(cons(boxSymbol("cons" ), cons(first(l ), doBoxList(cdr(l )))), NULL ));

  };

if (globalTrace)
    {printf("Leaving doBoxList\n");}

}


//Building function doStringList from line: 1116

function doStringList(l ) {
  var newlist = NULL ;
var ret = NULL ;

if (globalTrace)
    {printf("doStringList at base.qon:1116\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxSymbol("nil" ), NULL ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newlist = cons(boxSymbol("boxString" ), cons(first(l ), newlist ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ret = cons(cons(boxSymbol("cons" ), cons(newlist , doStringList(cdr(l )))), NULL );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(ret );

  };

if (globalTrace)
    {printf("Leaving doStringList\n");}

}


//Building function argList from line: 1140

function argList(count ,pos ,args ) {
  
if (globalTrace)
    {printf("argList at base.qon:1140\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(count , pos )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  };

if (globalTrace)
    {printf("Leaving argList\n");}

}


//Building function listReverse from line: 1152

function listReverse(l ) {
  
if (globalTrace)
    {printf("listReverse at base.qon:1152\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(NULL );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(car(l ), listReverse(cdr(l ))));

  };

if (globalTrace)
    {printf("Leaving listReverse\n");}

}


//Building function inList from line: 1158

function inList(item ,l ) {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(l )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(false );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(car(l ), item )) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(true );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(inList(item , cdr(l )));

    };

  };

}


//Building function tron from line: 1169

function tron() {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalTrace = true ;

}


//Building function troff from line: 1170

function troff() {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalTrace = false ;

}


//Building function stron from line: 1171

function stron() {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalStepTrace = true ;

}


//Building function stroff from line: 1172

function stroff() {
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalStepTrace = false ;

}


//Building function numbers from line: 4

function numbers(num ) {
  
if (globalTrace)
    {printf("numbers at perl.qon:4\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(0 , num )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxString("-" ), NULL ));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cons(boxString(stringify(boxInt(num ))), numbers(sub1(num ))));

  };

if (globalTrace)
    {printf("Leaving numbers\n");}

}


//Building function lexType from line: 11

function lexType(abox ) {
  
if (globalTrace)
    {printf("lexType at perl.qon:11\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("string" , boxType(abox ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return("string" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(boxString(sub_string(stringify(abox ), 0 , 1 )), numbers(9 ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return("number" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return("symbol" );

    };

  };

if (globalTrace)
    {printf("Leaving lexType\n");}

}


//Building function perlLeaf from line: 23

function perlLeaf(thisNode ,indent ) {
  
if (globalTrace)
    {printf("perlLeaf at perl.qon:23\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , lexType(codeof(thisNode )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s" , dollar ());

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(perlFuncMap(codeof(thisNode )));

if (globalTrace)
    {printf("Leaving perlLeaf\n");}

}


//Building function perlStructGetterExpression from line: 32

function perlStructGetterExpression(thisNode ,indent ) {
  
if (globalTrace)
    {printf("perlStructGetterExpression at perl.qon:32\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlLeaf(thisNode , indent );

  };

if (globalTrace)
    {printf("Leaving perlStructGetterExpression\n");}

}


//Building function perlExpression from line: 38

function perlExpression(node ,indent ) {
  
if (globalTrace)
    {printf("perlExpression at perl.qon:38\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isLeaf(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlLeaf(node , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlSubExpression(node , indent );

  };

if (globalTrace)
    {printf("Leaving perlExpression\n");}

}


//Building function perlRecurList from line: 44

function perlRecurList(expr ,indent ) {
  
if (globalTrace)
    {printf("perlRecurList at perl.qon:44\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(expr )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlExpression(car(expr ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf(", " );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      perlRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    {printf("Leaving perlRecurList\n");}

}


//Building function perlSubExpression from line: 55

function perlSubExpression(tree ,indent ) {
  var thing = NULL ;

if (globalTrace)
    {printf("perlSubExpression at perl.qon:55\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      perlSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isLeaf(tree )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("%s" , dollar ());
        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        display(perlFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("" );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("()" );

          };

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("%s%s->{%s}" , dollar (), stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("{}" );

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("%s(" , stringify(perlFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              perlRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving perlSubExpression\n");}

}


//Building function perlIf from line: 93

function perlIf(node ,indent ) {
  
if (globalTrace)
    {printf("perlIf at perl.qon:93\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("if ( " );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(") {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("} else {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("}" );

if (globalTrace)
    {printf("Leaving perlIf\n");}

}


//Building function perlSetStruct from line: 106

function perlSetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("perlSetStruct at perl.qon:106\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s->{%s} = " , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving perlSetStruct\n");}

}


//Building function perlGetStruct from line: 113

function perlGetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("perlGetStruct at perl.qon:113\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s->{%s}" , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    {printf("Leaving perlGetStruct\n");}

}


//Building function perlSet from line: 118

function perlSet(node ,indent ) {
  
if (globalTrace)
    {printf("perlSet at perl.qon:118\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s = " , dollar (), stringify(first(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving perlSet\n");}

}


//Building function assertNode from line: 124

function assertNode(node ) {
  
if (globalTrace)
    {printf("assertNode at perl.qon:124\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNode(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    panic("Not a node!" );

  };

if (globalTrace)
    {printf("Leaving assertNode\n");}

}


//Building function perlStatement from line: 131

function perlStatement(node ,indent ) {
  var functionName = NULL ;

if (globalTrace)
    {printf("perlStatement at perl.qon:131\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assertNode(node );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlSet(node , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      perlSetStruct(node , indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        perlIf(node , indent );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          functionName = functionNameof(node );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("\n#Returnvoid\n" );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("return" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), subnameof(node ))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            functionName = functionNameof(node );
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( inList(functionName , noStackTrace ())) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("" );

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("\n#standard return: %s\n" , stringify(functionName ));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              newLine(indent );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("%s%s%s" , "if (" , dollar (), "globalTrace) {printf(\"Leaving \\n\")}\n" );

            };
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            newLine(indent );
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            perlExpression(childrenof(node ), indent );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( inList(functionName , noStackTrace ())) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("" );

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("\n#standard expression\n" );

            };
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            newLine(indent );
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            perlExpression(childrenof(node ), indent );
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            newLine(indent );

          };

        };

      };

    };

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";\n" );

if (globalTrace)
    {printf("Leaving perlStatement\n");}

}


//Building function perlBody from line: 180

function perlBody(tree ,indent ) {
  
if (globalTrace)
    {printf("perlBody at perl.qon:180\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s%s%s" , "if (" , dollar (), "globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlStatement(car(tree ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlBody(cdr(tree ), indent );

  };

if (globalTrace)
    {printf("Leaving perlBody\n");}

}


//Building function perlDeclarations from line: 190

function perlDeclarations(decls ,indent ) {
  var decl = NULL ;

if (globalTrace)
    {printf("perlDeclarations at perl.qon:190\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(decls )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    decl = car(decls );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("my %s%s = " , dollar (), stringify(second(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(perlConstMap(third(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(";\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    {printf("Leaving perlDeclarations\n");}

}


//Building function perlFunction from line: 201

function perlFunction(node ) {
  var name = NULL ;

if (globalTrace)
    {printf("perlFunction at perl.qon:201\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  name = subnameof(node );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n#Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(0 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("sub %s" , stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(" {" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\nif (%sglobalTrace) { printf(\"%s at %s:%s\\n\") }\n" , dollar (), stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(name , noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlBody(childrenof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(name , noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n}\n" );

  };

if (globalTrace)
    {printf("Leaving perlFunction\n");}

}


//Building function perlForwardDeclaration from line: 233

function perlForwardDeclaration(node ) {
  
if (globalTrace)
    {printf("perlForwardDeclaration at perl.qon:233\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\nsub %s" , stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(";" );

  };

if (globalTrace)
    {printf("Leaving perlForwardDeclaration\n");}

}


//Building function perlForwardDeclarations from line: 243

function perlForwardDeclarations(tree ) {
  
if (globalTrace)
    {printf("perlForwardDeclarations at perl.qon:243\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlForwardDeclaration(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving perlForwardDeclarations\n");}

}


//Building function perlFunctions from line: 251

function perlFunctions(tree ) {
  
if (globalTrace)
    {printf("perlFunctions at perl.qon:251\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlFunction(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlFunctions(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving perlFunctions\n");}

}


//Building function dollar from line: 258

function dollar() {
  
if (globalTrace)
    {printf("dollar at perl.qon:258\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(character(36 ));

if (globalTrace)
    {printf("Leaving dollar\n");}

}


//Building function atSym from line: 261

function atSym() {
  
if (globalTrace)
    {printf("atSym at perl.qon:261\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(character(64 ));

if (globalTrace)
    {printf("Leaving atSym\n");}

}


//Building function perlIncludes from line: 265

function perlIncludes(nodes ) {
  
if (globalTrace)
    {printf("perlIncludes at perl.qon:265\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s\n" , "use strict;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s\n" , "use Carp;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  dollar ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s\n" , "use Carp::Always;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub greaterthan { " , dollar (), "_[0] > " , dollar (), "_[1] };" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub mult { " , dollar (), "_[0] * " , dollar (), "_[1] };" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub multf { " , dollar (), "_[0] * " , dollar (), "_[1] };" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub greaterthanf { " , dollar (), "_[0] > " , dollar (), "_[1] };" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub equalString { " , dollar (), "_[0] eq " , dollar (), "_[1] };" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("sub read_file { my %sfile = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; local %s/ = undef; my %scont = <%sfh>; close %sfh; return %scont; }; \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("sub write_file {my %sfile = shift; my %sdata = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; print %sfh %sdata; close %sfh; } \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub stringConcatenate { " , dollar (), "_[0] . " , dollar (), "_[1]}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub subtract { " , dollar (), "_[0] - " , dollar (), "_[1]}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub subf { " , dollar (), "_[0] - " , dollar (), "_[1]}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub andBool { " , dollar (), "_[0] && " , dollar (), "_[1]}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub equal { " , dollar (), "_[0] == " , dollar (), "_[1]}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s\n" , "sub panic { carp " , atSym (), "_; die \"" , atSym (), "_\"}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("sub intToString { return %s_[0]}\n" , dollar ());
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("sub character { return chr(%s_[0])}\n" , dollar ());
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s%s%s%s%s%s\n" , "sub getStringArray { my " , dollar (), "index = shift; my " , dollar (), "arr = shift; return " , dollar (), "arr->[" , dollar (), "index]}" );

if (globalTrace)
    {printf("Leaving perlIncludes\n");}

}


//Building function perlTypeDecl from line: 298

function perlTypeDecl(l ) {
  
if (globalTrace)
    {printf("perlTypeDecl at perl.qon:298\n");}

if (globalTrace)
    {printf("Leaving perlTypeDecl\n");}

}


//Building function perlStructComponents from line: 303

function perlStructComponents(node ) {
  
if (globalTrace)
    {printf("perlStructComponents at perl.qon:303\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlTypeDecl(car(node ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlStructComponents(cdr(node ));

  };

if (globalTrace)
    {printf("Leaving perlStructComponents\n");}

}


//Building function perlStruct from line: 309

function perlStruct(node ) {
  
if (globalTrace)
    {printf("perlStruct at perl.qon:309\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlStructComponents(cdr(car(node )));

if (globalTrace)
    {printf("Leaving perlStruct\n");}

}


//Building function perlTypeMap from line: 312

function perlTypeMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("perlTypeMap at perl.qon:312\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving perlTypeMap\n");}

}


//Building function perlConstMap from line: 324

function perlConstMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("perlConstMap at perl.qon:324\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    symMap = alistCons(boxSymbol("false" ), boxSymbol("0" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), NULL ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving perlConstMap\n");}

}


//Building function perlFuncMap from line: 334

function perlFuncMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("perlFuncMap at perl.qon:334\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("substr" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), NULL ))))))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving perlFuncMap\n");}

}


//Building function perlType from line: 351

function perlType(node ) {
  
if (globalTrace)
    {printf("perlType at perl.qon:351\n");}

if (globalTrace)
    {printf("Leaving perlType\n");}

}


//Building function perlTypes from line: 356

function perlTypes(nodes ) {
  
if (globalTrace)
    {printf("perlTypes at perl.qon:356\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(nodes )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlType(car(nodes ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlTypes(cdr(nodes ));

  };

if (globalTrace)
    {printf("Leaving perlTypes\n");}

}


//Building function perlFunctionArgs from line: 362

function perlFunctionArgs(tree ) {
  
if (globalTrace)
    {printf("perlFunctionArgs at perl.qon:362\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s%s" , "my " , dollar ());
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(second(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(" = shift;\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    perlFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    {printf("Leaving perlFunctionArgs\n");}

}


//Building function perlCompile from line: 372

function perlCompile(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("perlCompile at perl.qon:372\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = mergeIncludes(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("use strict;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("use Carp;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("use Data::Dumper;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "globalStackTrace = undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "globalTrace = undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "globalStepTrace = undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "globalArgs = undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "globalArgsCount = undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s\n" , "my " , dollar (), "true = 1;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "false = 0;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "my " , dollar (), "undef;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s" , "\nsub isNil {\n    return !defined(" , dollar (), "_[0]);\n}\n\n\n#Forward declarations\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n#End forward declarations\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s" , dollar (), "globalArgs = [ 1, " , atSym (), "ARGV];" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s%s%s%s" , dollar (), "globalArgsCount = scalar(" , atSym (), "ARGV)+1;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("start();" );

if (globalTrace)
    {printf("Leaving perlCompile\n");}

}


//Building function ansiFunctionArgs from line: 3

function ansiFunctionArgs(tree ) {
  
if (globalTrace)
    {printf("ansiFunctionArgs at ansi.qon:3\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(ansiTypeMap(first(tree )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(second(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("," );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    {printf("Leaving ansiFunctionArgs\n");}

}


//Building function ansiLeaf from line: 13

function ansiLeaf(thisNode ,indent ) {
  
if (globalTrace)
    {printf("ansiLeaf at ansi.qon:13\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(ansiFuncMap(codeof(thisNode )));

if (globalTrace)
    {printf("Leaving ansiLeaf\n");}

}


//Building function ansiStructGetterExpression from line: 16

function ansiStructGetterExpression(thisNode ,indent ) {
  
if (globalTrace)
    {printf("ansiStructGetterExpression at ansi.qon:16\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiLeaf(thisNode , indent );

  };

if (globalTrace)
    {printf("Leaving ansiStructGetterExpression\n");}

}


//Building function ansiExpression from line: 22

function ansiExpression(node ,indent ) {
  
if (globalTrace)
    {printf("ansiExpression at ansi.qon:22\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isLeaf(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(ansiFuncMap(codeof(node )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiSubExpression(node , indent );

  };

if (globalTrace)
    {printf("Leaving ansiExpression\n");}

}


//Building function ansiRecurList from line: 28

function ansiRecurList(expr ,indent ) {
  
if (globalTrace)
    {printf("ansiRecurList at ansi.qon:28\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(expr )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiExpression(car(expr ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf(", " );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      ansiRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    {printf("Leaving ansiRecurList\n");}

}


//Building function ansiSubExpression from line: 40

function ansiSubExpression(tree ,indent ) {
  var thing = NULL ;

if (globalTrace)
    {printf("ansiSubExpression at ansi.qon:40\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      ansiSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isLeaf(tree )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        display(ansiFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("" );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("()" );

          };

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("%s->%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof(tree )))));

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              ansiRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving ansiSubExpression\n");}

}


//Building function ansiIf from line: 80

function ansiIf(node ,indent ) {
  
if (globalTrace)
    {printf("ansiIf at ansi.qon:80\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("if ( " );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(") {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("} else {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("}" );

if (globalTrace)
    {printf("Leaving ansiIf\n");}

}


//Building function ansiSetStruct from line: 93

function ansiSetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("ansiSetStruct at ansi.qon:93\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving ansiSetStruct\n");}

}


//Building function ansiGetStruct from line: 102

function ansiGetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("ansiGetStruct at ansi.qon:102\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    {printf("Leaving ansiGetStruct\n");}

}


//Building function ansiSet from line: 110

function ansiSet(node ,indent ) {
  
if (globalTrace)
    {printf("ansiSet at ansi.qon:110\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving ansiSet\n");}

}


//Building function ansiStatement from line: 116

function ansiStatement(node ,indent ) {
  
if (globalTrace)
    {printf("ansiStatement at ansi.qon:116\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiSet(node , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      ansiSetStruct(node , indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        ansiIf(node , indent );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("return" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          ansiExpression(childrenof(node ), indent );

        };

      };

    };

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";\n" );

if (globalTrace)
    {printf("Leaving ansiStatement\n");}

}


//Building function ansiBody from line: 134

function ansiBody(tree ,indent ) {
  var code = NULL ;

if (globalTrace)
    {printf("ansiBody at ansi.qon:134\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    code = codeof(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(code )) {
    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      code = car(codeof(car(tree )));
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("\nif (globalTrace)\n    snprintf(caller, 1024, \"from %s:%s\");\n" , stringify(getTagFail(code , boxString("filename" ), boxString("Unknown" ))), stringify(getTagFail(code , boxString("line" ), boxString("Unknown" ))));

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiStatement(car(tree ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiBody(cdr(tree ), indent );

  };

if (globalTrace)
    {printf("Leaving ansiBody\n");}

}


//Building function ansiDeclarations from line: 153

function ansiDeclarations(decls ,indent ) {
  var decl = NULL ;

if (globalTrace)
    {printf("ansiDeclarations at ansi.qon:153\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(decls )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    decl = car(decls );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s = " , stringify(ansiTypeMap(first(decl ))), stringify(second(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(ansiFuncMap(third(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(";\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    {printf("Leaving ansiDeclarations\n");}

}


//Building function ansiFunction from line: 167

function ansiFunction(node ) {
  var name = NULL ;

if (globalTrace)
    {printf("ansiFunction at ansi.qon:167\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  name = subnameof(node );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(0 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(") {" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("\nif (globalTrace)\n    printf(\"%s at %s:%s (%%s)\\n\", caller);\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {
    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiBody(childrenof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify(name ));

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n}\n" );

  };

if (globalTrace)
    {printf("Leaving ansiFunction\n");}

}


//Building function ansiForwardDeclaration from line: 201

function ansiForwardDeclaration(node ) {
  
if (globalTrace)
    {printf("ansiForwardDeclaration at ansi.qon:201\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(");" );

  };

if (globalTrace)
    {printf("Leaving ansiForwardDeclaration\n");}

}


//Building function ansiForwardDeclarations from line: 213

function ansiForwardDeclarations(tree ) {
  
if (globalTrace)
    {printf("ansiForwardDeclarations at ansi.qon:213\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiForwardDeclaration(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving ansiForwardDeclarations\n");}

}


//Building function ansiFunctions from line: 221

function ansiFunctions(tree ) {
  
if (globalTrace)
    {printf("ansiFunctions at ansi.qon:221\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiFunction(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiFunctions(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving ansiFunctions\n");}

}


//Building function ansiIncludes from line: 226

function ansiIncludes(nodes ) {
  
if (globalTrace)
    {printf("ansiIncludes at ansi.qon:226\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nconst char* getEnv(char* key){return getenv(key);}\n void panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* setSubString(char* target, int start,char *source){target[start]=source[0]; return target;}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar* caller;\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n  caller=calloc(1024,1);\n\n  return start();\n\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }" );

if (globalTrace)
    {printf("Leaving ansiIncludes\n");}

}


//Building function ansiTypeDecl from line: 234

function ansiTypeDecl(l ) {
  
if (globalTrace)
    {printf("ansiTypeDecl at ansi.qon:234\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s;\n" , stringify(ansiTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    {printf("Leaving ansiTypeDecl\n");}

}


//Building function ansiStructComponents from line: 251

function ansiStructComponents(node ) {
  
if (globalTrace)
    {printf("ansiStructComponents at ansi.qon:251\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiTypeDecl(car(node ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiStructComponents(cdr(node ));

  };

if (globalTrace)
    {printf("Leaving ansiStructComponents\n");}

}


//Building function ansiStruct from line: 257

function ansiStruct(node ) {
  
if (globalTrace)
    {printf("ansiStruct at ansi.qon:257\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiStructComponents(cdr(car(node )));

if (globalTrace)
    {printf("Leaving ansiStruct\n");}

}


//Building function ansiTypeMap from line: 260

function ansiTypeMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("ansiTypeMap at ansi.qon:260\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving ansiTypeMap\n");}

}


//Building function ansiFuncMap from line: 272

function ansiFuncMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("ansiFuncMap at ansi.qon:272\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), NULL )))))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(aSym );

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving ansiFuncMap\n");}

}


//Building function ansiType from line: 303

function ansiType(node ) {
  
if (globalTrace)
    {printf("ansiType at ansi.qon:303\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(subnameof(node ), boxString("struct" ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiStruct(cdr(codeof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n} %s;\n" , stringify(first(codeof(node ))));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("typedef " );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiTypeDecl(codeof(node ));

  };

if (globalTrace)
    {printf("Leaving ansiType\n");}

}


//Building function ansiTypes from line: 313

function ansiTypes(nodes ) {
  
if (globalTrace)
    {printf("ansiTypes at ansi.qon:313\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(nodes )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiType(car(nodes ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    ansiTypes(cdr(nodes ));

  };

if (globalTrace)
    {printf("Leaving ansiTypes\n");}

}


//Building function uniqueTarget from line: 321

function uniqueTarget(a ,b ) {
  
if (globalTrace)
    {printf("uniqueTarget at ansi.qon:321\n");}

if (globalTrace)
    {printf("Leaving uniqueTarget\n");}

}


//Building function ansiCompile from line: 324

function ansiCompile(filename ) {
  var foundationFuncs = NULL ;
var foundation = NULL ;
var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("ansiCompile at ansi.qon:324\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  foundation = readSexpr(read_file("foundationlibs/ansi.qon" ), "foundationlibs/ansi.qon" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  foundationFuncs = cdr(third(foundation ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("//Scanning file...%s\n" , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("//Building sexpr\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = macrowalk(tree );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  cons(boxString("a" ), cons(boxString("b" ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("//Building AST\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("//Merging ASTs\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = mergeIncludes(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("//Printing program\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("Box* globalStackTrace = NULL;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n//End forward declarations\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n" );

if (globalTrace)
    {printf("Leaving ansiCompile\n");}

}


//Building function test0 from line: 7

function test0() {
  
if (globalTrace)
    {printf("test0 at tests.qon:7\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(stringify(boxString("hello" )), stringify(boxString("hello" )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("0.  pass string compare works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("0.  pass string compare fails\n" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("0.  pass string compare works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("0.  pass string compare fails\n" );

  };

if (globalTrace)
    {printf("Leaving test0\n");}

}


//Building function test1 from line: 20

function test1() {
  
if (globalTrace)
    {printf("test1 at tests.qon:20\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("1.  pass Function call and print work\n" );

if (globalTrace)
    {printf("Leaving test1\n");}

}


//Building function test2_do from line: 24

function test2_do(message ) {
  
if (globalTrace)
    {printf("test2_do at tests.qon:24\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("2.  pass Function call with arg works: %s\n" , message );

if (globalTrace)
    {printf("Leaving test2_do\n");}

}


//Building function test2 from line: 28

function test2() {
  
if (globalTrace)
    {printf("test2 at tests.qon:28\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  test2_do("This is the argument" );

if (globalTrace)
    {printf("Leaving test2\n");}

}


//Building function test3_do from line: 30

function test3_do(b ,c ) {
  
if (globalTrace)
    {printf("test3_do at tests.qon:30\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("3.1 pass Two arg call, first arg: %d\n" , b );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("3.2 pass Two arg call, second arg: %s\n" , c );

if (globalTrace)
    {printf("Leaving test3_do\n");}

}


//Building function test3 from line: 36

function test3() {
  
if (globalTrace)
    {printf("test3 at tests.qon:36\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  test3_do(42 , "Fourty-two" );

if (globalTrace)
    {printf("Leaving test3\n");}

}


//Building function test4_do from line: 37

function test4_do() {
  
if (globalTrace)
    {printf("test4_do at tests.qon:37\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return("pass Return works" );

if (globalTrace)
    {printf("Leaving test4_do\n");}

}


//Building function returnThis from line: 39

function returnThis(returnMessage ) {
  
if (globalTrace)
    {printf("returnThis at tests.qon:39\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(returnMessage );

if (globalTrace)
    {printf("Leaving returnThis\n");}

}


//Building function test4 from line: 44

function test4() {
  var message = "fail" ;

if (globalTrace)
    {printf("test4 at tests.qon:44\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  message = test4_do ();
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("4.  %s\n" , message );

if (globalTrace)
    {printf("Leaving test4\n");}

}


//Building function test5 from line: 49

function test5() {
  var message = "fail" ;

if (globalTrace)
    {printf("test5 at tests.qon:49\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  message = returnThis("pass return passthrough string" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("5.  %s\n" , message );

if (globalTrace)
    {printf("Leaving test5\n");}

}


//Building function test6 from line: 56

function test6() {
  
if (globalTrace)
    {printf("test6 at tests.qon:56\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( true ) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("6.  pass If statement works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("6.  fail If statement works\n" );

  };

if (globalTrace)
    {printf("Leaving test6\n");}

}


//Building function test7_do from line: 64

function test7_do(count ) {
  
if (globalTrace)
    {printf("test7_do at tests.qon:64\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  count = sub(count , 1 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(count , 0 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    count = test7_do(count );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(count );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(count );

if (globalTrace)
    {printf("Leaving test7_do\n");}

}


//Building function test7 from line: 72

function test7() {
  
if (globalTrace)
    {printf("test7 at tests.qon:72\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equal(0 , test7_do(10 ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("7.  pass count works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("7.  fail count fails\n" );

  };

if (globalTrace)
    {printf("Leaving test7\n");}

}


//Building function beer from line: 80

function beer() {
  
if (globalTrace)
    {printf("beer at tests.qon:80\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );

if (globalTrace)
    {printf("Leaving beer\n");}

}


//Building function plural from line: 89

function plural(num ) {
  
if (globalTrace)
    {printf("plural at tests.qon:89\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equal(num , 1 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return("" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return("s" );

  };

if (globalTrace)
    {printf("Leaving plural\n");}

}


//Building function beers from line: 94

function beers(count ) {
  var newcount = 0 ;

if (globalTrace)
    {printf("beers at tests.qon:94\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newcount = sub(count , 1 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , count , plural(count ), count , plural(count ), newcount , plural(newcount ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(count , 1 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    count = beers(newcount );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(count );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(0 );

if (globalTrace)
    {printf("Leaving beers\n");}

}


//Building function test8 from line: 110

function test8() {
  
if (globalTrace)
    {printf("test8 at tests.qon:110\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("8.  pass Nested expressions work\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("8.  fail Nested expressions don't work\n" );

  };

if (globalTrace)
    {printf("Leaving test8\n");}

}


//Building function test9 from line: 118

function test9() {
  var answer = -999999 ;

if (globalTrace)
    {printf("test9 at tests.qon:118\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  answer = sub(sub(20 , 1 ), sub(3 , 1 ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equal(answer , 17 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("9.  pass arithmetic works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("9.  fail arithmetic\n" );

  };

if (globalTrace)
    {printf("Leaving test9\n");}

}


//Building function test10 from line: 127

function test10() {
  var testString = "This is a test string" ;

if (globalTrace)
    {printf("test10 at tests.qon:127\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(testString , unBoxString(car(cons(boxString(testString ), NULL ))))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("10. pass cons and car work\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("10. fail cons and car fail\n" );

  };

if (globalTrace)
    {printf("Leaving test10\n");}

}


//Building function test12 from line: 137

function test12() {
  var b = NULL ;

if (globalTrace)
    {printf("test12 at tests.qon:137\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b = {};
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  b.str = "12. pass structure accessors\n" ;
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , b.str);

if (globalTrace)
    {printf("Leaving test12\n");}

}


//Building function test13 from line: 145

function test13() {
  var testString = "Hello from the filesystem!" ;
var contents = "" ;

if (globalTrace)
    {printf("test13 at tests.qon:145\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  write_file("test.txt" , testString );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  contents = read_file("test.txt" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(testString , contents )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("13. pass Read and write files\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("13. fail Read and write files\n" );

  };

if (globalTrace)
    {printf("Leaving test13\n");}

}


//Building function test15 from line: 157

function test15() {
  var a = "hello" ;
var b = " world" ;
var c = "" ;

if (globalTrace)
    {printf("test15 at tests.qon:157\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  c = stringConcatenate(a , b );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString(c , "hello world" )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("15. pass String concatenate\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("15. fail String concatenate\n" );

  };

if (globalTrace)
    {printf("Leaving test15\n");}

}


//Building function test16 from line: 167

function test16() {
  var assocCell1 = NULL ;
var assList = NULL ;
var assocCell2 = NULL ;
var assocCell3 = NULL ;

if (globalTrace)
    {printf("test16 at tests.qon:167\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assocCell1 = cons(boxString("Hello" ), boxString("world" ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assocCell2 = cons(boxString("goodnight" ), boxString("moon" ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assList = cons(assocCell2 , emptyList ());
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assList = cons(assocCell1 , assList );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  assList = cons(assocCell3 , assList );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(cdr(assoc("Hello" , assList )), boxString("world" ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("16.1 pass Basic assoc works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("16.1 fail Basic assoc fails\n" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( andBool(andBool(equalBox(cdr(assoc("Hello" , assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , assList )), boxString("gozaimasu" )))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("16.2 pass assoc list\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("16.2 fail assoc list\n" );

  };

if (globalTrace)
    {printf("Leaving test16\n");}

}


//Building function test17 from line: 192

function test17() {
  var l = NULL ;

if (globalTrace)
    {printf("test17 at tests.qon:192\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  l = cons(boxInt(1 ), cons(boxInt(2 ), cons(boxInt(3 ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(car(l ), boxInt(1 ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("17 pass list literal works\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("17 fail list literal failed\n" );

  };

if (globalTrace)
    {printf("Leaving test17\n");}

}


//Building function test18 from line: 201

function test18() {
  var val1 = "a" ;
var val2 = "b" ;
var val3 = "c" ;
var l = NULL ;

if (globalTrace)
    {printf("test18 at tests.qon:201\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(l );

if (globalTrace)
    {printf("Leaving test18\n");}

}


//Building function reverseRec from line: 211

function reverseRec(old ,new ) {
  
if (globalTrace)
    {printf("reverseRec at tests.qon:211\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(old )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(new );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(reverseRec(cdr(old ), cons(first(old ), new )));

  };

if (globalTrace)
    {printf("Leaving reverseRec\n");}

}


//Building function reverseList from line: 218

function reverseList(l ) {
  
if (globalTrace)
    {printf("reverseList at tests.qon:218\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(reverseRec(l , NULL ));

if (globalTrace)
    {printf("Leaving reverseList\n");}

}


//Building function test19 from line: 222

function test19() {
  var val1 = "a" ;
var val2 = "b" ;
var val3 = "c" ;
var l = NULL ;
var revlist = NULL ;

if (globalTrace)
    {printf("test19 at tests.qon:222\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("Starting reverselist\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  revlist = reverseList(l );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(revlist );

if (globalTrace)
    {printf("Leaving test19\n");}

}


//Building function concatenateLists from line: 235

function concatenateLists(old ,new ) {
  
if (globalTrace)
    {printf("concatenateLists at tests.qon:235\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(reverseRec(reverseList(old ), new ));

if (globalTrace)
    {printf("Leaving concatenateLists\n");}

}


//Building function test20 from line: 241

function test20() {
  var val1 = "a" ;
var val2 = "b" ;
var val3 = "c" ;
var l = NULL ;
var l2 = NULL ;
var combined = NULL ;
var revlist = NULL ;

if (globalTrace)
    {printf("test20 at tests.qon:241\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  l2 = cons(boxString("d" ), cons(boxString("e" ), cons(boxString("f" ), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  combined = concatenateLists(l , l2 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(l );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(l2 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(combined );

if (globalTrace)
    {printf("Leaving test20\n");}

}


//Building function nodeFunctionArgs from line: 4

function nodeFunctionArgs(tree ) {
  
if (globalTrace)
    {printf("nodeFunctionArgs at node.qon:4\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(second(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("," );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    {printf("Leaving nodeFunctionArgs\n");}

}


//Building function nodeLeaf from line: 13

function nodeLeaf(thisNode ,indent ) {
  
if (globalTrace)
    {printf("nodeLeaf at node.qon:13\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(nodeFuncMap(codeof(thisNode )));

if (globalTrace)
    {printf("Leaving nodeLeaf\n");}

}


//Building function nodeStructGetterExpression from line: 16

function nodeStructGetterExpression(thisNode ,indent ) {
  
if (globalTrace)
    {printf("nodeStructGetterExpression at node.qon:16\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeLeaf(thisNode , indent );

  };

if (globalTrace)
    {printf("Leaving nodeStructGetterExpression\n");}

}


//Building function nodeExpression from line: 22

function nodeExpression(node ,indent ) {
  
if (globalTrace)
    {printf("nodeExpression at node.qon:22\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isLeaf(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(nodeFuncMap(codeof(node )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeSubExpression(node , indent );

  };

if (globalTrace)
    {printf("Leaving nodeExpression\n");}

}


//Building function nodeRecurList from line: 28

function nodeRecurList(expr ,indent ) {
  
if (globalTrace)
    {printf("nodeRecurList at node.qon:28\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(expr )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeExpression(car(expr ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf(", " );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      nodeRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    {printf("Leaving nodeRecurList\n");}

}


//Building function nodeSubExpression from line: 41

function nodeSubExpression(tree ,indent ) {
  var thing = NULL ;

if (globalTrace)
    {printf("nodeSubExpression at node.qon:41\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      nodeSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isLeaf(tree )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        display(nodeFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("" );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("()" );

          };

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("{}" );

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("%s(" , stringify(nodeFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              nodeRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving nodeSubExpression\n");}

}


//Building function nodeIf from line: 82

function nodeIf(node ,indent ) {
  
if (globalTrace)
    {printf("nodeIf at node.qon:82\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("if ( " );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(") {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("} else {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("}" );

if (globalTrace)
    {printf("Leaving nodeIf\n");}

}


//Building function nodeGetStruct from line: 96

function nodeGetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("nodeGetStruct at node.qon:96\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    {printf("Leaving nodeGetStruct\n");}

}


//Building function nodeSet from line: 104

function nodeSet(node ,indent ) {
  
if (globalTrace)
    {printf("nodeSet at node.qon:104\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving nodeSet\n");}

}


//Building function nodeSetStruct from line: 110

function nodeSetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("nodeSetStruct at node.qon:110\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeExpression(childrenof(node ), indent );

if (globalTrace)
    {printf("Leaving nodeSetStruct\n");}

}


//Building function nodeStatement from line: 118

function nodeStatement(node ,indent ) {
  
if (globalTrace)
    {printf("nodeStatement at node.qon:118\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeSet(node , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      nodeSetStruct(node , indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        nodeIf(node , indent );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("return" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          nodeExpression(childrenof(node ), indent );

        };

      };

    };

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";\n" );

if (globalTrace)
    {printf("Leaving nodeStatement\n");}

}


//Building function nodeBody from line: 137

function nodeBody(tree ,indent ) {
  
if (globalTrace)
    {printf("nodeBody at node.qon:137\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s" , "if (globalStepTrace) {console.log(new Error(\"StepTrace \\n\"));}\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeStatement(car(tree ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeBody(cdr(tree ), indent );

  };

if (globalTrace)
    {printf("Leaving nodeBody\n");}

}


//Building function nodeDeclarations from line: 151

function nodeDeclarations(decls ,indent ) {
  var decl = NULL ;

if (globalTrace)
    {printf("nodeDeclarations at node.qon:151\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(decls )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    decl = car(decls );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("var %s = " , stringify(second(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(nodeFuncMap(third(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(";\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    {printf("Leaving nodeDeclarations\n");}

}


//Building function nodeFunction from line: 166

function nodeFunction(node ) {
  var name = NULL ;

if (globalTrace)
    {printf("nodeFunction at node.qon:166\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  name = subnameof(node );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(0 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("function %s(" , stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(") {" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("\nif (globalTrace)\n    {printf(\"%s at %s:%s\\n\");}\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {
    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeBody(childrenof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("\nif (globalTrace)\n    {printf(\"Leaving %s\\n\");}\n" , stringify(name ));

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n}\n" );

  };

if (globalTrace)
    {printf("Leaving nodeFunction\n");}

}


//Building function nodeForwardDeclaration from line: 199

function nodeForwardDeclaration(node ) {
  
if (globalTrace)
    {printf("nodeForwardDeclaration at node.qon:199\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n%s %s(" , stringify(nodeTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(");" );

  };

if (globalTrace)
    {printf("Leaving nodeForwardDeclaration\n");}

}


//Building function nodeForwardDeclarations from line: 211

function nodeForwardDeclarations(tree ) {
  
if (globalTrace)
    {printf("nodeForwardDeclarations at node.qon:211\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeForwardDeclaration(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving nodeForwardDeclarations\n");}

}


//Building function nodeFunctions from line: 221

function nodeFunctions(tree ) {
  
if (globalTrace)
    {printf("nodeFunctions at node.qon:221\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeFunction(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeFunctions(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving nodeFunctions\n");}

}


//Building function nodeIncludes from line: 229

function nodeIncludes(nodes ) {
  
if (globalTrace)
    {printf("nodeIncludes at node.qon:229\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function read_file(filename) {return fs.readFileSync(filename);}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function write_file(filename, data) {fs.writeFileSync(filename, data);}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "var util = require('util');\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function printf() {process.stdout.write(util.format.apply(this, arguments));}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "var fs = require('fs');\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function equalString(a,b) {return a.toString()===b.toString() }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function panic(s){console.trace(s);process.exit(1);}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function dump(s){console.log(s)}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function sub(a, b) { return a - b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function mult(a, b) { return a * b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function greaterthan(a, b) { return a > b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function subf(a, b) { return a - b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function multf(a, b) { return a * b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function greaterthanf(a, b) { return a > b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function equal(a, b) { return a == b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function andBool(a, b) { return a == b;}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function string_length(s) { return s.length;}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function stringConcatenate(a, b) { return a + b}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function intToString(a) {}\n\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function gc_malloc( size ) {\nreturn {};\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function makeArray(length) {\n   return [];\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function at(arr, index) {\n  return arr[index];\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function setAt(array, index, value) {\n    array[index] = value;\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function getStringArray(index, strs) {\nreturn strs[index];\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "var NULL = null;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "var globalArgs;\nvar globalArgsCount;\nvar globalTrace = false;\nvar globalStepTrace = false;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "function character(num) {}" );

if (globalTrace)
    {printf("Leaving nodeIncludes\n");}

}


//Building function nodeTypeDecl from line: 262

function nodeTypeDecl(l ) {
  
if (globalTrace)
    {printf("nodeTypeDecl at node.qon:262\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s %s;\n" , stringify(second(l )), stringify(nodeTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s;\n" , stringify(nodeTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    {printf("Leaving nodeTypeDecl\n");}

}


//Building function nodeStructComponents from line: 279

function nodeStructComponents(node ) {
  
if (globalTrace)
    {printf("nodeStructComponents at node.qon:279\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeTypeDecl(car(node ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeStructComponents(cdr(node ));

  };

if (globalTrace)
    {printf("Leaving nodeStructComponents\n");}

}


//Building function nodeStruct from line: 287

function nodeStruct(node ) {
  
if (globalTrace)
    {printf("nodeStruct at node.qon:287\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeStructComponents(cdr(car(node )));

if (globalTrace)
    {printf("Leaving nodeStruct\n");}

}


//Building function nodeTypeMap from line: 292

function nodeTypeMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("nodeTypeMap at node.qon:292\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving nodeTypeMap\n");}

}


//Building function nodeFuncMap from line: 307

function nodeFuncMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("nodeFuncMap at node.qon:307\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), NULL )))))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(aSym );

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving nodeFuncMap\n");}

}


//Building function nodeType from line: 338

function nodeType(node ) {
  
if (globalTrace)
    {printf("nodeType at node.qon:338\n");}

if (globalTrace)
    {printf("Leaving nodeType\n");}

}


//Building function nodeTypes from line: 342

function nodeTypes(nodes ) {
  
if (globalTrace)
    {printf("nodeTypes at node.qon:342\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(nodes )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeType(car(nodes ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    nodeTypes(cdr(nodes ));

  };

if (globalTrace)
    {printf("Leaving nodeTypes\n");}

}


//Building function nodeCompile from line: 350

function nodeCompile(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("nodeCompile at node.qon:350\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = mergeIncludes(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\nvar globalStackTrace = NULL;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\nfunction isNil(p) {\n    return p == NULL;\n}\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  nodeFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("const [asfdasdf, ...qwerqwer] = process.argv;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("globalArgs = qwerqwer;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("globalArgsCount = qwerqwer.length;" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "start();\n" );

if (globalTrace)
    {printf("Leaving nodeCompile\n");}

}


//Building function javaFunctionArgs from line: 3

function javaFunctionArgs(tree ) {
  
if (globalTrace)
    {printf("javaFunctionArgs at java.qon:3\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(javaTypeMap(first(tree )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(second(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("," );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    {printf("Leaving javaFunctionArgs\n");}

}


//Building function javaLeaf from line: 13

function javaLeaf(thisNode ,indent ) {
  
if (globalTrace)
    {printf("javaLeaf at java.qon:13\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  display(javaFuncMap(codeof(thisNode )));

if (globalTrace)
    {printf("Leaving javaLeaf\n");}

}


//Building function javaStructGetterExpression from line: 16

function javaStructGetterExpression(thisNode ,indent ) {
  
if (globalTrace)
    {printf("javaStructGetterExpression at java.qon:16\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaLeaf(thisNode , indent );

  };

if (globalTrace)
    {printf("Leaving javaStructGetterExpression\n");}

}


//Building function javaExpression from line: 22

function javaExpression(node ,indent ) {
  
if (globalTrace)
    {printf("javaExpression at java.qon:22\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isLeaf(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(javaFuncMap(codeof(node )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaSubExpression(node , indent );

  };

if (globalTrace)
    {printf("Leaving javaExpression\n");}

}


//Building function javaRecurList from line: 28

function javaRecurList(expr ,indent ) {
  
if (globalTrace)
    {printf("javaRecurList at java.qon:28\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(expr )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaExpression(car(expr ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf(", " );
      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      javaRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    {printf("Leaving javaRecurList\n");}

}


//Building function javaSubExpression from line: 40

function javaSubExpression(tree ,indent ) {
  var thing = NULL ;

if (globalTrace)
    {printf("javaSubExpression at java.qon:40\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      javaSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( isLeaf(tree )) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        display(javaFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("" );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("()" );

          };

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("new %s()" , stringify(codeof(third(childrenof(tree )))));

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("%s(" , stringify(javaFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              javaRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving javaSubExpression\n");}

}


//Building function javaIf from line: 80

function javaIf(node ,indent ) {
  
if (globalTrace)
    {printf("javaIf at java.qon:80\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("if ( " );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(") {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("} else {" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("}" );

if (globalTrace)
    {printf("Leaving javaIf\n");}

}


//Building function javaSetStruct from line: 93

function javaSetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("javaSetStruct at java.qon:93\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaExpression(childrenof(node ), indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";" );

if (globalTrace)
    {printf("Leaving javaSetStruct\n");}

}


//Building function javaGetStruct from line: 104

function javaGetStruct(node ,indent ) {
  
if (globalTrace)
    {printf("javaGetStruct at java.qon:104\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    {printf("Leaving javaGetStruct\n");}

}


//Building function javaSet from line: 112

function javaSet(node ,indent ) {
  
if (globalTrace)
    {printf("javaSet at java.qon:112\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaExpression(childrenof(node ), indent );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf(";" );

if (globalTrace)
    {printf("Leaving javaSet\n");}

}


//Building function javaStatement from line: 120

function javaStatement(node ,indent ) {
  
if (globalTrace)
    {printf("javaStatement at java.qon:120\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaSet(node , indent );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      javaSetStruct(node , indent );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        javaIf(node , indent );

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("return;" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          newLine(indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          javaExpression(childrenof(node ), indent );
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf(";" );

        };

      };

    };

  };

if (globalTrace)
    {printf("Leaving javaStatement\n");}

}


//Building function javaBody from line: 140

function javaBody(tree ,indent ) {
  
if (globalTrace)
    {printf("javaBody at java.qon:140\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaStatement(car(tree ), indent );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaBody(cdr(tree ), indent );

  };

if (globalTrace)
    {printf("Leaving javaBody\n");}

}


//Building function javaDeclarations from line: 150

function javaDeclarations(decls ,indent ) {
  var decl = NULL ;

if (globalTrace)
    {printf("javaDeclarations at java.qon:150\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(decls )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    decl = car(decls );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s = " , stringify(javaTypeMap(first(decl ))), stringify(second(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    display(javaFuncMap(third(decl )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(";\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    {printf("Leaving javaDeclarations\n");}

}


//Building function javaFunction from line: 164

function javaFunction(node ) {
  var name = NULL ;

if (globalTrace)
    {printf("javaFunction at java.qon:164\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  name = subnameof(node );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  newLine(0 );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isNil(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(0 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("public %s %s(" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf(") {" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    newLine(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {
    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaBody(childrenof(node ), 1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( equalString("void" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))))) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("\nif (globalTrace)\n   System.out. printf(\"Leaving %s\\n\");\n" , stringify(name ));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        printf("" );

      };

    };
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n}\n" );

  };

if (globalTrace)
    {printf("Leaving javaFunction\n");}

}


//Building function javaFunctions from line: 203

function javaFunctions(tree ) {
  
if (globalTrace)
    {printf("javaFunctions at java.qon:203\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(tree )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaFunction(car(tree ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaFunctions(cdr(tree ));

  };

if (globalTrace)
    {printf("Leaving javaFunctions\n");}

}


//Building function javaIncludes from line: 209

function javaIncludes(nodes ) {
  
if (globalTrace)
    {printf("javaIncludes at java.qon:209\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public void panic(String s) {System.exit(1);}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public int sub(int a, int b) { return a - b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public double mult(int a, int b) { return a * b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public boolean greaterthan(int a, int b) { return a > b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public double subf(double a, double b) { return a - b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public double multf(double a, double b) { return a * b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public boolean greaterthanf(double a, double b) { return a > b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public boolean equal(int a, int b) { return a == b; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public boolean equalString(String a, String b) { return a.equals(b); }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public boolean andBool(boolean a, boolean b) { return a == b;}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public int string_length(String s) { return s.length();}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String stringConcatenate(String s1, String s2) { return s1 + s2; }\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public int strcmp(String s1, String s2) { return s1.compareTo(s2);}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String read_file(String filename) {try { return new String(Files.readAllBytes(Paths.get(filename)));} catch (Exception e) {panic(\"Could not read file\");return \"\";}}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public void write_file(String filename, String data) {try {Files.write(Paths.get(filename), data.getBytes(\"UTF-8\"));} catch (Exception e) {panic(\"Could not write file\");}}\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String sub_string(String s, int start, int length) {\nreturn s.substring(start, start+length);\n}\n\n\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String intToString(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String character(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public String getStringArray(int index, String[] arr) { return arr[index];}" );

if (globalTrace)
    {printf("Leaving javaIncludes\n");}

}


//Building function javaTypeDecl from line: 232

function javaTypeDecl(l ) {
  
if (globalTrace)
    {printf("javaTypeDecl at java.qon:232\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printIndent(1 );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    {printf("Leaving javaTypeDecl\n");}

}


//Building function javaStructComponents from line: 249

function javaStructComponents(node ) {
  
if (globalTrace)
    {printf("javaStructComponents at java.qon:249\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(node )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaTypeDecl(car(node ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaStructComponents(cdr(node ));

  };

if (globalTrace)
    {printf("Leaving javaStructComponents\n");}

}


//Building function javaStruct from line: 255

function javaStruct(node ) {
  
if (globalTrace)
    {printf("javaStruct at java.qon:255\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaStructComponents(cdr(car(node )));

if (globalTrace)
    {printf("Leaving javaStruct\n");}

}


//Building function javaTypeMap from line: 258

function javaTypeMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("javaTypeMap at java.qon:258\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  symMap = alistCons(boxSymbol("pair" ), boxSymbol("Box" ), alistCons(boxSymbol("bool" ), boxSymbol("boolean" ), alistCons(boxSymbol("box" ), boxSymbol("Box" ), alistCons(boxSymbol("list" ), boxSymbol("Box" ), alistCons(boxSymbol("Box*" ), boxSymbol("Box" ), alistCons(boxSymbol("struct" ), boxSymbol("" ), alistCons(boxSymbol("int" ), boxSymbol("Integer" ), alistCons(boxSymbol("float" ), boxSymbol("double" ), alistCons(boxSymbol("stringArray" ), boxSymbol("String[]" ), alistCons(boxSymbol("string" ), boxSymbol("String" ), NULL ))))))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving javaTypeMap\n");}

}


//Building function javaTypesNoDeclare from line: 276

function javaTypesNoDeclare() {
  var syms = NULL ;

if (globalTrace)
    {printf("javaTypesNoDeclare at java.qon:276\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  syms = cons(boxString("pair" ), cons(boxString("box" ), NULL ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(syms );

if (globalTrace)
    {printf("Leaving javaTypesNoDeclare\n");}

}


//Building function javaFuncMap from line: 285

function javaFuncMap(aSym ) {
  var symMap = NULL ;

if (globalTrace)
    {printf("javaFuncMap at java.qon:285\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    symMap = alistCons(boxSymbol("printf" ), boxSymbol("System.out.printf" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("null" ), NULL ))))))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      return(aSym );

    };

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return(aSym );

  };

if (globalTrace)
    {printf("Leaving javaFuncMap\n");}

}


//Building function javaType from line: 315

function javaType(node ) {
  
if (globalTrace)
    {printf("javaType at java.qon:315\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( equalBox(subnameof(node ), boxString("struct" ))) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\npublic class %s {\n" , stringify(first(codeof(node ))));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaStruct(cdr(codeof(node )));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n};\n" );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( inList(boxString(stringify(first(codeof(node )))), javaTypesNoDeclare ())) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("" );

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      printf("public class %s extends %s {};\n" , stringify(first(codeof(node ))), stringify(javaTypeMap(listLast(codeof(node )))));

    };

  };

if (globalTrace)
    {printf("Leaving javaType\n");}

}


//Building function javaTypes from line: 330

function javaTypes(nodes ) {
  
if (globalTrace)
    {printf("javaTypes at java.qon:330\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( isEmpty(nodes )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    return;

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaType(car(nodes ));
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    javaTypes(cdr(nodes ));

  };

if (globalTrace)
    {printf("Leaving javaTypes\n");}

}


//Building function javaCompile from line: 336

function javaCompile(filename ) {
  var programStr = "" ;
var tree = NULL ;
var program = NULL ;

if (globalTrace)
    {printf("javaCompile at java.qon:336\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "package quonverter;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "import java.nio.file.Files;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "import java.nio.file.Paths;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "import java.io.IOException;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "import java.io.UnsupportedEncodingException;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("class MyProgram {\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  programStr = read_file(filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  program = mergeIncludes(program );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public boolean globalStackTrace = false;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public boolean globalStepTrace = false;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public boolean globalTrace = false;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public String FILE = null;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public Integer LINE = 0;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public static Integer globalArgsCount = 0;\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("public static String globalArgs[];\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("\npublic boolean isNil(Box p) {\n    return p == null;\n}\n\n\n" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  javaFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("%s" , "public static void main(String args[]) {\nglobalArgs = args;\nglobalArgsCount = args.length;MyProgram mp = new MyProgram(); mp.start();\n}" );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  printf("}\n" );

if (globalTrace)
    {printf("Leaving javaCompile\n");}

}


//Building function start from line: 4

function start() {
  var runTests = false ;
var cmdLine = NULL ;
var filename = NULL ;
var runPerl = false ;
var runJava = false ;
var runAst = false ;
var runNode = false ;
var runTree = false ;

if (globalTrace)
    {printf("start at compiler.qon:4\n");}
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  cmdLine = listReverse(argList(globalArgsCount , 0 , globalArgs ));
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( greaterthan(listLength(cmdLine ), 1 )) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    filename = second(cmdLine );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    filename = boxString("compiler.qon" );

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runTests = inList(boxString("--test" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runJava = inList(boxString("--java" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runPerl = inList(boxString("--perl" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runAst = inList(boxString("--ast" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runTree = inList(boxString("--tree" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  runNode = inList(boxString("--node" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalTrace = inList(boxString("--trace" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  globalStepTrace = inList(boxString("--steptrace" ), cmdLine );
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  if ( runTests ) {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test0 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test1 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test2 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test3 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test4 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test5 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test6 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test7 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test8 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test9 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test10 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test12 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test13 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test15 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test16 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test17 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test18 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test19 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    test20 ();
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    printf("\n\nAfter all that hard work, I need a beer...\n" );
    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    beers(9 );

  } else {    if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

    if ( runTree ) {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      display(macrowalk(treeCompile(unBoxString(filename ))));

    } else {      if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

      if ( runAst ) {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        astCompile(unBoxString(filename ));

      } else {        if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

        if ( runNode ) {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          nodeCompile(unBoxString(filename ));
          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          printf("\n" );

        } else {          if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

          if ( runPerl ) {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            perlCompile(unBoxString(filename ));
            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            printf("\n" );

          } else {            if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

            if ( runJava ) {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              javaCompile(unBoxString(filename ));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("\n" );

            } else {              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              ansiCompile(unBoxString(filename ));
              if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

              printf("\n" );

            };

          };

        };

      };

    };

  };
  if (globalStepTrace) {console.log(new Error("StepTrace \n"));}

  return(0 );

if (globalTrace)
    {printf("Leaving start\n");}

}

const [asfdasdf, ...qwerqwer] = process.argv;globalArgs = qwerqwer;globalArgsCount = qwerqwer.length;start();
