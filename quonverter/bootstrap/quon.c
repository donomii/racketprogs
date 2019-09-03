//Scanning file...compiler.qon
//Building sexpr
//Building AST
//Merging ASTs
//Printing program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
const char* getEnv(char* key){return getenv(key);}
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
char* setSubString(char* target, int start,char *source){target[start]=source[0]; return target;}
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

char* intToString(int a) {
int len = 100;
char* target = calloc(len,1);
snprintf(target, 99, "%d", a);
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
  if (buffer == NULL) {
  printf("Malloc failed!\n");
  exit(1);
}
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

fprintf(f, "%s", data);

fclose(f);
}

char* getStringArray(int index, char** strs) {
return strs[index];
}

int start();  //Forwards declare the user's main routine
char** globalArgs;
int globalArgsCount;
bool globalTrace = false;
bool globalStepTrace = false;

int main( int argc, char *argv[] )  {
  globalArgs = argv;
  globalArgsCount = argc;

  return start();

}

char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }
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
  struct Box* tag;

} Box;
typedef   Box Pair;
typedef   Box* pair;
typedef   Box* box;
typedef   Box* list;
Box* globalStackTrace = NULL;

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
void stackDump();
void nop();
box car(list l );
list cdr(list l );
bool isList(box b );
list emptyList();
bool isEmpty(box b );
int listLength(list l );
list alistCons(box key ,box value ,list alist );
list assoc(char* searchTerm ,list l );
bool equalBox(box a ,box b );
void displayList(list l ,int indent );
void display(list l );
char* boxType(box b );
box makeBox();
pair makePair();
box boxString(char* s );
box boxSymbol(char* s );
box boxBool(bool boo );
box boxInt(int val );
void assertType(char* atype ,box abox ,int line ,char* file );
char* unBoxString(box b );
char* unBoxSymbol(box b );
bool unBoxBool(box b );
int unBoxInt(box b );
char* stringify_rec(box b );
char* stringify(box b );
bool hasTag(box aBox ,box key );
box getTag(box aBox ,box key );
box getTagFail(box aBox ,box key ,box onFail );
bool assocExists(char* key ,box aBox );
box assocFail(char* key ,box aBox ,box onFail );
box setTag(box key ,list val ,box aStruct );
list filterVoid(list l );
list filterTokens(list l );
box finish_token(char* prog ,int start ,int len ,int line ,int column ,char* filename );
char* readString(char* prog ,int start ,int len );
char* readComment(char* prog ,int start ,int len );
bool isWhiteSpace(char* s );
bool isLineBreak(char* s );
int incForNewLine(box token ,int val );
box annotateReadPosition(char* filename ,int linecount ,int column ,int start ,box newBox );
list scan(char* prog ,int start ,int len ,int linecount ,int column ,char* filename );
bool isOpenBrace(box b );
char* openBrace();
bool isCloseBrace(box b );
char* closeBrace();
list sexprTree(list l );
list skipList(list l );
list readSexpr(char* aStr ,char* filename );
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
list addToNode(box key ,box val ,list node );
list makeStatementNode(char* name ,char* subname ,list code ,list children ,box functionName );
list astExpression(list tree );
list astSubExpression(list tree );
list astIf(list tree ,box fname );
list astSetStruct(list tree );
list astSet(list tree );
list astGetStruct(list tree );
list astReturnVoid(box fname );
list astStatement(list tree ,box fname );
list astBody(list tree ,box fname );
void linePanic(char* line ,char* message );
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
list declarationsof(list ass );
list codeof(list ass );
list functionNameof(list ass );
list nodeof(list ass );
list lineof(list ass );
list subnameof(list ass );
list nameof(list ass );
list childrenof(list ass );
bool isNode(list val );
bool truthy(box aVal );
bool isNotFalse(box aVal );
bool isLeaf(list n );
void printIndent(int ii );
void newLine(int indent );
list noStackTrace();
box toStr(box thing );
box listLast(list alist );
list treeCompile(char* filename );
list astBuild(char* filename );
void astCompile(char* filename );
list concatLists(list seq1 ,list seq2 );
list alistKeys(list alist );
list mergeIncludes(list program );
list merge_recur(list incs ,list program );
list mergeInclude(list inc ,list program );
list macrowalk(list l );
list doBoxList(list l );
list doStringList(list l );
list argList(int count ,int pos ,char** args );
list listReverse(list l );
bool inList(box item ,list l );
void tron();
void troff();
void stron();
void stroff();
list numbers(int num );
char* lexType(box abox );
void perlLeaf(list thisNode ,int indent );
void perlStructGetterExpression(list thisNode ,int indent );
void perlExpression(list node ,int indent );
void perlRecurList(list expr ,int indent );
void perlSubExpression(list tree ,int indent );
void perlIf(list node ,int indent );
void perlSetStruct(list node ,int indent );
void perlGetStruct(list node ,int indent );
void perlSet(list node ,int indent );
void assertNode(list node );
void perlStatement(list node ,int indent );
void perlBody(list tree ,int indent );
void perlDeclarations(list decls ,int indent );
void perlFunction(list node );
void perlForwardDeclaration(list node );
void perlForwardDeclarations(list tree );
void perlFunctions(list tree );
char* dollar();
char* atSym();
void perlIncludes(list nodes );
void perlTypeDecl(list l );
void perlStructComponents(list node );
void perlStruct(list node );
box perlTypeMap(box aSym );
box perlConstMap(box aSym );
box perlFuncMap(box aSym );
void perlType(list node );
void perlTypes(list nodes );
void perlFunctionArgs(list tree );
void perlCompile(char* filename );
void ansiFunctionArgs(list tree );
void ansiLeaf(list thisNode ,int indent );
void ansiStructGetterExpression(list thisNode ,int indent );
void ansiExpression(list node ,int indent );
void ansiRecurList(list expr ,int indent );
void ansiSubExpression(list tree ,int indent );
void ansiIf(list node ,int indent );
void ansiSetStruct(list node ,int indent );
void ansiGetStruct(list node ,int indent );
void ansiSet(list node ,int indent );
void ansiStatement(list node ,int indent );
void ansiBody(list tree ,int indent );
void ansiDeclarations(list decls ,int indent );
void ansiFunction(list node );
void ansiForwardDeclaration(list node );
void ansiForwardDeclarations(list tree );
void ansiFunctions(list tree );
void ansiIncludes(list nodes );
void ansiTypeDecl(list l );
void ansiStructComponents(list node );
void ansiStruct(list node );
box ansiTypeMap(box aSym );
box ansiFuncMap(box aSym );
void ansiType(list node );
void ansiTypes(list nodes );
void uniqueTarget(char* a ,char* b );
void ansiCompile(char* filename );
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
void test15();
void test16();
void test17();
void test18();
list reverseRec(list old ,list new );
void nodeFunctionArgs(list tree );
void nodeLeaf(list thisNode ,int indent );
void nodeStructGetterExpression(list thisNode ,int indent );
void nodeExpression(list node ,int indent );
void nodeRecurList(list expr ,int indent );
void nodeSubExpression(list tree ,int indent );
void nodeIf(list node ,int indent );
void nodeGetStruct(list node ,int indent );
void nodeSet(list node ,int indent );
void nodeSetStruct(list node ,int indent );
void nodeStatement(list node ,int indent );
void nodeBody(list tree ,int indent );
void nodeDeclarations(list decls ,int indent );
void nodeFunction(list node );
void nodeForwardDeclaration(list node );
void nodeForwardDeclarations(list tree );
void nodeFunctions(list tree );
void nodeIncludes(list nodes );
void nodeTypeDecl(list l );
void nodeStructComponents(list node );
void nodeStruct(list node );
box nodeTypeMap(box aSym );
box nodeFuncMap(box aSym );
void nodeType(list node );
void nodeTypes(list nodes );
void nodeCompile(char* filename );
void javaFunctionArgs(list tree );
void javaLeaf(list thisNode ,int indent );
void javaStructGetterExpression(list thisNode ,int indent );
void javaExpression(list node ,int indent );
void javaRecurList(list expr ,int indent );
void javaSubExpression(list tree ,int indent );
void javaIf(list node ,int indent );
void javaSetStruct(list node ,int indent );
void javaGetStruct(list node ,int indent );
void javaSet(list node ,int indent );
void javaStatement(list node ,int indent );
void javaBody(list tree ,int indent );
void javaDeclarations(list decls ,int indent );
void javaFunction(list node );
void javaFunctions(list tree );
void javaIncludes(list nodes );
void javaTypeDecl(list l );
void javaStructComponents(list node );
void javaStruct(list node );
box javaTypeMap(box aSym );
box javaTypesNoDeclare();
box javaFuncMap(box aSym );
void javaType(list node );
void javaTypes(list nodes );
void javaCompile(char* filename );
int start();

//End forward declarations



//Building function add from line: 19

int add(int a ,int b ) {
  
if (globalTrace)
    printf("add at base.qon:19\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(sub(a , sub(0 , b )));

if (globalTrace)
    printf("Leaving add\n");

}


//Building function addf from line: 20

float addf(float a ,float b ) {
  
if (globalTrace)
    printf("addf at base.qon:20\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(subf(a , subf(0 , b )));

if (globalTrace)
    printf("Leaving addf\n");

}


//Building function sub1 from line: 21

int sub1(int a ) {
  
if (globalTrace)
    printf("sub1 at base.qon:21\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(sub(a , 1 ));

if (globalTrace)
    printf("Leaving sub1\n");

}


//Building function add1 from line: 22

int add1(int a ) {
  
if (globalTrace)
    printf("add1 at base.qon:22\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(add(a , 1 ));

if (globalTrace)
    printf("Leaving add1\n");

}


//Building function clone from line: 24

box clone(box b ) {
  box newb = NULL ;

if (globalTrace)
    printf("clone at base.qon:24\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb = makeBox ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->typ = b->typ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->tag = b->tag;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->lis = b->lis;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->str = b->str;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->i = b->i;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->lengt = b->lengt;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(newb );

if (globalTrace)
    printf("Leaving clone\n");

}


//Building function newVoid from line: 38

box newVoid() {
  box newb = NULL ;

if (globalTrace)
    printf("newVoid at base.qon:38\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb = makeBox ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->voi = true ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->typ = "void" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(newb );

if (globalTrace)
    printf("Leaving newVoid\n");

}


//Building function cons from line: 47

list cons(box data ,list l ) {
  pair p = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p = makePair ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->cdr = l ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->car = data ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->typ = "list" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(p );

}


//Building function stackDump from line: 55

void stackDump() {
  
if (globalTrace)
    printf("stackDump at base.qon:55\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("" );

if (globalTrace)
    printf("Leaving stackDump\n");

}


//Building function nop from line: 60

void nop() {
  
if (globalTrace)
    printf("nop at base.qon:60\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("" );

if (globalTrace)
    printf("Leaving nop\n");

}


//Building function car from line: 63

box car(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l , 65 , "base.qon" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Cannot call car on empty list!\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Cannot call car on empty list!\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(l->car)) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(NULL );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(l->car);

    };

  };

}


//Building function cdr from line: 76

list cdr(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l , 78 , "base.qon" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Attempt to cdr an empty list!!!!\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Attempt to cdr an empty list!!!!\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(l->cdr);

  };

}


//Building function isList from line: 86

bool isList(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(equalString("list" , b->typ));

  };

}


//Building function emptyList from line: 93

list emptyList() {
  
if (globalTrace)
    printf("emptyList at base.qon:93\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(NULL );

if (globalTrace)
    printf("Leaving emptyList\n");

}


//Building function isEmpty from line: 95

bool isEmpty(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  };

}


//Building function listLength from line: 101

int listLength(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(0 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(listLength(cdr(l ))));

  };

}


//Building function alistCons from line: 110

list alistCons(box key ,box value ,list alist ) {
  
if (globalTrace)
    printf("alistCons at base.qon:110\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(cons(key , value ), alist ));

if (globalTrace)
    printf("Leaving alistCons\n");

}


//Building function assoc from line: 113

list assoc(char* searchTerm ,list l ) {
  list elem = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l , 115 , "base.qon" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    elem = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    assertType("list" , elem , 121 , "base.qon" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isEmpty(elem )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(assoc(searchTerm , cdr(l )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( false ) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("Comparing %s and %s\n" , searchTerm , stringify(car(elem )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("" );

      };
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString(searchTerm , stringify(car(elem )))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(elem );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(assoc(searchTerm , cdr(l )));

      };

    };

  };

}


//Building function equalBox from line: 132

bool equalBox(box a ,box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("string" , boxType(a ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(equalString(unBoxString(a ), stringify(b )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("bool" , boxType(a ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(andBool(unBoxBool(a ), unBoxBool(b )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalString("symbol" , boxType(a ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalString("symbol" , boxType(b ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(equalString(unBoxSymbol(a ), unBoxSymbol(b )));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(false );

          };

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalString("int" , boxType(a ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(equal(unBoxInt(a ), unBoxInt(b )));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(false );

          };

        };

      };

    };

  };

}


//Building function displayList from line: 153

void displayList(list l ,int indent ) {
  box val = NULL ;

if (globalTrace)
    printf("displayList at base.qon:153\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(l )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isEmpty(l )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return;

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        val = car(l );
        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( isList(val )) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("%s" , openBrace ());
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          displayList(car(l ), add1(indent ));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("%s" , closeBrace ());
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          displayList(cdr(l ), indent );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalString("string" , val->typ)) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("\"%s\" " , unBoxString(val ));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("%s " , stringify(val ));

          };
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          displayList(cdr(l ), indent );

        };

      };

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("string" , l->typ)) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("\"%s\" " , unBoxString(l ));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("%s " , stringify(l ));

      };

    };

  };

if (globalTrace)
    printf("Leaving displayList\n");

}


//Building function display from line: 181

void display(list l ) {
  
if (globalTrace)
    printf("display at base.qon:181\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("nil " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(l )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("[" );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      displayList(l , 0 );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("]" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      displayList(l , 0 );

    };

  };

if (globalTrace)
    printf("Leaving display\n");

}


//Building function boxType from line: 193

char* boxType(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->typ);

}


//Building function makeBox from line: 194

box makeBox() {
  box b = NULL ;

if (globalTrace)
    printf("makeBox at base.qon:194\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->tag = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->car = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->cdr = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->lis = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "None - error!" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

if (globalTrace)
    printf("Leaving makeBox\n");

}


//Building function makePair from line: 205

pair makePair() {
  
if (globalTrace)
    printf("makePair at base.qon:205\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeBox ());

if (globalTrace)
    printf("Leaving makePair\n");

}


//Building function boxString from line: 211

box boxString(char* s ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = makeBox ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->str = s ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->lengt = string_length(s );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "string" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function boxSymbol from line: 221

box boxSymbol(char* s ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = boxString(s );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "symbol" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function boxBool from line: 230

box boxBool(bool boo ) {
  box b = NULL ;

if (globalTrace)
    printf("boxBool at base.qon:230\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = makeBox ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->boo = boo ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "bool" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

if (globalTrace)
    printf("Leaving boxBool\n");

}


//Building function boxInt from line: 239

box boxInt(int val ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = makeBox ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->i = val ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "int" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function assertType from line: 248

void assertType(char* atype ,box abox ,int line ,char* file ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(abox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString(atype , "nil" )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return;

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return;

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString(atype , boxType(abox ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return;

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("Assertion failure at line %d, in file %s: provided value is not a '%s'!  It was actually (%s):" , line , file , atype , abox->typ);
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      display(abox );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      panic("Invalid type!" );

    };

  };

}


//Building function unBoxString from line: 260

char* unBoxString(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("string" , b , 261 , "base.qon" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

}


//Building function unBoxSymbol from line: 263

char* unBoxSymbol(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

}


//Building function unBoxBool from line: 264

bool unBoxBool(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->boo);

}


//Building function unBoxInt from line: 265

int unBoxInt(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->i);

}


//Building function stringify_rec from line: 267

char* stringify_rec(box b ) {
  
if (globalTrace)
    printf("stringify_rec at base.qon:267\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringify_rec(cdr(b )))));

  };

if (globalTrace)
    printf("Leaving stringify_rec\n");

}


//Building function stringify from line: 279

char* stringify(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("()" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("string" , boxType(b ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(unBoxString(b ));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("bool" , boxType(b ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( unBoxBool(b )) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return("true" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return("false" );

        };

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalString("int" , boxType(b ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(intToString(unBoxInt(b )));

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalString("symbol" , boxType(b ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(unBoxSymbol(b ));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalString("list" , boxType(b ))) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(stringConcatenate("(" , stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringConcatenate(stringify_rec(cdr(b )), ")" )))));

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(stringConcatenate("Unsupported type: " , boxType(b )));

            };

          };

        };

      };

    };

  };

}


//Building function hasTag from line: 310

bool hasTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("hasTag at base.qon:310\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(isNotFalse(assoc(stringify(key ), aBox->tag)));

  };

if (globalTrace)
    printf("Leaving hasTag\n");

}


//Building function getTag from line: 316

box getTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("getTag at base.qon:316\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( false ) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Getting %s from: " , stringify(key ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(alistKeys(aBox->tag));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc(stringify(key ), aBox->tag)));

if (globalTrace)
    printf("Leaving getTag\n");

}


//Building function getTagFail from line: 328

box getTagFail(box aBox ,box key ,box onFail ) {
  
if (globalTrace)
    printf("getTagFail at base.qon:328\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( hasTag(aBox , key )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(getTag(aBox , key ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(onFail );

  };

if (globalTrace)
    printf("Leaving getTagFail\n");

}


//Building function assocExists from line: 334

bool assocExists(char* key ,box aBox ) {
  
if (globalTrace)
    printf("assocExists at base.qon:334\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(isNotFalse(assoc(key , aBox )));

  };

if (globalTrace)
    printf("Leaving assocExists\n");

}


//Building function assocFail from line: 342

box assocFail(char* key ,box aBox ,box onFail ) {
  
if (globalTrace)
    printf("assocFail at base.qon:342\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( assocExists(key , aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(assoc(key , aBox ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(key ), onFail ));

  };

if (globalTrace)
    printf("Leaving assocFail\n");

}


//Building function setTag from line: 350

box setTag(box key ,list val ,box aStruct ) {
  
if (globalTrace)
    printf("setTag at base.qon:350\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  aStruct->tag = alistCons(key , val , aStruct->tag);
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(aStruct );

if (globalTrace)
    printf("Leaving setTag\n");

}


//Building function filterVoid from line: 360

list filterVoid(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterVoid at base.qon:360\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("void" , token->typ)) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(filterVoid(cdr(l )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(token , filterVoid(cdr(l ))));

    };

  };

if (globalTrace)
    printf("Leaving filterVoid\n");

}


//Building function filterTokens from line: 372

list filterTokens(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterTokens at base.qon:372\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString(boxType(token ), "symbol" )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("__LINE__" , stringify(token ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(cons(getTagFail(token , boxString("line" ), boxInt(-1 )), filterTokens(cdr(l ))));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalString("__COLUMN__" , stringify(token ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(cons(getTagFail(token , boxString("column" ), boxInt(-1 )), filterTokens(cdr(l ))));

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalString("__FILE__" , stringify(token ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(cons(getTagFail(token , boxString("filename" ), boxString("Unknown file" )), filterTokens(cdr(l ))));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(cons(token , filterTokens(cdr(l ))));

          };

        };

      };

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(token , filterTokens(cdr(l ))));

    };

  };

if (globalTrace)
    printf("Leaving filterTokens\n");

}


//Building function finish_token from line: 406

box finish_token(char* prog ,int start ,int len ,int line ,int column ,char* filename ) {
  box token = NULL ;

if (globalTrace)
    printf("finish_token at base.qon:406\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(len , 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token = boxSymbol(sub_string(prog , start , len ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token->tag = alistCons(boxString("filename" ), boxString(filename ), alistCons(boxString("column" ), boxInt(column ), alistCons(boxString("line" ), boxInt(line ), alistCons(boxString("totalCharPos" ), boxInt(start ), NULL ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(token );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(newVoid ());

  };

if (globalTrace)
    printf("Leaving finish_token\n");

}


//Building function readString from line: 421

char* readString(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readString at base.qon:421\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  token = sub_string(prog , sub1(add(start , len )), 1 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("\"" , token )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(sub_string(prog , start , sub1(len )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("\\" , token )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(readString(prog , start , add(2 , len )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(readString(prog , start , add1(len )));

    };

  };

if (globalTrace)
    printf("Leaving readString\n");

}


//Building function readComment from line: 432

char* readComment(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readComment at base.qon:432\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  token = sub_string(prog , sub1(add(start , len )), 1 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLineBreak(token )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(sub_string(prog , start , sub1(len )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(readComment(prog , start , add1(len )));

  };

if (globalTrace)
    printf("Leaving readComment\n");

}


//Building function isWhiteSpace from line: 440

bool isWhiteSpace(char* s ) {
  
if (globalTrace)
    printf("isWhiteSpace at base.qon:440\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(" " , s )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("\t" , s )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("\n" , s )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(true );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalString("\r" , s )) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(true );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(false );

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving isWhiteSpace\n");

}


//Building function isLineBreak from line: 457

bool isLineBreak(char* s ) {
  
if (globalTrace)
    printf("isLineBreak at base.qon:457\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("\n" , s )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("\r" , s )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  };

if (globalTrace)
    printf("Leaving isLineBreak\n");

}


//Building function incForNewLine from line: 464

int incForNewLine(box token ,int val ) {
  
if (globalTrace)
    printf("incForNewLine at base.qon:464\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("\n" , stringify(token ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(val ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(val );

  };

if (globalTrace)
    printf("Leaving incForNewLine\n");

}


//Building function annotateReadPosition from line: 471

box annotateReadPosition(char* filename ,int linecount ,int column ,int start ,box newBox ) {
  
if (globalTrace)
    printf("annotateReadPosition at base.qon:471\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(setTag(boxString("filename" ), boxString(filename ), setTag(boxString("column" ), boxInt(column ), setTag(boxString("line" ), boxInt(linecount ), setTag(boxString("totalCharPos" ), boxInt(start ), newBox )))));

if (globalTrace)
    printf("Leaving annotateReadPosition\n");

}


//Building function scan from line: 483

list scan(char* prog ,int start ,int len ,int linecount ,int column ,char* filename ) {
  box token = NULL ;
char* newString = "" ;
box newBox = NULL ;

if (globalTrace)
    printf("scan at base.qon:483\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( false ) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Scanning: line %d:%d\n" , linecount , column );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(string_length(prog ), sub(start , sub(0 , len )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token = boxSymbol(sub_string(prog , sub1(add(start , len )), 1 ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    token->tag = alistCons(boxString("totalCharPos" ), boxInt(start ), NULL );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isOpenBrace(token )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(boxSymbol(openBrace ()), scan(prog , add1(start ), 1 , linecount , add1(column ), filename ))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isCloseBrace(token )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(annotateReadPosition(filename , linecount , column , start , boxSymbol(closeBrace ())), scan(prog , add(start , len ), 1 , linecount , add1(column ), filename ))));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( isWhiteSpace(stringify(token ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), scan(prog , add(start , len ), 1 , incForNewLine(token , linecount ), 0 , filename )));

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol(";" ), token )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(scan(prog , add(start , add1(add1(string_length(readComment(prog , add1(start ), len ))))), 1 , add1(linecount ), 0 , filename ));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("\"" ), token )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              newString = readString(prog , add1(start ), len );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              newBox = annotateReadPosition(filename , linecount , column , start , boxString(newString ));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(cons(newBox , scan(prog , add(start , add1(add1(string_length(newString )))), 1 , linecount , add1(column ), filename )));

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(scan(prog , start , sub(len , -1 ), linecount , add1(column ), filename ));

            };

          };

        };

      };

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  };

if (globalTrace)
    printf("Leaving scan\n");

}


//Building function isOpenBrace from line: 523

bool isOpenBrace(box b ) {
  
if (globalTrace)
    printf("isOpenBrace at base.qon:523\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxSymbol(openBrace ()), b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxSymbol("[" ), b )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  };

if (globalTrace)
    printf("Leaving isOpenBrace\n");

}


//Building function openBrace from line: 531

char* openBrace() {
  
if (globalTrace)
    printf("openBrace at base.qon:531\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("(" );

if (globalTrace)
    printf("Leaving openBrace\n");

}


//Building function isCloseBrace from line: 533

bool isCloseBrace(box b ) {
  
if (globalTrace)
    printf("isCloseBrace at base.qon:533\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxSymbol(closeBrace ()), b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxSymbol("]" ), b )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  };

if (globalTrace)
    printf("Leaving isCloseBrace\n");

}


//Building function closeBrace from line: 543

char* closeBrace() {
  
if (globalTrace)
    printf("closeBrace at base.qon:543\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(")" );

if (globalTrace)
    printf("Leaving closeBrace\n");

}


//Building function sexprTree from line: 545

list sexprTree(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("sexprTree at base.qon:545\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    b = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isOpenBrace(b )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(sexprTree(cdr(l )), sexprTree(skipList(cdr(l )))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isCloseBrace(b )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(emptyList ());

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(setTag(boxString("line" ), getTagFail(b , boxString("line" ), boxInt(-1 )), cons(b , sexprTree(cdr(l )))));

      };

    };

  };

if (globalTrace)
    printf("Leaving sexprTree\n");

}


//Building function skipList from line: 564

list skipList(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("skipList at base.qon:564\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    b = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isOpenBrace(b )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(skipList(skipList(cdr(l ))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isCloseBrace(b )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(cdr(l ));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(skipList(cdr(l )));

      };

    };

  };

if (globalTrace)
    printf("Leaving skipList\n");

}


//Building function readSexpr from line: 579

list readSexpr(char* aStr ,char* filename ) {
  list tokens = NULL ;
list as = NULL ;

if (globalTrace)
    printf("readSexpr at base.qon:579\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tokens = emptyList ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tokens = filterTokens(filterVoid(scan(aStr , 0 , 1 , 0 , 0 , filename )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  as = sexprTree(tokens );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(as ));

if (globalTrace)
    printf("Leaving readSexpr\n");

}


//Building function caar from line: 589

box caar(list l ) {
  
if (globalTrace)
    printf("caar at base.qon:589\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(car(l )));

if (globalTrace)
    printf("Leaving caar\n");

}


//Building function cadr from line: 590

box cadr(list l ) {
  
if (globalTrace)
    printf("cadr at base.qon:590\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(l )));

if (globalTrace)
    printf("Leaving cadr\n");

}


//Building function caddr from line: 591

box caddr(list l ) {
  
if (globalTrace)
    printf("caddr at base.qon:591\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(l ))));

if (globalTrace)
    printf("Leaving caddr\n");

}


//Building function cadddr from line: 592

box cadddr(list l ) {
  
if (globalTrace)
    printf("cadddr at base.qon:592\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(l )))));

if (globalTrace)
    printf("Leaving cadddr\n");

}


//Building function caddddr from line: 593

box caddddr(list l ) {
  
if (globalTrace)
    printf("caddddr at base.qon:593\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(cdr(l ))))));

if (globalTrace)
    printf("Leaving caddddr\n");

}


//Building function cddr from line: 594

box cddr(list l ) {
  
if (globalTrace)
    printf("cddr at base.qon:594\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(cdr(l )));

if (globalTrace)
    printf("Leaving cddr\n");

}


//Building function first from line: 595

box first(list l ) {
  
if (globalTrace)
    printf("first at base.qon:595\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(l ));

if (globalTrace)
    printf("Leaving first\n");

}


//Building function second from line: 596

box second(list l ) {
  
if (globalTrace)
    printf("second at base.qon:596\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadr(l ));

if (globalTrace)
    printf("Leaving second\n");

}


//Building function third from line: 597

box third(list l ) {
  
if (globalTrace)
    printf("third at base.qon:597\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddr(l ));

if (globalTrace)
    printf("Leaving third\n");

}


//Building function fourth from line: 598

box fourth(list l ) {
  
if (globalTrace)
    printf("fourth at base.qon:598\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadddr(l ));

if (globalTrace)
    printf("Leaving fourth\n");

}


//Building function fifth from line: 599

box fifth(list l ) {
  
if (globalTrace)
    printf("fifth at base.qon:599\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddddr(l ));

if (globalTrace)
    printf("Leaving fifth\n");

}


//Building function makeNode from line: 605

list makeNode(char* name ,char* subname ,list code ,list children ) {
  
if (globalTrace)
    printf("makeNode at base.qon:605\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ())))))));

if (globalTrace)
    printf("Leaving makeNode\n");

}


//Building function addToNode from line: 621

list addToNode(box key ,box val ,list node ) {
  
if (globalTrace)
    printf("addToNode at base.qon:621\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxSymbol("node" ), alistCons(key , val , cdr(node ))));

if (globalTrace)
    printf("Leaving addToNode\n");

}


//Building function makeStatementNode from line: 626

list makeStatementNode(char* name ,char* subname ,list code ,list children ,box functionName ) {
  
if (globalTrace)
    printf("makeStatementNode at base.qon:626\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(addToNode(boxSymbol("functionName" ), functionName , makeNode(name , subname , code , children )));

if (globalTrace)
    printf("Leaving makeStatementNode\n");

}


//Building function astExpression from line: 631

list astExpression(list tree ) {
  
if (globalTrace)
    printf("astExpression at base.qon:631\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("expression" , "expression" , NULL , astSubExpression(tree )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astSubExpression(tree ));

  };

if (globalTrace)
    printf("Leaving astExpression\n");

}


//Building function astSubExpression from line: 639

list astSubExpression(list tree ) {
  
if (globalTrace)
    printf("astSubExpression at base.qon:639\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(tree )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(astExpression(car(tree )), astSubExpression(cdr(tree ))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(makeNode("expression" , "leaf" , tree , NULL ));

    };

  };

if (globalTrace)
    printf("Leaving astSubExpression\n");

}


//Building function astIf from line: 650

list astIf(list tree ,box fname ) {
  
if (globalTrace)
    printf("astIf at base.qon:650\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("then" ), car(second(tree )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nop ();

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Error at %s:%s!  If statement is missing the true branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Missing true branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("else" ), car(third(tree )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nop ();

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("Error at %s:%s!  If statement is missing the false branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Missing false branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), NULL ), cons(astBody(cdr(second(tree )), fname ), cons(astBody(cdr(third(tree )), fname ), NULL )))));

if (globalTrace)
    printf("Leaving astIf\n");

}


//Building function astSetStruct from line: 671

list astSetStruct(list tree ) {
  
if (globalTrace)
    printf("astSetStruct at base.qon:671\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));

if (globalTrace)
    printf("Leaving astSetStruct\n");

}


//Building function astSet from line: 676

list astSet(list tree ) {
  
if (globalTrace)
    printf("astSet at base.qon:676\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));

if (globalTrace)
    printf("Leaving astSet\n");

}


//Building function astGetStruct from line: 681

list astGetStruct(list tree ) {
  
if (globalTrace)
    printf("astGetStruct at base.qon:681\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("expression" , "structGetter" , tree , NULL ));

if (globalTrace)
    printf("Leaving astGetStruct\n");

}


//Building function astReturnVoid from line: 684

list astReturnVoid(box fname ) {
  
if (globalTrace)
    printf("astReturnVoid at base.qon:684\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeStatementNode("statement" , "returnvoid" , NULL , NULL , fname ));

if (globalTrace)
    printf("Leaving astReturnVoid\n");

}


//Building function astStatement from line: 688

list astStatement(list tree ,box fname ) {
  
if (globalTrace)
    printf("astStatement at base.qon:688\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("if" ), car(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astIf(cdr(tree ), fname ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxString("set" ), car(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(astSet(cdr(tree )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxString("get-struct" ), car(tree ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("Choosing get-struct statement\n" );
        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(astGetStruct(cdr(tree )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalBox(boxString("set-struct" ), car(tree ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(astSetStruct(cdr(tree )));

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), car(tree ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equal(listLength(tree ), 1 )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(astReturnVoid(fname ));

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(makeStatementNode("statement" , "return" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));

            };

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(makeStatementNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname ));

          };

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving astStatement\n");

}


//Building function astBody from line: 718

list astBody(list tree ,box fname ) {
  
if (globalTrace)
    printf("astBody at base.qon:718\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astStatement(car(tree ), fname ), astBody(cdr(tree ), fname )));

  };

if (globalTrace)
    printf("Leaving astBody\n");

}


//Building function linePanic from line: 724

void linePanic(char* line ,char* message ) {
  
if (globalTrace)
    printf("linePanic at base.qon:724\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("line %s: %s\n" , line , message );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  panic(message );

if (globalTrace)
    printf("Leaving linePanic\n");

}


//Building function astFunction from line: 730

list astFunction(list tree ) {
  char* line = "" ;
char* file = "" ;
box fname = NULL ;

if (globalTrace)
    printf("astFunction at base.qon:730\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  fname = second(tree );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  line = stringify(getTag(fname , boxString("line" )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  file = stringify(getTag(fname , boxString("filename" )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(1 , listLength(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    linePanic(line , "Malformed function, seems to be empty" );

  } else {
  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(2 , listLength(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    linePanic(line , "Malformed function, expected function name" );

  } else {
  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(3 , listLength(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    linePanic(line , "Malformed function, expected argument list" );

  } else {
  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(4 , listLength(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    linePanic(line , "Malformed function, expected variable declarations" );

  } else {
  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(5 , listLength(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    linePanic(line , "Malformed function, expected body" );

  } else {
  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )), fname )), emptyList ()))))))));

if (globalTrace)
    printf("Leaving astFunction\n");

}


//Building function astFunctionList from line: 760

list astFunctionList(list tree ) {
  
if (globalTrace)
    printf("astFunctionList at base.qon:760\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astFunctionList\n");

}


//Building function astFunctions from line: 768

list astFunctions(list tree ) {
  
if (globalTrace)
    printf("astFunctions at base.qon:768\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("functions" ), car(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Functions section not found!  Every program must have a function section, even if you don't define any functions, although that is a rather pointless program.  Your function section should look like:'\n\n(return_type function_name (arg1 arg2 arg3 ...) (declare types) (body (statement)(statement)))\n\n\nThe function section must be directly after the types section." );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving astFunctions\n");

}


//Building function loadLib from line: 776

list loadLib(char* path ) {
  char* programStr = "" ;
list tree = NULL ;
list library = NULL ;

if (globalTrace)
    printf("loadLib at base.qon:776\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = macrowalk(tree );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(library );

if (globalTrace)
    printf("Leaving loadLib\n");

}


//Building function astInclude from line: 792

list astInclude(list tree ) {
  
if (globalTrace)
    printf("astInclude at base.qon:792\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(loadLib(stringify(tree )));

if (globalTrace)
    printf("Leaving astInclude\n");

}


//Building function astIncludeList from line: 795

list astIncludeList(list tree ) {
  
if (globalTrace)
    printf("astIncludeList at base.qon:795\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astIncludeList\n");

}


//Building function astIncludes from line: 802

list astIncludes(list tree ) {
  
if (globalTrace)
    printf("astIncludes at base.qon:802\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("includes" ), car(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving astIncludes\n");

}


//Building function astStruct from line: 810

list astStruct(list tree ) {
  
if (globalTrace)
    printf("astStruct at base.qon:810\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("type" , "struct" , tree , NULL ));

if (globalTrace)
    printf("Leaving astStruct\n");

}


//Building function astType from line: 813

list astType(list tree ) {
  
if (globalTrace)
    printf("astType at base.qon:813\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(cadr(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astStruct(tree ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("type" , "type" , tree , NULL ));

  };

if (globalTrace)
    printf("Leaving astType\n");

}


//Building function astTypeList from line: 819

list astTypeList(list tree ) {
  
if (globalTrace)
    printf("astTypeList at base.qon:819\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astTypeList\n");

}


//Building function astTypes from line: 825

list astTypes(list tree ) {
  
if (globalTrace)
    printf("astTypes at base.qon:825\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("types" ), car(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Types section not found!  Every program must have a types section, even if you don't define any types" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxString("Fuck java" ));

  };

if (globalTrace)
    printf("Leaving astTypes\n");

}


//Building function declarationsof from line: 835

list declarationsof(list ass ) {
  
if (globalTrace)
    printf("declarationsof at base.qon:835\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("declarations" , cdr(ass ))));

if (globalTrace)
    printf("Leaving declarationsof\n");

}


//Building function codeof from line: 838

list codeof(list ass ) {
  
if (globalTrace)
    printf("codeof at base.qon:838\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("code" , cdr(ass ))));

if (globalTrace)
    printf("Leaving codeof\n");

}


//Building function functionNameof from line: 841

list functionNameof(list ass ) {
  
if (globalTrace)
    printf("functionNameof at base.qon:841\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("functionName" , cdr(ass ))));

if (globalTrace)
    printf("Leaving functionNameof\n");

}


//Building function nodeof from line: 844

list nodeof(list ass ) {
  
if (globalTrace)
    printf("nodeof at base.qon:844\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("node" , cdr(ass ))));

  };

if (globalTrace)
    printf("Leaving nodeof\n");

}


//Building function lineof from line: 850

list lineof(list ass ) {
  
if (globalTrace)
    printf("lineof at base.qon:850\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("line" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxInt(-1 ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("line" , cdr(ass ))));

  };

if (globalTrace)
    printf("Leaving lineof\n");

}


//Building function subnameof from line: 856

list subnameof(list ass ) {
  
if (globalTrace)
    printf("subnameof at base.qon:856\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("subname" , cdr(ass ))));

if (globalTrace)
    printf("Leaving subnameof\n");

}


//Building function nameof from line: 859

list nameof(list ass ) {
  
if (globalTrace)
    printf("nameof at base.qon:859\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("name" , cdr(ass ))));

if (globalTrace)
    printf("Leaving nameof\n");

}


//Building function childrenof from line: 862

list childrenof(list ass ) {
  
if (globalTrace)
    printf("childrenof at base.qon:862\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("children" , cdr(ass ))));

if (globalTrace)
    printf("Leaving childrenof\n");

}


//Building function isNode from line: 866

bool isNode(list val ) {
  
if (globalTrace)
    printf("isNode at base.qon:866\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(val )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(val )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxSymbol("node" ), car(val ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(true );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(false );

      };

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  };

if (globalTrace)
    printf("Leaving isNode\n");

}


//Building function truthy from line: 880

bool truthy(box aVal ) {
  
if (globalTrace)
    printf("truthy at base.qon:880\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(isNotFalse(aVal ));

if (globalTrace)
    printf("Leaving truthy\n");

}


//Building function isNotFalse from line: 884

bool isNotFalse(box aVal ) {
  
if (globalTrace)
    printf("isNotFalse at base.qon:884\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(boxType(aVal ), "bool" )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( unBoxBool(aVal )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  };

if (globalTrace)
    printf("Leaving isNotFalse\n");

}


//Building function isLeaf from line: 891

bool isLeaf(list n ) {
  
if (globalTrace)
    printf("isLeaf at base.qon:891\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(equalBox(boxString("leaf" ), subnameof(n )));

if (globalTrace)
    printf("Leaving isLeaf\n");

}


//Building function printIndent from line: 896

void printIndent(int ii ) {
  
if (globalTrace)
    printf("printIndent at base.qon:896\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(ii , 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("  " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(sub1(ii ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  };

if (globalTrace)
    printf("Leaving printIndent\n");

}


//Building function newLine from line: 904

void newLine(int indent ) {
  
if (globalTrace)
    printf("newLine at base.qon:904\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printIndent(indent );

if (globalTrace)
    printf("Leaving newLine\n");

}


//Building function noStackTrace from line: 908

list noStackTrace() {
  
if (globalTrace)
    printf("noStackTrace at base.qon:908\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), NULL ))))))))))))))))))))))))));

if (globalTrace)
    printf("Leaving noStackTrace\n");

}


//Building function toStr from line: 937

box toStr(box thing ) {
  
if (globalTrace)
    printf("toStr at base.qon:937\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(boxString(stringify(thing )));

if (globalTrace)
    printf("Leaving toStr\n");

}


//Building function listLast from line: 940

box listLast(list alist ) {
  
if (globalTrace)
    printf("listLast at base.qon:940\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(cdr(alist ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(car(alist ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(listLast(cdr(alist )));

  };

if (globalTrace)
    printf("Leaving listLast\n");

}


//Building function treeCompile from line: 947

list treeCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("treeCompile at base.qon:947\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(tree );

if (globalTrace)
    printf("Leaving treeCompile\n");

}


//Building function astBuild from line: 953

list astBuild(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("astBuild at base.qon:953\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(program );

if (globalTrace)
    printf("Leaving astBuild\n");

}


//Building function astCompile from line: 970

void astCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("astCompile at base.qon:970\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = astBuild(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );

if (globalTrace)
    printf("Leaving astCompile\n");

}


//Building function concatLists from line: 977

list concatLists(list seq1 ,list seq2 ) {
  
if (globalTrace)
    printf("concatLists at base.qon:977\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(seq1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(seq2 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));

  };

if (globalTrace)
    printf("Leaving concatLists\n");

}


//Building function alistKeys from line: 983

list alistKeys(list alist ) {
  
if (globalTrace)
    printf("alistKeys at base.qon:983\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(alist )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(car(alist )), alistKeys(cdr(alist ))));

  };

if (globalTrace)
    printf("Leaving alistKeys\n");

}


//Building function mergeIncludes from line: 989

list mergeIncludes(list program ) {
  
if (globalTrace)
    printf("mergeIncludes at base.qon:989\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program ));

if (globalTrace)
    printf("Leaving mergeIncludes\n");

}


//Building function merge_recur from line: 996

list merge_recur(list incs ,list program ) {
  
if (globalTrace)
    printf("merge_recur at base.qon:996\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(incs ), 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(mergeInclude(car(incs ), merge_recur(cdr(incs ), program )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(program );

  };

if (globalTrace)
    printf("Leaving merge_recur\n");

}


//Building function mergeInclude from line: 1004

list mergeInclude(list inc ,list program ) {
  list newProgram = NULL ;
list oldfunctionsnode = NULL ;
list oldfunctions = NULL ;
list newfunctions = NULL ;
list newFunctionNode = NULL ;
list functions = NULL ;
list oldtypesnode = NULL ;
list oldtypes = NULL ;
list newtypes = NULL ;
list newTypeNode = NULL ;
list types = NULL ;

if (globalTrace)
    printf("mergeInclude at base.qon:1004\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(inc )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(program );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    functions = childrenof(cdr(assoc("functions" , inc )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    oldfunctionsnode = cdr(assoc("functions" , program ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    oldfunctions = childrenof(oldfunctionsnode );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newfunctions = concatLists(functions , oldfunctions );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newfunctions , cdr(oldfunctionsnode )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    types = childrenof(cdr(assoc("types" , inc )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    oldtypesnode = cdr(assoc("types" , program ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    oldtypes = childrenof(oldtypesnode );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newtypes = concatLists(types , oldtypes );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newTypeNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newtypes , cdr(oldtypesnode )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newProgram = alistCons(boxString("functions" ), newFunctionNode , alistCons(boxString("types" ), newTypeNode , alistCons(boxString("includes" ), cons(boxSymbol("includes" ), NULL ), newProgram )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(newProgram );

  };

if (globalTrace)
    printf("Leaving mergeInclude\n");

}


//Building function macrowalk from line: 1058

list macrowalk(list l ) {
  box val = NULL ;

if (globalTrace)
    printf("macrowalk at base.qon:1058\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(l )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString(stringConcatenate("box" , "List" ), stringify(car(l )))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(car(doBoxList(cdr(l ))));

      } else {
      };
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString(stringConcatenate("string" , "List" ), stringify(car(l )))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(car(doStringList(cdr(l ))));

      } else {
      };
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(macrowalk(car(l )), macrowalk(cdr(l ))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(l );

    };

  };

if (globalTrace)
    printf("Leaving macrowalk\n");

}


//Building function doBoxList from line: 1100

list doBoxList(list l ) {
  
if (globalTrace)
    printf("doBoxList at base.qon:1100\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxSymbol("nil" ), NULL ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(cons(boxSymbol("cons" ), cons(first(l ), doBoxList(cdr(l )))), NULL ));

  };

if (globalTrace)
    printf("Leaving doBoxList\n");

}


//Building function doStringList from line: 1116

list doStringList(list l ) {
  list newlist = NULL ;
list ret = NULL ;

if (globalTrace)
    printf("doStringList at base.qon:1116\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxSymbol("nil" ), NULL ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newlist = cons(boxSymbol("boxString" ), cons(first(l ), newlist ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ret = cons(cons(boxSymbol("cons" ), cons(newlist , doStringList(cdr(l )))), NULL );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(ret );

  };

if (globalTrace)
    printf("Leaving doStringList\n");

}


//Building function argList from line: 1140

list argList(int count ,int pos ,char** args ) {
  
if (globalTrace)
    printf("argList at base.qon:1140\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(count , pos )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving argList\n");

}


//Building function listReverse from line: 1152

list listReverse(list l ) {
  
if (globalTrace)
    printf("listReverse at base.qon:1152\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(l ), listReverse(cdr(l ))));

  };

if (globalTrace)
    printf("Leaving listReverse\n");

}


//Building function inList from line: 1158

bool inList(box item ,list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(car(l ), item )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(inList(item , cdr(l )));

    };

  };

}


//Building function tron from line: 1169

void tron() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = true ;

}


//Building function troff from line: 1170

void troff() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = false ;

}


//Building function stron from line: 1171

void stron() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = true ;

}


//Building function stroff from line: 1172

void stroff() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = false ;

}


//Building function numbers from line: 4

list numbers(int num ) {
  
if (globalTrace)
    printf("numbers at perl.qon:4\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(0 , num )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString("-" ), NULL ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(stringify(boxInt(num ))), numbers(sub1(num ))));

  };

if (globalTrace)
    printf("Leaving numbers\n");

}


//Building function lexType from line: 11

char* lexType(box abox ) {
  
if (globalTrace)
    printf("lexType at perl.qon:11\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("string" , boxType(abox ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("string" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(boxString(sub_string(stringify(abox ), 0 , 1 )), numbers(9 ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return("number" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return("symbol" );

    };

  };

if (globalTrace)
    printf("Leaving lexType\n");

}


//Building function perlLeaf from line: 23

void perlLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("perlLeaf at perl.qon:23\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , lexType(codeof(thisNode )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , dollar ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(perlFuncMap(codeof(thisNode )));

if (globalTrace)
    printf("Leaving perlLeaf\n");

}


//Building function perlStructGetterExpression from line: 32

void perlStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("perlStructGetterExpression at perl.qon:32\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlLeaf(thisNode , indent );

  };

if (globalTrace)
    printf("Leaving perlStructGetterExpression\n");

}


//Building function perlExpression from line: 38

void perlExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("perlExpression at perl.qon:38\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlLeaf(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlSubExpression(node , indent );

  };

if (globalTrace)
    printf("Leaving perlExpression\n");

}


//Building function perlRecurList from line: 44

void perlRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("perlRecurList at perl.qon:44\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlExpression(car(expr ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf(", " );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      perlRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    printf("Leaving perlRecurList\n");

}


//Building function perlSubExpression from line: 55

void perlSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("perlSubExpression at perl.qon:55\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      perlSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isLeaf(tree )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("%s" , dollar ());
        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        display(perlFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("()" );

          };

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("%s%s->{%s}" , dollar (), stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("{}" );

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("%s(" , stringify(perlFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              perlRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving perlSubExpression\n");

}


//Building function perlIf from line: 93

void perlIf(list node ,int indent ) {
  
if (globalTrace)
    printf("perlIf at perl.qon:93\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("if ( " );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(") {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("} else {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("}" );

if (globalTrace)
    printf("Leaving perlIf\n");

}


//Building function perlSetStruct from line: 106

void perlSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("perlSetStruct at perl.qon:106\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s->{%s} = " , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving perlSetStruct\n");

}


//Building function perlGetStruct from line: 113

void perlGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("perlGetStruct at perl.qon:113\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s->{%s}" , dollar (), stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    printf("Leaving perlGetStruct\n");

}


//Building function perlSet from line: 118

void perlSet(list node ,int indent ) {
  
if (globalTrace)
    printf("perlSet at perl.qon:118\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s = " , dollar (), stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving perlSet\n");

}


//Building function assertNode from line: 124

void assertNode(list node ) {
  
if (globalTrace)
    printf("assertNode at perl.qon:124\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNode(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Not a node!" );

  };

if (globalTrace)
    printf("Leaving assertNode\n");

}


//Building function perlStatement from line: 131

void perlStatement(list node ,int indent ) {
  box functionName = NULL ;

if (globalTrace)
    printf("perlStatement at perl.qon:131\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertNode(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlSet(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      perlSetStruct(node , indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        perlIf(node , indent );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          functionName = functionNameof(node );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("\n#Returnvoid\n" );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("return" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), subnameof(node ))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            functionName = functionNameof(node );
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( inList(functionName , noStackTrace ())) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("" );

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("\n#standard return: %s\n" , stringify(functionName ));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              newLine(indent );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("%s%s%s" , "if (" , dollar (), "globalTrace) {printf(\"Leaving \\n\")}\n" );

            };
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            newLine(indent );
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            perlExpression(childrenof(node ), indent );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( inList(functionName , noStackTrace ())) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("" );

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("\n#standard expression\n" );

            };
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            newLine(indent );
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            perlExpression(childrenof(node ), indent );
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            newLine(indent );

          };

        };

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );

if (globalTrace)
    printf("Leaving perlStatement\n");

}


//Building function perlBody from line: 180

void perlBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("perlBody at perl.qon:180\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s%s%s" , "if (" , dollar (), "globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlBody(cdr(tree ), indent );

  };

if (globalTrace)
    printf("Leaving perlBody\n");

}


//Building function perlDeclarations from line: 190

void perlDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("perlDeclarations at perl.qon:190\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    decl = car(decls );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("my %s%s = " , dollar (), stringify(second(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(perlConstMap(third(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    printf("Leaving perlDeclarations\n");

}


//Building function perlFunction from line: 201

void perlFunction(list node ) {
  box name = NULL ;

if (globalTrace)
    printf("perlFunction at perl.qon:201\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n#Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(0 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("sub %s" , stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(" {" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\nif (%sglobalTrace) { printf(\"%s at %s:%s\\n\") }\n" , dollar (), stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

if (globalTrace)
    printf("Leaving perlFunction\n");

}


//Building function perlForwardDeclaration from line: 233

void perlForwardDeclaration(list node ) {
  
if (globalTrace)
    printf("perlForwardDeclaration at perl.qon:233\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\nsub %s" , stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";" );

  };

if (globalTrace)
    printf("Leaving perlForwardDeclaration\n");

}


//Building function perlForwardDeclarations from line: 243

void perlForwardDeclarations(list tree ) {
  
if (globalTrace)
    printf("perlForwardDeclarations at perl.qon:243\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlForwardDeclaration(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving perlForwardDeclarations\n");

}


//Building function perlFunctions from line: 251

void perlFunctions(list tree ) {
  
if (globalTrace)
    printf("perlFunctions at perl.qon:251\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunctions(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving perlFunctions\n");

}


//Building function dollar from line: 258

char* dollar() {
  
if (globalTrace)
    printf("dollar at perl.qon:258\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(character(36 ));

if (globalTrace)
    printf("Leaving dollar\n");

}


//Building function atSym from line: 261

char* atSym() {
  
if (globalTrace)
    printf("atSym at perl.qon:261\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(character(64 ));

if (globalTrace)
    printf("Leaving atSym\n");

}


//Building function perlIncludes from line: 265

void perlIncludes(list nodes ) {
  
if (globalTrace)
    printf("perlIncludes at perl.qon:265\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s\n" , "use strict;" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s\n" , "use Carp;" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  dollar ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s\n" , "use Carp::Always;" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub greaterthan { " , dollar (), "_[0] > " , dollar (), "_[1] };" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub mult { " , dollar (), "_[0] * " , dollar (), "_[1] };" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub multf { " , dollar (), "_[0] * " , dollar (), "_[1] };" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub greaterthanf { " , dollar (), "_[0] > " , dollar (), "_[1] };" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub equalString { " , dollar (), "_[0] eq " , dollar (), "_[1] };" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("sub read_file { my %sfile = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; local %s/ = undef; my %scont = <%sfh>; close %sfh; return %scont; }; \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("sub write_file {my %sfile = shift; my %sdata = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; print %sfh %sdata; close %sfh; } \n" , dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar (), dollar ());
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub stringConcatenate { " , dollar (), "_[0] . " , dollar (), "_[1]}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub subtract { " , dollar (), "_[0] - " , dollar (), "_[1]}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub subf { " , dollar (), "_[0] - " , dollar (), "_[1]}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub andBool { " , dollar (), "_[0] && " , dollar (), "_[1]}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub equal { " , dollar (), "_[0] == " , dollar (), "_[1]}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s\n" , "sub panic { carp " , atSym (), "_; die \"" , atSym (), "_\"}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("sub intToString { return %s_[0]}\n" , dollar ());
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("sub character { return chr(%s_[0])}\n" , dollar ());
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s%s%s%s%s%s\n" , "sub getStringArray { my " , dollar (), "index = shift; my " , dollar (), "arr = shift; return " , dollar (), "arr->[" , dollar (), "index]}" );

if (globalTrace)
    printf("Leaving perlIncludes\n");

}


//Building function perlTypeDecl from line: 298

void perlTypeDecl(list l ) {
  
if (globalTrace)
    printf("perlTypeDecl at perl.qon:298\n");

if (globalTrace)
    printf("Leaving perlTypeDecl\n");

}


//Building function perlStructComponents from line: 303

void perlStructComponents(list node ) {
  
if (globalTrace)
    printf("perlStructComponents at perl.qon:303\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlStructComponents(cdr(node ));

  };

if (globalTrace)
    printf("Leaving perlStructComponents\n");

}


//Building function perlStruct from line: 309

void perlStruct(list node ) {
  
if (globalTrace)
    printf("perlStruct at perl.qon:309\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlStructComponents(cdr(car(node )));

if (globalTrace)
    printf("Leaving perlStruct\n");

}


//Building function perlTypeMap from line: 312

box perlTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlTypeMap at perl.qon:312\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving perlTypeMap\n");

}


//Building function perlConstMap from line: 324

box perlConstMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlConstMap at perl.qon:324\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("false" ), boxSymbol("0" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), NULL ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving perlConstMap\n");

}


//Building function perlFuncMap from line: 334

box perlFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlFuncMap at perl.qon:334\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("substr" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), NULL ))))))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assocFail(stringify(aSym ), symMap , aSym )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving perlFuncMap\n");

}


//Building function perlType from line: 351

void perlType(list node ) {
  
if (globalTrace)
    printf("perlType at perl.qon:351\n");

if (globalTrace)
    printf("Leaving perlType\n");

}


//Building function perlTypes from line: 356

void perlTypes(list nodes ) {
  
if (globalTrace)
    printf("perlTypes at perl.qon:356\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlTypes(cdr(nodes ));

  };

if (globalTrace)
    printf("Leaving perlTypes\n");

}


//Building function perlFunctionArgs from line: 362

void perlFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("perlFunctionArgs at perl.qon:362\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s%s" , "my " , dollar ());
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(second(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(" = shift;\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    printf("Leaving perlFunctionArgs\n");

}


//Building function perlCompile from line: 372

void perlCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("perlCompile at perl.qon:372\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("use strict;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("use Carp;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("use Data::Dumper;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "globalStackTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "globalTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "globalStepTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "globalArgs = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "globalArgsCount = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s\n" , "my " , dollar (), "true = 1;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "false = 0;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "my " , dollar (), "undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s" , "\nsub isNil {\n    return !defined(" , dollar (), "_[0]);\n}\n\n\n#Forward declarations\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n#End forward declarations\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s" , dollar (), "globalArgs = [ 1, " , atSym (), "ARGV];" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s%s%s%s" , dollar (), "globalArgsCount = scalar(" , atSym (), "ARGV)+1;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("start();" );

if (globalTrace)
    printf("Leaving perlCompile\n");

}


//Building function ansiFunctionArgs from line: 3

void ansiFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("ansiFunctionArgs at ansi.qon:3\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(ansiTypeMap(first(tree )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(second(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("," );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    printf("Leaving ansiFunctionArgs\n");

}


//Building function ansiLeaf from line: 13

void ansiLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("ansiLeaf at ansi.qon:13\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(ansiFuncMap(codeof(thisNode )));

if (globalTrace)
    printf("Leaving ansiLeaf\n");

}


//Building function ansiStructGetterExpression from line: 16

void ansiStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("ansiStructGetterExpression at ansi.qon:16\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiLeaf(thisNode , indent );

  };

if (globalTrace)
    printf("Leaving ansiStructGetterExpression\n");

}


//Building function ansiExpression from line: 22

void ansiExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiExpression at ansi.qon:22\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(ansiFuncMap(codeof(node )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiSubExpression(node , indent );

  };

if (globalTrace)
    printf("Leaving ansiExpression\n");

}


//Building function ansiRecurList from line: 28

void ansiRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("ansiRecurList at ansi.qon:28\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiExpression(car(expr ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf(", " );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      ansiRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    printf("Leaving ansiRecurList\n");

}


//Building function ansiSubExpression from line: 40

void ansiSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("ansiSubExpression at ansi.qon:40\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      ansiSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isLeaf(tree )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        display(ansiFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("()" );

          };

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("%s->%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof(tree )))));

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              ansiRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving ansiSubExpression\n");

}


//Building function ansiIf from line: 80

void ansiIf(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiIf at ansi.qon:80\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("if ( " );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(") {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("} else {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("}" );

if (globalTrace)
    printf("Leaving ansiIf\n");

}


//Building function ansiSetStruct from line: 93

void ansiSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiSetStruct at ansi.qon:93\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving ansiSetStruct\n");

}


//Building function ansiGetStruct from line: 102

void ansiGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiGetStruct at ansi.qon:102\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    printf("Leaving ansiGetStruct\n");

}


//Building function ansiSet from line: 110

void ansiSet(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiSet at ansi.qon:110\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving ansiSet\n");

}


//Building function ansiStatement from line: 116

void ansiStatement(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiStatement at ansi.qon:116\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiSet(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      ansiSetStruct(node , indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        ansiIf(node , indent );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("return" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          ansiExpression(childrenof(node ), indent );

        };

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );

if (globalTrace)
    printf("Leaving ansiStatement\n");

}


//Building function ansiBody from line: 134

void ansiBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("ansiBody at ansi.qon:134\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiBody(cdr(tree ), indent );

  };

if (globalTrace)
    printf("Leaving ansiBody\n");

}


//Building function ansiDeclarations from line: 146

void ansiDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("ansiDeclarations at ansi.qon:146\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    decl = car(decls );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s = " , stringify(ansiTypeMap(first(decl ))), stringify(second(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(ansiFuncMap(third(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    printf("Leaving ansiDeclarations\n");

}


//Building function ansiFunction from line: 160

void ansiFunction(list node ) {
  box name = NULL ;

if (globalTrace)
    printf("ansiFunction at ansi.qon:160\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(0 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(") {" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\nif (globalTrace)\n    printf(\"%s at %s:%s\\n\");\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {
    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify(name ));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

if (globalTrace)
    printf("Leaving ansiFunction\n");

}


//Building function ansiForwardDeclaration from line: 194

void ansiForwardDeclaration(list node ) {
  
if (globalTrace)
    printf("ansiForwardDeclaration at ansi.qon:194\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(");" );

  };

if (globalTrace)
    printf("Leaving ansiForwardDeclaration\n");

}


//Building function ansiForwardDeclarations from line: 206

void ansiForwardDeclarations(list tree ) {
  
if (globalTrace)
    printf("ansiForwardDeclarations at ansi.qon:206\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiForwardDeclaration(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving ansiForwardDeclarations\n");

}


//Building function ansiFunctions from line: 214

void ansiFunctions(list tree ) {
  
if (globalTrace)
    printf("ansiFunctions at ansi.qon:214\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctions(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving ansiFunctions\n");

}


//Building function ansiIncludes from line: 219

void ansiIncludes(list nodes ) {
  
if (globalTrace)
    printf("ansiIncludes at ansi.qon:219\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nconst char* getEnv(char* key){return getenv(key);}\n void panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* setSubString(char* target, int start,char *source){target[start]=source[0]; return target;}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }" );

if (globalTrace)
    printf("Leaving ansiIncludes\n");

}


//Building function ansiTypeDecl from line: 227

void ansiTypeDecl(list l ) {
  
if (globalTrace)
    printf("ansiTypeDecl at ansi.qon:227\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(ansiTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    printf("Leaving ansiTypeDecl\n");

}


//Building function ansiStructComponents from line: 244

void ansiStructComponents(list node ) {
  
if (globalTrace)
    printf("ansiStructComponents at ansi.qon:244\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiStructComponents(cdr(node ));

  };

if (globalTrace)
    printf("Leaving ansiStructComponents\n");

}


//Building function ansiStruct from line: 250

void ansiStruct(list node ) {
  
if (globalTrace)
    printf("ansiStruct at ansi.qon:250\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiStructComponents(cdr(car(node )));

if (globalTrace)
    printf("Leaving ansiStruct\n");

}


//Building function ansiTypeMap from line: 253

box ansiTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("ansiTypeMap at ansi.qon:253\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving ansiTypeMap\n");

}


//Building function ansiFuncMap from line: 265

box ansiFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("ansiFuncMap at ansi.qon:265\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), NULL )))))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(aSym );

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving ansiFuncMap\n");

}


//Building function ansiType from line: 296

void ansiType(list node ) {
  
if (globalTrace)
    printf("ansiType at ansi.qon:296\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(subnameof(node ), boxString("struct" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiStruct(cdr(codeof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n} %s;\n" , stringify(first(codeof(node ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("typedef " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiTypeDecl(codeof(node ));

  };

if (globalTrace)
    printf("Leaving ansiType\n");

}


//Building function ansiTypes from line: 306

void ansiTypes(list nodes ) {
  
if (globalTrace)
    printf("ansiTypes at ansi.qon:306\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiTypes(cdr(nodes ));

  };

if (globalTrace)
    printf("Leaving ansiTypes\n");

}


//Building function uniqueTarget from line: 314

void uniqueTarget(char* a ,char* b ) {
  
if (globalTrace)
    printf("uniqueTarget at ansi.qon:314\n");

if (globalTrace)
    printf("Leaving uniqueTarget\n");

}


//Building function ansiCompile from line: 315

void ansiCompile(char* filename ) {
  list foundationFuncs = NULL ;
list foundation = NULL ;
char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("ansiCompile at ansi.qon:315\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  foundation = readSexpr(read_file("foundationlibs/ansi.qon" ), "foundationlibs/ansi.qon" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  foundationFuncs = cdr(third(foundation ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("//Scanning file...%s\n" , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("//Building sexpr\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = macrowalk(tree );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  cons(boxString("a" ), cons(boxString("b" ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("//Building AST\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("//Merging ASTs\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("//Printing program\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("Box* globalStackTrace = NULL;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n//End forward declarations\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );

if (globalTrace)
    printf("Leaving ansiCompile\n");

}


//Building function test0 from line: 8

void test0() {
  
if (globalTrace)
    printf("test0 at tests.qon:8\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(stringify(boxString("hello" )), stringify(boxString("hello" )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("0.  pass string compare works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("0.  pass string compare fails\n" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("0.  pass string compare works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("0.  pass string compare fails\n" );

  };

if (globalTrace)
    printf("Leaving test0\n");

}


//Building function test1 from line: 23

void test1() {
  
if (globalTrace)
    printf("test1 at tests.qon:23\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("1.  pass Function call and print work\n" );

if (globalTrace)
    printf("Leaving test1\n");

}


//Building function test2_do from line: 28

void test2_do(char* message ) {
  
if (globalTrace)
    printf("test2_do at tests.qon:28\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("2.  pass Function call with arg works: %s\n" , message );

if (globalTrace)
    printf("Leaving test2_do\n");

}


//Building function test2 from line: 32

void test2() {
  
if (globalTrace)
    printf("test2 at tests.qon:32\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  test2_do("This is the argument" );

if (globalTrace)
    printf("Leaving test2\n");

}


//Building function test3_do from line: 34

void test3_do(int b ,char* c ) {
  
if (globalTrace)
    printf("test3_do at tests.qon:34\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("3.1 pass Two arg call, first arg: %d\n" , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("3.2 pass Two arg call, second arg: %s\n" , c );

if (globalTrace)
    printf("Leaving test3_do\n");

}


//Building function test3 from line: 40

void test3() {
  
if (globalTrace)
    printf("test3 at tests.qon:40\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  test3_do(42 , "Fourty-two" );

if (globalTrace)
    printf("Leaving test3\n");

}


//Building function test4_do from line: 41

char* test4_do() {
  
if (globalTrace)
    printf("test4_do at tests.qon:41\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("pass Return works" );

if (globalTrace)
    printf("Leaving test4_do\n");

}


//Building function returnThis from line: 43

char* returnThis(char* returnMessage ) {
  
if (globalTrace)
    printf("returnThis at tests.qon:43\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(returnMessage );

if (globalTrace)
    printf("Leaving returnThis\n");

}


//Building function test4 from line: 48

void test4() {
  char* message = "fail" ;

if (globalTrace)
    printf("test4 at tests.qon:48\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  message = test4_do ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("4.  %s\n" , message );

if (globalTrace)
    printf("Leaving test4\n");

}


//Building function test5 from line: 53

void test5() {
  char* message = "fail" ;

if (globalTrace)
    printf("test5 at tests.qon:53\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  message = returnThis("pass return passthrough string" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("5.  %s\n" , message );

if (globalTrace)
    printf("Leaving test5\n");

}


//Building function test6 from line: 60

void test6() {
  
if (globalTrace)
    printf("test6 at tests.qon:60\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( true ) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("6.  pass If statement works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("6.  fail If statement works\n" );

  };

if (globalTrace)
    printf("Leaving test6\n");

}


//Building function test7_do from line: 68

int test7_do(int count ) {
  
if (globalTrace)
    printf("test7_do at tests.qon:68\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  count = sub(count , 1 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(count , 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    count = test7_do(count );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(count );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(count );

if (globalTrace)
    printf("Leaving test7_do\n");

}


//Building function test7 from line: 76

void test7() {
  
if (globalTrace)
    printf("test7 at tests.qon:76\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(0 , test7_do(10 ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("7.  pass count works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("7.  fail count fails\n" );

  };

if (globalTrace)
    printf("Leaving test7\n");

}


//Building function beer from line: 84

void beer() {
  
if (globalTrace)
    printf("beer at tests.qon:84\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );

if (globalTrace)
    printf("Leaving beer\n");

}


//Building function plural from line: 93

char* plural(int num ) {
  
if (globalTrace)
    printf("plural at tests.qon:93\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(num , 1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("s" );

  };

if (globalTrace)
    printf("Leaving plural\n");

}


//Building function beers from line: 98

int beers(int count ) {
  int newcount = 0 ;

if (globalTrace)
    printf("beers at tests.qon:98\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newcount = sub(count , 1 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , count , plural(count ), count , plural(count ), newcount , plural(newcount ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(count , 1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    count = beers(newcount );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(count );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(0 );

if (globalTrace)
    printf("Leaving beers\n");

}


//Building function test8 from line: 114

void test8() {
  
if (globalTrace)
    printf("test8 at tests.qon:114\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("8.  pass Nested expressions work\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("8.  fail Nested expressions don't work\n" );

  };

if (globalTrace)
    printf("Leaving test8\n");

}


//Building function test9 from line: 122

void test9() {
  int answer = -999999 ;

if (globalTrace)
    printf("test9 at tests.qon:122\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  answer = sub(sub(20 , 1 ), sub(3 , 1 ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(answer , 17 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("9.  pass arithmetic works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("9.  fail arithmetic\n" );

  };

if (globalTrace)
    printf("Leaving test9\n");

}


//Building function test10 from line: 131

void test10() {
  char* testString = "This is a test string" ;

if (globalTrace)
    printf("test10 at tests.qon:131\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(testString , unBoxString(car(cons(boxString(testString ), NULL ))))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("10. pass cons and car work\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("10. fail cons and car fail\n" );

  };

if (globalTrace)
    printf("Leaving test10\n");

}


//Building function test12 from line: 141

void test12() {
  box b = NULL ;

if (globalTrace)
    printf("test12 at tests.qon:141\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->str = "12. pass structure accessors\n" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , b->str);

if (globalTrace)
    printf("Leaving test12\n");

}


//Building function test13 from line: 149

void test13() {
  char* testString = "Hello from the filesystem!" ;
char* contents = "" ;

if (globalTrace)
    printf("test13 at tests.qon:149\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  write_file("test.txt" , testString );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  contents = read_file("test.txt" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(testString , contents )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("13. pass Read and write files\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("13. fail Read and write files\n" );

  };

if (globalTrace)
    printf("Leaving test13\n");

}


//Building function test15 from line: 161

void test15() {
  char* a = "hello" ;
char* b = " world" ;
char* c = "" ;

if (globalTrace)
    printf("test15 at tests.qon:161\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  c = stringConcatenate(a , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(c , "hello world" )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("15. pass String concatenate\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("15. fail String concatenate\n" );

  };

if (globalTrace)
    printf("Leaving test15\n");

}


//Building function test16 from line: 171

void test16() {
  list assocCell1 = NULL ;
list assList = NULL ;
list assocCell2 = NULL ;
list assocCell3 = NULL ;

if (globalTrace)
    printf("test16 at tests.qon:171\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assocCell1 = cons(boxString("Hello" ), boxString("world" ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assocCell2 = cons(boxString("goodnight" ), boxString("moon" ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assList = cons(assocCell2 , emptyList ());
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assList = cons(assocCell1 , assList );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assList = cons(assocCell3 , assList );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(cdr(assoc("Hello" , assList )), boxString("world" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("16.1 pass Basic assoc works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("16.1 fail Basic assoc fails\n" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( andBool(andBool(equalBox(cdr(assoc("Hello" , assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , assList )), boxString("gozaimasu" )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("16.2 pass assoc list\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("16.2 fail assoc list\n" );

  };

if (globalTrace)
    printf("Leaving test16\n");

}


//Building function test17 from line: 196

void test17() {
  list l = NULL ;

if (globalTrace)
    printf("test17 at tests.qon:196\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  l = cons(boxInt(1 ), cons(boxInt(2 ), cons(boxInt(3 ), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(car(l ), boxInt(1 ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("17 pass list literal works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("17 fail list literal failed\n" );

  };

if (globalTrace)
    printf("Leaving test17\n");

}


//Building function test18 from line: 205

void test18() {
  char* val1 = "a" ;
char* val2 = "b" ;
char* val3 = "c" ;
list l = NULL ;

if (globalTrace)
    printf("test18 at tests.qon:205\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(l );

if (globalTrace)
    printf("Leaving test18\n");

}


//Building function reverseRec from line: 215

list reverseRec(list old ,list new ) {
  
if (globalTrace)
    printf("reverseRec at tests.qon:215\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(old )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(reverseRec(cdr(old ), cons(first(old ), new )));

  };

if (globalTrace)
    printf("Leaving reverseRec\n");

}


//Building function nodeFunctionArgs from line: 4

void nodeFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("nodeFunctionArgs at node.qon:4\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(second(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("," );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    printf("Leaving nodeFunctionArgs\n");

}


//Building function nodeLeaf from line: 13

void nodeLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("nodeLeaf at node.qon:13\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(nodeFuncMap(codeof(thisNode )));

if (globalTrace)
    printf("Leaving nodeLeaf\n");

}


//Building function nodeStructGetterExpression from line: 16

void nodeStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("nodeStructGetterExpression at node.qon:16\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeLeaf(thisNode , indent );

  };

if (globalTrace)
    printf("Leaving nodeStructGetterExpression\n");

}


//Building function nodeExpression from line: 22

void nodeExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeExpression at node.qon:22\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(nodeFuncMap(codeof(node )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeSubExpression(node , indent );

  };

if (globalTrace)
    printf("Leaving nodeExpression\n");

}


//Building function nodeRecurList from line: 28

void nodeRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("nodeRecurList at node.qon:28\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeExpression(car(expr ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf(", " );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      nodeRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    printf("Leaving nodeRecurList\n");

}


//Building function nodeSubExpression from line: 41

void nodeSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("nodeSubExpression at node.qon:41\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      nodeSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isLeaf(tree )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        display(nodeFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("()" );

          };

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("{}" );

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("%s(" , stringify(nodeFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              nodeRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving nodeSubExpression\n");

}


//Building function nodeIf from line: 82

void nodeIf(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeIf at node.qon:82\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("if ( " );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(") {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("} else {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("}" );

if (globalTrace)
    printf("Leaving nodeIf\n");

}


//Building function nodeGetStruct from line: 96

void nodeGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeGetStruct at node.qon:96\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    printf("Leaving nodeGetStruct\n");

}


//Building function nodeSet from line: 104

void nodeSet(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeSet at node.qon:104\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving nodeSet\n");

}


//Building function nodeSetStruct from line: 110

void nodeSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeSetStruct at node.qon:110\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeExpression(childrenof(node ), indent );

if (globalTrace)
    printf("Leaving nodeSetStruct\n");

}


//Building function nodeStatement from line: 118

void nodeStatement(list node ,int indent ) {
  
if (globalTrace)
    printf("nodeStatement at node.qon:118\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeSet(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      nodeSetStruct(node , indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        nodeIf(node , indent );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("return" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          nodeExpression(childrenof(node ), indent );

        };

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );

if (globalTrace)
    printf("Leaving nodeStatement\n");

}


//Building function nodeBody from line: 137

void nodeBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("nodeBody at node.qon:137\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , "if (globalStepTrace) {console.log(new Error(\"StepTrace \\n\"));}\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeBody(cdr(tree ), indent );

  };

if (globalTrace)
    printf("Leaving nodeBody\n");

}


//Building function nodeDeclarations from line: 151

void nodeDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("nodeDeclarations at node.qon:151\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    decl = car(decls );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("var %s = " , stringify(second(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(nodeFuncMap(third(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    printf("Leaving nodeDeclarations\n");

}


//Building function nodeFunction from line: 166

void nodeFunction(list node ) {
  box name = NULL ;

if (globalTrace)
    printf("nodeFunction at node.qon:166\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(0 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("function %s(" , stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(") {" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\nif (globalTrace)\n    {printf(\"%s at %s:%s\\n\");}\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {
    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\nif (globalTrace)\n    {printf(\"Leaving %s\\n\");}\n" , stringify(name ));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

if (globalTrace)
    printf("Leaving nodeFunction\n");

}


//Building function nodeForwardDeclaration from line: 199

void nodeForwardDeclaration(list node ) {
  
if (globalTrace)
    printf("nodeForwardDeclaration at node.qon:199\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n%s %s(" , stringify(nodeTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(");" );

  };

if (globalTrace)
    printf("Leaving nodeForwardDeclaration\n");

}


//Building function nodeForwardDeclarations from line: 211

void nodeForwardDeclarations(list tree ) {
  
if (globalTrace)
    printf("nodeForwardDeclarations at node.qon:211\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeForwardDeclaration(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeForwardDeclarations(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving nodeForwardDeclarations\n");

}


//Building function nodeFunctions from line: 221

void nodeFunctions(list tree ) {
  
if (globalTrace)
    printf("nodeFunctions at node.qon:221\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeFunctions(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving nodeFunctions\n");

}


//Building function nodeIncludes from line: 229

void nodeIncludes(list nodes ) {
  
if (globalTrace)
    printf("nodeIncludes at node.qon:229\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function read_file(filename) {return fs.readFileSync(filename);}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function write_file(filename, data) {fs.writeFileSync(filename, data);}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "var util = require('util');\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function printf() {process.stdout.write(util.format.apply(this, arguments));}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "var fs = require('fs');\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function equalString(a,b) {return a.toString()===b.toString() }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function panic(s){console.trace(s);process.exit(1);}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function dump(s){console.log(s)}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function sub(a, b) { return a - b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function mult(a, b) { return a * b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function greaterthan(a, b) { return a > b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function subf(a, b) { return a - b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function multf(a, b) { return a * b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function greaterthanf(a, b) { return a > b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function equal(a, b) { return a == b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function andBool(a, b) { return a == b;}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function string_length(s) { return s.length;}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function stringConcatenate(a, b) { return a + b}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function intToString(a) {}\n\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function gc_malloc( size ) {\nreturn {};\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function makeArray(length) {\n   return [];\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function at(arr, index) {\n  return arr[index];\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function setAt(array, index, value) {\n    array[index] = value;\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function getStringArray(index, strs) {\nreturn strs[index];\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "var NULL = null;" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "var globalArgs;\nvar globalArgsCount;\nvar globalTrace = false;\nvar globalStepTrace = false;" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "function character(num) {}" );

if (globalTrace)
    printf("Leaving nodeIncludes\n");

}


//Building function nodeTypeDecl from line: 262

void nodeTypeDecl(list l ) {
  
if (globalTrace)
    printf("nodeTypeDecl at node.qon:262\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s %s;\n" , stringify(second(l )), stringify(nodeTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(nodeTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    printf("Leaving nodeTypeDecl\n");

}


//Building function nodeStructComponents from line: 279

void nodeStructComponents(list node ) {
  
if (globalTrace)
    printf("nodeStructComponents at node.qon:279\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeStructComponents(cdr(node ));

  };

if (globalTrace)
    printf("Leaving nodeStructComponents\n");

}


//Building function nodeStruct from line: 287

void nodeStruct(list node ) {
  
if (globalTrace)
    printf("nodeStruct at node.qon:287\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeStructComponents(cdr(car(node )));

if (globalTrace)
    printf("Leaving nodeStruct\n");

}


//Building function nodeTypeMap from line: 292

box nodeTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("nodeTypeMap at node.qon:292\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving nodeTypeMap\n");

}


//Building function nodeFuncMap from line: 307

box nodeFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("nodeFuncMap at node.qon:307\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), NULL )))))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(aSym );

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving nodeFuncMap\n");

}


//Building function nodeType from line: 338

void nodeType(list node ) {
  
if (globalTrace)
    printf("nodeType at node.qon:338\n");

if (globalTrace)
    printf("Leaving nodeType\n");

}


//Building function nodeTypes from line: 342

void nodeTypes(list nodes ) {
  
if (globalTrace)
    printf("nodeTypes at node.qon:342\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    nodeTypes(cdr(nodes ));

  };

if (globalTrace)
    printf("Leaving nodeTypes\n");

}


//Building function nodeCompile from line: 350

void nodeCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("nodeCompile at node.qon:350\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\nvar globalStackTrace = NULL;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\nfunction isNil(p) {\n    return p == NULL;\n}\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  nodeFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "start();\n" );

if (globalTrace)
    printf("Leaving nodeCompile\n");

}


//Building function javaFunctionArgs from line: 3

void javaFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("javaFunctionArgs at java.qon:3\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(javaTypeMap(first(tree )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(second(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cddr(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("," );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaFunctionArgs(cddr(tree ));

  };

if (globalTrace)
    printf("Leaving javaFunctionArgs\n");

}


//Building function javaLeaf from line: 13

void javaLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("javaLeaf at java.qon:13\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(javaFuncMap(codeof(thisNode )));

if (globalTrace)
    printf("Leaving javaLeaf\n");

}


//Building function javaStructGetterExpression from line: 16

void javaStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("javaStructGetterExpression at java.qon:16\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaLeaf(thisNode , indent );

  };

if (globalTrace)
    printf("Leaving javaStructGetterExpression\n");

}


//Building function javaExpression from line: 22

void javaExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("javaExpression at java.qon:22\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(javaFuncMap(codeof(node )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaSubExpression(node , indent );

  };

if (globalTrace)
    printf("Leaving javaExpression\n");

}


//Building function javaRecurList from line: 28

void javaRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("javaRecurList at java.qon:28\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaExpression(car(expr ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNil(cdr(expr ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf(", " );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      javaRecurList(cdr(expr ), indent );

    };

  };

if (globalTrace)
    printf("Leaving javaRecurList\n");

}


//Building function javaSubExpression from line: 40

void javaSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("javaSubExpression at java.qon:40\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      javaSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isLeaf(tree )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        display(javaFuncMap(codeof(tree )));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equal(1 , listLength(childrenof(tree )))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          display(codeof(car(childrenof(tree ))));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxString("return" ), codeof(car(childrenof(tree ))))) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("()" );

          };

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          thing = codeof(car(childrenof(tree )));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol("get-struct" ), thing )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("new" ), thing )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("new %s()" , stringify(codeof(third(childrenof(tree )))));

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("%s(" , stringify(javaFuncMap(codeof(car(childrenof(tree ))))));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              javaRecurList(cdr(childrenof(tree )), indent );
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf(")" );

            };

          };

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving javaSubExpression\n");

}


//Building function javaIf from line: 80

void javaIf(list node ,int indent ) {
  
if (globalTrace)
    printf("javaIf at java.qon:80\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("if ( " );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaExpression(car(first(childrenof(node ))), 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(") {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaBody(second(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("} else {" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaBody(third(childrenof(node )), add1(indent ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("}" );

if (globalTrace)
    printf("Leaving javaIf\n");

}


//Building function javaSetStruct from line: 93

void javaSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("javaSetStruct at java.qon:93\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaExpression(childrenof(node ), indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";" );

if (globalTrace)
    printf("Leaving javaSetStruct\n");

}


//Building function javaGetStruct from line: 104

void javaGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("javaGetStruct at java.qon:104\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

if (globalTrace)
    printf("Leaving javaGetStruct\n");

}


//Building function javaSet from line: 112

void javaSet(list node ,int indent ) {
  
if (globalTrace)
    printf("javaSet at java.qon:112\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaExpression(childrenof(node ), indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";" );

if (globalTrace)
    printf("Leaving javaSet\n");

}


//Building function javaStatement from line: 120

void javaStatement(list node ,int indent ) {
  
if (globalTrace)
    printf("javaStatement at java.qon:120\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("setter" ), subnameof(node ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaSet(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalBox(boxString("structSetter" ), subnameof(node ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      javaSetStruct(node , indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalBox(boxString("if" ), subnameof(node ))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        javaIf(node , indent );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( equalBox(boxString("returnvoid" ), subnameof(node ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("return;" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          javaExpression(childrenof(node ), indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf(";" );

        };

      };

    };

  };

if (globalTrace)
    printf("Leaving javaStatement\n");

}


//Building function javaBody from line: 140

void javaBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("javaBody at java.qon:140\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaBody(cdr(tree ), indent );

  };

if (globalTrace)
    printf("Leaving javaBody\n");

}


//Building function javaDeclarations from line: 150

void javaDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("javaDeclarations at java.qon:150\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    decl = car(decls );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s = " , stringify(javaTypeMap(first(decl ))), stringify(second(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(javaFuncMap(third(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaDeclarations(cdr(decls ), indent );

  };

if (globalTrace)
    printf("Leaving javaDeclarations\n");

}


//Building function javaFunction from line: 164

void javaFunction(list node ) {
  box name = NULL ;

if (globalTrace)
    printf("javaFunction at java.qon:164\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(0 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("public %s %s(" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(") {" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    newLine(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaDeclarations(declarationsof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {
    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(toStr(name ), noStackTrace ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("void" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("\nif (globalTrace)\n   System.out. printf(\"Leaving %s\\n\");\n" , stringify(name ));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("" );

      };

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

if (globalTrace)
    printf("Leaving javaFunction\n");

}


//Building function javaFunctions from line: 203

void javaFunctions(list tree ) {
  
if (globalTrace)
    printf("javaFunctions at java.qon:203\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaFunctions(cdr(tree ));

  };

if (globalTrace)
    printf("Leaving javaFunctions\n");

}


//Building function javaIncludes from line: 209

void javaIncludes(list nodes ) {
  
if (globalTrace)
    printf("javaIncludes at java.qon:209\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public void panic(String s) {System.exit(1);}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public int sub(int a, int b) { return a - b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public double mult(int a, int b) { return a * b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public boolean greaterthan(int a, int b) { return a > b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public double subf(double a, double b) { return a - b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public double multf(double a, double b) { return a * b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public boolean greaterthanf(double a, double b) { return a > b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public boolean equal(int a, int b) { return a == b; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public boolean equalString(String a, String b) { return a.equals(b); }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public boolean andBool(boolean a, boolean b) { return a == b;}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public int string_length(String s) { return s.length();}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String stringConcatenate(String s1, String s2) { return s1 + s2; }\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public int strcmp(String s1, String s2) { return s1.compareTo(s2);}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String read_file(String filename) {try { return new String(Files.readAllBytes(Paths.get(filename)));} catch (Exception e) {panic(\"Could not read file\");return \"\";}}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public void write_file(String filename, String data) {try {Files.write(Paths.get(filename), data.getBytes(\"UTF-8\"));} catch (Exception e) {panic(\"Could not write file\");}}\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String sub_string(String s, int start, int length) {\nreturn s.substring(start, start+length);\n}\n\n\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String intToString(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String character(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public String getStringArray(int index, String[] arr) { return arr[index];}" );

if (globalTrace)
    printf("Leaving javaIncludes\n");

}


//Building function javaTypeDecl from line: 232

void javaTypeDecl(list l ) {
  
if (globalTrace)
    printf("javaTypeDecl at java.qon:232\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    printf("Leaving javaTypeDecl\n");

}


//Building function javaStructComponents from line: 249

void javaStructComponents(list node ) {
  
if (globalTrace)
    printf("javaStructComponents at java.qon:249\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaStructComponents(cdr(node ));

  };

if (globalTrace)
    printf("Leaving javaStructComponents\n");

}


//Building function javaStruct from line: 255

void javaStruct(list node ) {
  
if (globalTrace)
    printf("javaStruct at java.qon:255\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaStructComponents(cdr(car(node )));

if (globalTrace)
    printf("Leaving javaStruct\n");

}


//Building function javaTypeMap from line: 258

box javaTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("javaTypeMap at java.qon:258\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("pair" ), boxSymbol("Box" ), alistCons(boxSymbol("bool" ), boxSymbol("boolean" ), alistCons(boxSymbol("box" ), boxSymbol("Box" ), alistCons(boxSymbol("list" ), boxSymbol("Box" ), alistCons(boxSymbol("Box*" ), boxSymbol("Box" ), alistCons(boxSymbol("struct" ), boxSymbol("" ), alistCons(boxSymbol("int" ), boxSymbol("Integer" ), alistCons(boxSymbol("float" ), boxSymbol("double" ), alistCons(boxSymbol("stringArray" ), boxSymbol("String[]" ), alistCons(boxSymbol("string" ), boxSymbol("String" ), NULL ))))))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving javaTypeMap\n");

}


//Building function javaTypesNoDeclare from line: 276

box javaTypesNoDeclare() {
  list syms = NULL ;

if (globalTrace)
    printf("javaTypesNoDeclare at java.qon:276\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  syms = cons(boxString("pair" ), cons(boxString("box" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(syms );

if (globalTrace)
    printf("Leaving javaTypesNoDeclare\n");

}


//Building function javaFuncMap from line: 285

box javaFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("javaFuncMap at java.qon:285\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("printf" ), boxSymbol("System.out.printf" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("sub_string" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("null" ), NULL ))))))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(aSym );

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

if (globalTrace)
    printf("Leaving javaFuncMap\n");

}


//Building function javaType from line: 315

void javaType(list node ) {
  
if (globalTrace)
    printf("javaType at java.qon:315\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(subnameof(node ), boxString("struct" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\npublic class %s {\n" , stringify(first(codeof(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaStruct(cdr(codeof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n};\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(boxString(stringify(first(codeof(node )))), javaTypesNoDeclare ())) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("public class %s extends %s {};\n" , stringify(first(codeof(node ))), stringify(javaTypeMap(listLast(codeof(node )))));

    };

  };

if (globalTrace)
    printf("Leaving javaType\n");

}


//Building function javaTypes from line: 330

void javaTypes(list nodes ) {
  
if (globalTrace)
    printf("javaTypes at java.qon:330\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    javaTypes(cdr(nodes ));

  };

if (globalTrace)
    printf("Leaving javaTypes\n");

}


//Building function javaCompile from line: 336

void javaCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("javaCompile at java.qon:336\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "package quonverter;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "import java.nio.file.Files;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "import java.nio.file.Paths;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "import java.io.IOException;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "import java.io.UnsupportedEncodingException;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("class MyProgram {\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaIncludes(cdr(assoc("includes" , program )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaTypes(childrenof(cdr(assoc("types" , program ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public boolean globalStackTrace = false;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public boolean globalStepTrace = false;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public boolean globalTrace = false;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public String FILE = null;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public Integer LINE = 0;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public static Integer globalArgsCount = 0;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("public static String globalArgs[];\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\npublic boolean isNil(Box p) {\n    return p == null;\n}\n\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  javaFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "public static void main(String args[]) {\nglobalArgs = args;\nglobalArgsCount = args.length;MyProgram mp = new MyProgram(); mp.start();\n}" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("}\n" );

if (globalTrace)
    printf("Leaving javaCompile\n");

}


//Building function start from line: 4

int start() {
  bool runTests = false ;
list cmdLine = NULL ;
box filename = NULL ;
bool runPerl = false ;
bool runJava = false ;
bool runAst = false ;
bool runNode = false ;
bool runTree = false ;

if (globalTrace)
    printf("start at compiler.qon:4\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  cmdLine = listReverse(argList(globalArgsCount , 0 , globalArgs ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(cmdLine ), 1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    filename = second(cmdLine );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    filename = boxString("compiler.qon" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runTests = inList(boxString("--test" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runJava = inList(boxString("--java" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runPerl = inList(boxString("--perl" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runAst = inList(boxString("--ast" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runTree = inList(boxString("--tree" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runNode = inList(boxString("--node" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = inList(boxString("--trace" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = inList(boxString("--steptrace" ), cmdLine );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( runTests ) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test0 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test1 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test2 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test3 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test4 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test5 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test6 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test7 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test8 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test9 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test10 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test12 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test13 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test15 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test16 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test17 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    test18 ();
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n\nAfter all that hard work, I need a beer...\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    beers(9 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( runTree ) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      display(macrowalk(treeCompile(unBoxString(filename ))));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( runAst ) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        astCompile(unBoxString(filename ));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( runNode ) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          nodeCompile(unBoxString(filename ));
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("\n" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( runPerl ) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            perlCompile(unBoxString(filename ));
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("\n" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( runJava ) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              javaCompile(unBoxString(filename ));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("\n" );

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              ansiCompile(unBoxString(filename ));
              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              printf("\n" );

            };

          };

        };

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(0 );

if (globalTrace)
    printf("Leaving start\n");

}


