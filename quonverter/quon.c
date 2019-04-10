
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
typedef   Box* box;
typedef   Box Pair;
typedef   Box* pair;
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
void astCompile(char* filename );
list concatLists(list seq1 ,list seq2 );
list alistKeys(list alist );
list mergeIncludes(list program );
list merge_recur(list incs ,list program );
list mergeInclude(list inc ,list program );
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

  newb = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->typ = b->typ;
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


//Building function newVoid from line: 36

box newVoid() {
  box newb = NULL ;

if (globalTrace)
    printf("newVoid at base.qon:36\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->voi = true ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->typ = "void" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(newb );

if (globalTrace)
    printf("Leaving newVoid\n");

}


//Building function cons from line: 44

list cons(box data ,list l ) {
  pair p = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p = malloc(sizeof(Pair));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->cdr = l ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->car = data ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  p->typ = "list" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(p );

}


//Building function stackDump from line: 52

void stackDump() {
  
if (globalTrace)
    printf("stackDump at base.qon:52\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("" );

if (globalTrace)
    printf("Leaving stackDump\n");

}


//Building function nop from line: 57

void nop() {
  
if (globalTrace)
    printf("nop at base.qon:57\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("" );

if (globalTrace)
    printf("Leaving nop\n");

}


//Building function car from line: 60

box car(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l );
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


//Building function cdr from line: 73

list cdr(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l );
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


//Building function isList from line: 83

bool isList(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(equalString("list" , b->typ));

  };

}


//Building function emptyList from line: 89

list emptyList() {
  
if (globalTrace)
    printf("emptyList at base.qon:89\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(NULL );

if (globalTrace)
    printf("Leaving emptyList\n");

}


//Building function isEmpty from line: 91

bool isEmpty(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  };

}


//Building function listLength from line: 97

int listLength(list l ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(0 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(listLength(cdr(l ))));

  };

}


//Building function alistCons from line: 106

list alistCons(box key ,box value ,list alist ) {
  
if (globalTrace)
    printf("alistCons at base.qon:106\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(cons(key , value ), alist ));

if (globalTrace)
    printf("Leaving alistCons\n");

}


//Building function assoc from line: 109

list assoc(char* searchTerm ,list l ) {
  list elem = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    elem = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    assertType("list" , elem );
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


//Building function equalBox from line: 128

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


//Building function displayList from line: 149

void displayList(list l ,int indent ) {
  box val = NULL ;

if (globalTrace)
    printf("displayList at base.qon:149\n");
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

          displayList(cdr(l ), add1(indent ));

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


//Building function display from line: 179

void display(list l ) {
  
if (globalTrace)
    printf("display at base.qon:179\n");
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


//Building function boxString from line: 195

box boxString(char* s ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->str = s ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->lengt = string_length(s );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "string" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function boxSymbol from line: 205

box boxSymbol(char* s ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = boxString(s );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "symbol" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function boxBool from line: 210

box boxBool(bool boo ) {
  box b = NULL ;

if (globalTrace)
    printf("boxBool at base.qon:210\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->boo = boo ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "bool" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

if (globalTrace)
    printf("Leaving boxBool\n");

}


//Building function boxInt from line: 219

box boxInt(int val ) {
  box b = NULL ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->i = val ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "int" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function assertType from line: 228

void assertType(char* atype ,box abox ) {
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

      printf("Assertion failure: provided value is not a '%s'!  It was actually:" , atype );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      display(abox );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      panic("Invalid type!" );

    };

  };

}


//Building function unBoxString from line: 240

char* unBoxString(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("string" , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

}


//Building function unBoxSymbol from line: 243

char* unBoxSymbol(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

}


//Building function unBoxBool from line: 244

bool unBoxBool(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->boo);

}


//Building function unBoxInt from line: 245

int unBoxInt(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->i);

}


//Building function stringify from line: 247

char* stringify(box b ) {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("nil" );

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

            return(boxType(b ));

          };

        };

      };

    };

  };

}


//Building function hasTag from line: 269

bool hasTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("hasTag at base.qon:269\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(isNotFalse(assoc(stringify(key ), aBox->tag)));

  };

if (globalTrace)
    printf("Leaving hasTag\n");

}


//Building function getTag from line: 275

box getTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("getTag at base.qon:275\n");
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


//Building function getTagFail from line: 287

box getTagFail(box aBox ,box key ,box onFail ) {
  
if (globalTrace)
    printf("getTagFail at base.qon:287\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( hasTag(aBox , key )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(getTag(aBox , key ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(onFail );

  };

if (globalTrace)
    printf("Leaving getTagFail\n");

}


//Building function assocExists from line: 293

bool assocExists(char* key ,box aBox ) {
  
if (globalTrace)
    printf("assocExists at base.qon:293\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(isNotFalse(assoc(key , aBox )));

  };

if (globalTrace)
    printf("Leaving assocExists\n");

}


//Building function assocFail from line: 301

box assocFail(char* key ,box aBox ,box onFail ) {
  
if (globalTrace)
    printf("assocFail at base.qon:301\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( assocExists(key , aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(assoc(key , aBox ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(key ), onFail ));

  };

if (globalTrace)
    printf("Leaving assocFail\n");

}


//Building function setTag from line: 309

box setTag(box key ,list val ,box aStruct ) {
  
if (globalTrace)
    printf("setTag at base.qon:309\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  aStruct->tag = alistCons(key , val , aStruct->tag);
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(aStruct );

if (globalTrace)
    printf("Leaving setTag\n");

}


//Building function filterVoid from line: 319

list filterVoid(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterVoid at base.qon:319\n");
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


//Building function filterTokens from line: 331

list filterTokens(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterTokens at base.qon:331\n");
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

          return(cons(token , filterTokens(cdr(l ))));

        };

      };

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cons(token , filterTokens(cdr(l ))));

    };

  };

if (globalTrace)
    printf("Leaving filterTokens\n");

}


//Building function finish_token from line: 357

box finish_token(char* prog ,int start ,int len ,int line ,int column ,char* filename ) {
  box token = NULL ;

if (globalTrace)
    printf("finish_token at base.qon:357\n");
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


//Building function readString from line: 372

char* readString(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readString at base.qon:372\n");
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
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(readString(prog , start , add1(len )));

  };

if (globalTrace)
    printf("Leaving readString\n");

}


//Building function readComment from line: 383

char* readComment(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readComment at base.qon:383\n");
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


//Building function isWhiteSpace from line: 391

bool isWhiteSpace(char* s ) {
  
if (globalTrace)
    printf("isWhiteSpace at base.qon:391\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(" " , s )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString("\n" , s )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(true );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString("\r" , s )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(true );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(false );

      };

    };

  };

if (globalTrace)
    printf("Leaving isWhiteSpace\n");

}


//Building function isLineBreak from line: 405

bool isLineBreak(char* s ) {
  
if (globalTrace)
    printf("isLineBreak at base.qon:405\n");
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


//Building function incForNewLine from line: 412

int incForNewLine(box token ,int val ) {
  
if (globalTrace)
    printf("incForNewLine at base.qon:412\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("\n" , stringify(token ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(val ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(val );

  };

if (globalTrace)
    printf("Leaving incForNewLine\n");

}


//Building function annotateReadPosition from line: 419

box annotateReadPosition(char* filename ,int linecount ,int column ,int start ,box newBox ) {
  
if (globalTrace)
    printf("annotateReadPosition at base.qon:419\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(setTag(boxString("filename" ), boxString(filename ), setTag(boxString("column" ), boxInt(column ), setTag(boxString("line" ), boxInt(linecount ), setTag(boxString("totalCharPos" ), boxInt(start ), newBox )))));

if (globalTrace)
    printf("Leaving annotateReadPosition\n");

}


//Building function scan from line: 431

list scan(char* prog ,int start ,int len ,int linecount ,int column ,char* filename ) {
  box token = NULL ;
char* newString = "" ;
box newBox = NULL ;

if (globalTrace)
    printf("scan at base.qon:431\n");
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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(emptyList ());

if (globalTrace)
    printf("Leaving scan\n");

}


//Building function isOpenBrace from line: 472

bool isOpenBrace(box b ) {
  
if (globalTrace)
    printf("isOpenBrace at base.qon:472\n");
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


//Building function openBrace from line: 482

char* openBrace() {
  
if (globalTrace)
    printf("openBrace at base.qon:482\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("(" );

if (globalTrace)
    printf("Leaving openBrace\n");

}


//Building function isCloseBrace from line: 484

bool isCloseBrace(box b ) {
  
if (globalTrace)
    printf("isCloseBrace at base.qon:484\n");
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


//Building function closeBrace from line: 494

char* closeBrace() {
  
if (globalTrace)
    printf("closeBrace at base.qon:494\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(")" );

if (globalTrace)
    printf("Leaving closeBrace\n");

}


//Building function sexprTree from line: 496

list sexprTree(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("sexprTree at base.qon:496\n");
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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("AAAAAA code should never reach here!\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(emptyList ());

if (globalTrace)
    printf("Leaving sexprTree\n");

}


//Building function skipList from line: 515

list skipList(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("skipList at base.qon:515\n");
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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("AAAAAA code should never reach here!\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(emptyList ());

if (globalTrace)
    printf("Leaving skipList\n");

}


//Building function readSexpr from line: 530

list readSexpr(char* aStr ,char* filename ) {
  list tokens = NULL ;
list as = NULL ;

if (globalTrace)
    printf("readSexpr at base.qon:530\n");
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


//Building function caar from line: 540

box caar(list l ) {
  
if (globalTrace)
    printf("caar at base.qon:540\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(car(l )));

if (globalTrace)
    printf("Leaving caar\n");

}


//Building function cadr from line: 541

box cadr(list l ) {
  
if (globalTrace)
    printf("cadr at base.qon:541\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(l )));

if (globalTrace)
    printf("Leaving cadr\n");

}


//Building function caddr from line: 542

box caddr(list l ) {
  
if (globalTrace)
    printf("caddr at base.qon:542\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(l ))));

if (globalTrace)
    printf("Leaving caddr\n");

}


//Building function cadddr from line: 543

box cadddr(list l ) {
  
if (globalTrace)
    printf("cadddr at base.qon:543\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(l )))));

if (globalTrace)
    printf("Leaving cadddr\n");

}


//Building function caddddr from line: 545

box caddddr(list l ) {
  
if (globalTrace)
    printf("caddddr at base.qon:545\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(cdr(l ))))));

if (globalTrace)
    printf("Leaving caddddr\n");

}


//Building function cddr from line: 549

box cddr(list l ) {
  
if (globalTrace)
    printf("cddr at base.qon:549\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(cdr(l )));

if (globalTrace)
    printf("Leaving cddr\n");

}


//Building function first from line: 550

box first(list l ) {
  
if (globalTrace)
    printf("first at base.qon:550\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(l ));

if (globalTrace)
    printf("Leaving first\n");

}


//Building function second from line: 551

box second(list l ) {
  
if (globalTrace)
    printf("second at base.qon:551\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadr(l ));

if (globalTrace)
    printf("Leaving second\n");

}


//Building function third from line: 552

box third(list l ) {
  
if (globalTrace)
    printf("third at base.qon:552\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddr(l ));

if (globalTrace)
    printf("Leaving third\n");

}


//Building function fourth from line: 553

box fourth(list l ) {
  
if (globalTrace)
    printf("fourth at base.qon:553\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadddr(l ));

if (globalTrace)
    printf("Leaving fourth\n");

}


//Building function fifth from line: 554

box fifth(list l ) {
  
if (globalTrace)
    printf("fifth at base.qon:554\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddddr(l ));

if (globalTrace)
    printf("Leaving fifth\n");

}


//Building function makeNode from line: 560

list makeNode(char* name ,char* subname ,list code ,list children ) {
  
if (globalTrace)
    printf("makeNode at base.qon:560\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ())))))));

if (globalTrace)
    printf("Leaving makeNode\n");

}


//Building function addToNode from line: 576

list addToNode(box key ,box val ,list node ) {
  
if (globalTrace)
    printf("addToNode at base.qon:576\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxSymbol("node" ), alistCons(key , val , cdr(node ))));

if (globalTrace)
    printf("Leaving addToNode\n");

}


//Building function makeStatementNode from line: 581

list makeStatementNode(char* name ,char* subname ,list code ,list children ,box functionName ) {
  
if (globalTrace)
    printf("makeStatementNode at base.qon:581\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(addToNode(boxSymbol("functionName" ), functionName , makeNode(name , subname , code , children )));

if (globalTrace)
    printf("Leaving makeStatementNode\n");

}


//Building function astExpression from line: 586

list astExpression(list tree ) {
  
if (globalTrace)
    printf("astExpression at base.qon:586\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("expression" , "expression" , NULL , astSubExpression(tree )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astSubExpression(tree ));

  };

if (globalTrace)
    printf("Leaving astExpression\n");

}


//Building function astSubExpression from line: 594

list astSubExpression(list tree ) {
  
if (globalTrace)
    printf("astSubExpression at base.qon:594\n");
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


//Building function astIf from line: 605

list astIf(list tree ,box fname ) {
  
if (globalTrace)
    printf("astIf at base.qon:605\n");
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


//Building function astSetStruct from line: 626

list astSetStruct(list tree ) {
  
if (globalTrace)
    printf("astSetStruct at base.qon:626\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));

if (globalTrace)
    printf("Leaving astSetStruct\n");

}


//Building function astSet from line: 631

list astSet(list tree ) {
  
if (globalTrace)
    printf("astSet at base.qon:631\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));

if (globalTrace)
    printf("Leaving astSet\n");

}


//Building function astGetStruct from line: 636

list astGetStruct(list tree ) {
  
if (globalTrace)
    printf("astGetStruct at base.qon:636\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("expression" , "structGetter" , tree , NULL ));

if (globalTrace)
    printf("Leaving astGetStruct\n");

}


//Building function astReturnVoid from line: 639

list astReturnVoid(box fname ) {
  
if (globalTrace)
    printf("astReturnVoid at base.qon:639\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeStatementNode("statement" , "returnvoid" , NULL , NULL , fname ));

if (globalTrace)
    printf("Leaving astReturnVoid\n");

}


//Building function astStatement from line: 643

list astStatement(list tree ,box fname ) {
  
if (globalTrace)
    printf("astStatement at base.qon:643\n");
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


//Building function astBody from line: 673

list astBody(list tree ,box fname ) {
  
if (globalTrace)
    printf("astBody at base.qon:673\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astStatement(car(tree ), fname ), astBody(cdr(tree ), fname )));

  };

if (globalTrace)
    printf("Leaving astBody\n");

}


//Building function astFunction from line: 679

list astFunction(list tree ) {
  box fname = NULL ;

if (globalTrace)
    printf("astFunction at base.qon:679\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  fname = second(tree );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )), fname )), emptyList ()))))))));

if (globalTrace)
    printf("Leaving astFunction\n");

}


//Building function astFunctionList from line: 700

list astFunctionList(list tree ) {
  
if (globalTrace)
    printf("astFunctionList at base.qon:700\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astFunctionList\n");

}


//Building function astFunctions from line: 708

list astFunctions(list tree ) {
  
if (globalTrace)
    printf("astFunctions at base.qon:708\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(car(tree ), boxString("functions" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving astFunctions\n");

}


//Building function loadLib from line: 719

list loadLib(char* path ) {
  char* programStr = "" ;
list tree = NULL ;
list library = NULL ;

if (globalTrace)
    printf("loadLib at base.qon:719\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(library );

if (globalTrace)
    printf("Leaving loadLib\n");

}


//Building function astInclude from line: 735

list astInclude(list tree ) {
  
if (globalTrace)
    printf("astInclude at base.qon:735\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(loadLib(stringify(tree )));

if (globalTrace)
    printf("Leaving astInclude\n");

}


//Building function astIncludeList from line: 738

list astIncludeList(list tree ) {
  
if (globalTrace)
    printf("astIncludeList at base.qon:738\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astIncludeList\n");

}


//Building function astIncludes from line: 745

list astIncludes(list tree ) {
  
if (globalTrace)
    printf("astIncludes at base.qon:745\n");
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


//Building function astStruct from line: 755

list astStruct(list tree ) {
  
if (globalTrace)
    printf("astStruct at base.qon:755\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("type" , "struct" , tree , NULL ));

if (globalTrace)
    printf("Leaving astStruct\n");

}


//Building function astType from line: 758

list astType(list tree ) {
  
if (globalTrace)
    printf("astType at base.qon:758\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(cadr(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astStruct(tree ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("type" , "type" , tree , NULL ));

  };

if (globalTrace)
    printf("Leaving astType\n");

}


//Building function astTypeList from line: 764

list astTypeList(list tree ) {
  
if (globalTrace)
    printf("astTypeList at base.qon:764\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));

  };

if (globalTrace)
    printf("Leaving astTypeList\n");

}


//Building function astTypes from line: 770

list astTypes(list tree ) {
  
if (globalTrace)
    printf("astTypes at base.qon:770\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(car(tree ), boxString("types" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    panic("Types section not found!  Every program must have a types section, even if you don't define any types" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving astTypes\n");

}


//Building function declarationsof from line: 779

list declarationsof(list ass ) {
  
if (globalTrace)
    printf("declarationsof at base.qon:779\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("declarations" , cdr(ass ))));

if (globalTrace)
    printf("Leaving declarationsof\n");

}


//Building function codeof from line: 782

list codeof(list ass ) {
  
if (globalTrace)
    printf("codeof at base.qon:782\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("code" , cdr(ass ))));

if (globalTrace)
    printf("Leaving codeof\n");

}


//Building function functionNameof from line: 785

list functionNameof(list ass ) {
  
if (globalTrace)
    printf("functionNameof at base.qon:785\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("functionName" , cdr(ass ))));

if (globalTrace)
    printf("Leaving functionNameof\n");

}


//Building function nodeof from line: 789

list nodeof(list ass ) {
  
if (globalTrace)
    printf("nodeof at base.qon:789\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("node" , cdr(ass ))));

  };

if (globalTrace)
    printf("Leaving nodeof\n");

}


//Building function lineof from line: 797

list lineof(list ass ) {
  
if (globalTrace)
    printf("lineof at base.qon:797\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("line" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxInt(-1 ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("line" , cdr(ass ))));

  };

if (globalTrace)
    printf("Leaving lineof\n");

}


//Building function subnameof from line: 805

list subnameof(list ass ) {
  
if (globalTrace)
    printf("subnameof at base.qon:805\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("subname" , cdr(ass ))));

if (globalTrace)
    printf("Leaving subnameof\n");

}


//Building function nameof from line: 810

list nameof(list ass ) {
  
if (globalTrace)
    printf("nameof at base.qon:810\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("name" , cdr(ass ))));

if (globalTrace)
    printf("Leaving nameof\n");

}


//Building function childrenof from line: 815

list childrenof(list ass ) {
  
if (globalTrace)
    printf("childrenof at base.qon:815\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("children" , cdr(ass ))));

if (globalTrace)
    printf("Leaving childrenof\n");

}


//Building function isNode from line: 819

bool isNode(list val ) {
  
if (globalTrace)
    printf("isNode at base.qon:819\n");
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


//Building function truthy from line: 833

bool truthy(box aVal ) {
  
if (globalTrace)
    printf("truthy at base.qon:833\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(isNotFalse(aVal ));

if (globalTrace)
    printf("Leaving truthy\n");

}


//Building function isNotFalse from line: 837

bool isNotFalse(box aVal ) {
  
if (globalTrace)
    printf("isNotFalse at base.qon:837\n");
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


//Building function isLeaf from line: 844

bool isLeaf(list n ) {
  
if (globalTrace)
    printf("isLeaf at base.qon:844\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(equalBox(boxString("leaf" ), subnameof(n )));

if (globalTrace)
    printf("Leaving isLeaf\n");

}


//Building function printIndent from line: 849

void printIndent(int ii ) {
  
if (globalTrace)
    printf("printIndent at base.qon:849\n");
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


//Building function newLine from line: 857

void newLine(int indent ) {
  
if (globalTrace)
    printf("newLine at base.qon:857\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printIndent(indent );

if (globalTrace)
    printf("Leaving newLine\n");

}


//Building function noStackTrace from line: 861

list noStackTrace() {
  
if (globalTrace)
    printf("noStackTrace at base.qon:861\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), NULL ))))))))))))))))))))))))));

if (globalTrace)
    printf("Leaving noStackTrace\n");

}


//Building function toStr from line: 890

box toStr(box thing ) {
  
if (globalTrace)
    printf("toStr at base.qon:890\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(boxString(stringify(thing )));

if (globalTrace)
    printf("Leaving toStr\n");

}


//Building function listLast from line: 893

box listLast(list alist ) {
  
if (globalTrace)
    printf("listLast at base.qon:893\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(cdr(alist ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(car(alist ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(listLast(cdr(alist )));

  };

if (globalTrace)
    printf("Leaving listLast\n");

}


//Building function treeCompile from line: 900

list treeCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("treeCompile at base.qon:900\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(tree );

if (globalTrace)
    printf("Leaving treeCompile\n");

}


//Building function astCompile from line: 906

void astCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("astCompile at base.qon:906\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(program );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );

if (globalTrace)
    printf("Leaving astCompile\n");

}


//Building function concatLists from line: 924

list concatLists(list seq1 ,list seq2 ) {
  
if (globalTrace)
    printf("concatLists at base.qon:924\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(seq1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(seq2 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));

  };

if (globalTrace)
    printf("Leaving concatLists\n");

}


//Building function alistKeys from line: 931

list alistKeys(list alist ) {
  
if (globalTrace)
    printf("alistKeys at base.qon:931\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(alist )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(car(alist )), alistKeys(cdr(alist ))));

  };

if (globalTrace)
    printf("Leaving alistKeys\n");

}


//Building function mergeIncludes from line: 938

list mergeIncludes(list program ) {
  
if (globalTrace)
    printf("mergeIncludes at base.qon:938\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program ));

if (globalTrace)
    printf("Leaving mergeIncludes\n");

}


//Building function merge_recur from line: 947

list merge_recur(list incs ,list program ) {
  
if (globalTrace)
    printf("merge_recur at base.qon:947\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(incs ), 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(mergeInclude(car(incs ), merge_recur(cdr(incs ), program )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(program );

  };

if (globalTrace)
    printf("Leaving merge_recur\n");

}


//Building function mergeInclude from line: 957

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
    printf("mergeInclude at base.qon:957\n");
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


//Building function argList from line: 1011

list argList(int count ,int pos ,char** args ) {
  
if (globalTrace)
    printf("argList at base.qon:1011\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(count , pos )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

if (globalTrace)
    printf("Leaving argList\n");

}


//Building function listReverse from line: 1023

list listReverse(list l ) {
  
if (globalTrace)
    printf("listReverse at base.qon:1023\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(l ), listReverse(cdr(l ))));

  };

if (globalTrace)
    printf("Leaving listReverse\n");

}


//Building function inList from line: 1029

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


//Building function tron from line: 1040

void tron() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = true ;

}


//Building function troff from line: 1041

void troff() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = false ;

}


//Building function stron from line: 1042

void stron() {
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = true ;

}


//Building function stroff from line: 1043

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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("symbol" );

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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

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


//Building function perlTypeDecl from line: 297

void perlTypeDecl(list l ) {
  
if (globalTrace)
    printf("perlTypeDecl at perl.qon:297\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s %s;\n" , stringify(second(l )), stringify(perlTypeMap(listLast(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(perlTypeMap(listLast(l ))), stringify(car(l )));

  };

if (globalTrace)
    printf("Leaving perlTypeDecl\n");

}


//Building function perlStructComponents from line: 315

void perlStructComponents(list node ) {
  
if (globalTrace)
    printf("perlStructComponents at perl.qon:315\n");
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


//Building function perlStruct from line: 321

void perlStruct(list node ) {
  
if (globalTrace)
    printf("perlStruct at perl.qon:321\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlStructComponents(cdr(car(node )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

if (globalTrace)
    printf("Leaving perlStruct\n");

}


//Building function perlTypeMap from line: 324

box perlTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlTypeMap at perl.qon:324\n");
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


//Building function perlConstMap from line: 336

box perlConstMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlConstMap at perl.qon:336\n");
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


//Building function perlFuncMap from line: 346

box perlFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlFuncMap at perl.qon:346\n");
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


//Building function perlType from line: 363

void perlType(list node ) {
  
if (globalTrace)
    printf("perlType at perl.qon:363\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(subnameof(node ), boxString("struct" ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlStruct(cdr(codeof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n} %s;\n" , stringify(first(codeof(node ))));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("typedef " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlTypeDecl(codeof(node ));

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

if (globalTrace)
    printf("Leaving perlType\n");

}


//Building function perlTypes from line: 374

void perlTypes(list nodes ) {
  
if (globalTrace)
    printf("perlTypes at perl.qon:374\n");
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


//Building function perlFunctionArgs from line: 380

void perlFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("perlFunctionArgs at perl.qon:380\n");
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


//Building function perlCompile from line: 390

void perlCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("perlCompile at perl.qon:390\n");
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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

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

  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nvoid panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" );
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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

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
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return;

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


//Building function ansiCompile from line: 312

void ansiCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("ansiCompile at ansi.qon:312\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , filename );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  program = mergeIncludes(program );
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


//Building function start from line: 4

int start() {
  bool runTests = false ;
list cmdLine = NULL ;
box filename = NULL ;
bool runPerl = false ;
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

    printf("\n\nAfter all that hard work, I need a beer...\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    beers(9 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( runTree ) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      display(treeCompile(unBoxString(filename )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( runAst ) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        astCompile(unBoxString(filename ));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( runNode ) {
        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( runPerl ) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            perlCompile(unBoxString(filename ));
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("\n" );

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            ansiCompile(unBoxString(filename ));
            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            printf("\n" );

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


