package quonverter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
class MyProgram {
public void panic(String s) {System.exit(1);}
public int sub(int a, int b) { return a - b; }
public double mult(int a, int b) { return a * b; }
public boolean greaterthan(int a, int b) { return a > b; }
public double subf(double a, double b) { return a - b; }
public double multf(double a, double b) { return a * b; }
public boolean greaterthanf(double a, double b) { return a > b; }
public boolean equal(int a, int b) { return a == b; }
public boolean equalString(String a, String b) { return a.equals(b); }
public boolean andBool(boolean a, boolean b) { return a == b;}
public int string_length(String s) { return s.length();}
public String stringConcatenate(String s1, String s2) { return s1 + s2; }
public int strcmp(String s1, String s2) { return s1.compareTo(s2);}
public String read_file(String filename) {try { return new String(Files.readAllBytes(Paths.get(filename)));} catch (Exception e) {panic("Could not read file");return "";}}
public void write_file(String filename, String data) {try {Files.write(Paths.get(filename), data.getBytes("UTF-8"));} catch (Exception e) {panic("Could not write file");}}
public String sub_string(String s, int start, int length) {
return s.substring(start, start+length);
}



public String intToString(int num) { char c=(char) num;  String s=Character.toString(c); return s;}public String character(int num) { char c=(char) num;  String s=Character.toString(c); return s;}public String getStringArray(int index, String[] arr) { return arr[index];}
public class Box {
  Box lis;
  String str;
  Integer i;
  String typ;
  boolean voi;
  boolean boo;
  Integer lengt;
  Box car;
  Box cdr;
  Box tag;

};
public class Pair extends Box {};
public class list extends Box {};
public boolean globalStackTrace = false;
public boolean globalStepTrace = false;
public boolean globalTrace = false;
public String FILE = null;
public Integer LINE = 0;
public static Integer globalArgsCount = 0;
public static String globalArgs[];

public boolean isNil(Box p) {
    return p == null;
}




//Building function add from line: 19

public Integer add(Integer a ,Integer b ) {
    
  return(sub(a , sub(0 , b )));
}


//Building function addf from line: 20

public double addf(double a ,double b ) {
    
  return(subf(a , subf(0 , b )));
}


//Building function sub1 from line: 21

public Integer sub1(Integer a ) {
    
  return(sub(a , 1 ));
}


//Building function add1 from line: 22

public Integer add1(Integer a ) {
    
  return(add(a , 1 ));
}


//Building function clone from line: 24

public Box clone(Box b ) {
  Box newb = null ;
  
  newb = makeBox ();  
  newb.typ = b.typ;  
  newb.tag = b.tag;  
  newb.lis = b.lis;  
  newb.str = b.str;  
  newb.i = b.i;  
  newb.lengt = b.lengt;  
  return(newb );
}


//Building function newVoid from line: 38

public Box newVoid() {
  Box newb = null ;
  
  newb = makeBox ();  
  newb.voi = true ;  
  newb.typ = "void" ;  
  return(newb );
}


//Building function cons from line: 47

public Box cons(Box data ,Box l ) {
  Box p = null ;
  
  p = makePair ();  
  p.cdr = l ;  
  p.car = data ;  
  p.typ = "list" ;  
  return(p );
}


//Building function stackDump from line: 55

public void stackDump() {
    
  System.out.printf("" );
if (globalTrace)
   System.out. printf("Leaving stackDump\n");

}


//Building function nop from line: 60

public void nop() {
    
  System.out.printf("" );
if (globalTrace)
   System.out. printf("Leaving nop\n");

}


//Building function car from line: 63

public Box car(Box l ) {
    
  assertType("list" , l , 65 , "base.qon" );  
  if ( isNil(l )) {    
    System.out.printf("Cannot call car on empty list!\n" );    
    panic("Cannot call car on empty list!\n" );    
    return(null );
  } else {    
    if ( isNil(l.car)) {      
      return(null );
    } else {      
      return(l.car);
    }
  }
}


//Building function cdr from line: 76

public Box cdr(Box l ) {
    
  assertType("list" , l , 78 , "base.qon" );  
  if ( isEmpty(l )) {    
    System.out.printf("Attempt to cdr an empty list!!!!\n" );    
    panic("Attempt to cdr an empty list!!!!\n" );    
    return(null );
  } else {    
    return(l.cdr);
  }
}


//Building function isList from line: 86

public boolean isList(Box b ) {
    
  if ( isNil(b )) {    
    return(true );
  } else {    
    return(equalString("list" , b.typ));
  }
}


//Building function emptyList from line: 93

public Box emptyList() {
    
  return(null );
}


//Building function isEmpty from line: 95

public boolean isEmpty(Box b ) {
    
  if ( isNil(b )) {    
    return(true );
  } else {    
    return(false );
  }
}


//Building function listLength from line: 101

public Integer listLength(Box l ) {
    
  if ( isEmpty(l )) {    
    return(0 );
  } else {    
    return(add1(listLength(cdr(l ))));
  }
}


//Building function alistCons from line: 110

public Box alistCons(Box key ,Box value ,Box alist ) {
    
  return(cons(cons(key , value ), alist ));
}


//Building function assoc from line: 113

public Box assoc(String searchTerm ,Box l ) {
  Box elem = null ;
  
  assertType("list" , l , 115 , "base.qon" );  
  if ( isEmpty(l )) {    
    return(boxBool(false ));
  } else {    
    elem = car(l );    
    assertType("list" , elem , 121 , "base.qon" );    
    if ( isEmpty(elem )) {      
      return(assoc(searchTerm , cdr(l )));
    } else {      
      if ( false ) {        
        System.out.printf("Comparing %s and %s\n" , searchTerm , stringify(car(elem )));
      } else {        
        System.out.printf("" );
      }      
      if ( equalString(searchTerm , stringify(car(elem )))) {        
        return(elem );
      } else {        
        return(assoc(searchTerm , cdr(l )));
      }
    }
  }
}


//Building function equalBox from line: 132

public boolean equalBox(Box a ,Box b ) {
    
  if ( isList(b )) {    
    return(false );
  } else {    
    if ( equalString("string" , boxType(a ))) {      
      return(equalString(unBoxString(a ), stringify(b )));
    } else {      
      if ( equalString("bool" , boxType(a ))) {        
        return(andBool(unBoxBool(a ), unBoxBool(b )));
      } else {        
        if ( equalString("symbol" , boxType(a ))) {          
          if ( equalString("symbol" , boxType(b ))) {            
            return(equalString(unBoxSymbol(a ), unBoxSymbol(b )));
          } else {            
            return(false );
          }
        } else {          
          if ( equalString("int" , boxType(a ))) {            
            return(equal(unBoxInt(a ), unBoxInt(b )));
          } else {            
            return(false );
          }
        }
      }
    }
  }
}


//Building function displayList from line: 153

public void displayList(Box l ,Integer indent ) {
  Box val = null ;
  
  if ( isEmpty(l )) {    
    return;
  } else {    
    if ( isList(l )) {      
      if ( isEmpty(l )) {        
        return;
      } else {        
        val = car(l );        
        if ( isList(val )) {          
          newLine(indent );          
          System.out.printf("%s" , openBrace ());          
          displayList(car(l ), add1(indent ));          
          System.out.printf("%s" , closeBrace ());          
          displayList(cdr(l ), add1(indent ));
        } else {          
          if ( equalString("string" , val.typ)) {            
            System.out.printf("\"%s\" " , unBoxString(val ));
          } else {            
            System.out.printf("%s " , stringify(val ));
          }          
          displayList(cdr(l ), indent );
        }
      }
    } else {      
      if ( equalString("string" , l.typ)) {        
        System.out.printf("\"%s\" " , unBoxString(l ));
      } else {        
        System.out.printf("%s " , stringify(l ));
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving displayList\n");

}


//Building function display from line: 183

public void display(Box l ) {
    
  if ( isEmpty(l )) {    
    System.out.printf("nil " );    
    return;
  } else {    
    if ( isList(l )) {      
      System.out.printf("[" );      
      displayList(l , 0 );      
      System.out.printf("]" );
    } else {      
      displayList(l , 0 );
    }
  }
if (globalTrace)
   System.out. printf("Leaving display\n");

}


//Building function boxType from line: 197

public String boxType(Box b ) {
    
  return(b.typ);
}


//Building function makeBox from line: 198

public Box makeBox() {
  Box b = null ;
  
  b = new Box();  
  b.tag = null ;  
  b.car = null ;  
  b.cdr = null ;  
  b.lis = null ;  
  b.typ = "None - error!" ;  
  return(b );
}


//Building function makePair from line: 209

public Box makePair() {
    
  return(makeBox ());
}


//Building function boxString from line: 215

public Box boxString(String s ) {
  Box b = null ;
  
  b = makeBox ();  
  b.str = s ;  
  b.lengt = string_length(s );  
  b.typ = "string" ;  
  return(b );
}


//Building function boxSymbol from line: 225

public Box boxSymbol(String s ) {
  Box b = null ;
  
  b = boxString(s );  
  b.typ = "symbol" ;  
  return(b );
}


//Building function boxBool from line: 234

public Box boxBool(boolean boo ) {
  Box b = null ;
  
  b = makeBox ();  
  b.boo = boo ;  
  b.typ = "bool" ;  
  return(b );
}


//Building function boxInt from line: 243

public Box boxInt(Integer val ) {
  Box b = null ;
  
  b = makeBox ();  
  b.i = val ;  
  b.typ = "int" ;  
  return(b );
}


//Building function assertType from line: 252

public void assertType(String atype ,Box abox ,Integer line ,String file ) {
    
  if ( isNil(abox )) {    
    if ( equalString(atype , "nil" )) {      
      return;
    } else {      
      return;
    }
  } else {    
    if ( equalString(atype , boxType(abox ))) {      
      return;
    } else {      
      System.out.printf("Assertion failure at line %d, in file %s: provided value is not a '%s'!  It was actually (%s):" , line , file , atype , abox->typ );      
      display(abox );      
      panic("Invalid type!" );
    }
  }
}


//Building function unBoxString from line: 264

public String unBoxString(Box b ) {
    
  assertType("string" , b , 265 , "base.qon" );  
  return(b.str);
}


//Building function unBoxSymbol from line: 267

public String unBoxSymbol(Box b ) {
    
  return(b.str);
}


//Building function unBoxBool from line: 268

public boolean unBoxBool(Box b ) {
    
  return(b.boo);
}


//Building function unBoxInt from line: 269

public Integer unBoxInt(Box b ) {
    
  return(b.i);
}


//Building function stringify from line: 271

public String stringify(Box b ) {
    
  if ( isNil(b )) {    
    return("nil" );
  } else {    
    if ( equalString("string" , boxType(b ))) {      
      return(unBoxString(b ));
    } else {      
      if ( equalString("bool" , boxType(b ))) {        
        if ( unBoxBool(b )) {          
          return("true" );
        } else {          
          return("false" );
        }
      } else {        
        if ( equalString("int" , boxType(b ))) {          
          return(intToString(unBoxInt(b )));
        } else {          
          if ( equalString("symbol" , boxType(b ))) {            
            return(unBoxSymbol(b ));
          } else {            
            return(boxType(b ));
          }
        }
      }
    }
  }
}


//Building function hasTag from line: 293

public boolean hasTag(Box aBox ,Box key ) {
    
  if ( isNil(aBox )) {    
    return(false );
  } else {    
    return(isNotFalse(assoc(stringify(key ), aBox.tag)));
  }
}


//Building function getTag from line: 299

public Box getTag(Box aBox ,Box key ) {
    
  if ( false ) {    
    System.out.printf("Getting %s from: " , stringify(key ));    
    display(alistKeys(aBox.tag));    
    System.out.printf("\n" );
  } else {    
    System.out.printf("" );
  }  
  return(cdr(assoc(stringify(key ), aBox.tag)));
}


//Building function getTagFail from line: 311

public Box getTagFail(Box aBox ,Box key ,Box onFail ) {
    
  if ( hasTag(aBox , key )) {    
    return(getTag(aBox , key ));
  } else {    
    return(onFail );
  }
}


//Building function assocExists from line: 317

public boolean assocExists(String key ,Box aBox ) {
    
  if ( isNil(aBox )) {    
    return(false );
  } else {    
    return(isNotFalse(assoc(key , aBox )));
  }
}


//Building function assocFail from line: 325

public Box assocFail(String key ,Box aBox ,Box onFail ) {
    
  if ( assocExists(key , aBox )) {    
    return(assoc(key , aBox ));
  } else {    
    return(cons(boxString(key ), onFail ));
  }
}


//Building function setTag from line: 333

public Box setTag(Box key ,Box val ,Box aStruct ) {
    
  aStruct.tag = alistCons(key , val , aStruct.tag);  
  return(aStruct );
}


//Building function filterVoid from line: 343

public Box filterVoid(Box l ) {
  Box token = null ;
  
  if ( isEmpty(l )) {    
    return(emptyList ());
  } else {    
    token = car(l );    
    if ( equalString("void" , token.typ)) {      
      return(filterVoid(cdr(l )));
    } else {      
      return(cons(token , filterVoid(cdr(l ))));
    }
  }
}


//Building function filterTokens from line: 355

public Box filterTokens(Box l ) {
  Box token = null ;
  
  if ( isEmpty(l )) {    
    return(emptyList ());
  } else {    
    token = car(l );    
    if ( equalString(boxType(token ), "symbol" )) {      
      if ( equalString("__LINE__" , stringify(token ))) {        
        return(cons(getTagFail(token , boxString("line" ), boxInt(-1 )), filterTokens(cdr(l ))));
      } else {        
        if ( equalString("__COLUMN__" , stringify(token ))) {          
          return(cons(getTagFail(token , boxString("column" ), boxInt(-1 )), filterTokens(cdr(l ))));
        } else {          
          if ( equalString("__FILE__" , stringify(token ))) {            
            return(cons(getTagFail(token , boxString("filename" ), boxString("Unknown file" )), filterTokens(cdr(l ))));
          } else {            
            return(cons(token , filterTokens(cdr(l ))));
          }
        }
      }
    } else {      
      return(cons(token , filterTokens(cdr(l ))));
    }
  }
}


//Building function finish_token from line: 389

public Box finish_token(String prog ,Integer start ,Integer len ,Integer line ,Integer column ,String filename ) {
  Box token = null ;
  
  if ( greaterthan(len , 0 )) {    
    token = boxSymbol(sub_string(prog , start , len ));    
    token.tag = alistCons(boxString("filename" ), boxString(filename ), alistCons(boxString("column" ), boxInt(column ), alistCons(boxString("line" ), boxInt(line ), alistCons(boxString("totalCharPos" ), boxInt(start ), null ))));    
    return(token );
  } else {    
    return(newVoid ());
  }
}


//Building function readString from line: 404

public String readString(String prog ,Integer start ,Integer len ) {
  String token = "" ;
  
  token = sub_string(prog , sub1(add(start , len )), 1 );  
  if ( equalString("\"" , token )) {    
    return(sub_string(prog , start , sub1(len )));
  } else {    
    if ( equalString("\\" , token )) {      
      return(readString(prog , start , add(2 , len )));
    } else {      
      return(readString(prog , start , add1(len )));
    }
  }
}


//Building function readComment from line: 415

public String readComment(String prog ,Integer start ,Integer len ) {
  String token = "" ;
  
  token = sub_string(prog , sub1(add(start , len )), 1 );  
  if ( isLineBreak(token )) {    
    return(sub_string(prog , start , sub1(len )));
  } else {    
    return(readComment(prog , start , add1(len )));
  }
}


//Building function isWhiteSpace from line: 423

public boolean isWhiteSpace(String s ) {
    
  if ( equalString(" " , s )) {    
    return(true );
  } else {    
    if ( equalString("\t" , s )) {      
      return(true );
    } else {      
      if ( equalString("\n" , s )) {        
        return(true );
      } else {        
        if ( equalString("\r" , s )) {          
          return(true );
        } else {          
          return(false );
        }
      }
    }
  }
}


//Building function isLineBreak from line: 440

public boolean isLineBreak(String s ) {
    
  if ( equalString("\n" , s )) {    
    return(true );
  } else {    
    if ( equalString("\r" , s )) {      
      return(true );
    } else {      
      return(false );
    }
  }
}


//Building function incForNewLine from line: 447

public Integer incForNewLine(Box token ,Integer val ) {
    
  if ( equalString("\n" , stringify(token ))) {    
    return(add1(val ));
  } else {    
    return(val );
  }
}


//Building function annotateReadPosition from line: 454

public Box annotateReadPosition(String filename ,Integer linecount ,Integer column ,Integer start ,Box newBox ) {
    
  return(setTag(boxString("filename" ), boxString(filename ), setTag(boxString("column" ), boxInt(column ), setTag(boxString("line" ), boxInt(linecount ), setTag(boxString("totalCharPos" ), boxInt(start ), newBox )))));
}


//Building function scan from line: 466

public Box scan(String prog ,Integer start ,Integer len ,Integer linecount ,Integer column ,String filename ) {
  Box token = null ;
String newString = "" ;
Box newBox = null ;
  
  if ( false ) {    
    System.out.printf("Scanning: line %d:%d\n" , linecount , column );
  } else {    
    System.out.printf("" );
  }  
  if ( greaterthan(string_length(prog ), sub(start , sub(0 , len )))) {    
    token = boxSymbol(sub_string(prog , sub1(add(start , len )), 1 ));    
    token.tag = alistCons(boxString("totalCharPos" ), boxInt(start ), null );    
    if ( isOpenBrace(token )) {      
      return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(boxSymbol(openBrace ()), scan(prog , add1(start ), 1 , linecount , add1(column ), filename ))));
    } else {      
      if ( isCloseBrace(token )) {        
        return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(annotateReadPosition(filename , linecount , column , start , boxSymbol(closeBrace ())), scan(prog , add(start , len ), 1 , linecount , add1(column ), filename ))));
      } else {        
        if ( isWhiteSpace(stringify(token ))) {          
          return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), scan(prog , add(start , len ), 1 , incForNewLine(token , linecount ), 0 , filename )));
        } else {          
          if ( equalBox(boxSymbol(";" ), token )) {            
            return(scan(prog , add(start , add1(add1(string_length(readComment(prog , add1(start ), len ))))), 1 , add1(linecount ), 0 , filename ));
          } else {            
            if ( equalBox(boxSymbol("\"" ), token )) {              
              newString = readString(prog , add1(start ), len );              
              newBox = annotateReadPosition(filename , linecount , column , start , boxString(newString ));              
              return(cons(newBox , scan(prog , add(start , add1(add1(string_length(newString )))), 1 , linecount , add1(column ), filename )));
            } else {              
              return(scan(prog , start , sub(len , -1 ), linecount , add1(column ), filename ));
            }
          }
        }
      }
    }
  } else {    
    return(emptyList ());
  }
}


//Building function isOpenBrace from line: 506

public boolean isOpenBrace(Box b ) {
    
  if ( equalBox(boxSymbol(openBrace ()), b )) {    
    return(true );
  } else {    
    if ( equalBox(boxSymbol("[" ), b )) {      
      return(true );
    } else {      
      return(false );
    }
  }
}


//Building function openBrace from line: 514

public String openBrace() {
    
  return("(" );
}


//Building function isCloseBrace from line: 516

public boolean isCloseBrace(Box b ) {
    
  if ( equalBox(boxSymbol(closeBrace ()), b )) {    
    return(true );
  } else {    
    if ( equalBox(boxSymbol("]" ), b )) {      
      return(true );
    } else {      
      return(false );
    }
  }
}


//Building function closeBrace from line: 526

public String closeBrace() {
    
  return(")" );
}


//Building function sexprTree from line: 528

public Box sexprTree(Box l ) {
  Box b = null ;
  
  if ( isEmpty(l )) {    
    return(emptyList ());
  } else {    
    b = car(l );    
    if ( isOpenBrace(b )) {      
      return(cons(sexprTree(cdr(l )), sexprTree(skipList(cdr(l )))));
    } else {      
      if ( isCloseBrace(b )) {        
        return(emptyList ());
      } else {        
        return(setTag(boxString("line" ), getTagFail(b , boxString("line" ), boxInt(-1 )), cons(b , sexprTree(cdr(l )))));
      }
    }
  }
}


//Building function skipList from line: 547

public Box skipList(Box l ) {
  Box b = null ;
  
  if ( isEmpty(l )) {    
    return(emptyList ());
  } else {    
    b = car(l );    
    if ( isOpenBrace(b )) {      
      return(skipList(skipList(cdr(l ))));
    } else {      
      if ( isCloseBrace(b )) {        
        return(cdr(l ));
      } else {        
        return(skipList(cdr(l )));
      }
    }
  }
}


//Building function readSexpr from line: 562

public Box readSexpr(String aStr ,String filename ) {
  Box tokens = null ;
Box as = null ;
  
  tokens = emptyList ();  
  tokens = filterTokens(filterVoid(scan(aStr , 0 , 1 , 0 , 0 , filename )));  
  as = sexprTree(tokens );  
  return(car(as ));
}


//Building function caar from line: 572

public Box caar(Box l ) {
    
  return(car(car(l )));
}


//Building function cadr from line: 573

public Box cadr(Box l ) {
    
  return(car(cdr(l )));
}


//Building function caddr from line: 574

public Box caddr(Box l ) {
    
  return(car(cdr(cdr(l ))));
}


//Building function cadddr from line: 575

public Box cadddr(Box l ) {
    
  return(car(cdr(cdr(cdr(l )))));
}


//Building function caddddr from line: 576

public Box caddddr(Box l ) {
    
  return(car(cdr(cdr(cdr(cdr(l ))))));
}


//Building function cddr from line: 577

public Box cddr(Box l ) {
    
  return(cdr(cdr(l )));
}


//Building function first from line: 578

public Box first(Box l ) {
    
  return(car(l ));
}


//Building function second from line: 579

public Box second(Box l ) {
    
  return(cadr(l ));
}


//Building function third from line: 580

public Box third(Box l ) {
    
  return(caddr(l ));
}


//Building function fourth from line: 581

public Box fourth(Box l ) {
    
  return(cadddr(l ));
}


//Building function fifth from line: 582

public Box fifth(Box l ) {
    
  return(caddddr(l ));
}


//Building function makeNode from line: 588

public Box makeNode(String name ,String subname ,Box code ,Box children ) {
    
  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ())))))));
}


//Building function addToNode from line: 604

public Box addToNode(Box key ,Box val ,Box node ) {
    
  return(cons(boxSymbol("node" ), alistCons(key , val , cdr(node ))));
}


//Building function makeStatementNode from line: 609

public Box makeStatementNode(String name ,String subname ,Box code ,Box children ,Box functionName ) {
    
  return(addToNode(boxSymbol("functionName" ), functionName , makeNode(name , subname , code , children )));
}


//Building function astExpression from line: 614

public Box astExpression(Box tree ) {
    
  if ( isList(tree )) {    
    return(makeNode("expression" , "expression" , null , astSubExpression(tree )));
  } else {    
    return(astSubExpression(tree ));
  }
}


//Building function astSubExpression from line: 622

public Box astSubExpression(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());
  } else {    
    if ( isList(tree )) {      
      return(cons(astExpression(car(tree )), astSubExpression(cdr(tree ))));
    } else {      
      return(makeNode("expression" , "leaf" , tree , null ));
    }
  }
}


//Building function astIf from line: 633

public Box astIf(Box tree ,Box fname ) {
    
  if ( equalBox(boxString("then" ), car(second(tree )))) {    
    nop ();
  } else {    
    System.out.printf("Error at %s:%s!  If statement is missing the true branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));    
    panic("Missing true branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );
  }  
  if ( equalBox(boxString("else" ), car(third(tree )))) {    
    nop ();
  } else {    
    System.out.printf("Error at %s:%s!  If statement is missing the false branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));    
    panic("Missing false branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );
  }  
  return(makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), null ), cons(astBody(cdr(second(tree )), fname ), cons(astBody(cdr(third(tree )), fname ), null )))));
}


//Building function astSetStruct from line: 654

public Box astSetStruct(Box tree ) {
    
  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));
}


//Building function astSet from line: 659

public Box astSet(Box tree ) {
    
  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));
}


//Building function astGetStruct from line: 664

public Box astGetStruct(Box tree ) {
    
  return(makeNode("expression" , "structGetter" , tree , null ));
}


//Building function astReturnVoid from line: 667

public Box astReturnVoid(Box fname ) {
    
  return(makeStatementNode("statement" , "returnvoid" , null , null , fname ));
}


//Building function astStatement from line: 671

public Box astStatement(Box tree ,Box fname ) {
    
  if ( equalBox(boxString("if" ), car(tree ))) {    
    return(astIf(cdr(tree ), fname ));
  } else {    
    if ( equalBox(boxString("set" ), car(tree ))) {      
      return(astSet(cdr(tree )));
    } else {      
      if ( equalBox(boxString("get-struct" ), car(tree ))) {        
        System.out.printf("Choosing get-struct statement\n" );        
        return(astGetStruct(cdr(tree )));
      } else {        
        if ( equalBox(boxString("set-struct" ), car(tree ))) {          
          return(astSetStruct(cdr(tree )));
        } else {          
          if ( equalBox(boxString("return" ), car(tree ))) {            
            if ( equal(listLength(tree ), 1 )) {              
              return(astReturnVoid(fname ));
            } else {              
              return(makeStatementNode("statement" , "return" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));
            }
          } else {            
            return(makeStatementNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));
          }
        }
      }
    }
  }
}


//Building function astBody from line: 701

public Box astBody(Box tree ,Box fname ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());
  } else {    
    return(cons(astStatement(car(tree ), fname ), astBody(cdr(tree ), fname )));
  }
}


//Building function astFunction from line: 707

public Box astFunction(Box tree ) {
  Box fname = null ;
  
  fname = second(tree );  
  return(alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )), fname )), emptyList ()))))))));
}


//Building function astFunctionList from line: 730

public Box astFunctionList(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());
  } else {    
    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));
  }
}


//Building function astFunctions from line: 738

public Box astFunctions(Box tree ) {
    
  if ( equalBox(boxString("functions" ), car(tree ))) {    
    return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));
  } else {    
    panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );    
    return(null );
  }
}


//Building function loadLib from line: 746

public Box loadLib(String path ) {
  String programStr = "" ;
Box tree = null ;
Box library = null ;
  
  programStr = read_file(path );  
  tree = readSexpr(programStr , path );  
  tree = treewalk(tree );  
  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  return(library );
}


//Building function astInclude from line: 762

public Box astInclude(Box tree ) {
    
  return(loadLib(stringify(tree )));
}


//Building function astIncludeList from line: 765

public Box astIncludeList(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());
  } else {    
    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));
  }
}


//Building function astIncludes from line: 772

public Box astIncludes(Box tree ) {
    
  if ( equalBox(boxString("includes" ), car(tree ))) {    
    return(makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree ))));
  } else {    
    panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );    
    return(null );
  }
}


//Building function astStruct from line: 780

public Box astStruct(Box tree ) {
    
  return(makeNode("type" , "struct" , tree , null ));
}


//Building function astType from line: 783

public Box astType(Box tree ) {
    
  if ( isList(cadr(tree ))) {    
    return(astStruct(tree ));
  } else {    
    return(makeNode("type" , "type" , tree , null ));
  }
}


//Building function astTypeList from line: 789

public Box astTypeList(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());
  } else {    
    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));
  }
}


//Building function astTypes from line: 795

public Box astTypes(Box tree ) {
    
  if ( equalBox(boxString("types" ), car(tree ))) {    
    return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));
  } else {    
    panic("Types section not found!  Every program must have a types section, even if you don't define any types" );    
    return(boxString("Fuck java" ));
  }
}


//Building function declarationsof from line: 805

public Box declarationsof(Box ass ) {
    
  return(cdr(assoc("declarations" , cdr(ass ))));
}


//Building function codeof from line: 808

public Box codeof(Box ass ) {
    
  return(cdr(assoc("code" , cdr(ass ))));
}


//Building function functionNameof from line: 811

public Box functionNameof(Box ass ) {
    
  return(cdr(assoc("functionName" , cdr(ass ))));
}


//Building function nodeof from line: 815

public Box nodeof(Box ass ) {
    
  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    
    return(boxBool(false ));
  } else {    
    return(cdr(assoc("node" , cdr(ass ))));
  }
}


//Building function lineof from line: 823

public Box lineof(Box ass ) {
    
  if ( equalBox(boxBool(false ), assoc("line" , cdr(ass )))) {    
    return(boxInt(-1 ));
  } else {    
    return(cdr(assoc("line" , cdr(ass ))));
  }
}


//Building function subnameof from line: 831

public Box subnameof(Box ass ) {
    
  return(cdr(assoc("subname" , cdr(ass ))));
}


//Building function nameof from line: 836

public Box nameof(Box ass ) {
    
  return(cdr(assoc("name" , cdr(ass ))));
}


//Building function childrenof from line: 841

public Box childrenof(Box ass ) {
    
  return(cdr(assoc("children" , cdr(ass ))));
}


//Building function isNode from line: 845

public boolean isNode(Box val ) {
    
  if ( isEmpty(val )) {    
    return(false );
  } else {    
    if ( isList(val )) {      
      if ( equalBox(boxSymbol("node" ), car(val ))) {        
        return(true );
      } else {        
        return(false );
      }
    } else {      
      return(false );
    }
  }
}


//Building function truthy from line: 859

public boolean truthy(Box aVal ) {
    
  return(isNotFalse(aVal ));
}


//Building function isNotFalse from line: 863

public boolean isNotFalse(Box aVal ) {
    
  if ( equalString(boxType(aVal ), "bool" )) {    
    if ( unBoxBool(aVal )) {      
      return(true );
    } else {      
      return(false );
    }
  } else {    
    return(true );
  }
}


//Building function isLeaf from line: 870

public boolean isLeaf(Box n ) {
    
  return(equalBox(boxString("leaf" ), subnameof(n )));
}


//Building function printIndent from line: 875

public void printIndent(Integer ii ) {
    
  if ( greaterthan(ii , 0 )) {    
    System.out.printf("  " );    
    printIndent(sub1(ii ));
  } else {    
    return;
  }
if (globalTrace)
   System.out. printf("Leaving printIndent\n");

}


//Building function newLine from line: 883

public void newLine(Integer indent ) {
    
  System.out.printf("\n" );  
  printIndent(indent );
if (globalTrace)
   System.out. printf("Leaving newLine\n");

}


//Building function noStackTrace from line: 887

public Box noStackTrace() {
    
  return(cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), null ))))))))))))))))))))))))));
}


//Building function toStr from line: 916

public Box toStr(Box thing ) {
    
  return(boxString(stringify(thing )));
}


//Building function listLast from line: 919

public Box listLast(Box alist ) {
    
  if ( isEmpty(cdr(alist ))) {    
    return(car(alist ));
  } else {    
    return(listLast(cdr(alist )));
  }
}


//Building function treeCompile from line: 926

public Box treeCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  programStr = read_file(filename );  
  tree = readSexpr(programStr , filename );  
  return(tree );
}


//Building function astBuild from line: 932

public Box astBuild(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  programStr = read_file(filename );  
  tree = readSexpr(programStr , filename );  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  program = mergeIncludes(program );  
  return(program );
}


//Building function astCompile from line: 949

public void astCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  program = astBuild(filename );  
  display(program );  
  System.out.printf("\n" );
if (globalTrace)
   System.out. printf("Leaving astCompile\n");

}


//Building function concatLists from line: 956

public Box concatLists(Box seq1 ,Box seq2 ) {
    
  if ( isNil(seq1 )) {    
    return(seq2 );
  } else {    
    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));
  }
}


//Building function alistKeys from line: 962

public Box alistKeys(Box alist ) {
    
  if ( isNil(alist )) {    
    return(null );
  } else {    
    return(cons(car(car(alist )), alistKeys(cdr(alist ))));
  }
}


//Building function mergeIncludes from line: 968

public Box mergeIncludes(Box program ) {
    
  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program ));
}


//Building function merge_recur from line: 975

public Box merge_recur(Box incs ,Box program ) {
    
  if ( greaterthan(listLength(incs ), 0 )) {    
    return(mergeInclude(car(incs ), merge_recur(cdr(incs ), program )));
  } else {    
    return(program );
  }
}


//Building function mergeInclude from line: 983

public Box mergeInclude(Box inc ,Box program ) {
  Box newProgram = null ;
Box oldfunctionsnode = null ;
Box oldfunctions = null ;
Box newfunctions = null ;
Box newFunctionNode = null ;
Box functions = null ;
Box oldtypesnode = null ;
Box oldtypes = null ;
Box newtypes = null ;
Box newTypeNode = null ;
Box types = null ;
  
  if ( isNil(inc )) {    
    return(program );
  } else {    
    functions = childrenof(cdr(assoc("functions" , inc )));    
    oldfunctionsnode = cdr(assoc("functions" , program ));    
    oldfunctions = childrenof(oldfunctionsnode );    
    newfunctions = concatLists(functions , oldfunctions );    
    newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newfunctions , cdr(oldfunctionsnode )));    
    types = childrenof(cdr(assoc("types" , inc )));    
    oldtypesnode = cdr(assoc("types" , program ));    
    oldtypes = childrenof(oldtypesnode );    
    newtypes = concatLists(types , oldtypes );    
    newTypeNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newtypes , cdr(oldtypesnode )));    
    newProgram = alistCons(boxString("functions" ), newFunctionNode , alistCons(boxString("types" ), newTypeNode , alistCons(boxString("includes" ), cons(boxSymbol("includes" ), null ), newProgram )));    
    return(newProgram );
  }
}


//Building function argList from line: 1039

public Box argList(Integer count ,Integer pos ,String[] args ) {
    
  if ( greaterthan(count , pos )) {    
    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));
  } else {    
    return(null );
  }
}


//Building function listReverse from line: 1051

public Box listReverse(Box l ) {
    
  if ( isNil(l )) {    
    return(null );
  } else {    
    return(cons(car(l ), listReverse(cdr(l ))));
  }
}


//Building function inList from line: 1057

public boolean inList(Box item ,Box l ) {
    
  if ( isNil(l )) {    
    return(false );
  } else {    
    if ( equalBox(car(l ), item )) {      
      return(true );
    } else {      
      return(inList(item , cdr(l )));
    }
  }
}


//Building function tron from line: 1068

public void tron() {
    
  globalTrace = true ;
}


//Building function troff from line: 1069

public void troff() {
    
  globalTrace = false ;
}


//Building function stron from line: 1070

public void stron() {
    
  globalStepTrace = true ;
}


//Building function stroff from line: 1071

public void stroff() {
    
  globalStepTrace = false ;
}


//Building function numbers from line: 4

public Box numbers(Integer num ) {
    
  if ( greaterthan(0 , num )) {    
    return(cons(boxString("-" ), null ));
  } else {    
    return(cons(boxString(stringify(boxInt(num ))), numbers(sub1(num ))));
  }
}


//Building function lexType from line: 11

public String lexType(Box abox ) {
    
  if ( equalString("string" , boxType(abox ))) {    
    return("string" );
  } else {    
    if ( inList(boxString(sub_string(stringify(abox ), 0 , 1 )), numbers(9 ))) {      
      return("number" );
    } else {      
      return("symbol" );
    }
  }
}


//Building function perlLeaf from line: 23

public void perlLeaf(Box thisNode ,Integer indent ) {
    
  if ( equalString("symbol" , lexType(codeof(thisNode )))) {    
    System.out.printf("%s" , dollar ());
  } else {    
    System.out.printf("" );
  }  
  display(perlFuncMap(codeof(thisNode )));
if (globalTrace)
   System.out. printf("Leaving perlLeaf\n");

}


//Building function perlStructGetterExpression from line: 32

public void perlStructGetterExpression(Box thisNode ,Integer indent ) {
    
  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    
    perlGetStruct(thisNode , indent );
  } else {    
    perlLeaf(thisNode , indent );
  }
if (globalTrace)
   System.out. printf("Leaving perlStructGetterExpression\n");

}


//Building function perlExpression from line: 38

public void perlExpression(Box node ,Integer indent ) {
    
  if ( isLeaf(node )) {    
    perlLeaf(node , indent );
  } else {    
    perlSubExpression(node , indent );
  }
if (globalTrace)
   System.out. printf("Leaving perlExpression\n");

}


//Building function perlRecurList from line: 44

public void perlRecurList(Box expr ,Integer indent ) {
    
  if ( isEmpty(expr )) {    
    return;
  } else {    
    perlExpression(car(expr ), indent );    
    if ( isNil(cdr(expr ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf(", " );      
      perlRecurList(cdr(expr ), indent );
    }
  }
if (globalTrace)
   System.out. printf("Leaving perlRecurList\n");

}


//Building function perlSubExpression from line: 55

public void perlSubExpression(Box tree ,Integer indent ) {
  Box thing = null ;
  
  if ( isEmpty(tree )) {    
    return;
  } else {    
    if ( isNode(childrenof(tree ))) {      
      perlSubExpression(childrenof(tree ), indent );
    } else {      
      if ( isLeaf(tree )) {        
        System.out.printf("%s" , dollar ());        
        display(perlFuncMap(codeof(tree )));
      } else {        
        if ( equal(1 , listLength(childrenof(tree )))) {          
          display(codeof(car(childrenof(tree ))));          
          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            
            System.out.printf("" );
          } else {            
            System.out.printf("()" );
          }
        } else {          
          thing = codeof(car(childrenof(tree )));          
          if ( equalBox(boxSymbol("get-struct" ), thing )) {            
            System.out.printf("%s%s->{%s}" , dollar (), stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));
          } else {            
            if ( equalBox(boxSymbol("new" ), thing )) {              
              System.out.printf("{}" );
            } else {              
              System.out.printf("%s(" , stringify(perlFuncMap(codeof(car(childrenof(tree ))))));              
              perlRecurList(cdr(childrenof(tree )), indent );              
              System.out.printf(")" );
            }
          }
        }
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving perlSubExpression\n");

}


//Building function perlIf from line: 93

public void perlIf(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("if ( " );  
  perlExpression(car(first(childrenof(node ))), 0 );  
  System.out.printf(") {" );  
  perlBody(second(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("} else {" );  
  perlBody(third(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("}" );
if (globalTrace)
   System.out. printf("Leaving perlIf\n");

}


//Building function perlSetStruct from line: 106

public void perlSetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s%s->{%s} = " , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));  
  perlExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving perlSetStruct\n");

}


//Building function perlGetStruct from line: 113

public void perlGetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s%s->{%s}" , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));
if (globalTrace)
   System.out. printf("Leaving perlGetStruct\n");

}


//Building function perlSet from line: 118

public void perlSet(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s%s = " , dollar (), stringify(first(codeof(node ))));  
  perlExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving perlSet\n");

}


//Building function assertNode from line: 124

public void assertNode(Box node ) {
    
  if ( isNode(node )) {    
    return;
  } else {    
    panic("Not a node!" );
  }
if (globalTrace)
   System.out. printf("Leaving assertNode\n");

}


//Building function perlStatement from line: 131

public void perlStatement(Box node ,Integer indent ) {
  Box functionName = null ;
  
  assertNode(node );  
  if ( equalBox(boxString("setter" ), subnameof(node ))) {    
    perlSet(node , indent );
  } else {    
    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      
      perlSetStruct(node , indent );
    } else {      
      if ( equalBox(boxString("if" ), subnameof(node ))) {        
        perlIf(node , indent );
      } else {        
        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          
          functionName = functionNameof(node );          
          System.out.printf("\n#Returnvoid\n" );          
          newLine(indent );          
          newLine(indent );          
          System.out.printf("return" );
        } else {          
          if ( equalBox(boxString("return" ), subnameof(node ))) {            
            functionName = functionNameof(node );            
            if ( inList(functionName , noStackTrace ())) {              
              System.out.printf("" );
            } else {              
              System.out.printf("\n#standard return: %s\n" , stringify(functionName ));              
              newLine(indent );              
              System.out.printf("%s%s%s" , "if (" , dollar (), "globalTrace) {printf(\"Leaving \\n\")}\n" );
            }            
            newLine(indent );            
            perlExpression(childrenof(node ), indent );
          } else {            
            if ( inList(functionName , noStackTrace ())) {              
              System.out.printf("" );
            } else {              
              System.out.printf("\n#standard expression\n" );
            }            
            newLine(indent );            
            perlExpression(childrenof(node ), indent );            
            newLine(indent );
          }
        }
      }
    }
  }  
  System.out.printf(";\n" );
if (globalTrace)
   System.out. printf("Leaving perlStatement\n");

}


//Building function perlBody from line: 180

public void perlBody(Box tree ,Integer indent ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    printIndent(indent );    
    System.out.printf("%s%s%s" , "if (" , dollar (), "globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" );    
    perlStatement(car(tree ), indent );    
    perlBody(cdr(tree ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving perlBody\n");

}


//Building function perlDeclarations from line: 190

public void perlDeclarations(Box decls ,Integer indent ) {
  Box decl = null ;
  
  if ( isEmpty(decls )) {    
    return;
  } else {    
    decl = car(decls );    
    System.out.printf("my %s%s = " , dollar (), stringify(second(decl )));    
    display(perlConstMap(third(decl )));    
    System.out.printf(";\n" );    
    perlDeclarations(cdr(decls ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving perlDeclarations\n");

}


//Building function perlFunction from line: 201

public void perlFunction(Box node ) {
  Box name = null ;
  
  name = subnameof(node );  
  System.out.printf("\n\n#Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));  
  newLine(0 );  
  if ( isNil(node )) {    
    return;
  } else {    
    newLine(0 );    
    System.out.printf("sub %s" , stringify(subnameof(node )));    
    System.out.printf(" {" );    
    newLine(1 );    
    perlFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    newLine(1 );    
    perlDeclarations(declarationsof(node ), 1 );    
    System.out.printf("\nif (%sglobalTrace) { printf(\"%s at %s:%s\\n\") }\n" , dollar (), stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));    
    if ( inList(name , noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("" );
    }    
    perlBody(childrenof(node ), 1 );    
    if ( inList(name , noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("" );
    }    
    System.out.printf("\n}\n" );
  }
if (globalTrace)
   System.out. printf("Leaving perlFunction\n");

}


//Building function perlForwardDeclaration from line: 233

public void perlForwardDeclaration(Box node ) {
    
  if ( isNil(node )) {    
    return;
  } else {    
    System.out.printf("\nsub %s" , stringify(subnameof(node )));    
    System.out.printf(";" );
  }
if (globalTrace)
   System.out. printf("Leaving perlForwardDeclaration\n");

}


//Building function perlForwardDeclarations from line: 243

public void perlForwardDeclarations(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    perlForwardDeclaration(car(tree ));    
    perlForwardDeclarations(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving perlForwardDeclarations\n");

}


//Building function perlFunctions from line: 251

public void perlFunctions(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    perlFunction(car(tree ));    
    perlFunctions(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving perlFunctions\n");

}


//Building function dollar from line: 258

public String dollar() {
    
  return(character(36 ));
}


//Building function atSym from line: 261

public String atSym() {
    
  return(character(64 ));
}


//Building function perlIncludes from line: 265

public void perlIncludes(Box nodes ) {
    
  System.out.printf("%s\n" , "use strict;" );  
  System.out.printf("%s\n" , "use Carp;" );  
  dollar ();  
  System.out.printf("%s\n" , "use Carp::Always;" );  
  System.out.printf("%s%s%s%s%s\n" , "sub greaterthan { " , dollar (), "_[0] > " , dollar (), "_[1] };" );  
  System.out.printf("%s%s%s%s%s\n" , "sub mult { " , dollar (), "_[0] * " , dollar (), "_[1] };" );  
  System.out.printf("%s%s%s%s%s\n" , "sub multf { " , dollar (), "_[0] * " , dollar (), "_[1] };" );  
  System.out.printf("%s%s%s%s%s\n" , "sub greaterthanf { " , dollar (), "_[0] > " , dollar (), "_[1] };" );  
  System.out.printf("%s%s%s%s%s\n" , "sub equalString { " , dollar (), "_[0] eq " , dollar (), "_[1] };" );  
  System.out.printf("sub read_file { my %sfile = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; local %s/ = undef; my %scont = <%sfh>; close %sfh; return %scont; }; \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());  
  System.out.printf("sub write_file {my %sfile = shift; my %sdata = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; print %sfh %sdata; close %sfh; } \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());  
  System.out.printf("%s%s%s%s%s\n" , "sub stringConcatenate { " , dollar (), "_[0] . " , dollar (), "_[1]}" );  
  System.out.printf("%s%s%s%s%s\n" , "sub subtract { " , dollar (), "_[0] - " , dollar (), "_[1]}" );  
  System.out.printf("%s%s%s%s%s\n" , "sub subf { " , dollar (), "_[0] - " , dollar (), "_[1]}" );  
  System.out.printf("%s%s%s%s%s\n" , "sub andBool { " , dollar (), "_[0] && " , dollar (), "_[1]}" );  
  System.out.printf("%s%s%s%s%s\n" , "sub equal { " , dollar (), "_[0] == " , dollar (), "_[1]}" );  
  System.out.printf("%s%s%s%s%s\n" , "sub panic { carp " , atSym (), "_; die \"" , atSym (), "_\"}" );  
  System.out.printf("sub intToString { return %s_[0]}\n" , dollar ());  
  System.out.printf("sub character { return chr(%s_[0])}\n" , dollar ());  
  System.out.printf("%s%s%s%s%s%s%s%s%s\n" , "sub getStringArray { my " , dollar (), "index = shift; my " , dollar (), "arr = shift; return " , dollar (), "arr->[" , dollar (), "index]}" );
if (globalTrace)
   System.out. printf("Leaving perlIncludes\n");

}


//Building function perlTypeDecl from line: 298

public void perlTypeDecl(Box l ) {
  
if (globalTrace)
   System.out. printf("Leaving perlTypeDecl\n");

}


//Building function perlStructComponents from line: 303

public void perlStructComponents(Box node ) {
    
  if ( isEmpty(node )) {    
    return;
  } else {    
    perlTypeDecl(car(node ));    
    perlStructComponents(cdr(node ));
  }
if (globalTrace)
   System.out. printf("Leaving perlStructComponents\n");

}


//Building function perlStruct from line: 309

public void perlStruct(Box node ) {
    
  perlStructComponents(cdr(car(node )));
if (globalTrace)
   System.out. printf("Leaving perlStruct\n");

}


//Building function perlTypeMap from line: 312

public Box perlTypeMap(Box aSym ) {
  Box symMap = null ;
  
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), null ));  
  if ( truthy(assoc(stringify(aSym ), symMap ))) {    
    return(cdr(assoc(stringify(aSym ), symMap )));
  } else {    
    return(aSym );
  }
}


//Building function perlConstMap from line: 324

public Box perlConstMap(Box aSym ) {
  Box symMap = null ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("false" ), boxSymbol("0" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), null ));    
    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));
  } else {    
    return(aSym );
  }
}


//Building function perlFuncMap from line: 334

public Box perlFuncMap(Box aSym ) {
  Box symMap = null ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("substr" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), null ))))))));    
    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));
  } else {    
    return(aSym );
  }
}


//Building function perlType from line: 351

public void perlType(Box node ) {
  
if (globalTrace)
   System.out. printf("Leaving perlType\n");

}


//Building function perlTypes from line: 356

public void perlTypes(Box nodes ) {
    
  if ( isEmpty(nodes )) {    
    return;
  } else {    
    perlType(car(nodes ));    
    perlTypes(cdr(nodes ));
  }
if (globalTrace)
   System.out. printf("Leaving perlTypes\n");

}


//Building function perlFunctionArgs from line: 362

public void perlFunctionArgs(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    System.out.printf("%s%s" , "my " , dollar ());    
    display(second(tree ));    
    System.out.printf(" = shift;\n" );    
    perlFunctionArgs(cddr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving perlFunctionArgs\n");

}


//Building function perlCompile from line: 372

public void perlCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  programStr = read_file(filename );  
  tree = readSexpr(programStr , filename );  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  program = mergeIncludes(program );  
  perlIncludes(cdr(assoc("includes" , program )));  
  perlTypes(childrenof(cdr(assoc("types" , program ))));  
  System.out.printf("use strict;\n" );  
  System.out.printf("use Carp;\n" );  
  System.out.printf("use Data::Dumper;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "globalStackTrace = undef;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "globalTrace = undef;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "globalStepTrace = undef;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "globalArgs = undef;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "globalArgsCount = undef;\n" );  
  System.out.printf("%s%s%s\n" , "my " , dollar (), "true = 1;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "false = 0;\n" );  
  System.out.printf("%s%s%s" , "my " , dollar (), "undef;\n" );  
  System.out.printf("%s%s%s" , "\nsub isNil {\n    return !defined(" , dollar (), "_[0]);\n}\n\n\n#Forward declarations\n" );  
  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf("\n\n#End forward declarations\n\n" );  
  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf(";\n" );  
  System.out.printf("%s%s%s%s" , dollar (), "globalArgs = [ 1, " , atSym (), "ARGV];" );  
  System.out.printf("%s%s%s%s" , dollar (), "globalArgsCount = scalar(" , atSym (), "ARGV)+1;\n" );  
  System.out.printf("start();" );
if (globalTrace)
   System.out. printf("Leaving perlCompile\n");

}


//Building function ansiFunctionArgs from line: 3

public void ansiFunctionArgs(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    display(ansiTypeMap(first(tree )));    
    display(second(tree ));    
    if ( isNil(cddr(tree ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf("," );
    }    
    ansiFunctionArgs(cddr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiFunctionArgs\n");

}


//Building function ansiLeaf from line: 13

public void ansiLeaf(Box thisNode ,Integer indent ) {
    
  display(ansiFuncMap(codeof(thisNode )));
if (globalTrace)
   System.out. printf("Leaving ansiLeaf\n");

}


//Building function ansiStructGetterExpression from line: 16

public void ansiStructGetterExpression(Box thisNode ,Integer indent ) {
    
  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    
    ansiGetStruct(thisNode , indent );
  } else {    
    ansiLeaf(thisNode , indent );
  }
if (globalTrace)
   System.out. printf("Leaving ansiStructGetterExpression\n");

}


//Building function ansiExpression from line: 22

public void ansiExpression(Box node ,Integer indent ) {
    
  if ( isLeaf(node )) {    
    display(ansiFuncMap(codeof(node )));
  } else {    
    ansiSubExpression(node , indent );
  }
if (globalTrace)
   System.out. printf("Leaving ansiExpression\n");

}


//Building function ansiRecurList from line: 28

public void ansiRecurList(Box expr ,Integer indent ) {
    
  if ( isEmpty(expr )) {    
    return;
  } else {    
    ansiExpression(car(expr ), indent );    
    if ( isNil(cdr(expr ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf(", " );      
      ansiRecurList(cdr(expr ), indent );
    }
  }
if (globalTrace)
   System.out. printf("Leaving ansiRecurList\n");

}


//Building function ansiSubExpression from line: 40

public void ansiSubExpression(Box tree ,Integer indent ) {
  Box thing = null ;
  
  if ( isEmpty(tree )) {    
    return;
  } else {    
    if ( isNode(childrenof(tree ))) {      
      ansiSubExpression(childrenof(tree ), indent );
    } else {      
      if ( isLeaf(tree )) {        
        display(ansiFuncMap(codeof(tree )));
      } else {        
        if ( equal(1 , listLength(childrenof(tree )))) {          
          display(codeof(car(childrenof(tree ))));          
          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            
            System.out.printf("" );
          } else {            
            System.out.printf("()" );
          }
        } else {          
          thing = codeof(car(childrenof(tree )));          
          if ( equalBox(boxSymbol("get-struct" ), thing )) {            
            System.out.printf("%s->%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));
          } else {            
            if ( equalBox(boxSymbol("new" ), thing )) {              
              System.out.printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof(tree )))));
            } else {              
              System.out.printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof(tree ))))));              
              ansiRecurList(cdr(childrenof(tree )), indent );              
              System.out.printf(")" );
            }
          }
        }
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving ansiSubExpression\n");

}


//Building function ansiIf from line: 80

public void ansiIf(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("if ( " );  
  ansiExpression(car(first(childrenof(node ))), 0 );  
  System.out.printf(") {" );  
  ansiBody(second(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("} else {" );  
  ansiBody(third(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("}" );
if (globalTrace)
   System.out. printf("Leaving ansiIf\n");

}


//Building function ansiSetStruct from line: 93

public void ansiSetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));  
  ansiExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving ansiSetStruct\n");

}


//Building function ansiGetStruct from line: 102

public void ansiGetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
if (globalTrace)
   System.out. printf("Leaving ansiGetStruct\n");

}


//Building function ansiSet from line: 110

public void ansiSet(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s = " , stringify(first(codeof(node ))));  
  ansiExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving ansiSet\n");

}


//Building function ansiStatement from line: 116

public void ansiStatement(Box node ,Integer indent ) {
    
  if ( equalBox(boxString("setter" ), subnameof(node ))) {    
    ansiSet(node , indent );
  } else {    
    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      
      ansiSetStruct(node , indent );
    } else {      
      if ( equalBox(boxString("if" ), subnameof(node ))) {        
        ansiIf(node , indent );
      } else {        
        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          
          newLine(indent );          
          System.out.printf("return" );
        } else {          
          newLine(indent );          
          ansiExpression(childrenof(node ), indent );
        }
      }
    }
  }  
  System.out.printf(";\n" );
if (globalTrace)
   System.out. printf("Leaving ansiStatement\n");

}


//Building function ansiBody from line: 134

public void ansiBody(Box tree ,Integer indent ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    printIndent(indent );    
    System.out.printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" );    
    ansiStatement(car(tree ), indent );    
    ansiBody(cdr(tree ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving ansiBody\n");

}


//Building function ansiDeclarations from line: 146

public void ansiDeclarations(Box decls ,Integer indent ) {
  Box decl = null ;
  
  if ( isEmpty(decls )) {    
    return;
  } else {    
    decl = car(decls );    
    System.out.printf("%s %s = " , stringify(ansiTypeMap(first(decl ))), stringify(second(decl )));    
    display(ansiFuncMap(third(decl )));    
    System.out.printf(";\n" );    
    ansiDeclarations(cdr(decls ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving ansiDeclarations\n");

}


//Building function ansiFunction from line: 160

public void ansiFunction(Box node ) {
  Box name = null ;
  
  name = subnameof(node );  
  System.out.printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));  
  newLine(0 );  
  if ( isNil(node )) {    
    return;
  } else {    
    newLine(0 );    
    System.out.printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));    
    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    System.out.printf(") {" );    
    newLine(1 );    
    ansiDeclarations(declarationsof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("\nif (globalTrace)\n    printf(\"%s at %s:%s\\n\");\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    }    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {
    }    
    ansiBody(childrenof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify(name ));
    }    
    System.out.printf("\n}\n" );
  }
if (globalTrace)
   System.out. printf("Leaving ansiFunction\n");

}


//Building function ansiForwardDeclaration from line: 194

public void ansiForwardDeclaration(Box node ) {
    
  if ( isNil(node )) {    
    return;
  } else {    
    System.out.printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));    
    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    System.out.printf(");" );
  }
if (globalTrace)
   System.out. printf("Leaving ansiForwardDeclaration\n");

}


//Building function ansiForwardDeclarations from line: 206

public void ansiForwardDeclarations(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    ansiForwardDeclaration(car(tree ));    
    ansiForwardDeclarations(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiForwardDeclarations\n");

}


//Building function ansiFunctions from line: 214

public void ansiFunctions(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    ansiFunction(car(tree ));    
    ansiFunctions(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiFunctions\n");

}


//Building function ansiIncludes from line: 219

public void ansiIncludes(Box nodes ) {
    
  System.out.printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nvoid panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" );  
  System.out.printf("%s" , "char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }" );
if (globalTrace)
   System.out. printf("Leaving ansiIncludes\n");

}


//Building function ansiTypeDecl from line: 227

public void ansiTypeDecl(Box l ) {
    
  if ( greaterthan(listLength(l ), 2 )) {    
    printIndent(1 );    
    System.out.printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(listLast(l ))), stringify(first(l )));
  } else {    
    printIndent(1 );    
    System.out.printf("%s %s;\n" , stringify(ansiTypeMap(listLast(l ))), stringify(car(l )));
  }
if (globalTrace)
   System.out. printf("Leaving ansiTypeDecl\n");

}


//Building function ansiStructComponents from line: 244

public void ansiStructComponents(Box node ) {
    
  if ( isEmpty(node )) {    
    return;
  } else {    
    ansiTypeDecl(car(node ));    
    ansiStructComponents(cdr(node ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiStructComponents\n");

}


//Building function ansiStruct from line: 250

public void ansiStruct(Box node ) {
    
  ansiStructComponents(cdr(car(node )));
if (globalTrace)
   System.out. printf("Leaving ansiStruct\n");

}


//Building function ansiTypeMap from line: 253

public Box ansiTypeMap(Box aSym ) {
  Box symMap = null ;
  
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), null ));  
  if ( truthy(assoc(stringify(aSym ), symMap ))) {    
    return(cdr(assoc(stringify(aSym ), symMap )));
  } else {    
    return(aSym );
  }
}


//Building function ansiFuncMap from line: 265

public Box ansiFuncMap(Box aSym ) {
  Box symMap = null ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), null )))))));    
    if ( truthy(assoc(stringify(aSym ), symMap ))) {      
      return(cdr(assoc(stringify(aSym ), symMap )));
    } else {      
      return(aSym );
    }
  } else {    
    return(aSym );
  }
}


//Building function ansiType from line: 296

public void ansiType(Box node ) {
    
  if ( equalBox(subnameof(node ), boxString("struct" ))) {    
    System.out.printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));    
    ansiStruct(cdr(codeof(node )));    
    System.out.printf("\n} %s;\n" , stringify(first(codeof(node ))));
  } else {    
    System.out.printf("typedef " );    
    ansiTypeDecl(codeof(node ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiType\n");

}


//Building function ansiTypes from line: 306

public void ansiTypes(Box nodes ) {
    
  if ( isEmpty(nodes )) {    
    return;
  } else {    
    ansiType(car(nodes ));    
    ansiTypes(cdr(nodes ));
  }
if (globalTrace)
   System.out. printf("Leaving ansiTypes\n");

}


//Building function treewalk from line: 313

public Box treewalk(Box l ) {
  Box val = null ;
  
  if ( isEmpty(l )) {    
    return(null );
  } else {    
    if ( isList(l )) {      
      return(cons(treewalk(car(l )), treewalk(cdr(l ))));
    } else {      
      if ( equalString("b0rk" , stringify(l ))) {        
        val = clone(l );        
        val.str = "b0rk" ;        
        return(val );
      } else {        
        return(l );
      }
    }
  }
}


//Building function b0rk from line: 340

public void b0rk() {
  
if (globalTrace)
   System.out. printf("Leaving b0rk\n");

}


//Building function ansiCompile from line: 341

public void ansiCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  System.out.printf("//Scanning file...%s\n" , filename );  
  programStr = read_file(filename );  
  System.out.printf("//Building sexpr\n" );  
  tree = readSexpr(programStr , filename );  
  tree = treewalk(tree );  
  b0rk("blah" , "blah" );  
  System.out.printf("//Building AST\n" );  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  System.out.printf("//Merging ASTs\n" );  
  program = mergeIncludes(program );  
  System.out.printf("//Printing program\n" );  
  ansiIncludes(cdr(assoc("includes" , program )));  
  ansiTypes(childrenof(cdr(assoc("types" , program ))));  
  System.out.printf("Box* globalStackTrace = NULL;\n" );  
  System.out.printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" );  
  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf("\n\n//End forward declarations\n\n" );  
  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf("\n" );
if (globalTrace)
   System.out. printf("Leaving ansiCompile\n");

}


//Building function test0 from line: 8

public void test0() {
    
  if ( equalString(stringify(boxString("hello" )), stringify(boxString("hello" )))) {    
    System.out.printf("0.  pass string compare works\n" );
  } else {    
    System.out.printf("0.  pass string compare fails\n" );
  }  
  if ( equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" )))) {    
    System.out.printf("0.  pass string compare works\n" );
  } else {    
    System.out.printf("0.  pass string compare fails\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test0\n");

}


//Building function test1 from line: 23

public void test1() {
    
  System.out.printf("1.  pass Function call and print work\n" );
if (globalTrace)
   System.out. printf("Leaving test1\n");

}


//Building function test2_do from line: 28

public void test2_do(String message ) {
    
  System.out.printf("2.  pass Function call with arg works: %s\n" , message );
if (globalTrace)
   System.out. printf("Leaving test2_do\n");

}


//Building function test2 from line: 32

public void test2() {
    
  test2_do("This is the argument" );
if (globalTrace)
   System.out. printf("Leaving test2\n");

}


//Building function test3_do from line: 34

public void test3_do(Integer b ,String c ) {
    
  System.out.printf("3.1 pass Two arg call, first arg: %d\n" , b );  
  System.out.printf("3.2 pass Two arg call, second arg: %s\n" , c );
if (globalTrace)
   System.out. printf("Leaving test3_do\n");

}


//Building function test3 from line: 40

public void test3() {
    
  test3_do(42 , "Fourty-two" );
if (globalTrace)
   System.out. printf("Leaving test3\n");

}


//Building function test4_do from line: 41

public String test4_do() {
    
  return("pass Return works" );
}


//Building function returnThis from line: 43

public String returnThis(String returnMessage ) {
    
  return(returnMessage );
}


//Building function test4 from line: 48

public void test4() {
  String message = "fail" ;
  
  message = test4_do ();  
  System.out.printf("4.  %s\n" , message );
if (globalTrace)
   System.out. printf("Leaving test4\n");

}


//Building function test5 from line: 53

public void test5() {
  String message = "fail" ;
  
  message = returnThis("pass return passthrough string" );  
  System.out.printf("5.  %s\n" , message );
if (globalTrace)
   System.out. printf("Leaving test5\n");

}


//Building function test6 from line: 60

public void test6() {
    
  if ( true ) {    
    System.out.printf("6.  pass If statement works\n" );
  } else {    
    System.out.printf("6.  fail If statement works\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test6\n");

}


//Building function test7_do from line: 68

public Integer test7_do(Integer count ) {
    
  count = sub(count , 1 );  
  if ( greaterthan(count , 0 )) {    
    count = test7_do(count );
  } else {    
    return(count );
  }  
  return(count );
}


//Building function test7 from line: 76

public void test7() {
    
  if ( equal(0 , test7_do(10 ))) {    
    System.out.printf("7.  pass count works\n" );
  } else {    
    System.out.printf("7.  fail count fails\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test7\n");

}


//Building function beer from line: 84

public void beer() {
    
  System.out.printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );
if (globalTrace)
   System.out. printf("Leaving beer\n");

}


//Building function plural from line: 93

public String plural(Integer num ) {
    
  if ( equal(num , 1 )) {    
    return("" );
  } else {    
    return("s" );
  }
}


//Building function beers from line: 98

public Integer beers(Integer count ) {
  Integer newcount = 0 ;
  
  newcount = sub(count , 1 );  
  System.out.printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , count , plural(count ), count , plural(count ), newcount , plural(newcount ));  
  if ( greaterthan(count , 1 )) {    
    count = beers(newcount );
  } else {    
    return(count );
  }  
  return(0 );
}


//Building function test8 from line: 114

public void test8() {
    
  if ( equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 )) {    
    System.out.printf("8.  pass Nested expressions work\n" );
  } else {    
    System.out.printf("8.  fail Nested expressions don't work\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test8\n");

}


//Building function test9 from line: 122

public void test9() {
  Integer answer = -999999 ;
  
  answer = sub(sub(20 , 1 ), sub(3 , 1 ));  
  if ( equal(answer , 17 )) {    
    System.out.printf("9.  pass arithmetic works\n" );
  } else {    
    System.out.printf("9.  fail arithmetic\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test9\n");

}


//Building function test10 from line: 131

public void test10() {
  String testString = "This is a test string" ;
  
  if ( equalString(testString , unBoxString(car(cons(boxString(testString ), null ))))) {    
    System.out.printf("10. pass cons and car work\n" );
  } else {    
    System.out.printf("10. fail cons and car fail\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test10\n");

}


//Building function test12 from line: 141

public void test12() {
  Box b = null ;
  
  b = new Box();  
  b.str = "12. pass structure accessors\n" ;  
  System.out.printf("%s" , b.str);
if (globalTrace)
   System.out. printf("Leaving test12\n");

}


//Building function test13 from line: 149

public void test13() {
  String testString = "Hello from the filesystem!" ;
String contents = "" ;
  
  write_file("test.txt" , testString );  
  contents = read_file("test.txt" );  
  if ( equalString(testString , contents )) {    
    System.out.printf("13. pass Read and write files\n" );
  } else {    
    System.out.printf("13. fail Read and write files\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test13\n");

}


//Building function test15 from line: 161

public void test15() {
  String a = "hello" ;
String b = " world" ;
String c = "" ;
  
  c = stringConcatenate(a , b );  
  if ( equalString(c , "hello world" )) {    
    System.out.printf("15. pass String concatenate\n" );
  } else {    
    System.out.printf("15. fail String concatenate\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test15\n");

}


//Building function test16 from line: 171

public void test16() {
  Box assocCell1 = null ;
Box assList = null ;
Box assocCell2 = null ;
Box assocCell3 = null ;
  
  assocCell1 = cons(boxString("Hello" ), boxString("world" ));  
  assocCell2 = cons(boxString("goodnight" ), boxString("moon" ));  
  assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ));  
  assList = cons(assocCell2 , emptyList ());  
  assList = cons(assocCell1 , assList );  
  assList = cons(assocCell3 , assList );  
  if ( equalBox(cdr(assoc("Hello" , assList )), boxString("world" ))) {    
    System.out.printf("16.1 pass Basic assoc works\n" );
  } else {    
    System.out.printf("16.1 fail Basic assoc fails\n" );
  }  
  if ( andBool(andBool(equalBox(cdr(assoc("Hello" , assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , assList )), boxString("gozaimasu" )))) {    
    System.out.printf("16.2 pass assoc list\n" );
  } else {    
    System.out.printf("16.2 fail assoc list\n" );
  }
if (globalTrace)
   System.out. printf("Leaving test16\n");

}


//Building function nodeFunctionArgs from line: 4

public void nodeFunctionArgs(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    display(second(tree ));    
    if ( isNil(cddr(tree ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf("," );
    }    
    nodeFunctionArgs(cddr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving nodeFunctionArgs\n");

}


//Building function nodeLeaf from line: 13

public void nodeLeaf(Box thisNode ,Integer indent ) {
    
  display(nodeFuncMap(codeof(thisNode )));
if (globalTrace)
   System.out. printf("Leaving nodeLeaf\n");

}


//Building function nodeStructGetterExpression from line: 16

public void nodeStructGetterExpression(Box thisNode ,Integer indent ) {
    
  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    
    nodeGetStruct(thisNode , indent );
  } else {    
    nodeLeaf(thisNode , indent );
  }
if (globalTrace)
   System.out. printf("Leaving nodeStructGetterExpression\n");

}


//Building function nodeExpression from line: 22

public void nodeExpression(Box node ,Integer indent ) {
    
  if ( isLeaf(node )) {    
    display(nodeFuncMap(codeof(node )));
  } else {    
    nodeSubExpression(node , indent );
  }
if (globalTrace)
   System.out. printf("Leaving nodeExpression\n");

}


//Building function nodeRecurList from line: 28

public void nodeRecurList(Box expr ,Integer indent ) {
    
  if ( isEmpty(expr )) {    
    return;
  } else {    
    nodeExpression(car(expr ), indent );    
    if ( isNil(cdr(expr ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf(", " );      
      nodeRecurList(cdr(expr ), indent );
    }
  }
if (globalTrace)
   System.out. printf("Leaving nodeRecurList\n");

}


//Building function nodeSubExpression from line: 41

public void nodeSubExpression(Box tree ,Integer indent ) {
  Box thing = null ;
  
  if ( isEmpty(tree )) {    
    return;
  } else {    
    if ( isNode(childrenof(tree ))) {      
      nodeSubExpression(childrenof(tree ), indent );
    } else {      
      if ( isLeaf(tree )) {        
        display(nodeFuncMap(codeof(tree )));
      } else {        
        if ( equal(1 , listLength(childrenof(tree )))) {          
          display(codeof(car(childrenof(tree ))));          
          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            
            System.out.printf("" );
          } else {            
            System.out.printf("()" );
          }
        } else {          
          thing = codeof(car(childrenof(tree )));          
          if ( equalBox(boxSymbol("get-struct" ), thing )) {            
            System.out.printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));
          } else {            
            if ( equalBox(boxSymbol("new" ), thing )) {              
              System.out.printf("{}" );
            } else {              
              System.out.printf("%s(" , stringify(nodeFuncMap(codeof(car(childrenof(tree ))))));              
              nodeRecurList(cdr(childrenof(tree )), indent );              
              System.out.printf(")" );
            }
          }
        }
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving nodeSubExpression\n");

}


//Building function nodeIf from line: 82

public void nodeIf(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("if ( " );  
  nodeExpression(car(first(childrenof(node ))), 0 );  
  System.out.printf(") {" );  
  nodeBody(second(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("} else {" );  
  nodeBody(third(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("}" );
if (globalTrace)
   System.out. printf("Leaving nodeIf\n");

}


//Building function nodeGetStruct from line: 96

public void nodeGetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
if (globalTrace)
   System.out. printf("Leaving nodeGetStruct\n");

}


//Building function nodeSet from line: 104

public void nodeSet(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s = " , stringify(first(codeof(node ))));  
  nodeExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving nodeSet\n");

}


//Building function nodeSetStruct from line: 110

public void nodeSetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));  
  nodeExpression(childrenof(node ), indent );
if (globalTrace)
   System.out. printf("Leaving nodeSetStruct\n");

}


//Building function nodeStatement from line: 118

public void nodeStatement(Box node ,Integer indent ) {
    
  if ( equalBox(boxString("setter" ), subnameof(node ))) {    
    nodeSet(node , indent );
  } else {    
    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      
      nodeSetStruct(node , indent );
    } else {      
      if ( equalBox(boxString("if" ), subnameof(node ))) {        
        nodeIf(node , indent );
      } else {        
        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          
          newLine(indent );          
          System.out.printf("return" );
        } else {          
          newLine(indent );          
          nodeExpression(childrenof(node ), indent );
        }
      }
    }
  }  
  System.out.printf(";\n" );
if (globalTrace)
   System.out. printf("Leaving nodeStatement\n");

}


//Building function nodeBody from line: 137

public void nodeBody(Box tree ,Integer indent ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    printIndent(indent );    
    System.out.printf("%s" , "if (globalStepTrace) {console.log(new Error(\"StepTrace \\n\"));}\n" );    
    nodeStatement(car(tree ), indent );    
    nodeBody(cdr(tree ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving nodeBody\n");

}


//Building function nodeDeclarations from line: 151

public void nodeDeclarations(Box decls ,Integer indent ) {
  Box decl = null ;
  
  if ( isEmpty(decls )) {    
    return;
  } else {    
    decl = car(decls );    
    System.out.printf("var %s = " , stringify(second(decl )));    
    display(nodeFuncMap(third(decl )));    
    System.out.printf(";\n" );    
    nodeDeclarations(cdr(decls ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving nodeDeclarations\n");

}


//Building function nodeFunction from line: 166

public void nodeFunction(Box node ) {
  Box name = null ;
  
  name = subnameof(node );  
  System.out.printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));  
  newLine(0 );  
  if ( isNil(node )) {    
    return;
  } else {    
    newLine(0 );    
    System.out.printf("function %s(" , stringify(subnameof(node )));    
    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    System.out.printf(") {" );    
    newLine(1 );    
    nodeDeclarations(declarationsof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("\nif (globalTrace)\n    {printf(\"%s at %s:%s\\n\");}\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    }    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {
    }    
    nodeBody(childrenof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("\nif (globalTrace)\n    {printf(\"Leaving %s\\n\");}\n" , stringify(name ));
    }    
    System.out.printf("\n}\n" );
  }
if (globalTrace)
   System.out. printf("Leaving nodeFunction\n");

}


//Building function nodeForwardDeclaration from line: 199

public void nodeForwardDeclaration(Box node ) {
    
  if ( isNil(node )) {    
    return;
  } else {    
    System.out.printf("\n%s %s(" , stringify(nodeTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));    
    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    System.out.printf(");" );
  }
if (globalTrace)
   System.out. printf("Leaving nodeForwardDeclaration\n");

}


//Building function nodeForwardDeclarations from line: 211

public void nodeForwardDeclarations(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    nodeForwardDeclaration(car(tree ));    
    nodeForwardDeclarations(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving nodeForwardDeclarations\n");

}


//Building function nodeFunctions from line: 221

public void nodeFunctions(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    nodeFunction(car(tree ));    
    nodeFunctions(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving nodeFunctions\n");

}


//Building function nodeIncludes from line: 229

public void nodeIncludes(Box nodes ) {
    
  System.out.printf("%s" , "function read_file(filename) {return fs.readFileSync(filename);}\n" );  
  System.out.printf("%s" , "function write_file(filename, data) {fs.writeFileSync(filename, data);}\n" );  
  System.out.printf("%s" , "var util = require('util');\n" );  
  System.out.printf("%s" , "function printf() {process.stdout.write(util.format.apply(this, arguments));}\n" );  
  System.out.printf("%s" , "var fs = require('fs');\n" );  
  System.out.printf("%s" , "function equalString(a,b) {return a.toString()===b.toString() }\n" );  
  System.out.printf("%s" , "function panic(s){console.trace(s);process.exit(1);}\n" );  
  System.out.printf("%s" , "function dump(s){console.log(s)}" );  
  System.out.printf("%s" , "function sub(a, b) { return a - b; }\n" );  
  System.out.printf("%s" , "function mult(a, b) { return a * b; }\n" );  
  System.out.printf("%s" , "function greaterthan(a, b) { return a > b; }\n" );  
  System.out.printf("%s" , "function subf(a, b) { return a - b; }\n" );  
  System.out.printf("%s" , "function multf(a, b) { return a * b; }\n" );  
  System.out.printf("%s" , "function greaterthanf(a, b) { return a > b; }\n" );  
  System.out.printf("%s" , "function equal(a, b) { return a == b; }\n" );  
  System.out.printf("%s" , "function andBool(a, b) { return a == b;}\n" );  
  System.out.printf("%s" , "function string_length(s) { return s.length;}\n" );  
  System.out.printf("%s" , "function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};\n" );  
  System.out.printf("%s" , "function stringConcatenate(a, b) { return a + b}\n" );  
  System.out.printf("%s" , "function intToString(a) {}\n\n\n" );  
  System.out.printf("%s" , "function gc_malloc( size ) {\nreturn {};\n}\n\n" );  
  System.out.printf("%s" , "function makeArray(length) {\n   return [];\n}\n\n" );  
  System.out.printf("%s" , "function at(arr, index) {\n  return arr[index];\n}\n\n" );  
  System.out.printf("%s" , "function setAt(array, index, value) {\n    array[index] = value;\n}\n\n" );  
  System.out.printf("%s" , "function getStringArray(index, strs) {\nreturn strs[index];\n}\n\n" );  
  System.out.printf("%s" , "var NULL = null;" );  
  System.out.printf("%s" , "var globalArgs;\nvar globalArgsCount;\nvar globalTrace = false;\nvar globalStepTrace = false;" );  
  System.out.printf("%s" , "function character(num) {}" );
if (globalTrace)
   System.out. printf("Leaving nodeIncludes\n");

}


//Building function nodeTypeDecl from line: 262

public void nodeTypeDecl(Box l ) {
    
  if ( greaterthan(listLength(l ), 2 )) {    
    printIndent(1 );    
    System.out.printf("%s %s %s;\n" , stringify(second(l )), stringify(nodeTypeMap(listLast(l ))), stringify(first(l )));
  } else {    
    printIndent(1 );    
    System.out.printf("%s %s;\n" , stringify(nodeTypeMap(listLast(l ))), stringify(car(l )));
  }
if (globalTrace)
   System.out. printf("Leaving nodeTypeDecl\n");

}


//Building function nodeStructComponents from line: 279

public void nodeStructComponents(Box node ) {
    
  if ( isEmpty(node )) {    
    return;
  } else {    
    nodeTypeDecl(car(node ));    
    nodeStructComponents(cdr(node ));
  }
if (globalTrace)
   System.out. printf("Leaving nodeStructComponents\n");

}


//Building function nodeStruct from line: 287

public void nodeStruct(Box node ) {
    
  nodeStructComponents(cdr(car(node )));
if (globalTrace)
   System.out. printf("Leaving nodeStruct\n");

}


//Building function nodeTypeMap from line: 292

public Box nodeTypeMap(Box aSym ) {
  Box symMap = null ;
  
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), null ));  
  if ( truthy(assoc(stringify(aSym ), symMap ))) {    
    return(cdr(assoc(stringify(aSym ), symMap )));
  } else {    
    return(aSym );
  }
}


//Building function nodeFuncMap from line: 307

public Box nodeFuncMap(Box aSym ) {
  Box symMap = null ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), null )))))));    
    if ( truthy(assoc(stringify(aSym ), symMap ))) {      
      return(cdr(assoc(stringify(aSym ), symMap )));
    } else {      
      return(aSym );
    }
  } else {    
    return(aSym );
  }
}


//Building function nodeType from line: 338

public void nodeType(Box node ) {
  
if (globalTrace)
   System.out. printf("Leaving nodeType\n");

}


//Building function nodeTypes from line: 342

public void nodeTypes(Box nodes ) {
    
  if ( isEmpty(nodes )) {    
    return;
  } else {    
    nodeType(car(nodes ));    
    nodeTypes(cdr(nodes ));
  }
if (globalTrace)
   System.out. printf("Leaving nodeTypes\n");

}


//Building function nodeCompile from line: 350

public void nodeCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  programStr = read_file(filename );  
  tree = readSexpr(programStr , filename );  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  program = mergeIncludes(program );  
  nodeIncludes(cdr(assoc("includes" , program )));  
  nodeTypes(childrenof(cdr(assoc("types" , program ))));  
  System.out.printf("\nvar globalStackTrace = NULL;\n" );  
  System.out.printf("\nfunction isNil(p) {\n    return p == NULL;\n}\n\n" );  
  nodeFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf("\n" );  
  System.out.printf("%s" , "start();\n" );
if (globalTrace)
   System.out. printf("Leaving nodeCompile\n");

}


//Building function javaFunctionArgs from line: 3

public void javaFunctionArgs(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    display(javaTypeMap(first(tree )));    
    display(second(tree ));    
    if ( isNil(cddr(tree ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf("," );
    }    
    javaFunctionArgs(cddr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving javaFunctionArgs\n");

}


//Building function javaLeaf from line: 13

public void javaLeaf(Box thisNode ,Integer indent ) {
    
  display(javaFuncMap(codeof(thisNode )));
if (globalTrace)
   System.out. printf("Leaving javaLeaf\n");

}


//Building function javaStructGetterExpression from line: 16

public void javaStructGetterExpression(Box thisNode ,Integer indent ) {
    
  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    
    javaGetStruct(thisNode , indent );
  } else {    
    javaLeaf(thisNode , indent );
  }
if (globalTrace)
   System.out. printf("Leaving javaStructGetterExpression\n");

}


//Building function javaExpression from line: 22

public void javaExpression(Box node ,Integer indent ) {
    
  if ( isLeaf(node )) {    
    display(javaFuncMap(codeof(node )));
  } else {    
    javaSubExpression(node , indent );
  }
if (globalTrace)
   System.out. printf("Leaving javaExpression\n");

}


//Building function javaRecurList from line: 28

public void javaRecurList(Box expr ,Integer indent ) {
    
  if ( isEmpty(expr )) {    
    return;
  } else {    
    javaExpression(car(expr ), indent );    
    if ( isNil(cdr(expr ))) {      
      System.out.printf("" );
    } else {      
      System.out.printf(", " );      
      javaRecurList(cdr(expr ), indent );
    }
  }
if (globalTrace)
   System.out. printf("Leaving javaRecurList\n");

}


//Building function javaSubExpression from line: 40

public void javaSubExpression(Box tree ,Integer indent ) {
  Box thing = null ;
  
  if ( isEmpty(tree )) {    
    return;
  } else {    
    if ( isNode(childrenof(tree ))) {      
      javaSubExpression(childrenof(tree ), indent );
    } else {      
      if ( isLeaf(tree )) {        
        display(javaFuncMap(codeof(tree )));
      } else {        
        if ( equal(1 , listLength(childrenof(tree )))) {          
          display(codeof(car(childrenof(tree ))));          
          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            
            System.out.printf("" );
          } else {            
            System.out.printf("()" );
          }
        } else {          
          thing = codeof(car(childrenof(tree )));          
          if ( equalBox(boxSymbol("get-struct" ), thing )) {            
            System.out.printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));
          } else {            
            if ( equalBox(boxSymbol("new" ), thing )) {              
              System.out.printf("new %s()" , stringify(codeof(third(childrenof(tree )))));
            } else {              
              System.out.printf("%s(" , stringify(javaFuncMap(codeof(car(childrenof(tree ))))));              
              javaRecurList(cdr(childrenof(tree )), indent );              
              System.out.printf(")" );
            }
          }
        }
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving javaSubExpression\n");

}


//Building function javaIf from line: 80

public void javaIf(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("if ( " );  
  javaExpression(car(first(childrenof(node ))), 0 );  
  System.out.printf(") {" );  
  javaBody(second(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("} else {" );  
  javaBody(third(childrenof(node )), add1(indent ));  
  newLine(indent );  
  System.out.printf("}" );
if (globalTrace)
   System.out. printf("Leaving javaIf\n");

}


//Building function javaSetStruct from line: 93

public void javaSetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));  
  javaExpression(childrenof(node ), indent );  
  System.out.printf(";" );
if (globalTrace)
   System.out. printf("Leaving javaSetStruct\n");

}


//Building function javaGetStruct from line: 104

public void javaGetStruct(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
if (globalTrace)
   System.out. printf("Leaving javaGetStruct\n");

}


//Building function javaSet from line: 112

public void javaSet(Box node ,Integer indent ) {
    
  newLine(indent );  
  System.out.printf("%s = " , stringify(first(codeof(node ))));  
  javaExpression(childrenof(node ), indent );  
  System.out.printf(";" );
if (globalTrace)
   System.out. printf("Leaving javaSet\n");

}


//Building function javaStatement from line: 120

public void javaStatement(Box node ,Integer indent ) {
    
  if ( equalBox(boxString("setter" ), subnameof(node ))) {    
    javaSet(node , indent );
  } else {    
    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      
      javaSetStruct(node , indent );
    } else {      
      if ( equalBox(boxString("if" ), subnameof(node ))) {        
        javaIf(node , indent );
      } else {        
        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          
          newLine(indent );          
          System.out.printf("return;" );
        } else {          
          newLine(indent );          
          javaExpression(childrenof(node ), indent );          
          System.out.printf(";" );
        }
      }
    }
  }
if (globalTrace)
   System.out. printf("Leaving javaStatement\n");

}


//Building function javaBody from line: 140

public void javaBody(Box tree ,Integer indent ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    printIndent(indent );    
    System.out.printf("" );    
    javaStatement(car(tree ), indent );    
    javaBody(cdr(tree ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving javaBody\n");

}


//Building function javaDeclarations from line: 150

public void javaDeclarations(Box decls ,Integer indent ) {
  Box decl = null ;
  
  if ( isEmpty(decls )) {    
    return;
  } else {    
    decl = car(decls );    
    System.out.printf("%s %s = " , stringify(javaTypeMap(first(decl ))), stringify(second(decl )));    
    display(javaFuncMap(third(decl )));    
    System.out.printf(";\n" );    
    javaDeclarations(cdr(decls ), indent );
  }
if (globalTrace)
   System.out. printf("Leaving javaDeclarations\n");

}


//Building function javaFunction from line: 164

public void javaFunction(Box node ) {
  Box name = null ;
  
  name = subnameof(node );  
  System.out.printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));  
  newLine(0 );  
  if ( isNil(node )) {    
    return;
  } else {    
    newLine(0 );    
    System.out.printf("public %s %s(" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));    
    javaFunctionArgs(cdr(assoc("intype" , cdr(node ))));    
    System.out.printf(") {" );    
    newLine(1 );    
    javaDeclarations(declarationsof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("" );
    }    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {
    }    
    javaBody(childrenof(node ), 1 );    
    if ( inList(toStr(name ), noStackTrace ())) {      
      System.out.printf("" );
    } else {      
      if ( equalString("void" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))))) {        
        System.out.printf("\nif (globalTrace)\n   System.out. printf(\"Leaving %s\\n\");\n" , stringify(name ));
      } else {        
        System.out.printf("" );
      }
    }    
    System.out.printf("\n}\n" );
  }
if (globalTrace)
   System.out. printf("Leaving javaFunction\n");

}


//Building function javaFunctions from line: 203

public void javaFunctions(Box tree ) {
    
  if ( isEmpty(tree )) {    
    return;
  } else {    
    javaFunction(car(tree ));    
    javaFunctions(cdr(tree ));
  }
if (globalTrace)
   System.out. printf("Leaving javaFunctions\n");

}


//Building function javaIncludes from line: 209

public void javaIncludes(Box nodes ) {
    
  System.out.printf("%s" , "public void panic(String s) {System.exit(1);}\n" );  
  System.out.printf("%s" , "public int sub(int a, int b) { return a - b; }\n" );  
  System.out.printf("%s" , "public double mult(int a, int b) { return a * b; }\n" );  
  System.out.printf("%s" , "public boolean greaterthan(int a, int b) { return a > b; }\n" );  
  System.out.printf("%s" , "public double subf(double a, double b) { return a - b; }\n" );  
  System.out.printf("%s" , "public double multf(double a, double b) { return a * b; }\n" );  
  System.out.printf("%s" , "public boolean greaterthanf(double a, double b) { return a > b; }\n" );  
  System.out.printf("%s" , "public boolean equal(int a, int b) { return a == b; }\n" );  
  System.out.printf("%s" , "public boolean equalString(String a, String b) { return a.equals(b); }\n" );  
  System.out.printf("%s" , "public boolean andBool(boolean a, boolean b) { return a == b;}\n" );  
  System.out.printf("%s" , "public int string_length(String s) { return s.length();}\n" );  
  System.out.printf("%s" , "public String stringConcatenate(String s1, String s2) { return s1 + s2; }\n" );  
  System.out.printf("%s" , "public int strcmp(String s1, String s2) { return s1.compareTo(s2);}\n" );  
  System.out.printf("%s" , "public String read_file(String filename) {try { return new String(Files.readAllBytes(Paths.get(filename)));} catch (Exception e) {panic(\"Could not read file\");return \"\";}}\n" );  
  System.out.printf("%s" , "public void write_file(String filename, String data) {try {Files.write(Paths.get(filename), data.getBytes(\"UTF-8\"));} catch (Exception e) {panic(\"Could not write file\");}}\n" );  
  System.out.printf("%s" , "public String sub_string(String s, int start, int length) {\nreturn s.substring(start, start+length);\n}\n\n\n\n" );  
  System.out.printf("%s" , "public String intToString(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );  
  System.out.printf("%s" , "public String character(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );  
  System.out.printf("%s" , "public String getStringArray(int index, String[] arr) { return arr[index];}" );
if (globalTrace)
   System.out. printf("Leaving javaIncludes\n");

}


//Building function javaTypeDecl from line: 232

public void javaTypeDecl(Box l ) {
    
  if ( greaterthan(listLength(l ), 2 )) {    
    printIndent(1 );    
    System.out.printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(first(l )));
  } else {    
    printIndent(1 );    
    System.out.printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(car(l )));
  }
if (globalTrace)
   System.out. printf("Leaving javaTypeDecl\n");

}


//Building function javaStructComponents from line: 249

public void javaStructComponents(Box node ) {
    
  if ( isEmpty(node )) {    
    return;
  } else {    
    javaTypeDecl(car(node ));    
    javaStructComponents(cdr(node ));
  }
if (globalTrace)
   System.out. printf("Leaving javaStructComponents\n");

}


//Building function javaStruct from line: 255

public void javaStruct(Box node ) {
    
  javaStructComponents(cdr(car(node )));
if (globalTrace)
   System.out. printf("Leaving javaStruct\n");

}


//Building function javaTypeMap from line: 258

public Box javaTypeMap(Box aSym ) {
  Box symMap = null ;
  
  symMap = alistCons(boxSymbol("pair" ), boxSymbol("Box" ), alistCons(boxSymbol("bool" ), boxSymbol("boolean" ), alistCons(boxSymbol("box" ), boxSymbol("Box" ), alistCons(boxSymbol("list" ), boxSymbol("Box" ), alistCons(boxSymbol("Box*" ), boxSymbol("Box" ), alistCons(boxSymbol("struct" ), boxSymbol("" ), alistCons(boxSymbol("int" ), boxSymbol("Integer" ), alistCons(boxSymbol("float" ), boxSymbol("double" ), alistCons(boxSymbol("stringArray" ), boxSymbol("String[]" ), alistCons(boxSymbol("string" ), boxSymbol("String" ), null ))))))))));  
  if ( truthy(assoc(stringify(aSym ), symMap ))) {    
    return(cdr(assoc(stringify(aSym ), symMap )));
  } else {    
    return(aSym );
  }
}


//Building function javaTypesNoDeclare from line: 276

public Box javaTypesNoDeclare() {
  Box syms = null ;
  
  syms = cons(boxString("pair" ), cons(boxString("box" ), null ));  
  return(syms );
}


//Building function javaFuncMap from line: 285

public Box javaFuncMap(Box aSym ) {
  Box symMap = null ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("printf" ), boxSymbol("System.out.printf" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("null" ), null ))))))));    
    if ( truthy(assoc(stringify(aSym ), symMap ))) {      
      return(cdr(assoc(stringify(aSym ), symMap )));
    } else {      
      return(aSym );
    }
  } else {    
    return(aSym );
  }
}


//Building function javaType from line: 315

public void javaType(Box node ) {
    
  if ( equalBox(subnameof(node ), boxString("struct" ))) {    
    System.out.printf("\npublic class %s {\n" , stringify(first(codeof(node ))));    
    javaStruct(cdr(codeof(node )));    
    System.out.printf("\n};\n" );
  } else {    
    if ( inList(boxString(stringify(first(codeof(node )))), javaTypesNoDeclare ())) {      
      System.out.printf("" );
    } else {      
      System.out.printf("public class %s extends %s {};\n" , stringify(first(codeof(node ))), stringify(javaTypeMap(listLast(codeof(node )))));
    }
  }
if (globalTrace)
   System.out. printf("Leaving javaType\n");

}


//Building function javaTypes from line: 330

public void javaTypes(Box nodes ) {
    
  if ( isEmpty(nodes )) {    
    return;
  } else {    
    javaType(car(nodes ));    
    javaTypes(cdr(nodes ));
  }
if (globalTrace)
   System.out. printf("Leaving javaTypes\n");

}


//Building function javaCompile from line: 336

public void javaCompile(String filename ) {
  String programStr = "" ;
Box tree = null ;
Box program = null ;
  
  System.out.printf("%s" , "package quonverter;\n" );  
  System.out.printf("%s" , "import java.nio.file.Files;\n" );  
  System.out.printf("%s" , "import java.nio.file.Paths;\n" );  
  System.out.printf("%s" , "import java.io.IOException;\n" );  
  System.out.printf("%s" , "import java.io.UnsupportedEncodingException;\n" );  
  System.out.printf("class MyProgram {\n" );  
  programStr = read_file(filename );  
  tree = readSexpr(programStr , filename );  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), null )));  
  program = mergeIncludes(program );  
  javaIncludes(cdr(assoc("includes" , program )));  
  javaTypes(childrenof(cdr(assoc("types" , program ))));  
  System.out.printf("public boolean globalStackTrace = false;\n" );  
  System.out.printf("public boolean globalStepTrace = false;\n" );  
  System.out.printf("public boolean globalTrace = false;\n" );  
  System.out.printf("public String FILE = null;\n" );  
  System.out.printf("public Integer LINE = 0;\n" );  
  System.out.printf("public static Integer globalArgsCount = 0;\n" );  
  System.out.printf("public static String globalArgs[];\n" );  
  System.out.printf("\npublic boolean isNil(Box p) {\n    return p == null;\n}\n\n\n" );  
  javaFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));  
  System.out.printf("%s" , "public static void main(String args[]) {\nglobalArgs = args;\nglobalArgsCount = args.length;MyProgram mp = new MyProgram(); mp.start();\n}" );  
  System.out.printf("}\n" );
if (globalTrace)
   System.out. printf("Leaving javaCompile\n");

}


//Building function start from line: 4

public Integer start() {
  boolean runTests = false ;
Box cmdLine = null ;
Box filename = null ;
boolean runPerl = false ;
boolean runJava = false ;
boolean runAst = false ;
boolean runNode = false ;
boolean runTree = false ;
  
  cmdLine = listReverse(argList(globalArgsCount , 0 , globalArgs ));  
  if ( greaterthan(listLength(cmdLine ), 1 )) {    
    filename = second(cmdLine );
  } else {    
    filename = boxString("compiler.qon" );
  }  
  runTests = inList(boxString("--test" ), cmdLine );  
  runJava = inList(boxString("--java" ), cmdLine );  
  runPerl = inList(boxString("--perl" ), cmdLine );  
  runAst = inList(boxString("--ast" ), cmdLine );  
  runTree = inList(boxString("--tree" ), cmdLine );  
  runNode = inList(boxString("--node" ), cmdLine );  
  globalTrace = inList(boxString("--trace" ), cmdLine );  
  globalStepTrace = inList(boxString("--steptrace" ), cmdLine );  
  if ( runTests ) {    
    test0 ();    
    test1 ();    
    test2 ();    
    test3 ();    
    test4 ();    
    test5 ();    
    test6 ();    
    test7 ();    
    test8 ();    
    test9 ();    
    test10 ();    
    test12 ();    
    test13 ();    
    test15 ();    
    test16 ();    
    System.out.printf("\n\nAfter all that hard work, I need a beer...\n" );    
    beers(9 );
  } else {    
    if ( runTree ) {      
      display(treeCompile(unBoxString(filename )));
    } else {      
      if ( runAst ) {        
        astCompile(unBoxString(filename ));
      } else {        
        if ( runNode ) {          
          nodeCompile(unBoxString(filename ));          
          System.out.printf("\n" );
        } else {          
          if ( runPerl ) {            
            perlCompile(unBoxString(filename ));            
            System.out.printf("\n" );
          } else {            
            if ( runJava ) {              
              javaCompile(unBoxString(filename ));              
              System.out.printf("\n" );
            } else {              
              ansiCompile(unBoxString(filename ));              
              System.out.printf("\n" );
            }
          }
        }
      }
    }
  }  
  return(0 );
}
public static void main(String args[]) {
globalArgs = args;
globalArgsCount = args.length;MyProgram mp = new MyProgram(); mp.start();
}}

