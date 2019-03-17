//["C:\Users\user\AppData\Local\Temp\go-build852188306\b001\exe\test.exe" ]"test.sexpr" 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void panic(char* s){abort();}
int sub(int a, int b) { return a - b; }
float mult(int a, int b) { return a * b; }
int greaterthan(int a, int b) { return a > b; }
float subf(float a, float b) { return a - b; }
float multf(float a, float b) { return a * b; }
int greaterthanf(float a, float b) { return a > b; }
int equal(int a, int b) { return a == b; }
int equalString(char* a, char* b) { return !strcmp(a,b); }
int andBool(int a, int b) { return a == b;}
int string_length(char* s) { return strlen(s);}
char* sub_string(char* s, int start, int length) {
char* substr = calloc(length+1, 1);
strncpy(substr, s+start, length);
return substr;
}



char* stringConcatenate(char* a, char* b) {
int len = strlen(a) + strlen(b) + 1;
char* target = calloc(len,1);
strncat(target, a, len);
strncat(target, b, len);
return target;
}

typedef int*  array;
typedef int bool;
#define true 1
#define false 0



void * gc_malloc( unsigned int size ) {
return malloc( size);
}

int* makeArray(int length) {
    int * array = gc_malloc(length*sizeof(int));
    return array;
}

int at(int* arr, int index) {
  return arr[index];
}

void setAt(int* array, int index, int value) {
    array[index] = value;
}

char * read_file(char * filename) {
char * buffer = 0;
long length;
FILE * f = fopen (filename, "rb");

if (f)
{
  fseek (f, 0, SEEK_END);
  length = ftell (f);
  fseek (f, 0, SEEK_SET);
  buffer = malloc (length);
  if (buffer)
  {
    fread (buffer, 1, length, f);
  }
  fclose (f);
}
return buffer;
}


void write_file (char * filename, char * data) {
FILE *f = fopen(filename, "w");
if (f == NULL)
{
    printf("Error opening file!");
    exit(1);
}

fprintf(f,  data);

fclose(f);
}

char* getStringArray(int index, char** strs) {
return strs[index];
}

int start();  //Forwards declare the user's main routine
char** globalArgs;
int globalArgsCount;

int main( int argc, char *argv[] )  {
  globalArgs = argv;
  globalArgsCount = argc;

  return start();

}


typedef struct Box {
  struct Box* lis;
  char* str;
  int i;
  char* typ;
  bool voi;
  bool boo;
  int lengt;
  struct Box* car;
  struct Box* cdr;

} Box;
typedef   Box* box;
typedef   Box Pair;
typedef   Box* pair;
typedef   Box* list;

bool isNil(list p) {
    return p == NULL;
}


//Forward declarations

int add(int a ,int b );
float addf(float a ,float b );
int sub1(int a );
int add1(int a );
box clone(box b );
box newVoid();
list cons(box data ,list l );
box car(list l );
list cdr(list l );
bool isList(box b );
list emptyList();
bool isEmpty(box b );
list alistCons(box key ,box value ,list alist );
list assoc(char* searchTerm ,list l );
bool equalBox(box a ,box b );
char* boxType(box b );
box boxString(char* s );
box boxSymbol(char* s );
box boxBool(bool boo );
box boxInt(int val );
void assertType(char* atype ,box abox );
char* unBoxString(box b );
char* unBoxSymbol(box b );
bool unBoxBool(box b );
int unBoxInt(box b );
char* stringify(box b );
void displayList(list l ,int indent );
void display(list l );
list filterVoid(list l );
box finish_token(char* prog ,int start ,int len );
char* readString(char* prog ,int start ,int len );
char* readComment(char* prog ,int start ,int len );
bool isWhiteSpace(char* s );
list scan(char* prog ,int start ,int len );
bool isOpenBrace(box b );
char* openBrace();
bool isCloseBrace(box b );
char* closeBrace();
list sexprTree(list l );
list skipList(list l );
list readSexpr(char* aStr );
void test0();
void test1();
void test2_do(char* message );
void test2();
void test3_do(int b ,char* c );
void test3();
char* test4_do();
char* returnThis(char* returnMessage );
void test4();
void test5();
void test6();
int test7_do(int count );
void test7();
void beer();
char* plural(int num );
int beers(int count );
void test8();
void test9();
void test10();
void test12();
void test13();
box caar(list l );
box cadr(list l );
box caddr(list l );
box cadddr(list l );
box caddddr(list l );
box cddr(list l );
box first(list l );
box second(list l );
box third(list l );
box fourth(list l );
box fifth(list l );
list makeNode(char* name ,char* subname ,list code ,list children );
list astExpression(list tree );
list astSubExpression(list tree );
list astIf(list tree );
list astSetStruct(list tree );
list astSet(list tree );
list astGetStruct(list tree );
list astReturnVoid();
int length(list l );
list astStatement(list tree );
list astBody(list tree );
list astFunction(list tree );
list astFunctionList(list tree );
list astFunctions(list tree );
list loadLib(char* path );
list astInclude(list tree );
list astIncludeList(list tree );
list astIncludes(list tree );
list astStruct(list tree );
list astType(list tree );
list astTypeList(list tree );
list astTypes(list tree );
void ansiFunctionArgs(list tree );
list declarationsof(list ass );
list codeof(list ass );
list nodeof(list ass );
list subnameof(list ass );
list nameof(list ass );
list childrenof(list ass );
bool isNode(list val );
void ansiLeaf(list thisNode ,int indent );
void ansiStructGetterExpression(list thisNode ,int indent );
void ansiExpression(list node ,int indent );
void ansiRecurList(list expr ,int indent );
bool isLeaf(list n );
void ansiSubExpression(list tree ,int indent );
void ansiIf(list node ,int indent );
void ansiSetStruct(list node ,int indent );
void ansiGetStruct(list node ,int indent );
void ansiSet(list node ,int indent );
void ansiStatement(list node ,int indent );
void printIndent(int ii );
void newLine(int indent );
void ansiBody(list tree ,int indent );
void ansiDeclarations(list decls ,int indent );
void ansiFunction(list node );
void ansiForwardDeclaration(list node );
void ansiForwardDeclarations(list tree );
void ansiFunctions(list tree );
void ansiIncludes(list nodes );
box last(list alist );
void ansiTypeDecl(list l );
void ansiStructComponents(list node );
void ansiStruct(list node );
bool truthy(box aVal );
box ansiTypeMap(box aSym );
box ansiFuncMap(box aSym );
void ansiType(list node );
void ansiTypes(list nodes );
list concatLists(list seq1 ,list seq2 );
list alistKeys(list alist );
list mergeIncludes(list program );
void compile(char* filename );
void test15();
void test16();
list argList(int count ,int pos ,char** args );
list reverse(list l );
int start();

//End forward declarations


int add(int a ,int b ) {
    
  return(sub(a , sub(0 , b )));

}

float addf(float a ,float b ) {
    
  return(subf(a , subf(0 , b )));

}

int sub1(int a ) {
    
  return(sub(a , 1 ));

}

int add1(int a ) {
    
  return(add(a , 1 ));

}

box clone(box b ) {
  box newb = NULL ;
  
  newb = malloc(sizeof(Box));
  
  newb->typ = b->typ;
  
  newb->lis = b->lis;
  
  newb->str = b->str;
  
  newb->i = b->i;
  
  newb->lengt = b->lengt;
  
  return(newb );

}

box newVoid() {
  box newb = NULL ;
  
  newb = malloc(sizeof(Box));
  
  newb->voi = true ;
  
  newb->typ = "void" ;
  
  return(newb );

}

list cons(box data ,list l ) {
  pair p = NULL ;
  
  p = malloc(sizeof(Pair));
  
  p->cdr = l ;
  
  p->car = data ;
  
  p->typ = "list" ;
  
  return(p );

}

box car(list l ) {
    
  assertType("list" , l );
  
  if ( isNil(l )) {    
    printf("Cannot call car on empty list!\n" );
    
    panic("Cannot call car on empty list!\n" );
    
    return(NULL );

  } else {    
    if ( isNil(l->car)) {      
      return(NULL );

    } else {      
      return(l->car);

    };

  };

}

list cdr(list l ) {
    
  assertType("list" , l );
  
  if ( isEmpty(l )) {    
    printf("Attempt to cdr an empty list!!!!\n" );
    
    panic("Attempt to cdr an empty list!!!!\n" );
    
    return(NULL );

  } else {    
    return(l->cdr);

  };

}

bool isList(box b ) {
    
  if ( isNil(b )) {    
    return(true );

  } else {    
    return(equalString("list" , b->typ));

  };

}

list emptyList() {
    
  return(NULL );

}

bool isEmpty(box b ) {
    
  if ( isNil(b )) {    
    return(true );

  } else {    
    if ( isList(b )) {      
      return(false );

    } else {      
      return(false );

    };

  };

}

list alistCons(box key ,box value ,list alist ) {
    
  return(cons(cons(key , value ), alist ));

}

list assoc(char* searchTerm ,list l ) {
  list elem = NULL ;
  
  assertType("list" , l );
  
  if ( isEmpty(l )) {    
    return(boxBool(false ));

  } else {    
    elem = car(l );
    
    if ( isEmpty(elem )) {      
      return(assoc(searchTerm , cdr(l )));

    } else {      
      if ( equalString(stringify(boxString(searchTerm )), stringify(car(elem )))) {        
        return(elem );

      } else {        
        return(assoc(searchTerm , cdr(l )));

      };

    };

  };

}

bool equalBox(box a ,box b ) {
    
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

          };

        } else {          
          if ( equalString("int" , boxType(a ))) {            
            return(equal(unBoxInt(a ), unBoxInt(b )));

          } else {            
            return(false );

          };

        };

      };

    };

  };

}

char* boxType(box b ) {
    
  return(b->typ);

}

box boxString(char* s ) {
  box b = NULL ;
  
  b = malloc(sizeof(Box));
  
  b->str = s ;
  
  b->lengt = string_length(s );
  
  b->typ = "string" ;
  
  return(b );

}

box boxSymbol(char* s ) {
  box b = NULL ;
  
  b = boxString(s );
  
  b->typ = "symbol" ;
  
  return(b );

}

box boxBool(bool boo ) {
  box b = NULL ;
  
  b = malloc(sizeof(Box));
  
  b->boo = boo ;
  
  b->typ = "bool" ;
  
  return(b );

}

box boxInt(int val ) {
  box b = NULL ;
  
  b = malloc(sizeof(Box));
  
  b->i = val ;
  
  b->typ = "int" ;
  
  return(b );

}

void assertType(char* atype ,box abox ) {
    
  if ( isNil(abox )) {    
    if ( equalString(atype , "nil" )) {      
      return ;

    } else {      
      return ;

    };

  } else {    
    if ( equalString(atype , boxType(abox ))) {      
      return ;

    } else {      
      printf("Assertion failure: provided value is not a '%s'!  It was actually:" , atype );
      
      display(abox );
      
      panic("Invalid type!" );

    };

  };

}

char* unBoxString(box b ) {
    
  assertType("string" , b );
  
  return(b->str);

}

char* unBoxSymbol(box b ) {
    
  return(b->str);

}

bool unBoxBool(box b ) {
    
  return(b->boo);

}

int unBoxInt(box b ) {
    
  return(b->i);

}

char* stringify(box b ) {
    
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

        };

      } else {        
        if ( equalString("symbol" , boxType(b ))) {          
          return(unBoxSymbol(b ));

        } else {          
          return(boxType(b ));

        };

      };

    };

  };

}

void displayList(list l ,int indent ) {
  box val = NULL ;
  
  if ( isEmpty(l )) {    
    return ;

  } else {    
    if ( isList(l )) {      
      if ( isEmpty(l )) {        
        return ;

      } else {        
        val = car(l );
        
        if ( isList(val )) {          
          newLine(indent );
          
          printf("%s" , openBrace ());
          
          displayList(car(l ), add1(indent ));
          
          printf("%s" , closeBrace ());
          
          displayList(cdr(l ), add1(indent ));

        } else {          
          if ( equalString("string" , val->typ)) {            
            printf("\"%s\" " , unBoxString(val ));

          } else {            
            printf("%s " , stringify(val ));

          };
          
          displayList(cdr(l ), indent );

        };

      };

    } else {      
      if ( equalString("string" , l->typ)) {        
        printf("\"%s\" " , unBoxString(l ));

      } else {        
        printf("%s " , stringify(l ));

      };

    };

  };

}

void display(list l ) {
    
  if ( isEmpty(l )) {    
    printf("nil " );
    
    return ;

  } else {    
    if ( isList(l )) {      
      printf("[" );
      
      displayList(l , 0 );
      
      printf("]" );

    } else {      
      displayList(l , 0 );

    };

  };

}

list filterVoid(list l ) {
  box token = NULL ;
  
  if ( isEmpty(l )) {    
    return(emptyList ());

  } else {    
    token = car(l );
    
    if ( equalString("void" , token->typ)) {      
      return(filterVoid(cdr(l )));

    } else {      
      return(cons(token , filterVoid(cdr(l ))));

    };

  };

}

box finish_token(char* prog ,int start ,int len ) {
    
  if ( greaterthan(len , 0 )) {    
    return(boxSymbol(sub_string(prog , start , len )));

  } else {    
    return(newVoid ());

  };

}

char* readString(char* prog ,int start ,int len ) {
  char* token = "" ;
  
  token = sub_string(prog , sub1(add(start , len )), 1 );
  
  if ( equalString("\"" , token )) {    
    return(sub_string(prog , start , sub1(len )));

  } else {    
    if ( equalString("\\" , token )) {      
      return(readString(prog , start , add(2 , len )));

    } else {      
      return(readString(prog , start , add1(len )));

    };
    
    return(readString(prog , start , add1(len )));

  };

}

char* readComment(char* prog ,int start ,int len ) {
  char* token = "" ;
  
  token = sub_string(prog , sub1(add(start , len )), 1 );
  
  if ( equalString("\n" , token )) {    
    return(sub_string(prog , start , sub1(len )));

  } else {    
    return(readComment(prog , start , add1(len )));

  };

}

bool isWhiteSpace(char* s ) {
    
  if ( equalString(" " , s )) {    
    return(true );

  } else {    
    if ( equalString("\n" , s )) {      
      return(true );

    } else {      
      return(false );

    };

  };

}

list scan(char* prog ,int start ,int len ) {
  box token = NULL ;
  
  if ( greaterthan(string_length(prog ), sub(start , sub(0 , len )))) {    
    token = boxSymbol(sub_string(prog , sub1(add(start , len )), 1 ));
    
    if ( isOpenBrace(token )) {      
      return(cons(finish_token(prog , start , sub1(len )), cons(boxSymbol(openBrace ()), scan(prog , add1(start ), 1 ))));

    } else {      
      if ( isCloseBrace(token )) {        
        return(cons(finish_token(prog , start , sub1(len )), cons(boxSymbol(closeBrace ()), scan(prog , add(start , len ), 1 ))));

      } else {        
        if ( isWhiteSpace(stringify(token ))) {          
          return(cons(finish_token(prog , start , sub1(len )), scan(prog , add(start , len ), 1 )));

        } else {          
          if ( equalBox(boxSymbol(";" ), token )) {            
            return(scan(prog , add(start , add1(add1(string_length(readComment(prog , add1(start ), len ))))), 1 ));

          } else {            
            if ( equalBox(boxSymbol("\"" ), token )) {              
              return(cons(boxString(readString(prog , add1(start ), len )), scan(prog , add(start , add1(add1(string_length(readString(prog , add1(start ), len ))))), 1 )));

            } else {              
              return(scan(prog , start , sub(len , -1 )));

            };

          };

        };

      };

    };

  } else {    
    return(emptyList ());

  };
  
  return(emptyList ());

}

bool isOpenBrace(box b ) {
    
  if ( equalBox(boxSymbol(openBrace ()), b )) {    
    return(true );

  } else {    
    if ( equalBox(boxSymbol("[" ), b )) {      
      return(true );

    } else {      
      return(false );

    };

  };

}

char* openBrace() {
    
  return("(" );

}

bool isCloseBrace(box b ) {
    
  if ( equalBox(boxSymbol(closeBrace ()), b )) {    
    return(true );

  } else {    
    if ( equalBox(boxSymbol("]" ), b )) {      
      return(true );

    } else {      
      return(false );

    };

  };

}

char* closeBrace() {
    
  return(")" );

}

list sexprTree(list l ) {
  box b = NULL ;
  
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
        return(cons(b , sexprTree(cdr(l ))));

      };

    };

  };
  
  printf("AAAAAA code should never reach here!\n" );
  
  return(emptyList ());

}

list skipList(list l ) {
  box b = NULL ;
  
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

      };

    };

  };
  
  printf("AAAAAA code should never reach here!\n" );
  
  return(emptyList ());

}

list readSexpr(char* aStr ) {
  list tokens = NULL ;
list as = NULL ;
  
  tokens = emptyList ();
  
  tokens = filterVoid(scan(aStr , 0 , 1 ));
  
  as = sexprTree(tokens );
  
  return(car(as ));

}

void test0() {
    
  if ( equalString(stringify(boxString("hello" )), stringify(boxString("hello" )))) {    
    printf("0.  pass string compare works\n" );

  } else {    
    printf("0.  pass string compare fails\n" );

  };
  
  if ( equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" )))) {    
    printf("0.  pass string compare works\n" );

  } else {    
    printf("0.  pass string compare fails\n" );

  };

}

void test1() {
    
  printf("1.  pass Function call and print work\n" );

}

void test2_do(char* message ) {
    
  printf("2.  pass Function call with arg works: %s\n" , message );

}

void test2() {
    
  test2_do("This is the argument" );

}

void test3_do(int b ,char* c ) {
    
  printf("3.1 pass Two arg call, first arg: %d\n" , b );
  
  printf("3.2 pass Two arg call, second arg: %s\n" , c );

}

void test3() {
    
  test3_do(42 , "Fourty-two" );

}

char* test4_do() {
    
  return("pass Return works" );

}

char* returnThis(char* returnMessage ) {
    
  return(returnMessage );

}

void test4() {
  char* message = "fail" ;
  
  message = test4_do ();
  
  printf("4.  %s\n" , message );

}

void test5() {
  char* message = "fail" ;
  
  message = returnThis("pass return passthrough string" );
  
  printf("5.  %s\n" , message );

}

void test6() {
    
  if ( true ) {    
    printf("6.  pass If statement works\n" );

  } else {    
    printf("6.  fail If statement works\n" );

  };

}

int test7_do(int count ) {
    
  count = sub(count , 1 );
  
  if ( greaterthan(count , 0 )) {    
    count = test7_do(count );

  } else {    
    return(count );

  };
  
  return(count );

}

void test7() {
    
  if ( equal(0 , test7_do(10 ))) {    
    printf("7.  pass count works\n" );

  } else {    
    printf("7.  fail count fails\n" );

  };

}

void beer() {
    
  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );

}

char* plural(int num ) {
    
  if ( equal(num , 1 )) {    
    return("" );

  } else {    
    return("s" );

  };

}

int beers(int count ) {
  int newcount = 0 ;
  
  newcount = sub(count , 1 );
  
  printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , count , plural(count ), count , plural(count ), newcount , plural(newcount ));
  
  if ( greaterthan(count , 1 )) {    
    count = beers(newcount );

  } else {    
    return(count );

  };
  
  return(0 );

}

void test8() {
    
  if ( equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 )) {    
    printf("8.  pass Nested expressions work\n" );

  } else {    
    printf("8.  fail Nested expressions don't work\n" );

  };

}

void test9() {
  int answer = -999999 ;
  
  answer = sub(sub(20 , 1 ), sub(3 , 1 ));
  
  if ( equal(answer , 17 )) {    
    printf("9.  pass arithmetic works\n" );

  } else {    
    printf("9.  fail arithmetic\n" );

  };

}

void test10() {
  char* testString = "This is a test string" ;
  
  if ( equalString(testString , unBoxString(car(cons(boxString(testString ), NULL ))))) {    
    printf("10. pass cons and car work\n" );

  } else {    
    printf("10. fail cons and car fail\n" );

  };

}

void test12() {
  box b = NULL ;
  
  b = malloc(sizeof(Box));
  
  b->str = "12. pass structure accessors\n" ;
  
  printf("%s" , b->str);

}

void test13() {
  char* testString = "Hello from the filesystem!" ;
char* contents = "" ;
  
  write_file("test.txt" , testString );
  
  contents = read_file("test.txt" );
  
  if ( equalString(testString , contents )) {    
    printf("13. pass Read and write files\n" );

  } else {    
    printf("13. fail Read and write files\n" );

  };

}

box caar(list l ) {
    
  return(car(car(l )));

}

box cadr(list l ) {
    
  return(car(cdr(l )));

}

box caddr(list l ) {
    
  return(car(cdr(cdr(l ))));

}

box cadddr(list l ) {
    
  return(car(cdr(cdr(cdr(l )))));

}

box caddddr(list l ) {
    
  return(car(cdr(cdr(cdr(cdr(l ))))));

}

box cddr(list l ) {
    
  return(cdr(cdr(l )));

}

box first(list l ) {
    
  return(car(l ));

}

box second(list l ) {
    
  return(cadr(l ));

}

box third(list l ) {
    
  return(caddr(l ));

}

box fourth(list l ) {
    
  return(cadddr(l ));

}

box fifth(list l ) {
    
  return(caddddr(l ));

}

list makeNode(char* name ,char* subname ,list code ,list children ) {
    
  return(cons(boxSymbol("node" ), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ()))))));

}

list astExpression(list tree ) {
    
  if ( isList(tree )) {    
    return(makeNode("expression" , "expression" , NULL , astSubExpression(tree )));

  } else {    
    return(astSubExpression(tree ));

  };

}

list astSubExpression(list tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());

  } else {    
    if ( isList(tree )) {      
      return(cons(astExpression(car(tree )), astSubExpression(cdr(tree ))));

    } else {      
      return(makeNode("expression" , "leaf" , tree , NULL ));

    };

  };

}

list astIf(list tree ) {
    
  return(makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), NULL ), cons(astBody(cdr(second(tree ))), cons(astBody(cdr(third(tree ))), NULL )))));

}

list astSetStruct(list tree ) {
    
  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));

}

list astSet(list tree ) {
    
  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));

}

list astGetStruct(list tree ) {
    
  return(makeNode("expression" , "structGetter" , tree , NULL ));

}

list astReturnVoid() {
    
  return(makeNode("statement" , "returnvoid" , NULL , NULL ));

}

int length(list l ) {
    
  if ( isEmpty(l )) {    
    return(0 );

  } else {    
    return(add1(length(cdr(l ))));

  };

}

list astStatement(list tree ) {
    
  if ( equalBox(boxString("if" ), car(tree ))) {    
    return(astIf(cdr(tree )));

  } else {    
    if ( equalBox(boxString("set" ), car(tree ))) {      
      return(astSet(cdr(tree )));

    } else {      
      if ( equalBox(boxString("get-struct" ), car(tree ))) {        
        printf("Choosing get-struct statement\n" );
        
        return(astGetStruct(cdr(tree )));

      } else {        
        if ( equalBox(boxString("set-struct" ), car(tree ))) {          
          return(astSetStruct(cdr(tree )));

        } else {          
          if ( equal(length(tree ), 1 )) {            
            if ( equalBox(car(tree ), boxString("return" ))) {              
              return(astReturnVoid ());

            } else {              
              return(makeNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree ))));

            };

          } else {            
            return(makeNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree ))));

          };

        };

      };

    };

  };

}

list astBody(list tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());

  } else {    
    return(cons(astStatement(car(tree )), astBody(cdr(tree ))));

  };

}

list astFunction(list tree ) {
    
  return(cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )))), emptyList ())))))));

}

list astFunctionList(list tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());

  } else {    
    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));

  };

}

list astFunctions(list tree ) {
    
  return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));

}

list loadLib(char* path ) {
  char* programStr = "" ;
list tree = NULL ;
list library = NULL ;
  
  programStr = read_file(path );
  
  tree = readSexpr(programStr );
  
  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  
  return(library );

}

list astInclude(list tree ) {
    
  return(loadLib(stringify(tree )));

}

list astIncludeList(list tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());

  } else {    
    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));

  };

}

list astIncludes(list tree ) {
    
  return(makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree ))));

}

list astStruct(list tree ) {
    
  return(makeNode("type" , "struct" , tree , NULL ));

}

list astType(list tree ) {
    
  if ( isList(cadr(tree ))) {    
    return(astStruct(tree ));

  } else {    
    return(makeNode("type" , "type" , tree , NULL ));

  };

}

list astTypeList(list tree ) {
    
  if ( isEmpty(tree )) {    
    return(emptyList ());

  } else {    
    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));

  };

}

list astTypes(list tree ) {
    
  return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));

}

void ansiFunctionArgs(list tree ) {
    
  if ( isEmpty(tree )) {    
    return ;

  } else {    
    display(ansiTypeMap(first(tree )));
    
    display(second(tree ));
    
    if ( isNil(cddr(tree ))) {      
      printf("" );

    } else {      
      printf("," );

    };
    
    ansiFunctionArgs(cddr(tree ));

  };

}

list declarationsof(list ass ) {
    
  return(cdr(assoc("declarations" , cdr(ass ))));

}

list codeof(list ass ) {
    
  return(cdr(assoc("code" , cdr(ass ))));

}

list nodeof(list ass ) {
    
  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    
    return(boxBool(false ));

  } else {    
    return(cdr(assoc("node" , cdr(ass ))));

  };

}

list subnameof(list ass ) {
    
  return(cdr(assoc("subname" , cdr(ass ))));

}

list nameof(list ass ) {
    
  return(cdr(assoc("name" , cdr(ass ))));

}

list childrenof(list ass ) {
    
  return(cdr(assoc("children" , cdr(ass ))));

}

bool isNode(list val ) {
    
  if ( isEmpty(val )) {    
    return(false );

  } else {    
    if ( isList(val )) {      
      if ( equalBox(boxSymbol("node" ), car(val ))) {        
        return(true );

      } else {        
        return(false );

      };

    } else {      
      return(false );

    };

  };

}

void ansiLeaf(list thisNode ,int indent ) {
    
  display(ansiFuncMap(codeof(thisNode )));

}

void ansiStructGetterExpression(list thisNode ,int indent ) {
    
  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    
    ansiGetStruct(thisNode , indent );

  } else {    
    ansiLeaf(thisNode , indent );

  };

}

void ansiExpression(list node ,int indent ) {
    
  if ( isLeaf(node )) {    
    display(ansiFuncMap(codeof(node )));

  } else {    
    ansiSubExpression(node , indent );

  };

}

void ansiRecurList(list expr ,int indent ) {
    
  if ( isEmpty(expr )) {    
    return ;

  } else {    
    ansiExpression(car(expr ), indent );
    
    if ( isNil(cdr(expr ))) {      
      printf("" );

    } else {      
      printf(", " );
      
      ansiRecurList(cdr(expr ), indent );

    };

  };
  
  return ;

}

bool isLeaf(list n ) {
    
  return(equalBox(boxString("leaf" ), subnameof(n )));

}

void ansiSubExpression(list tree ,int indent ) {
  box thing = NULL ;
  
  if ( isEmpty(tree )) {    
    return ;

  } else {    
    if ( isNode(childrenof(tree ))) {      
      ansiSubExpression(childrenof(tree ), indent );

    } else {      
      if ( isLeaf(tree )) {        
        display(ansiFuncMap(codeof(tree )));

      } else {        
        if ( equal(1 , length(childrenof(tree )))) {          
          display(codeof(car(childrenof(tree ))));
          
          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            
            printf("" );

          } else {            
            printf("()" );

          };

        } else {          
          thing = codeof(car(childrenof(tree )));
          
          if ( equalBox(boxSymbol("get-struct" ), thing )) {            
            printf("%s->%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            
            if ( equalBox(boxSymbol("new" ), thing )) {              
              printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof(tree )))));

            } else {              
              printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof(tree ))))));
              
              ansiRecurList(cdr(childrenof(tree )), indent );
              
              printf(")" );

            };

          };

        };

      };

    };

  };

}

void ansiIf(list node ,int indent ) {
    
  newLine(indent );
  
  printf("if ( " );
  
  ansiExpression(car(first(childrenof(node ))), 0 );
  
  printf(") {" );
  
  ansiBody(second(childrenof(node )), add1(indent ));
  
  newLine(indent );
  
  printf("} else {" );
  
  ansiBody(third(childrenof(node )), add1(indent ));
  
  newLine(indent );
  
  printf("}" );

}

void ansiSetStruct(list node ,int indent ) {
    
  newLine(indent );
  
  printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  
  ansiExpression(childrenof(node ), indent );

}

void ansiGetStruct(list node ,int indent ) {
    
  newLine(indent );
  
  printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

}

void ansiSet(list node ,int indent ) {
    
  newLine(indent );
  
  printf("%s = " , stringify(first(codeof(node ))));
  
  ansiExpression(childrenof(node ), indent );

}

void ansiStatement(list node ,int indent ) {
    
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
          
          printf("return" );

        } else {          
          newLine(indent );
          
          ansiExpression(childrenof(node ), indent );

        };

      };

    };

  };
  
  printf(";\n" );

}

void printIndent(int ii ) {
    
  if ( greaterthan(ii , 0 )) {    
    printf("  " );
    
    printIndent(sub1(ii ));

  } else {    
    return ;

  };

}

void newLine(int indent ) {
    
  printf("\n" );
  
  printIndent(indent );

}

void ansiBody(list tree ,int indent ) {
    
  if ( isEmpty(tree )) {    
    return ;

  } else {    
    printIndent(indent );
    
    ansiStatement(car(tree ), indent );
    
    ansiBody(cdr(tree ), indent );

  };

}

void ansiDeclarations(list decls ,int indent ) {
  box decl = NULL ;
  
  if ( isEmpty(decls )) {    
    return ;

  } else {    
    decl = car(decls );
    
    printf("%s %s = " , stringify(ansiTypeMap(first(decl ))), stringify(second(decl )));
    
    display(ansiFuncMap(third(decl )));
    
    printf(";\n" );
    
    ansiDeclarations(cdr(decls ), indent );

  };

}

void ansiFunction(list node ) {
    
  if ( isNil(node )) {    
    return ;

  } else {    
    newLine(0 );
    
    printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    
    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    
    printf(") {" );
    
    newLine(1 );
    
    ansiDeclarations(declarationsof(node ), 1 );
    
    ansiBody(childrenof(node ), 1 );
    
    printf("\n}\n" );

  };

}

void ansiForwardDeclaration(list node ) {
    
  if ( isNil(node )) {    
    return ;

  } else {    
    printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    
    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    
    printf(");" );

  };

}

void ansiForwardDeclarations(list tree ) {
    
  if ( isEmpty(tree )) {    
    return ;

  } else {    
    ansiForwardDeclaration(car(tree ));
    
    ansiForwardDeclarations(cdr(tree ));

  };

}

void ansiFunctions(list tree ) {
    
  if ( isEmpty(tree )) {    
    return ;

  } else {    
    ansiFunction(car(tree ));
    
    ansiFunctions(cdr(tree ));

  };

}

void ansiIncludes(list nodes ) {
    
  printf("\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nvoid panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f,  data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" );

}

box last(list alist ) {
    
  if ( isEmpty(cdr(alist ))) {    
    return(car(alist ));

  } else {    
    return(last(cdr(alist )));

  };

}

void ansiTypeDecl(list l ) {
    
  if ( greaterthan(length(l ), 2 )) {    
    printIndent(1 );
    
    printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(last(l ))), stringify(first(l )));

  } else {    
    printIndent(1 );
    
    printf("%s %s;\n" , stringify(ansiTypeMap(last(l ))), stringify(car(l )));

  };

}

void ansiStructComponents(list node ) {
    
  if ( isEmpty(node )) {    
    return ;

  } else {    
    ansiTypeDecl(car(node ));
    
    ansiStructComponents(cdr(node ));

  };

}

void ansiStruct(list node ) {
    
  ansiStructComponents(cdr(car(node )));
  
  return ;

}

bool truthy(box aVal ) {
    
  if ( equalBox(boxBool(false ), aVal )) {    
    return(false );

  } else {    
    return(true );

  };

}

box ansiTypeMap(box aSym ) {
  list symMap = NULL ;
  
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  
  if ( truthy(assoc(stringify(aSym ), symMap ))) {    
    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    
    return(aSym );

  };

}

box ansiFuncMap(box aSym ) {
  list symMap = NULL ;
  
  if ( equalString("symbol" , boxType(aSym ))) {    
    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), NULL )))))));
    
    if ( truthy(assoc(stringify(aSym ), symMap ))) {      
      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      
      return(aSym );

    };

  } else {    
    return(aSym );

  };

}

void ansiType(list node ) {
    
  if ( equalBox(subnameof(node ), boxString("struct" ))) {    
    printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));
    
    ansiStruct(cdr(codeof(node )));
    
    printf("\n} %s;\n" , stringify(first(codeof(node ))));

  } else {    
    printf("typedef " );
    
    ansiTypeDecl(codeof(node ));

  };
  
  return ;

}

void ansiTypes(list nodes ) {
    
  if ( isEmpty(nodes )) {    
    return ;

  } else {    
    ansiType(car(nodes ));
    
    ansiTypes(cdr(nodes ));

  };

}

list concatLists(list seq1 ,list seq2 ) {
    
  if ( isNil(seq1 )) {    
    return(seq2 );

  } else {    
    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));

  };

}

list alistKeys(list alist ) {
    
  if ( isNil(alist )) {    
    return(NULL );

  } else {    
    return(cons(car(car(alist )), alistKeys(cdr(alist ))));

  };

}

list mergeIncludes(list program ) {
  list newProgram = NULL ;
list oldfunctionsnode = NULL ;
list oldfunctions = NULL ;
list newfunctions = NULL ;
list newFunctionNode = NULL ;
list functions = NULL ;
  
  if ( greaterthan(length(childrenof(cdr(cdr(assoc("includes" , program ))))), 0 )) {    
    functions = childrenof(cdr(assoc("functions" , car(childrenof(cdr(cdr(assoc("includes" , program ))))))));
    
    oldfunctionsnode = cdr(assoc("functions" , program ));
    
    oldfunctions = childrenof(oldfunctionsnode );
    
    newfunctions = concatLists(functions , oldfunctions );
    
    newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newfunctions , cdr(oldfunctionsnode )));
    
    newProgram = alistCons(boxString("functions" ), newFunctionNode , alistCons(boxString("types" ), cdr(assoc("types" , program )), alistCons(boxString("includes" ), cons(boxSymbol("includes" ), NULL ), newProgram )));
    
    return(newProgram );

  } else {    
    return(program );

  };

}

void compile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;
  
  programStr = read_file(filename );
  
  tree = readSexpr(programStr );
  
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  
  program = mergeIncludes(program );
  
  ansiIncludes(cdr(assoc("includes" , program )));
  
  ansiTypes(childrenof(cdr(assoc("types" , program ))));
  
  printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" );
  
  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  
  printf("\n\n//End forward declarations\n\n" );
  
  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  
  printf("\n" );

}

void test15() {
  char* a = "hello" ;
char* b = " world" ;
char* c = "" ;
  
  c = stringConcatenate(a , b );
  
  if ( equalString(c , "hello world" )) {    
    printf("15. pass String concatenate\n" );

  } else {    
    printf("15. fail String concatenate\n" );

  };

}

void test16() {
  list assocCell1 = NULL ;
list assList = NULL ;
list assocCell2 = NULL ;
list assocCell3 = NULL ;
  
  assocCell1 = cons(boxString("Hello" ), boxString("world" ));
  
  assocCell2 = cons(boxString("goodnight" ), boxString("moon" ));
  
  assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ));
  
  assList = cons(assocCell2 , emptyList ());
  
  assList = cons(assocCell1 , assList );
  
  assList = cons(assocCell3 , assList );
  
  if ( equalBox(cdr(assoc("Hello" , assList )), boxString("world" ))) {    
    printf("16.1 pass Basic assoc works\n" );

  } else {    
    printf("16.1 fail Basic assoc fails\n" );

  };
  
  if ( andBool(andBool(equalBox(cdr(assoc("Hello" , assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , assList )), boxString("gozaimasu" )))) {    
    printf("16.2 pass assoc list\n" );

  } else {    
    printf("16.2 fail assoc list\n" );

  };

}

list argList(int count ,int pos ,char** args ) {
    
  if ( greaterthan(count , pos )) {    
    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));

  } else {    
    return(NULL );

  };

}

list reverse(list l ) {
    
  if ( isEmpty(l )) {    
    return(NULL );

  } else {    
    return(cons(car(l ), reverse(cdr(l ))));

  };

}

int start() {
  bool runTests = false ;
list cmdLine = NULL ;
box filename = NULL ;
  
  cmdLine = reverse(argList(globalArgsCount , 0 , globalArgs ));
  
  printf("//" );
  
  display(cmdLine );
  
  if ( greaterthan(length(cmdLine ), 1 )) {    
    filename = second(cmdLine );

  } else {    
    filename = boxString("test.sexpr" );

  };
  
  display(filename );
  
  runTests = equalBox(boxString("--test" ), filename );
  
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
    
    printf("\n\nAfter all that hard work, I need a beer...\n" );
    
    beers(9 );

  } else {    
    compile(unBoxString(filename ));
    
    printf("\n" );

  };
  
  return(0 );

}


