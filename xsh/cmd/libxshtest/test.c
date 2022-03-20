#include <stdio.h>
#include "../../libxsh.h"

int main()
{
    XshInit();
    XshEval("puts Hello world from Xsh!", "greeter");
    printf("2 + 2 = %s\n", XshEval("+ 2 2", "calc"));
    return 0;
}