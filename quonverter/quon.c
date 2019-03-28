//["./quon" "compiler.qon" ]"compiler.qon" //Building includes AST...
//Loading library base.qon
//Building includes AST...
//Loading library perl.qon
//Building includes AST...

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
box car(list l );
list cdr(list l );
bool isList(box b );
list emptyList();
bool isEmpty(box b );
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
box setTag(box aStruct ,box key ,list val );
list filterVoid(list l );
list filterTokens(list l );
box finish_token(char* prog ,int start ,int len ,int line ,int column ,char* filename );
char* readString(char* prog ,int start ,int len );
char* readComment(char* prog ,int start ,int len );
bool isWhiteSpace(char* s );
bool isLineBreak(char* s );
int incForNewLine(box token ,int val );
list scan(char* prog ,int start ,int len ,int linecount ,int column ,char* filename );
bool isOpenBrace(box b );
char* openBrace();
bool isCloseBrace(box b );
char* closeBrace();
list sexprTree(list l );
list skipList(list l );
list readSexpr(char* aStr ,char* filename );
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
int listLength(list l );
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
list lineof(list ass );
list subnameof(list ass );
list nameof(list ass );
list childrenof(list ass );
bool isNode(list val );
bool truthy(box aVal );
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
box ansiTypeMap(box aSym );
box ansiFuncMap(box aSym );
void ansiType(list node );
void ansiTypes(list nodes );
void ansiCompile(char* filename );
list concatLists(list seq1 ,list seq2 );
list alistKeys(list alist );
list mergeIncludes(list program );
list merge_recur(list incs ,list program );
list mergeInclude(list inc ,list program );
list argList(int count ,int pos ,char** args );
list reverse(list l );
bool inList(box item ,list l );
void stackTracePush(char* file ,char* fname ,int line ,int column );
list stackTracePop();
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
void perlStatement(list node ,int indent );
void perlBody(list tree ,int indent );
void perlDeclarations(list decls ,int indent );
void perlFunction(list node );
void perlForwardDeclaration(list node );
void perlForwardDeclarations(list tree );
void perlFunctions(list tree );
void perlIncludes(list nodes );
void perlTypeDecl(list l );
void perlStructComponents(list node );
void perlStruct(list node );
box perlTypeMap(box aSym );
box perlFuncMap(box aSym );
void perlType(list node );
void perlTypes(list nodes );
void perlFunctionArgs(list tree );
void perlCompile(char* filename );
int start();

//End forward declarations



//Building function add from line: 19

int add(int a ,int b ) {
  
if (globalTrace)
    printf("add at base.qon:19\n");

  stackTracePush("base.qon", "add", 19, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(sub(a , sub(0 , b )));

  stackTracePop();
if (globalTrace)
    printf("Leaving add\n");

}


//Building function addf from line: 20

float addf(float a ,float b ) {
  
if (globalTrace)
    printf("addf at base.qon:20\n");

  stackTracePush("base.qon", "addf", 20, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(subf(a , subf(0 , b )));

  stackTracePop();
if (globalTrace)
    printf("Leaving addf\n");

}


//Building function sub1 from line: 21

int sub1(int a ) {
  
if (globalTrace)
    printf("sub1 at base.qon:21\n");

  stackTracePush("base.qon", "sub1", 21, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(sub(a , 1 ));

  stackTracePop();
if (globalTrace)
    printf("Leaving sub1\n");

}


//Building function add1 from line: 22

int add1(int a ) {
  
if (globalTrace)
    printf("add1 at base.qon:22\n");

  stackTracePush("base.qon", "add1", 22, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(add(a , 1 ));

  stackTracePop();
if (globalTrace)
    printf("Leaving add1\n");

}


//Building function clone from line: 24

box clone(box b ) {
  box newb = NULL ;

if (globalTrace)
    printf("clone at base.qon:24\n");

  stackTracePush("base.qon", "clone", 24, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving clone\n");

}


//Building function newVoid from line: 36

box newVoid() {
  box newb = NULL ;

if (globalTrace)
    printf("newVoid at base.qon:36\n");

  stackTracePush("base.qon", "newVoid", 36, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->voi = true ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newb->typ = "void" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(newb );

  stackTracePop();
if (globalTrace)
    printf("Leaving newVoid\n");

}


//Building function cons from line: 45

list cons(box data ,list l ) {
  pair p = NULL ;

if (globalTrace)
    printf("cons at base.qon:45\n");
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


//Building function stackDump from line: 54

void stackDump() {
  
if (globalTrace)
    printf("stackDump at base.qon:54\n");

  stackTracePush("base.qon", "stackDump", 54, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(globalStackTrace );

  stackTracePop();
if (globalTrace)
    printf("Leaving stackDump\n");

}


//Building function car from line: 56

box car(list l ) {
  
if (globalTrace)
    printf("car at base.qon:56\n");
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


//Building function cdr from line: 71

list cdr(list l ) {
  
if (globalTrace)
    printf("cdr at base.qon:71\n");
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
  
if (globalTrace)
    printf("isList at base.qon:83\n");

  stackTracePush("base.qon", "isList", 83, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(equalString("list" , b->typ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving isList\n");

}


//Building function emptyList from line: 90

list emptyList() {
  
if (globalTrace)
    printf("emptyList at base.qon:90\n");

  stackTracePush("base.qon", "emptyList", 90, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(NULL );

  stackTracePop();
if (globalTrace)
    printf("Leaving emptyList\n");

}


//Building function isEmpty from line: 92

bool isEmpty(box b ) {
  
if (globalTrace)
    printf("isEmpty at base.qon:92\n");

  stackTracePush("base.qon", "isEmpty", 92, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(b )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(b )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(false );

    };

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving isEmpty\n");

}


//Building function alistCons from line: 100

list alistCons(box key ,box value ,list alist ) {
  
if (globalTrace)
    printf("alistCons at base.qon:100\n");

  stackTracePush("base.qon", "alistCons", 100, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(cons(key , value ), alist ));

  stackTracePop();
if (globalTrace)
    printf("Leaving alistCons\n");

}


//Building function assoc from line: 105

list assoc(char* searchTerm ,list l ) {
  list elem = NULL ;

if (globalTrace)
    printf("assoc at base.qon:105\n");

  stackTracePush("base.qon", "assoc", 105, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("list" , l );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    elem = car(l );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isEmpty(elem )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(assoc(searchTerm , cdr(l )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( equalString(stringify(boxString(searchTerm )), stringify(car(elem )))) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(elem );

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return(assoc(searchTerm , cdr(l )));

      };

    };

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving assoc\n");

}


//Building function equalBox from line: 123

bool equalBox(box a ,box b ) {
  
if (globalTrace)
    printf("equalBox at base.qon:123\n");

  stackTracePush("base.qon", "equalBox", 123, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving equalBox\n");

}


//Building function displayList from line: 146

void displayList(list l ,int indent ) {
  box val = NULL ;

if (globalTrace)
    printf("displayList at base.qon:146\n");

  stackTracePush("base.qon", "displayList", 146, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isList(l )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isEmpty(l )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        return ;

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

  stackTracePop();
if (globalTrace)
    printf("Leaving displayList\n");

}


//Building function display from line: 176

void display(list l ) {
  
if (globalTrace)
    printf("display at base.qon:176\n");

  stackTracePush("base.qon", "display", 176, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("nil " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  stackTracePop();
if (globalTrace)
    printf("Leaving display\n");

}


//Building function boxType from line: 187

char* boxType(box b ) {
  
if (globalTrace)
    printf("boxType at base.qon:187\n");

  stackTracePush("base.qon", "boxType", 187, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->typ);

  stackTracePop();
if (globalTrace)
    printf("Leaving boxType\n");

}


//Building function boxString from line: 189

box boxString(char* s ) {
  box b = NULL ;

if (globalTrace)
    printf("boxString at base.qon:189\n");
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


//Building function boxSymbol from line: 199

box boxSymbol(char* s ) {
  box b = NULL ;

if (globalTrace)
    printf("boxSymbol at base.qon:199\n");

  stackTracePush("base.qon", "boxSymbol", 199, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = boxString(s );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "symbol" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

  stackTracePop();
if (globalTrace)
    printf("Leaving boxSymbol\n");

}


//Building function boxBool from line: 204

box boxBool(bool boo ) {
  box b = NULL ;

if (globalTrace)
    printf("boxBool at base.qon:204\n");

  stackTracePush("base.qon", "boxBool", 204, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->boo = boo ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "bool" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

  stackTracePop();
if (globalTrace)
    printf("Leaving boxBool\n");

}


//Building function boxInt from line: 213

box boxInt(int val ) {
  box b = NULL ;

if (globalTrace)
    printf("boxInt at base.qon:213\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->i = val ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->typ = "int" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b );

}


//Building function assertType from line: 222

void assertType(char* atype ,box abox ) {
  
if (globalTrace)
    printf("assertType at base.qon:222\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(abox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString(atype , "nil" )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return ;

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return ;

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( equalString(atype , boxType(abox ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return ;

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("Assertion failure: provided value is not a '%s'!  It was actually:" , atype );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      display(abox );
      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      panic("Invalid type!" );

    };

  };

}


//Building function unBoxString from line: 237

char* unBoxString(box b ) {
  
if (globalTrace)
    printf("unBoxString at base.qon:237\n");

  stackTracePush("base.qon", "unBoxString", 237, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  assertType("string" , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

  stackTracePop();
if (globalTrace)
    printf("Leaving unBoxString\n");

}


//Building function unBoxSymbol from line: 240

char* unBoxSymbol(box b ) {
  
if (globalTrace)
    printf("unBoxSymbol at base.qon:240\n");

  stackTracePush("base.qon", "unBoxSymbol", 240, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->str);

  stackTracePop();
if (globalTrace)
    printf("Leaving unBoxSymbol\n");

}


//Building function unBoxBool from line: 241

bool unBoxBool(box b ) {
  
if (globalTrace)
    printf("unBoxBool at base.qon:241\n");

  stackTracePush("base.qon", "unBoxBool", 241, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->boo);

  stackTracePop();
if (globalTrace)
    printf("Leaving unBoxBool\n");

}


//Building function unBoxInt from line: 242

int unBoxInt(box b ) {
  
if (globalTrace)
    printf("unBoxInt at base.qon:242\n");

  stackTracePush("base.qon", "unBoxInt", 242, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(b->i);

  stackTracePop();
if (globalTrace)
    printf("Leaving unBoxInt\n");

}


//Building function stringify from line: 244

char* stringify(box b ) {
  
if (globalTrace)
    printf("stringify at base.qon:244\n");

  stackTracePush("base.qon", "stringify", 244, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving stringify\n");

}


//Building function hasTag from line: 265

bool hasTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("hasTag at base.qon:265\n");

  stackTracePush("base.qon", "hasTag", 265, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(aBox )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(truthy(assoc(stringify(key ), aBox->tag)));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving hasTag\n");

}


//Building function getTag from line: 273

box getTag(box aBox ,box key ) {
  
if (globalTrace)
    printf("getTag at base.qon:273\n");

  stackTracePush("base.qon", "getTag", 273, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc(stringify(key ), aBox->tag)));

  stackTracePop();
if (globalTrace)
    printf("Leaving getTag\n");

}


//Building function getTagFail from line: 278

box getTagFail(box aBox ,box key ,box onFail ) {
  
if (globalTrace)
    printf("getTagFail at base.qon:278\n");

  stackTracePush("base.qon", "getTagFail", 278, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( hasTag(aBox , key )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(key ), aBox->tag)));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(onFail );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving getTagFail\n");

}


//Building function setTag from line: 286

box setTag(box aStruct ,box key ,list val ) {
  
if (globalTrace)
    printf("setTag at base.qon:286\n");

  stackTracePush("base.qon", "setTag", 286, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  aStruct->tag = alistCons(key , val , aStruct->tag);
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(aStruct );

  stackTracePop();
if (globalTrace)
    printf("Leaving setTag\n");

}


//Building function filterVoid from line: 294

list filterVoid(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterVoid at base.qon:294\n");

  stackTracePush("base.qon", "filterVoid", 294, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving filterVoid\n");

}


//Building function filterTokens from line: 306

list filterTokens(list l ) {
  box token = NULL ;

if (globalTrace)
    printf("filterTokens at base.qon:306\n");

  stackTracePush("base.qon", "filterTokens", 306, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving filterTokens\n");

}


//Building function finish_token from line: 332

box finish_token(char* prog ,int start ,int len ,int line ,int column ,char* filename ) {
  box token = NULL ;

if (globalTrace)
    printf("finish_token at base.qon:332\n");

  stackTracePush("base.qon", "finish_token", 332, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving finish_token\n");

}


//Building function readString from line: 355

char* readString(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readString at base.qon:355\n");

  stackTracePush("base.qon", "readString", 355, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving readString\n");

}


//Building function readComment from line: 368

char* readComment(char* prog ,int start ,int len ) {
  char* token = "" ;

if (globalTrace)
    printf("readComment at base.qon:368\n");

  stackTracePush("base.qon", "readComment", 368, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  token = sub_string(prog , sub1(add(start , len )), 1 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLineBreak(token )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(sub_string(prog , start , sub1(len )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(readComment(prog , start , add1(len )));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving readComment\n");

}


//Building function isWhiteSpace from line: 377

bool isWhiteSpace(char* s ) {
  
if (globalTrace)
    printf("isWhiteSpace at base.qon:377\n");

  stackTracePush("base.qon", "isWhiteSpace", 377, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving isWhiteSpace\n");

}


//Building function isLineBreak from line: 391

bool isLineBreak(char* s ) {
  
if (globalTrace)
    printf("isLineBreak at base.qon:391\n");

  stackTracePush("base.qon", "isLineBreak", 391, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving isLineBreak\n");

}


//Building function incForNewLine from line: 400

int incForNewLine(box token ,int val ) {
  
if (globalTrace)
    printf("incForNewLine at base.qon:400\n");

  stackTracePush("base.qon", "incForNewLine", 400, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("\n" , stringify(token ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(val ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(val );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving incForNewLine\n");

}


//Building function scan from line: 407

list scan(char* prog ,int start ,int len ,int linecount ,int column ,char* filename ) {
  box token = NULL ;

if (globalTrace)
    printf("scan at base.qon:407\n");

  stackTracePush("base.qon", "scan", 407, 0 );
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

        return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(boxSymbol(closeBrace ()), scan(prog , add(start , len ), 1 , linecount , add1(column ), filename ))));

      } else {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        if ( isWhiteSpace(stringify(token ))) {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          return(cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), scan(prog , add(start , len ), 1 , incForNewLine(token , linecount ), 0 , filename )));

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          if ( equalBox(boxSymbol(";" ), token )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(scan(prog , add(start , add1(add1(string_length(readComment(prog , add1(start ), len ))))), 1 , linecount , add1(column ), filename ));

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(boxSymbol("\"" ), token )) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(cons(boxString(readString(prog , add1(start ), len )), scan(prog , add(start , add1(add1(string_length(readString(prog , add1(start ), len ))))), 1 , linecount , add1(column ), filename )));

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

  stackTracePop();
if (globalTrace)
    printf("Leaving scan\n");

}


//Building function isOpenBrace from line: 496

bool isOpenBrace(box b ) {
  
if (globalTrace)
    printf("isOpenBrace at base.qon:496\n");

  stackTracePush("base.qon", "isOpenBrace", 496, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving isOpenBrace\n");

}


//Building function openBrace from line: 506

char* openBrace() {
  
if (globalTrace)
    printf("openBrace at base.qon:506\n");

  stackTracePush("base.qon", "openBrace", 506, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("(" );

  stackTracePop();
if (globalTrace)
    printf("Leaving openBrace\n");

}


//Building function isCloseBrace from line: 508

bool isCloseBrace(box b ) {
  
if (globalTrace)
    printf("isCloseBrace at base.qon:508\n");

  stackTracePush("base.qon", "isCloseBrace", 508, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving isCloseBrace\n");

}


//Building function closeBrace from line: 518

char* closeBrace() {
  
if (globalTrace)
    printf("closeBrace at base.qon:518\n");

  stackTracePush("base.qon", "closeBrace", 518, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(")" );

  stackTracePop();
if (globalTrace)
    printf("Leaving closeBrace\n");

}


//Building function sexprTree from line: 520

list sexprTree(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("sexprTree at base.qon:520\n");

  stackTracePush("base.qon", "sexprTree", 520, 0 );
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

        return(setTag(cons(b , sexprTree(cdr(l ))), boxString("line" ), getTagFail(b , boxString("line" ), boxInt(-1 ))));

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("AAAAAA code should never reach here!\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(emptyList ());

  stackTracePop();
if (globalTrace)
    printf("Leaving sexprTree\n");

}


//Building function skipList from line: 544

list skipList(list l ) {
  box b = NULL ;

if (globalTrace)
    printf("skipList at base.qon:544\n");

  stackTracePush("base.qon", "skipList", 544, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving skipList\n");

}


//Building function readSexpr from line: 561

list readSexpr(char* aStr ,char* filename ) {
  list tokens = NULL ;
list as = NULL ;

if (globalTrace)
    printf("readSexpr at base.qon:561\n");

  stackTracePush("base.qon", "readSexpr", 561, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tokens = emptyList ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tokens = filterTokens(filterVoid(scan(aStr , 0 , 1 , 0 , 0 , filename )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  as = sexprTree(tokens );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(as ));

  stackTracePop();
if (globalTrace)
    printf("Leaving readSexpr\n");

}


//Building function test0 from line: 573

void test0() {
  
if (globalTrace)
    printf("test0 at base.qon:573\n");

  stackTracePush("base.qon", "test0", 573, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving test0\n");

}


//Building function test1 from line: 588

void test1() {
  
if (globalTrace)
    printf("test1 at base.qon:588\n");

  stackTracePush("base.qon", "test1", 588, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("1.  pass Function call and print work\n" );

  stackTracePop();
if (globalTrace)
    printf("Leaving test1\n");

}


//Building function test2_do from line: 593

void test2_do(char* message ) {
  
if (globalTrace)
    printf("test2_do at base.qon:593\n");

  stackTracePush("base.qon", "test2_do", 593, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("2.  pass Function call with arg works: %s\n" , message );

  stackTracePop();
if (globalTrace)
    printf("Leaving test2_do\n");

}


//Building function test2 from line: 597

void test2() {
  
if (globalTrace)
    printf("test2 at base.qon:597\n");

  stackTracePush("base.qon", "test2", 597, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  test2_do("This is the argument" );

  stackTracePop();
if (globalTrace)
    printf("Leaving test2\n");

}


//Building function test3_do from line: 599

void test3_do(int b ,char* c ) {
  
if (globalTrace)
    printf("test3_do at base.qon:599\n");

  stackTracePush("base.qon", "test3_do", 599, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("3.1 pass Two arg call, first arg: %d\n" , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("3.2 pass Two arg call, second arg: %s\n" , c );

  stackTracePop();
if (globalTrace)
    printf("Leaving test3_do\n");

}


//Building function test3 from line: 605

void test3() {
  
if (globalTrace)
    printf("test3 at base.qon:605\n");

  stackTracePush("base.qon", "test3", 605, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  test3_do(42 , "Fourty-two" );

  stackTracePop();
if (globalTrace)
    printf("Leaving test3\n");

}


//Building function test4_do from line: 606

char* test4_do() {
  
if (globalTrace)
    printf("test4_do at base.qon:606\n");

  stackTracePush("base.qon", "test4_do", 606, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return("pass Return works" );

  stackTracePop();
if (globalTrace)
    printf("Leaving test4_do\n");

}


//Building function returnThis from line: 608

char* returnThis(char* returnMessage ) {
  
if (globalTrace)
    printf("returnThis at base.qon:608\n");

  stackTracePush("base.qon", "returnThis", 608, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(returnMessage );

  stackTracePop();
if (globalTrace)
    printf("Leaving returnThis\n");

}


//Building function test4 from line: 613

void test4() {
  char* message = "fail" ;

if (globalTrace)
    printf("test4 at base.qon:613\n");

  stackTracePush("base.qon", "test4", 613, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  message = test4_do ();
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("4.  %s\n" , message );

  stackTracePop();
if (globalTrace)
    printf("Leaving test4\n");

}


//Building function test5 from line: 618

void test5() {
  char* message = "fail" ;

if (globalTrace)
    printf("test5 at base.qon:618\n");

  stackTracePush("base.qon", "test5", 618, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  message = returnThis("pass return passthrough string" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("5.  %s\n" , message );

  stackTracePop();
if (globalTrace)
    printf("Leaving test5\n");

}


//Building function test6 from line: 625

void test6() {
  
if (globalTrace)
    printf("test6 at base.qon:625\n");

  stackTracePush("base.qon", "test6", 625, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( true ) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("6.  pass If statement works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("6.  fail If statement works\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test6\n");

}


//Building function test7_do from line: 633

int test7_do(int count ) {
  
if (globalTrace)
    printf("test7_do at base.qon:633\n");

  stackTracePush("base.qon", "test7_do", 633, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving test7_do\n");

}


//Building function test7 from line: 641

void test7() {
  
if (globalTrace)
    printf("test7 at base.qon:641\n");

  stackTracePush("base.qon", "test7", 641, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(0 , test7_do(10 ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("7.  pass count works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("7.  fail count fails\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test7\n");

}


//Building function beer from line: 649

void beer() {
  
if (globalTrace)
    printf("beer at base.qon:649\n");

  stackTracePush("base.qon", "beer", 649, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );

  stackTracePop();
if (globalTrace)
    printf("Leaving beer\n");

}


//Building function plural from line: 658

char* plural(int num ) {
  
if (globalTrace)
    printf("plural at base.qon:658\n");

  stackTracePush("base.qon", "plural", 658, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(num , 1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return("s" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving plural\n");

}


//Building function beers from line: 663

int beers(int count ) {
  int newcount = 0 ;

if (globalTrace)
    printf("beers at base.qon:663\n");

  stackTracePush("base.qon", "beers", 663, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving beers\n");

}


//Building function test8 from line: 679

void test8() {
  
if (globalTrace)
    printf("test8 at base.qon:679\n");

  stackTracePush("base.qon", "test8", 679, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("8.  pass Nested expressions work\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("8.  fail Nested expressions don't work\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test8\n");

}


//Building function test9 from line: 687

void test9() {
  int answer = -999999 ;

if (globalTrace)
    printf("test9 at base.qon:687\n");

  stackTracePush("base.qon", "test9", 687, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  answer = sub(sub(20 , 1 ), sub(3 , 1 ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equal(answer , 17 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("9.  pass arithmetic works\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("9.  fail arithmetic\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test9\n");

}


//Building function test10 from line: 696

void test10() {
  char* testString = "This is a test string" ;

if (globalTrace)
    printf("test10 at base.qon:696\n");

  stackTracePush("base.qon", "test10", 696, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(testString , unBoxString(car(cons(boxString(testString ), NULL ))))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("10. pass cons and car work\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("10. fail cons and car fail\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test10\n");

}


//Building function test12 from line: 706

void test12() {
  box b = NULL ;

if (globalTrace)
    printf("test12 at base.qon:706\n");

  stackTracePush("base.qon", "test12", 706, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b = malloc(sizeof(Box));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  b->str = "12. pass structure accessors\n" ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , b->str);

  stackTracePop();
if (globalTrace)
    printf("Leaving test12\n");

}


//Building function test13 from line: 714

void test13() {
  char* testString = "Hello from the filesystem!" ;
char* contents = "" ;

if (globalTrace)
    printf("test13 at base.qon:714\n");

  stackTracePush("base.qon", "test13", 714, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving test13\n");

}


//Building function test15 from line: 726

void test15() {
  char* a = "hello" ;
char* b = " world" ;
char* c = "" ;

if (globalTrace)
    printf("test15 at base.qon:726\n");

  stackTracePush("base.qon", "test15", 726, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  c = stringConcatenate(a , b );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString(c , "hello world" )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("15. pass String concatenate\n" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("15. fail String concatenate\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving test15\n");

}


//Building function test16 from line: 736

void test16() {
  list assocCell1 = NULL ;
list assList = NULL ;
list assocCell2 = NULL ;
list assocCell3 = NULL ;

if (globalTrace)
    printf("test16 at base.qon:736\n");

  stackTracePush("base.qon", "test16", 736, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving test16\n");

}


//Building function caar from line: 761

box caar(list l ) {
  
if (globalTrace)
    printf("caar at base.qon:761\n");

  stackTracePush("base.qon", "caar", 761, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(car(l )));

  stackTracePop();
if (globalTrace)
    printf("Leaving caar\n");

}


//Building function cadr from line: 762

box cadr(list l ) {
  
if (globalTrace)
    printf("cadr at base.qon:762\n");

  stackTracePush("base.qon", "cadr", 762, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(l )));

  stackTracePop();
if (globalTrace)
    printf("Leaving cadr\n");

}


//Building function caddr from line: 763

box caddr(list l ) {
  
if (globalTrace)
    printf("caddr at base.qon:763\n");

  stackTracePush("base.qon", "caddr", 763, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(l ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving caddr\n");

}


//Building function cadddr from line: 764

box cadddr(list l ) {
  
if (globalTrace)
    printf("cadddr at base.qon:764\n");

  stackTracePush("base.qon", "cadddr", 764, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(l )))));

  stackTracePop();
if (globalTrace)
    printf("Leaving cadddr\n");

}


//Building function caddddr from line: 766

box caddddr(list l ) {
  
if (globalTrace)
    printf("caddddr at base.qon:766\n");

  stackTracePush("base.qon", "caddddr", 766, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(cdr(cdr(cdr(cdr(l ))))));

  stackTracePop();
if (globalTrace)
    printf("Leaving caddddr\n");

}


//Building function cddr from line: 770

box cddr(list l ) {
  
if (globalTrace)
    printf("cddr at base.qon:770\n");

  stackTracePush("base.qon", "cddr", 770, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(cdr(l )));

  stackTracePop();
if (globalTrace)
    printf("Leaving cddr\n");

}


//Building function first from line: 771

box first(list l ) {
  
if (globalTrace)
    printf("first at base.qon:771\n");

  stackTracePush("base.qon", "first", 771, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(car(l ));

  stackTracePop();
if (globalTrace)
    printf("Leaving first\n");

}


//Building function second from line: 772

box second(list l ) {
  
if (globalTrace)
    printf("second at base.qon:772\n");

  stackTracePush("base.qon", "second", 772, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadr(l ));

  stackTracePop();
if (globalTrace)
    printf("Leaving second\n");

}


//Building function third from line: 773

box third(list l ) {
  
if (globalTrace)
    printf("third at base.qon:773\n");

  stackTracePush("base.qon", "third", 773, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddr(l ));

  stackTracePop();
if (globalTrace)
    printf("Leaving third\n");

}


//Building function fourth from line: 774

box fourth(list l ) {
  
if (globalTrace)
    printf("fourth at base.qon:774\n");

  stackTracePush("base.qon", "fourth", 774, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cadddr(l ));

  stackTracePop();
if (globalTrace)
    printf("Leaving fourth\n");

}


//Building function fifth from line: 775

box fifth(list l ) {
  
if (globalTrace)
    printf("fifth at base.qon:775\n");

  stackTracePush("base.qon", "fifth", 775, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(caddddr(l ));

  stackTracePop();
if (globalTrace)
    printf("Leaving fifth\n");

}


//Building function makeNode from line: 779

list makeNode(char* name ,char* subname ,list code ,list children ) {
  
if (globalTrace)
    printf("makeNode at base.qon:779\n");

  stackTracePush("base.qon", "makeNode", 779, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList ())))))));

  stackTracePop();
if (globalTrace)
    printf("Leaving makeNode\n");

}


//Building function astExpression from line: 797

list astExpression(list tree ) {
  
if (globalTrace)
    printf("astExpression at base.qon:797\n");

  stackTracePush("base.qon", "astExpression", 797, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("expression" , "expression" , NULL , astSubExpression(tree )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astSubExpression(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astExpression\n");

}


//Building function astSubExpression from line: 807

list astSubExpression(list tree ) {
  
if (globalTrace)
    printf("astSubExpression at base.qon:807\n");

  stackTracePush("base.qon", "astSubExpression", 807, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving astSubExpression\n");

}


//Building function astIf from line: 820

list astIf(list tree ) {
  
if (globalTrace)
    printf("astIf at base.qon:820\n");

  stackTracePush("base.qon", "astIf", 820, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), NULL ), cons(astBody(cdr(second(tree ))), cons(astBody(cdr(third(tree ))), NULL )))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astIf\n");

}


//Building function astSetStruct from line: 835

list astSetStruct(list tree ) {
  
if (globalTrace)
    printf("astSetStruct at base.qon:835\n");

  stackTracePush("base.qon", "astSetStruct", 835, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "structSetter" , tree , astExpression(third(tree ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astSetStruct\n");

}


//Building function astSet from line: 842

list astSet(list tree ) {
  
if (globalTrace)
    printf("astSet at base.qon:842\n");

  stackTracePush("base.qon", "astSet", 842, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "setter" , tree , astExpression(second(tree ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astSet\n");

}


//Building function astGetStruct from line: 849

list astGetStruct(list tree ) {
  
if (globalTrace)
    printf("astGetStruct at base.qon:849\n");

  stackTracePush("base.qon", "astGetStruct", 849, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("expression" , "structGetter" , tree , NULL ));

  stackTracePop();
if (globalTrace)
    printf("Leaving astGetStruct\n");

}


//Building function astReturnVoid from line: 854

list astReturnVoid() {
  
if (globalTrace)
    printf("astReturnVoid at base.qon:854\n");

  stackTracePush("base.qon", "astReturnVoid", 854, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("statement" , "returnvoid" , NULL , NULL ));

  stackTracePop();
if (globalTrace)
    printf("Leaving astReturnVoid\n");

}


//Building function listLength from line: 858

int listLength(list l ) {
  
if (globalTrace)
    printf("listLength at base.qon:858\n");

  stackTracePush("base.qon", "listLength", 858, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(0 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(add1(listLength(cdr(l ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving listLength\n");

}


//Building function astStatement from line: 866

list astStatement(list tree ) {
  
if (globalTrace)
    printf("astStatement at base.qon:866\n");

  stackTracePush("base.qon", "astStatement", 866, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("if" ), car(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astIf(cdr(tree )));

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

          if ( equal(listLength(tree ), 1 )) {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            if ( equalBox(car(tree ), boxString("return" ))) {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(astReturnVoid ());

            } else {              if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

              return(makeNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree ))));

            };

          } else {            if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

            return(makeNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree ))));

          };

        };

      };

    };

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astStatement\n");

}


//Building function astBody from line: 909

list astBody(list tree ) {
  
if (globalTrace)
    printf("astBody at base.qon:909\n");

  stackTracePush("base.qon", "astBody", 909, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astStatement(car(tree )), astBody(cdr(tree ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astBody\n");

}


//Building function astFunction from line: 917

list astFunction(list tree ) {
  box fname = NULL ;

if (globalTrace)
    printf("astFunction at base.qon:917\n");

  stackTracePush("base.qon", "astFunction", 917, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  fname = second(tree );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )))), emptyList ()))))))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astFunction\n");

}


//Building function astFunctionList from line: 940

list astFunctionList(list tree ) {
  
if (globalTrace)
    printf("astFunctionList at base.qon:940\n");

  stackTracePush("base.qon", "astFunctionList", 940, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astFunction(car(tree )), astFunctionList(cdr(tree ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astFunctionList\n");

}


//Building function astFunctions from line: 950

list astFunctions(list tree ) {
  
if (globalTrace)
    printf("astFunctions at base.qon:950\n");

  stackTracePush("base.qon", "astFunctions", 950, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astFunctions\n");

}


//Building function loadLib from line: 957

list loadLib(char* path ) {
  char* programStr = "" ;
list tree = NULL ;
list library = NULL ;

if (globalTrace)
    printf("loadLib at base.qon:957\n");

  stackTracePush("base.qon", "loadLib", 957, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  programStr = read_file(path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  tree = readSexpr(programStr , path );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), NULL )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(library );

  stackTracePop();
if (globalTrace)
    printf("Leaving loadLib\n");

}


//Building function astInclude from line: 974

list astInclude(list tree ) {
  
if (globalTrace)
    printf("astInclude at base.qon:974\n");

  stackTracePush("base.qon", "astInclude", 974, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(loadLib(stringify(tree )));

  stackTracePop();
if (globalTrace)
    printf("Leaving astInclude\n");

}


//Building function astIncludeList from line: 979

list astIncludeList(list tree ) {
  
if (globalTrace)
    printf("astIncludeList at base.qon:979\n");

  stackTracePush("base.qon", "astIncludeList", 979, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astInclude(car(tree )), astIncludeList(cdr(tree ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astIncludeList\n");

}


//Building function astIncludes from line: 988

list astIncludes(list tree ) {
  
if (globalTrace)
    printf("astIncludes at base.qon:988\n");

  stackTracePush("base.qon", "astIncludes", 988, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astIncludes\n");

}


//Building function astStruct from line: 995

list astStruct(list tree ) {
  
if (globalTrace)
    printf("astStruct at base.qon:995\n");

  stackTracePush("base.qon", "astStruct", 995, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("type" , "struct" , tree , NULL ));

  stackTracePop();
if (globalTrace)
    printf("Leaving astStruct\n");

}


//Building function astType from line: 1000

list astType(list tree ) {
  
if (globalTrace)
    printf("astType at base.qon:1000\n");

  stackTracePush("base.qon", "astType", 1000, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isList(cadr(tree ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(astStruct(tree ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(makeNode("type" , "type" , tree , NULL ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astType\n");

}


//Building function astTypeList from line: 1008

list astTypeList(list tree ) {
  
if (globalTrace)
    printf("astTypeList at base.qon:1008\n");

  stackTracePush("base.qon", "astTypeList", 1008, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(emptyList ());

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(astType(car(tree )), astTypeList(cdr(tree ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving astTypeList\n");

}


//Building function astTypes from line: 1016

list astTypes(list tree ) {
  
if (globalTrace)
    printf("astTypes at base.qon:1016\n");

  stackTracePush("base.qon", "astTypes", 1016, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(makeNode("types" , "types" , tree , astTypeList(cdr(tree ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving astTypes\n");

}


//Building function ansiFunctionArgs from line: 1021

void ansiFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("ansiFunctionArgs at base.qon:1021\n");

  stackTracePush("base.qon", "ansiFunctionArgs", 1021, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiFunctionArgs\n");

}


//Building function declarationsof from line: 1032

list declarationsof(list ass ) {
  
if (globalTrace)
    printf("declarationsof at base.qon:1032\n");

  stackTracePush("base.qon", "declarationsof", 1032, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("declarations" , cdr(ass ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving declarationsof\n");

}


//Building function codeof from line: 1037

list codeof(list ass ) {
  
if (globalTrace)
    printf("codeof at base.qon:1037\n");

  stackTracePush("base.qon", "codeof", 1037, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("code" , cdr(ass ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving codeof\n");

}


//Building function nodeof from line: 1042

list nodeof(list ass ) {
  
if (globalTrace)
    printf("nodeof at base.qon:1042\n");

  stackTracePush("base.qon", "nodeof", 1042, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("node" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxBool(false ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("node" , cdr(ass ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving nodeof\n");

}


//Building function lineof from line: 1050

list lineof(list ass ) {
  
if (globalTrace)
    printf("lineof at base.qon:1050\n");

  stackTracePush("base.qon", "lineof", 1050, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), assoc("line" , cdr(ass )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(boxInt(-1 ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc("line" , cdr(ass ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving lineof\n");

}


//Building function subnameof from line: 1058

list subnameof(list ass ) {
  
if (globalTrace)
    printf("subnameof at base.qon:1058\n");

  stackTracePush("base.qon", "subnameof", 1058, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("subname" , cdr(ass ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving subnameof\n");

}


//Building function nameof from line: 1063

list nameof(list ass ) {
  
if (globalTrace)
    printf("nameof at base.qon:1063\n");

  stackTracePush("base.qon", "nameof", 1063, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("name" , cdr(ass ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving nameof\n");

}


//Building function childrenof from line: 1068

list childrenof(list ass ) {
  
if (globalTrace)
    printf("childrenof at base.qon:1068\n");

  stackTracePush("base.qon", "childrenof", 1068, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(cdr(assoc("children" , cdr(ass ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving childrenof\n");

}


//Building function isNode from line: 1073

bool isNode(list val ) {
  
if (globalTrace)
    printf("isNode at base.qon:1073\n");

  stackTracePush("base.qon", "isNode", 1073, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving isNode\n");

}


//Building function truthy from line: 1088

bool truthy(box aVal ) {
  
if (globalTrace)
    printf("truthy at base.qon:1088\n");

  stackTracePush("base.qon", "truthy", 1088, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxBool(false ), aVal )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(false );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(true );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving truthy\n");

}


//Building function ansiLeaf from line: 1096

void ansiLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("ansiLeaf at base.qon:1096\n");

  stackTracePush("base.qon", "ansiLeaf", 1096, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(ansiFuncMap(codeof(thisNode )));

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiLeaf\n");

}


//Building function ansiStructGetterExpression from line: 1101

void ansiStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("ansiStructGetterExpression at base.qon:1101\n");

  stackTracePush("base.qon", "ansiStructGetterExpression", 1101, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiLeaf(thisNode , indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiStructGetterExpression\n");

}


//Building function ansiExpression from line: 1109

void ansiExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiExpression at base.qon:1109\n");

  stackTracePush("base.qon", "ansiExpression", 1109, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(ansiFuncMap(codeof(node )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiSubExpression(node , indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiExpression\n");

}


//Building function ansiRecurList from line: 1117

void ansiRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("ansiRecurList at base.qon:1117\n");

  stackTracePush("base.qon", "ansiRecurList", 1117, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiRecurList\n");

}


//Building function isLeaf from line: 1130

bool isLeaf(list n ) {
  
if (globalTrace)
    printf("isLeaf at base.qon:1130\n");

  stackTracePush("base.qon", "isLeaf", 1130, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(equalBox(boxString("leaf" ), subnameof(n )));

  stackTracePop();
if (globalTrace)
    printf("Leaving isLeaf\n");

}


//Building function ansiSubExpression from line: 1135

void ansiSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("ansiSubExpression at base.qon:1135\n");

  stackTracePush("base.qon", "ansiSubExpression", 1135, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiSubExpression\n");

}


//Building function ansiIf from line: 1178

void ansiIf(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiIf at base.qon:1178\n");

  stackTracePush("base.qon", "ansiIf", 1178, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiIf\n");

}


//Building function ansiSetStruct from line: 1193

void ansiSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiSetStruct at base.qon:1193\n");

  stackTracePush("base.qon", "ansiSetStruct", 1193, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiExpression(childrenof(node ), indent );

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiSetStruct\n");

}


//Building function ansiGetStruct from line: 1204

void ansiGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiGetStruct at base.qon:1204\n");

  stackTracePush("base.qon", "ansiGetStruct", 1204, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiGetStruct\n");

}


//Building function ansiSet from line: 1214

void ansiSet(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiSet at base.qon:1214\n");

  stackTracePush("base.qon", "ansiSet", 1214, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiExpression(childrenof(node ), indent );

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiSet\n");

}


//Building function ansiStatement from line: 1222

void ansiStatement(list node ,int indent ) {
  
if (globalTrace)
    printf("ansiStatement at base.qon:1222\n");

  stackTracePush("base.qon", "ansiStatement", 1222, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiStatement\n");

}


//Building function printIndent from line: 1242

void printIndent(int ii ) {
  
if (globalTrace)
    printf("printIndent at base.qon:1242\n");

  stackTracePush("base.qon", "printIndent", 1242, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(ii , 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("  " );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(sub1(ii ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving printIndent\n");

}


//Building function newLine from line: 1250

void newLine(int indent ) {
  
if (globalTrace)
    printf("newLine at base.qon:1250\n");

  stackTracePush("base.qon", "newLine", 1250, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printIndent(indent );

  stackTracePop();
if (globalTrace)
    printf("Leaving newLine\n");

}


//Building function ansiBody from line: 1255

void ansiBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("ansiBody at base.qon:1255\n");

  stackTracePush("base.qon", "ansiBody", 1255, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiBody(cdr(tree ), indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiBody\n");

}


//Building function ansiDeclarations from line: 1269

void ansiDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("ansiDeclarations at base.qon:1269\n");

  stackTracePush("base.qon", "ansiDeclarations", 1269, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiDeclarations\n");

}


//Building function ansiFunction from line: 1285

void ansiFunction(list node ) {
  box name = NULL ;
list noStackTrace = NULL ;

if (globalTrace)
    printf("ansiFunction at base.qon:1285\n");

  stackTracePush("base.qon", "ansiFunction", 1285, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  noStackTrace = cons(boxSymbol("stroff" ), cons(boxSymbol("troff" ), cons(boxSymbol("tron" ), cons(boxSymbol("stron" ), cons(boxSymbol("car" ), cons(boxSymbol("cdr" ), cons(boxSymbol("cons" ), cons(boxSymbol("stackTracePush" ), cons(boxSymbol("stackTracePop" ), cons(boxSymbol("assertType" ), cons(boxSymbol("boxString" ), cons(boxSymbol("boxInt" ), NULL ))))))))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

    printf("\nif (globalTrace)\n    printf(\"%s at %s:%s\\n\");\n" , stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\n  stackTracePush(\"%s\", \"%s\", %s, %d );\n" , stringify(getTag(name , boxString("filename" ))), stringify(subnameof(node )), stringify(getTag(name , boxString("line" ))), 0 );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\n  stackTracePop();\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify(subnameof(node )));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiFunction\n");

}


//Building function ansiForwardDeclaration from line: 1341

void ansiForwardDeclaration(list node ) {
  
if (globalTrace)
    printf("ansiForwardDeclaration at base.qon:1341\n");

  stackTracePush("base.qon", "ansiForwardDeclaration", 1341, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(");" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiForwardDeclaration\n");

}


//Building function ansiForwardDeclarations from line: 1355

void ansiForwardDeclarations(list tree ) {
  
if (globalTrace)
    printf("ansiForwardDeclarations at base.qon:1355\n");

  stackTracePush("base.qon", "ansiForwardDeclarations", 1355, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiForwardDeclaration(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiForwardDeclarations(cdr(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiForwardDeclarations\n");

}


//Building function ansiFunctions from line: 1365

void ansiFunctions(list tree ) {
  
if (globalTrace)
    printf("ansiFunctions at base.qon:1365\n");

  stackTracePush("base.qon", "ansiFunctions", 1365, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiFunctions(cdr(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiFunctions\n");

}


//Building function ansiIncludes from line: 1373

void ansiIncludes(list nodes ) {
  
if (globalTrace)
    printf("ansiIncludes at base.qon:1373\n");

  stackTracePush("base.qon", "ansiIncludes", 1373, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nvoid panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n\n  return start();\n\n}\n\n" );

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiIncludes\n");

}


//Building function last from line: 1381

box last(list alist ) {
  
if (globalTrace)
    printf("last at base.qon:1381\n");

  stackTracePush("base.qon", "last", 1381, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(cdr(alist ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(car(alist ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(last(cdr(alist )));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving last\n");

}


//Building function ansiTypeDecl from line: 1389

void ansiTypeDecl(list l ) {
  
if (globalTrace)
    printf("ansiTypeDecl at base.qon:1389\n");

  stackTracePush("base.qon", "ansiTypeDecl", 1389, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(last(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(ansiTypeMap(last(l ))), stringify(car(l )));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiTypeDecl\n");

}


//Building function ansiStructComponents from line: 1408

void ansiStructComponents(list node ) {
  
if (globalTrace)
    printf("ansiStructComponents at base.qon:1408\n");

  stackTracePush("base.qon", "ansiStructComponents", 1408, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiStructComponents(cdr(node ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiStructComponents\n");

}


//Building function ansiStruct from line: 1416

void ansiStruct(list node ) {
  
if (globalTrace)
    printf("ansiStruct at base.qon:1416\n");

  stackTracePush("base.qon", "ansiStruct", 1416, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  ansiStructComponents(cdr(car(node )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiStruct\n");

}


//Building function ansiTypeMap from line: 1421

box ansiTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("ansiTypeMap at base.qon:1421\n");

  stackTracePush("base.qon", "ansiTypeMap", 1421, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiTypeMap\n");

}


//Building function ansiFuncMap from line: 1435

box ansiFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("ansiFuncMap at base.qon:1435\n");

  stackTracePush("base.qon", "ansiFuncMap", 1435, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiFuncMap\n");

}


//Building function ansiType from line: 1467

void ansiType(list node ) {
  
if (globalTrace)
    printf("ansiType at base.qon:1467\n");

  stackTracePush("base.qon", "ansiType", 1467, 0 );
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

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiType\n");

}


//Building function ansiTypes from line: 1479

void ansiTypes(list nodes ) {
  
if (globalTrace)
    printf("ansiTypes at base.qon:1479\n");

  stackTracePush("base.qon", "ansiTypes", 1479, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    ansiTypes(cdr(nodes ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiTypes\n");

}


//Building function ansiCompile from line: 1487

void ansiCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("ansiCompile at base.qon:1487\n");

  stackTracePush("base.qon", "ansiCompile", 1487, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving ansiCompile\n");

}


//Building function concatLists from line: 1516

list concatLists(list seq1 ,list seq2 ) {
  
if (globalTrace)
    printf("concatLists at base.qon:1516\n");

  stackTracePush("base.qon", "concatLists", 1516, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(seq1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(seq2 );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 )));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving concatLists\n");

}


//Building function alistKeys from line: 1524

list alistKeys(list alist ) {
  
if (globalTrace)
    printf("alistKeys at base.qon:1524\n");

  stackTracePush("base.qon", "alistKeys", 1524, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(alist )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(car(alist )), alistKeys(cdr(alist ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving alistKeys\n");

}


//Building function mergeIncludes from line: 1532

list mergeIncludes(list program ) {
  
if (globalTrace)
    printf("mergeIncludes at base.qon:1532\n");

  stackTracePush("base.qon", "mergeIncludes", 1532, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program ));

  stackTracePop();
if (globalTrace)
    printf("Leaving mergeIncludes\n");

}


//Building function merge_recur from line: 1541

list merge_recur(list incs ,list program ) {
  
if (globalTrace)
    printf("merge_recur at base.qon:1541\n");

  stackTracePush("base.qon", "merge_recur", 1541, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(incs ), 0 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(mergeInclude(car(incs ), merge_recur(cdr(incs ), program )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(program );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving merge_recur\n");

}


//Building function mergeInclude from line: 1550

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
    printf("mergeInclude at base.qon:1550\n");

  stackTracePush("base.qon", "mergeInclude", 1550, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving mergeInclude\n");

}


//Building function argList from line: 1603

list argList(int count ,int pos ,char** args ) {
  
if (globalTrace)
    printf("argList at base.qon:1603\n");

  stackTracePush("base.qon", "argList", 1603, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(count , pos )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving argList\n");

}


//Building function reverse from line: 1615

list reverse(list l ) {
  
if (globalTrace)
    printf("reverse at base.qon:1615\n");

  stackTracePush("base.qon", "reverse", 1615, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(l )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(NULL );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(car(l ), reverse(cdr(l ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving reverse\n");

}


//Building function inList from line: 1623

bool inList(box item ,list l ) {
  
if (globalTrace)
    printf("inList at base.qon:1623\n");

  stackTracePush("base.qon", "inList", 1623, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving inList\n");

}


//Building function stackTracePush from line: 1634

void stackTracePush(char* file ,char* fname ,int line ,int column ) {
  
if (globalTrace)
    printf("stackTracePush at base.qon:1634\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStackTrace = cons(cons(boxString(file ), cons(boxString(fname ), cons(boxInt(line ), cons(boxInt(column ), NULL )))), globalStackTrace );

}


//Building function stackTracePop from line: 1648

list stackTracePop() {
  list top = NULL ;

if (globalTrace)
    printf("stackTracePop at base.qon:1648\n");
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  top = car(globalStackTrace );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStackTrace = cdr(globalStackTrace );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(top );

}


//Building function tron from line: 1655

void tron() {
  
if (globalTrace)
    printf("tron at base.qon:1655\n");

  stackTracePush("base.qon", "tron", 1655, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = true ;

  stackTracePop();
if (globalTrace)
    printf("Leaving tron\n");

}


//Building function troff from line: 1656

void troff() {
  
if (globalTrace)
    printf("troff at base.qon:1656\n");

  stackTracePush("base.qon", "troff", 1656, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalTrace = false ;

  stackTracePop();
if (globalTrace)
    printf("Leaving troff\n");

}


//Building function stron from line: 1657

void stron() {
  
if (globalTrace)
    printf("stron at base.qon:1657\n");

  stackTracePush("base.qon", "stron", 1657, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = true ;

  stackTracePop();
if (globalTrace)
    printf("Leaving stron\n");

}


//Building function stroff from line: 1658

void stroff() {
  
if (globalTrace)
    printf("stroff at base.qon:1658\n");

  stackTracePush("base.qon", "stroff", 1658, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  globalStepTrace = false ;

  stackTracePop();
if (globalTrace)
    printf("Leaving stroff\n");

}


//Building function numbers from line: 4

list numbers(int num ) {
  
if (globalTrace)
    printf("numbers at perl.qon:4\n");

  stackTracePush("perl.qon", "numbers", 4, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(0 , num )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString("-" ), NULL ));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cons(boxString(stringify(boxInt(num ))), numbers(sub1(num ))));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving numbers\n");

}


//Building function lexType from line: 11

char* lexType(box abox ) {
  
if (globalTrace)
    printf("lexType at perl.qon:11\n");

  stackTracePush("perl.qon", "lexType", 11, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving lexType\n");

}


//Building function perlLeaf from line: 22

void perlLeaf(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("perlLeaf at perl.qon:22\n");

  stackTracePush("perl.qon", "perlLeaf", 22, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , lexType(codeof(thisNode )))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , "\$" );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  display(perlFuncMap(codeof(thisNode )));

  stackTracePop();
if (globalTrace)
    printf("Leaving perlLeaf\n");

}


//Building function perlStructGetterExpression from line: 31

void perlStructGetterExpression(list thisNode ,int indent ) {
  
if (globalTrace)
    printf("perlStructGetterExpression at perl.qon:31\n");

  stackTracePush("perl.qon", "perlStructGetterExpression", 31, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalBox(boxString("structGetter" ), subnameof(thisNode ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlGetStruct(thisNode , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlLeaf(thisNode , indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlStructGetterExpression\n");

}


//Building function perlExpression from line: 37

void perlExpression(list node ,int indent ) {
  
if (globalTrace)
    printf("perlExpression at perl.qon:37\n");

  stackTracePush("perl.qon", "perlExpression", 37, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isLeaf(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlLeaf(node , indent );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlSubExpression(node , indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlExpression\n");

}


//Building function perlRecurList from line: 43

void perlRecurList(list expr ,int indent ) {
  
if (globalTrace)
    printf("perlRecurList at perl.qon:43\n");

  stackTracePush("perl.qon", "perlRecurList", 43, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(expr )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving perlRecurList\n");

}


//Building function perlSubExpression from line: 54

void perlSubExpression(list tree ,int indent ) {
  box thing = NULL ;

if (globalTrace)
    printf("perlSubExpression at perl.qon:54\n");

  stackTracePush("perl.qon", "perlSubExpression", 54, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( isNode(childrenof(tree ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      perlSubExpression(childrenof(tree ), indent );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      if ( isLeaf(tree )) {        if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

        printf("%s" , "\$" );
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

            printf("$%s->{%s}" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

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

  stackTracePop();
if (globalTrace)
    printf("Leaving perlSubExpression\n");

}


//Building function perlIf from line: 92

void perlIf(list node ,int indent ) {
  
if (globalTrace)
    printf("perlIf at perl.qon:92\n");

  stackTracePush("perl.qon", "perlIf", 92, 0 );
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

  stackTracePop();
if (globalTrace)
    printf("Leaving perlIf\n");

}


//Building function perlSetStruct from line: 105

void perlSetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("perlSetStruct at perl.qon:105\n");

  stackTracePush("perl.qon", "perlSetStruct", 105, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("$%s->{%s} = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlExpression(childrenof(node ), indent );

  stackTracePop();
if (globalTrace)
    printf("Leaving perlSetStruct\n");

}


//Building function perlGetStruct from line: 112

void perlGetStruct(list node ,int indent ) {
  
if (globalTrace)
    printf("perlGetStruct at perl.qon:112\n");

  stackTracePush("perl.qon", "perlGetStruct", 112, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("$%s->{%s}" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

  stackTracePop();
if (globalTrace)
    printf("Leaving perlGetStruct\n");

}


//Building function perlSet from line: 117

void perlSet(list node ,int indent ) {
  
if (globalTrace)
    printf("perlSet at perl.qon:117\n");

  stackTracePush("perl.qon", "perlSet", 117, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(indent );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("$%s = " , stringify(first(codeof(node ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlExpression(childrenof(node ), indent );

  stackTracePop();
if (globalTrace)
    printf("Leaving perlSet\n");

}


//Building function perlStatement from line: 123

void perlStatement(list node ,int indent ) {
  
if (globalTrace)
    printf("perlStatement at perl.qon:123\n");

  stackTracePush("perl.qon", "perlStatement", 123, 0 );
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

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          printf("return" );

        } else {          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          newLine(indent );
          if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

          perlExpression(childrenof(node ), indent );

        };

      };

    };

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );

  stackTracePop();
if (globalTrace)
    printf("Leaving perlStatement\n");

}


//Building function perlBody from line: 141

void perlBody(list tree ,int indent ) {
  
if (globalTrace)
    printf("perlBody at perl.qon:141\n");

  stackTracePush("perl.qon", "perlBody", 141, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s" , "if ($globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlStatement(car(tree ), indent );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlBody(cdr(tree ), indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlBody\n");

}


//Building function perlDeclarations from line: 152

void perlDeclarations(list decls ,int indent ) {
  box decl = NULL ;

if (globalTrace)
    printf("perlDeclarations at perl.qon:152\n");

  stackTracePush("perl.qon", "perlDeclarations", 152, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(decls )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    decl = car(decls );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("my \$%s = " , stringify(second(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(perlFuncMap(third(decl )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlDeclarations(cdr(decls ), indent );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlDeclarations\n");

}


//Building function perlFunction from line: 163

void perlFunction(list node ) {
  box name = NULL ;
list noStackTrace = NULL ;

if (globalTrace)
    printf("perlFunction at perl.qon:163\n");

  stackTracePush("perl.qon", "perlFunction", 163, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  name = subnameof(node );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  noStackTrace = cons(boxSymbol("troff" ), cons(boxSymbol("stroff" ), cons(boxSymbol("stron" ), cons(boxSymbol("tron" ), cons(boxSymbol("car" ), cons(boxSymbol("cdr" ), cons(boxSymbol("cons" ), cons(boxSymbol("stackTracePush" ), cons(boxSymbol("stackTracePop" ), cons(boxSymbol("assertType" ), cons(boxSymbol("boxString" ), cons(boxSymbol("boxInt" ), NULL ))))))))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n#Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  newLine(0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

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

    printf("\nif ($globalTrace) { printf(\"%s at %s:%s\\n\") }\n" , stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\n  stackTracePush(\"%s\", \"%s\", %s, %d );\n" , stringify(getTag(name , boxString("filename" ))), stringify(subnameof(node )), stringify(getTag(name , boxString("line" ))), 0 );

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlBody(childrenof(node ), 1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( inList(name , noStackTrace )) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("" );

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      printf("\n  stackTracePop();\nif ($globalTrace) {printf(\"Leaving %s\\n\")}\n" , stringify(subnameof(node )));

    };
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n}\n" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlFunction\n");

}


//Building function perlForwardDeclaration from line: 213

void perlForwardDeclaration(list node ) {
  
if (globalTrace)
    printf("perlForwardDeclaration at perl.qon:213\n");

  stackTracePush("perl.qon", "perlForwardDeclaration", 213, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isNil(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\nsub %s" , stringify(subnameof(node )));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(";" );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlForwardDeclaration\n");

}


//Building function perlForwardDeclarations from line: 223

void perlForwardDeclarations(list tree ) {
  
if (globalTrace)
    printf("perlForwardDeclarations at perl.qon:223\n");

  stackTracePush("perl.qon", "perlForwardDeclarations", 223, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlForwardDeclaration(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlForwardDeclarations(cdr(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlForwardDeclarations\n");

}


//Building function perlFunctions from line: 231

void perlFunctions(list tree ) {
  
if (globalTrace)
    printf("perlFunctions at perl.qon:231\n");

  stackTracePush("perl.qon", "perlFunctions", 231, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunction(car(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunctions(cdr(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlFunctions\n");

}


//Building function perlIncludes from line: 236

void perlIncludes(list nodes ) {
  
if (globalTrace)
    printf("perlIncludes at perl.qon:236\n");

  stackTracePush("perl.qon", "perlIncludes", 236, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , " sub greaterthan { \$_[0] > \$_[1] } ; sub equalString { \$_[0] eq \$_[1] } ;sub read_file { my \$file = shift; open my \$fh, '<', \$file or die; local \$/ = undef; my \$cont = <\$fh>; close \$fh; return \$cont; }; " );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("%s" , "sub subtract { \$_[0] - \$_[1]}" );

  stackTracePop();
if (globalTrace)
    printf("Leaving perlIncludes\n");

}


//Building function perlTypeDecl from line: 241

void perlTypeDecl(list l ) {
  
if (globalTrace)
    printf("perlTypeDecl at perl.qon:241\n");

  stackTracePush("perl.qon", "perlTypeDecl", 241, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return ;
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(l ), 2 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s %s;\n" , stringify(second(l )), stringify(perlTypeMap(last(l ))), stringify(first(l )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printIndent(1 );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("%s %s;\n" , stringify(perlTypeMap(last(l ))), stringify(car(l )));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlTypeDecl\n");

}


//Building function perlStructComponents from line: 259

void perlStructComponents(list node ) {
  
if (globalTrace)
    printf("perlStructComponents at perl.qon:259\n");

  stackTracePush("perl.qon", "perlStructComponents", 259, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(node )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlTypeDecl(car(node ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlStructComponents(cdr(node ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlStructComponents\n");

}


//Building function perlStruct from line: 267

void perlStruct(list node ) {
  
if (globalTrace)
    printf("perlStruct at perl.qon:267\n");

  stackTracePush("perl.qon", "perlStruct", 267, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlStructComponents(cdr(car(node )));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving perlStruct\n");

}


//Building function perlTypeMap from line: 270

box perlTypeMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlTypeMap at perl.qon:270\n");

  stackTracePush("perl.qon", "perlTypeMap", 270, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), NULL ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( truthy(assoc(stringify(aSym ), symMap ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(cdr(assoc(stringify(aSym ), symMap )));

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlTypeMap\n");

}


//Building function perlFuncMap from line: 282

box perlFuncMap(box aSym ) {
  list symMap = NULL ;

if (globalTrace)
    printf("perlFuncMap at perl.qon:282\n");

  stackTracePush("perl.qon", "perlFuncMap", 282, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( equalString("symbol" , boxType(aSym ))) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("sub-string" ), boxSymbol("substr" ), alistCons(boxSymbol("read-file" ), boxSymbol("read_file" ), alistCons(boxSymbol("write-file" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string-length" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), NULL ))))))));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    if ( truthy(assoc(stringify(aSym ), symMap ))) {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(cdr(assoc(stringify(aSym ), symMap )));

    } else {      if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

      return(aSym );

    };

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return(aSym );

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlFuncMap\n");

}


//Building function perlType from line: 301

void perlType(list node ) {
  
if (globalTrace)
    printf("perlType at perl.qon:301\n");

  stackTracePush("perl.qon", "perlType", 301, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return ;
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

  return ;

  stackTracePop();
if (globalTrace)
    printf("Leaving perlType\n");

}


//Building function perlTypes from line: 311

void perlTypes(list nodes ) {
  
if (globalTrace)
    printf("perlTypes at perl.qon:311\n");

  stackTracePush("perl.qon", "perlTypes", 311, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(nodes )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlType(car(nodes ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlTypes(cdr(nodes ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlTypes\n");

}


//Building function perlFunctionArgs from line: 317

void perlFunctionArgs(list tree ) {
  
if (globalTrace)
    printf("perlFunctionArgs at perl.qon:317\n");

  stackTracePush("perl.qon", "perlFunctionArgs", 317, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( isEmpty(tree )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    return ;

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("my \$" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    display(second(tree ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf(" = shift;\n" );
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    perlFunctionArgs(cddr(tree ));

  };

  stackTracePop();
if (globalTrace)
    printf("Leaving perlFunctionArgs\n");

}


//Building function perlCompile from line: 327

void perlCompile(char* filename ) {
  char* programStr = "" ;
list tree = NULL ;
list program = NULL ;

if (globalTrace)
    printf("perlCompile at perl.qon:327\n");

  stackTracePush("perl.qon", "perlCompile", 327, 0 );
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

  printf("my \$globalStackTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$globalTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$globalStepTrace = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$globalArgs = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$globalArgsCount = undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$true = 1;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$false = 0;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("my \$undef;\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\nsub isNil {\n    return defined($_[0]);\n}\n\n\n#Forward declarations\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("\n\n#End forward declarations\n\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf(";\n" );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  printf("start();" );

  stackTracePop();
if (globalTrace)
    printf("Leaving perlCompile\n");

}


//Building function start from line: 4

int start() {
  bool runTests = false ;
list cmdLine = NULL ;
box filename = NULL ;

if (globalTrace)
    printf("start at compiler.qon:4\n");

  stackTracePush("compiler.qon", "start", 4, 0 );
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  cmdLine = reverse(argList(globalArgsCount , 0 , globalArgs ));
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  if ( greaterthan(listLength(cmdLine ), 1 )) {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    filename = second(cmdLine );

  } else {    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    filename = boxString("compiler.qon" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  runTests = inList(boxString("--test" ), cmdLine );
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

    perlCompile(unBoxString(filename ));
    if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

    printf("\n" );

  };
  if (globalStepTrace) printf("StepTrace %s:%d\n", __FILE__, __LINE__);

  return(0 );

  stackTracePop();
if (globalTrace)
    printf("Leaving start\n");

}


