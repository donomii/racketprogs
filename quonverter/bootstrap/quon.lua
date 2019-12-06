---Matched!: write-file
---Matched!: write-file
---Matched!: write-file
---Matched!: write-file
---Matched!: write-file
---Matched!: write-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: read-file
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: string-length
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: sub-string
---Matched!: stringLength

function luaDump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. luaDump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
printf = function(s,...)
return io.write(s:format(...))
end -- function
    
function stringConcatenate(a,b)
return a..b
end
    
function getStringArray(index, arr)
return arr[index]
end
       
function luaWriteFile(name, data)  
local file = io.open(name, "w")
file:write(data)
file:close(file)
end
    function luaSubstring(s, start, length)
return string.sub(s, start, start+length)
end
    
    function luaReadFile(file)
      local f = assert(io.open(file, "rb"))
      local content = f:read("*all")      f:close()
      return content
    end
     
function equalString(a,b)
        return a==b;
     end
    
     function new()
        return {};
     end
    
     function isNil(val)
        return val == nil;
     end
    
     function getEnv(key)
        return os.getenv(key);
     end
    
    function panic(s)
      do return end;
    end
    
    function sub(a, b) 
      return a - b; 
    end

    function mult(a, b) 
      return a * b;
    end
    
    function greaterthan(a, b)
      return a > b;
    end
    
    function subf(a, b) 
      return a - b;
    end
    
    function multf(a, b)
      return a * b;
    end
    
    function greaterthanf(a, b)
      return a > b;
    end
    
    function equal(a, b)
      return a == b;
    end
    
    function andBool(a, b)
      return a == b;
    end
    
    function string_length(s)
      return strlen(s);
    end
    
    function setSubString(target, start, source)
      target[start]=source[0];
      return target;
    end
    
    function sub_string(s, start, length)
      substr = calloc(length+1, 1);
      strncpy(substr, s+start, length);
      return substr;
    end
    
    function intToString(a)
      return a
    end

    function gc_malloc(size)
      return ""
    end
    
    function makeArray(length)
      return {}
    end
    
    function at(arr, index)
      return arr[index];
    end
    
    function setAt(array, index, value)
      array[index] = value;
    end
    
    function read_file(file)
      local f = io.open(file, "r")
      local content = ""
      local length = 0

      while f:read(0) ~= "" do
          local current = f:read("*all")

          print(#current, length)
          length = length + #current

          content = content .. current
      end

      return content
    end
    
    function write_file(filename, data)
      local file = io.open(filename,'w')
      file:write(tostring(data))
      file:close()
    end
    
    caller="";
    
    globalArgs={};
    globalArgsCount=0;
    globalTrace = false;
    globalStepTrace = false;

    function main()
      globalArgs = arg;
      globalArgsCount = #arg + 1;
      return start();
    end
    
-- Chose function name luaFunctionArgs
function luaFunctionArgs(indent ,tree )
print("caller: ", caller, "-> luaFunctionArgs")
caller="luaFunctionArgs"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      display(second(tree ));

caller=""
      if isNil(cddr(tree )) then
caller=""
          printf("" );

      else
caller=""
          printf("," );

      end

caller=""
      luaFunctionArgs(indent , cddr(tree ));

  end

end
-- Chose function name luaFunction
function luaFunction(indent ,functionDefinition )
print("caller: ", caller, "-> luaFunction")
local fname ="" 
caller="luaFunction"
  fname = stringify(second(functionDefinition ))
caller="luaFunction"
  printf("-- Chose function name %s" , fname );

caller="luaFunction"
  printf("\nfunction %s(" , fname );

caller="luaFunction"
  luaFunctionArgs(indent , third(functionDefinition ));

caller="luaFunction"
  printf(")\n" );

caller="luaFunction"
  printf("print(\"caller: \", caller, \"-> %s\")\n" , fname );

caller="luaFunction"
  luaDeclarations(add1(indent ), cdr(fourth(functionDefinition )));

caller="luaFunction"
  luaBody(fname , indent , cdr(fifth(functionDefinition )));

caller="luaFunction"
  printf("end\n" );

end
-- Chose function name luaDeclarations
function luaDeclarations(indent ,declarations )
print("caller: ", caller, "-> luaDeclarations")
local decl =nil 
caller="luaDeclarations"
  if isNil(declarations ) then
caller=""
      return 

  else
caller=""
      decl = first(declarations )
caller=""
      printf("local %s =" , stringify(second(decl )));

caller=""
      luaExpressionStart(indent , third(decl ));

caller=""
      printf("\n" );

caller=""
      luaDeclarations(indent , cdr(declarations ));

  end

end
-- Chose function name luaExpressionStart
function luaExpressionStart(indent ,program )
print("caller: ", caller, "-> luaExpressionStart")
caller="luaExpressionStart"
  if isNil(program ) then
caller=""
      return 

  else
caller=""
      if isList(program ) then
caller=""
          if equalString(stringify(car(program )), "get-struct" ) then
caller=""
              printf("%s.%s" , stringify(second(program )), stringify(third(program )));

          else
caller=""
              if equalString(stringify(car(program )), ">" ) then
caller=""
                  printf("greaterthan(" );

caller=""
                  luaExpression(indent , cdr(program ));

caller=""
                  printf(")" );

              else
caller=""
                  if equalString(stringify(car(program )), "=" ) then
caller=""
                      printf("equal(" );

caller=""
                      luaExpression(indent , cdr(program ));

caller=""
                      printf(")" );

                  else
caller=""
                      printf("%s(" , stringify(car(program )));

caller=""
                      luaExpression(indent , cdr(program ));

caller=""
                      printf(")" );

                  end

              end

          end

      else
caller=""
          luaExpression(indent , program );

      end

  end

end
-- Chose function name luaExpression
function luaExpression(indent ,program )
print("caller: ", caller, "-> luaExpression")
caller="luaExpression"
  if isNil(program ) then
caller=""
      return 

  else
caller=""
      if isList(program ) then
caller=""
          if isList(car(program )) then
caller=""
              luaExpressionStart(indent , car(program ));

          else
caller=""
              display(car(program ));

          end

caller=""
          if greaterthan(listLength(program ), 1 ) then
caller=""
              printf(", " );

          else
          end

caller=""
          luaExpression(indent , cdr(program ));

      else
caller=""
          display(program );

      end

  end

end
-- Chose function name luaStatement
function luaStatement(indent ,statement )
print("caller: ", caller, "-> luaStatement")
caller="luaStatement"
  if equalString(stringify(car(statement )), "if" ) then
caller=""
      printIndent(indent );

caller=""
      printf("if " );

caller=""
      add1(indent );

caller=""
      luaExpressionStart(add1(indent ), second(statement ));

caller=""
      printf(" then\n" );

caller=""
      luaBody(caller , add1(indent ), cdr(third(statement )));

caller=""
      printIndent(indent );

caller=""
      printf("else\n" );

caller=""
      luaBody(caller , add1(indent ), cdr(fourth(statement )));

caller=""
      printIndent(indent );

caller=""
      printf("end\n" );

  else
caller=""
      if equalString(stringify(car(statement )), "set" ) then
caller=""
          printIndent(indent );

caller=""
          printf("%s = " , stringify(second(statement )));

caller=""
          luaExpressionStart(add1(indent ), third(statement ));

      else
caller=""
          if equalString(stringify(car(statement )), "set-struct" ) then
caller=""
              printf("%s.%s = " , stringify(second(statement )), stringify(third(statement )));

caller=""
              luaExpressionStart(indent , fourth(statement ));

          else
caller=""
              if equalString(stringify(car(statement )), "return" ) then
caller=""
                  printIndent(indent );

caller=""
                  printf("return " );

caller=""
                  if greaterthan(listLength(statement ), 1 ) then
caller=""
                      luaExpressionStart(indent , second(statement ));

                  else
                  end

caller=""
                  printf("\n" );

              else
caller=""
                  printIndent(indent );

caller=""
                  luaExpressionStart(indent , statement );

caller=""
                  printf(";\n" );

              end

          end

      end

  end

end
-- Chose function name luaBody
function luaBody(local_caller ,indent ,program )
print("caller: ", caller, "-> luaBody")
caller="luaBody"
  if isNil(program ) then
caller=""
      return 

  else
caller=""
      printf("caller=\"%s\"\n" , local_caller );

caller=""
      luaStatement(add1(indent ), car(program ));

caller=""
      printf("\n" );

caller=""
      luaBody(local_caller , indent , cdr(program ));

  end

end
-- Chose function name luaFunctions
function luaFunctions(indent ,program )
print("caller: ", caller, "-> luaFunctions")
caller="luaFunctions"
  if isNil(program ) then
caller=""
      return 

  else
caller=""
      luaFunction(indent , car(program ));

caller=""
      luaFunctions(indent , cdr(program ));

  end

end
-- Chose function name luaProgram
function luaProgram(program )
print("caller: ", caller, "-> luaProgram")
caller="luaProgram"
  luaIncludes(nil );

caller="luaProgram"
  luaFunctions(0 , cdr(third(program )));

end
-- Chose function name luaIncludes
function luaIncludes(nodes )
print("caller: ", caller, "-> luaIncludes")
caller="luaIncludes"
  printf("%s" , "\nfunction luaDump(o)\n   if type(o) == 'table' then\n      local s = '{ '\n      for k,v in pairs(o) do\n         if type(k) ~= 'number' then k = '\"'..k..'\"' end\n         s = s .. '['..k..'] = ' .. luaDump(v) .. ','\n      end\n      return s .. '} '\n   else\n      return tostring(o)\n   end\nend\nprintf = function(s,...)\nreturn io.write(s:format(...))\nend -- function\n    \nfunction stringConcatenate(a,b)\nreturn a..b\nend\n    \nfunction getStringArray(index, arr)\nreturn arr[index]\nend\n       \nfunction luaWriteFile(name, data)  \nlocal file = io.open(name, \"w\")\nfile:write(data)\nfile:close(file)\nend\n    function luaSubstring(s, start, length)\nreturn string.sub(s, start, start+length)\nend\n    \n    function luaReadFile(file)\n      local f = assert(io.open(file, \"rb\"))\n      local content = f:read(\"*all\")      f:close()\n      return content\n    end\n     \nfunction equalString(a,b)\n        return a==b;\n     end\n    \n     function new()\n        return {};\n     end\n    \n     function isNil(val)\n        return val == nil;\n     end\n    \n     function getEnv(key)\n        return os.getenv(key);\n     end\n    \n    function panic(s)\n      do return end;\n    end\n    \n    function sub(a, b) \n      return a - b; \n    end\n\n    function mult(a, b) \n      return a * b;\n    end\n    \n    function greaterthan(a, b)\n      return a > b;\n    end\n    \n    function subf(a, b) \n      return a - b;\n    end\n    \n    function multf(a, b)\n      return a * b;\n    end\n    \n    function greaterthanf(a, b)\n      return a > b;\n    end\n    \n    function equal(a, b)\n      return a == b;\n    end\n    \n    function andBool(a, b)\n      return a == b;\n    end\n    \n    function string_length(s)\n      return strlen(s);\n    end\n    \n    function setSubString(target, start, source)\n      target[start]=source[0];\n      return target;\n    end\n    \n    function sub_string(s, start, length)\n      substr = calloc(length+1, 1);\n      strncpy(substr, s+start, length);\n      return substr;\n    end\n    \n    function intToString(a)\n      return a\n    end\n\n    function gc_malloc(size)\n      return \"\"\n    end\n    \n    function makeArray(length)\n      return {}\n    end\n    \n    function at(arr, index)\n      return arr[index];\n    end\n    \n    function setAt(array, index, value)\n      array[index] = value;\n    end\n    \n    function read_file(file)\n      local f = io.open(file, \"r\")\n      local content = \"\"\n      local length = 0\n\n      while f:read(0) ~= \"\" do\n          local current = f:read(\"*all\")\n\n          print(#current, length)\n          length = length + #current\n\n          content = content .. current\n      end\n\n      return content\n    end\n    \n    function write_file(filename, data)\n      local file = io.open(filename,'w')\n      file:write(tostring(data))\n      file:close()\n    end\n    \n    caller=\"\";\n    \n    globalArgs={};\n    globalArgsCount=0;\n    globalTrace = false;\n    globalStepTrace = false;\n\n    function main()\n      globalArgs = arg;\n      globalArgsCount = #arg + 1;\n      return start();\n    end\n    \n" );

end
-- Chose function name loadQuon
function loadQuon(filename )
print("caller: ", caller, "-> loadQuon")
local foundationFuncs =nil 
local foundation =nil 
local programStr ="" 
local tree =nil 
caller="loadQuon"
  foundation = readSexpr(luaReadFile(filename ), filename )
caller="loadQuon"
  foundationFuncs = cdr(third(foundation ))
caller="loadQuon"
  programStr = luaReadFile(filename )
caller="loadQuon"
  tree = readSexpr(programStr , filename )
caller="loadQuon"
  return tree 

end
-- Chose function name getIncludes
function getIncludes(program )
print("caller: ", caller, "-> getIncludes")
caller="getIncludes"
  return cdr(first(program ))

end
-- Chose function name getTypes
function getTypes(program )
print("caller: ", caller, "-> getTypes")
caller="getTypes"
  return cdr(second(program ))

end
-- Chose function name getFunctions
function getFunctions(program )
print("caller: ", caller, "-> getFunctions")
caller="getFunctions"
  return cdr(third(program ))

end
-- Chose function name loadIncludes
function loadIncludes(tree )
print("caller: ", caller, "-> loadIncludes")
local newProg =nil 
local includeFile ="" 
local functionsCombined =nil 
local typesCombined =nil 
local includeTree =nil 
local program =nil 
caller="loadIncludes"
  if greaterthan(listLength(getIncludes(tree )), 0 ) then
caller=""
      includeFile = stringify(first(getIncludes(tree )))
caller=""
      includeTree = loadQuon(includeFile )
caller=""
      functionsCombined = concatLists(getFunctions(includeTree ), getFunctions(tree ))
caller=""
      typesCombined = concatLists(getTypes(includeTree ), getTypes(tree ))
caller=""
      newProg = buildProg(cdr(getIncludes(tree )), typesCombined , functionsCombined )
caller=""
      return loadIncludes(newProg )

  else
caller=""
      return tree 

  end

end
-- Chose function name buildProg
function buildProg(includes ,types ,functions )
print("caller: ", caller, "-> buildProg")
local program =nil 
caller="buildProg"
  includes = cons(boxSymbol("includes" ), includes )
caller="buildProg"
  types = cons(boxSymbol("types" ), types )
caller="buildProg"
  functions = cons(boxSymbol("functions" ), functions )
caller="buildProg"
  program = cons(includes , cons(types , cons(functions , nil )))
caller="buildProg"
  return program 

end
-- Chose function name luaCompile
function luaCompile(filename )
print("caller: ", caller, "-> luaCompile")
local tree =nil 
caller="luaCompile"
  tree = loadQuon("compiler.qon" )
caller="luaCompile"
  tree = loadIncludes(tree )
caller="luaCompile"
  tree = macrowalk(tree )
caller="luaCompile"
  tree = macrosingle(tree , "luaWriteFile" , "luaWriteFile" )
caller="luaCompile"
  tree = macrosingle(tree , "luaReadFile" , "luaReadFile" )
caller="luaCompile"
  tree = macrosingle(tree , "string.len" , "string.len" )
caller="luaCompile"
  tree = macrosingle(tree , "luaSubstring" , "luaSubstring" )
caller="luaCompile"
  tree = macrosingle(tree , "string.len" , "string.len" )
caller="luaCompile"
  luaProgram(tree );

caller="luaCompile"
  printf("\n" );

caller="luaCompile"
  printf("function main()\nglobalArgs = arg\nglobalArgsCount = #arg\nstart()\nend\n" );

caller="luaCompile"
  printf("main()" );

end
-- Chose function name javaFunctionArgs
function javaFunctionArgs(tree )
print("caller: ", caller, "-> javaFunctionArgs")
caller="javaFunctionArgs"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      display(javaTypeMap(first(tree )));

caller=""
      display(second(tree ));

caller=""
      if isNil(cddr(tree )) then
caller=""
          printf("" );

      else
caller=""
          printf("," );

      end

caller=""
      javaFunctionArgs(cddr(tree ));

  end

end
-- Chose function name javaLeaf
function javaLeaf(thisNode ,indent )
print("caller: ", caller, "-> javaLeaf")
caller="javaLeaf"
  display(javaFuncMap(codeof(thisNode )));

end
-- Chose function name javaStructGetterExpression
function javaStructGetterExpression(thisNode ,indent )
print("caller: ", caller, "-> javaStructGetterExpression")
caller="javaStructGetterExpression"
  if equalBox(boxString("structGetter" ), subnameof(thisNode )) then
caller=""
      javaGetStruct(thisNode , indent );

  else
caller=""
      javaLeaf(thisNode , indent );

  end

end
-- Chose function name javaExpression
function javaExpression(node ,indent )
print("caller: ", caller, "-> javaExpression")
caller="javaExpression"
  if isLeaf(node ) then
caller=""
      display(javaFuncMap(codeof(node )));

  else
caller=""
      javaSubExpression(node , indent );

  end

end
-- Chose function name javaRecurList
function javaRecurList(expr ,indent )
print("caller: ", caller, "-> javaRecurList")
caller="javaRecurList"
  if isEmpty(expr ) then
caller=""
      return 

  else
caller=""
      javaExpression(car(expr ), indent );

caller=""
      if isNil(cdr(expr )) then
caller=""
          printf("" );

      else
caller=""
          printf(", " );

caller=""
          javaRecurList(cdr(expr ), indent );

      end

  end

end
-- Chose function name javaSubExpression
function javaSubExpression(tree ,indent )
print("caller: ", caller, "-> javaSubExpression")
local thing =nil 
caller="javaSubExpression"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      if isNode(childrenof(tree )) then
caller=""
          javaSubExpression(childrenof(tree ), indent );

      else
caller=""
          if isLeaf(tree ) then
caller=""
              display(javaFuncMap(codeof(tree )));

          else
caller=""
              if equal(1 , listLength(childrenof(tree ))) then
caller=""
                  display(codeof(car(childrenof(tree ))));

caller=""
                  if equalBox(boxString("return" ), codeof(car(childrenof(tree )))) then
caller=""
                      printf("" );

                  else
caller=""
                      printf("()" );

                  end

              else
caller=""
                  thing = codeof(car(childrenof(tree )))
caller=""
                  if equalBox(boxSymbol("get-struct" ), thing ) then
caller=""
                      printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

                  else
caller=""
                      if equalBox(boxSymbol("new" ), thing ) then
caller=""
                          printf("new %s()" , stringify(codeof(third(childrenof(tree )))));

                      else
caller=""
                          printf("%s(" , stringify(javaFuncMap(codeof(car(childrenof(tree ))))));

caller=""
                          javaRecurList(cdr(childrenof(tree )), indent );

caller=""
                          printf(")" );

                      end

                  end

              end

          end

      end

  end

end
-- Chose function name javaIf
function javaIf(node ,indent )
print("caller: ", caller, "-> javaIf")
caller="javaIf"
  newLine(indent );

caller="javaIf"
  printf("if ( " );

caller="javaIf"
  javaExpression(car(first(childrenof(node ))), 0 );

caller="javaIf"
  printf(") {" );

caller="javaIf"
  javaBody(second(childrenof(node )), add1(indent ));

caller="javaIf"
  newLine(indent );

caller="javaIf"
  printf("} else {" );

caller="javaIf"
  javaBody(third(childrenof(node )), add1(indent ));

caller="javaIf"
  newLine(indent );

caller="javaIf"
  printf("}" );

end
-- Chose function name javaSetStruct
function javaSetStruct(node ,indent )
print("caller: ", caller, "-> javaSetStruct")
caller="javaSetStruct"
  newLine(indent );

caller="javaSetStruct"
  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

caller="javaSetStruct"
  javaExpression(childrenof(node ), indent );

caller="javaSetStruct"
  printf(";" );

end
-- Chose function name javaGetStruct
function javaGetStruct(node ,indent )
print("caller: ", caller, "-> javaGetStruct")
caller="javaGetStruct"
  newLine(indent );

caller="javaGetStruct"
  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

end
-- Chose function name javaSet
function javaSet(node ,indent )
print("caller: ", caller, "-> javaSet")
caller="javaSet"
  newLine(indent );

caller="javaSet"
  printf("%s = " , stringify(first(codeof(node ))));

caller="javaSet"
  javaExpression(childrenof(node ), indent );

caller="javaSet"
  printf(";" );

end
-- Chose function name javaStatement
function javaStatement(node ,indent )
print("caller: ", caller, "-> javaStatement")
caller="javaStatement"
  if equalBox(boxString("setter" ), subnameof(node )) then
caller=""
      javaSet(node , indent );

  else
caller=""
      if equalBox(boxString("structSetter" ), subnameof(node )) then
caller=""
          javaSetStruct(node , indent );

      else
caller=""
          if equalBox(boxString("if" ), subnameof(node )) then
caller=""
              javaIf(node , indent );

          else
caller=""
              if equalBox(boxString("returnvoid" ), subnameof(node )) then
caller=""
                  newLine(indent );

caller=""
                  printf("return;" );

              else
caller=""
                  newLine(indent );

caller=""
                  javaExpression(childrenof(node ), indent );

caller=""
                  printf(";" );

              end

          end

      end

  end

end
-- Chose function name javaBody
function javaBody(tree ,indent )
print("caller: ", caller, "-> javaBody")
caller="javaBody"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      printIndent(indent );

caller=""
      printf("" );

caller=""
      javaStatement(car(tree ), indent );

caller=""
      javaBody(cdr(tree ), indent );

  end

end
-- Chose function name javaDeclarations
function javaDeclarations(decls ,indent )
print("caller: ", caller, "-> javaDeclarations")
local decl =nil 
caller="javaDeclarations"
  if isEmpty(decls ) then
caller=""
      return 

  else
caller=""
      decl = car(decls )
caller=""
      printf("%s %s = " , stringify(javaTypeMap(first(decl ))), stringify(second(decl )));

caller=""
      display(javaFuncMap(third(decl )));

caller=""
      printf(";\n" );

caller=""
      javaDeclarations(cdr(decls ), indent );

  end

end
-- Chose function name javaFunction
function javaFunction(node )
print("caller: ", caller, "-> javaFunction")
local name =nil 
caller="javaFunction"
  name = subnameof(node )
caller="javaFunction"
  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));

caller="javaFunction"
  newLine(0 );

caller="javaFunction"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      newLine(0 );

caller=""
      printf("public %s %s(" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));

caller=""
      javaFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      printf(") {" );

caller=""
      newLine(1 );

caller=""
      javaDeclarations(declarationsof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("" );

      end

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
      end

caller=""
      javaBody(childrenof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          if equalString("void" , stringify(javaTypeMap(cdr(assoc("outtype" , cdr(node )))))) then
caller=""
              printf("\nif (globalTrace)\n   System.out. printf(\"Leaving %s\\n\");\n" , stringify(name ));

          else
caller=""
              printf("" );

          end

      end

caller=""
      printf("\n}\n" );

  end

end
-- Chose function name javaFunctions
function javaFunctions(tree )
print("caller: ", caller, "-> javaFunctions")
caller="javaFunctions"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      javaFunction(car(tree ));

caller=""
      javaFunctions(cdr(tree ));

  end

end
-- Chose function name javaIncludes
function javaIncludes(nodes )
print("caller: ", caller, "-> javaIncludes")
caller="javaIncludes"
  printf("%s" , "public void panic(String s) {System.exit(1);}\n" );

caller="javaIncludes"
  printf("%s" , "public int sub(int a, int b) { return a - b; }\n" );

caller="javaIncludes"
  printf("%s" , "public double mult(int a, int b) { return a * b; }\n" );

caller="javaIncludes"
  printf("%s" , "public boolean greaterthan(int a, int b) { return a > b; }\n" );

caller="javaIncludes"
  printf("%s" , "public double subf(double a, double b) { return a - b; }\n" );

caller="javaIncludes"
  printf("%s" , "public double multf(double a, double b) { return a * b; }\n" );

caller="javaIncludes"
  printf("%s" , "public boolean greaterthanf(double a, double b) { return a > b; }\n" );

caller="javaIncludes"
  printf("%s" , "public boolean equal(int a, int b) { return a == b; }\n" );

caller="javaIncludes"
  printf("%s" , "public boolean equalString(String a, String b) { return a.equals(b); }\n" );

caller="javaIncludes"
  printf("%s" , "public boolean andBool(boolean a, boolean b) { return a == b;}\n" );

caller="javaIncludes"
  printf("%s" , "public int string_length(String s) { return s.length();}\n" );

caller="javaIncludes"
  printf("%s" , "public String stringConcatenate(String s1, String s2) { return s1 + s2; }\n" );

caller="javaIncludes"
  printf("%s" , "public int strcmp(String s1, String s2) { return s1.compareTo(s2);}\n" );

caller="javaIncludes"
  printf("%s" , "public String read_file(String filename) {try { return new String(Files.readAllBytes(Paths.get(filename)));} catch (Exception e) {panic(\"Could not read file\");return \"\";}}\n" );

caller="javaIncludes"
  printf("%s" , "public void write_file(String filename, String data) {try {Files.write(Paths.get(filename), data.getBytes(\"UTF-8\"));} catch (Exception e) {panic(\"Could not write file\");}}\n" );

caller="javaIncludes"
  printf("%s" , "public String sub_string(String s, int start, int length) {\nreturn s.substring(start, start+length);\n}\n\n\n\n" );

caller="javaIncludes"
  printf("%s" , "public String intToString(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );

caller="javaIncludes"
  printf("%s" , "public String character(int num) { char c=(char) num;  String s=Character.toString(c); return s;}" );

caller="javaIncludes"
  printf("%s" , "public String getStringArray(int index, String[] arr) { return arr[index];}" );

end
-- Chose function name javaTypeDecl
function javaTypeDecl(l )
print("caller: ", caller, "-> javaTypeDecl")
caller="javaTypeDecl"
  if greaterthan(listLength(l ), 2 ) then
caller=""
      printIndent(1 );

caller=""
      printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(first(l )));

  else
caller=""
      printIndent(1 );

caller=""
      printf("%s %s;\n" , stringify(javaTypeMap(listLast(l ))), stringify(car(l )));

  end

end
-- Chose function name javaStructComponents
function javaStructComponents(node )
print("caller: ", caller, "-> javaStructComponents")
caller="javaStructComponents"
  if isEmpty(node ) then
caller=""
      return 

  else
caller=""
      javaTypeDecl(car(node ));

caller=""
      javaStructComponents(cdr(node ));

  end

end
-- Chose function name javaStruct
function javaStruct(node )
print("caller: ", caller, "-> javaStruct")
caller="javaStruct"
  javaStructComponents(cdr(car(node )));

end
-- Chose function name javaTypeMap
function javaTypeMap(aSym )
print("caller: ", caller, "-> javaTypeMap")
local symMap =nil 
caller="javaTypeMap"
  symMap = alistCons(boxSymbol("pair" ), boxSymbol("Box" ), alistCons(boxSymbol("bool" ), boxSymbol("boolean" ), alistCons(boxSymbol("box" ), boxSymbol("Box" ), alistCons(boxSymbol("list" ), boxSymbol("Box" ), alistCons(boxSymbol("Box*" ), boxSymbol("Box" ), alistCons(boxSymbol("struct" ), boxSymbol("" ), alistCons(boxSymbol("int" ), boxSymbol("Integer" ), alistCons(boxSymbol("float" ), boxSymbol("double" ), alistCons(boxSymbol("stringArray" ), boxSymbol("String[]" ), alistCons(boxSymbol("string" ), boxSymbol("String" ), nil ))))))))))
caller="javaTypeMap"
  if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
      return cdr(assoc(stringify(aSym ), symMap ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name javaTypesNoDeclare
function javaTypesNoDeclare()
print("caller: ", caller, "-> javaTypesNoDeclare")
local syms =nil 
caller="javaTypesNoDeclare"
  syms = cons(boxString("pair" ), cons(boxString("box" ), nil ))
caller="javaTypesNoDeclare"
  return syms 

end
-- Chose function name javaFuncMap
function javaFuncMap(aSym )
print("caller: ", caller, "-> javaFuncMap")
local symMap =nil 
caller="javaFuncMap"
  if equalString("symbol" , boxType(aSym )) then
caller=""
      symMap = alistCons(boxSymbol("printf" ), boxSymbol("System.out.printf" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("luaSubstring" ), boxSymbol("sub_string" ), alistCons(boxSymbol("luaReadFile" ), boxSymbol("read_file" ), alistCons(boxSymbol("luaWriteFile" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string.len" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("null" ), nil ))))))))
caller=""
      if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
          return cdr(assoc(stringify(aSym ), symMap ))

      else
caller=""
          return aSym 

      end

  else
caller=""
      return aSym 

  end

end
-- Chose function name javaType
function javaType(node )
print("caller: ", caller, "-> javaType")
caller="javaType"
  if equalBox(subnameof(node ), boxString("struct" )) then
caller=""
      printf("\npublic class %s {\n" , stringify(first(codeof(node ))));

caller=""
      javaStruct(cdr(codeof(node )));

caller=""
      printf("\n};\n" );

  else
caller=""
      if inList(boxString(stringify(first(codeof(node )))), javaTypesNoDeclare()) then
caller=""
          printf("" );

      else
caller=""
          printf("public class %s extends %s {};\n" , stringify(first(codeof(node ))), stringify(javaTypeMap(listLast(codeof(node )))));

      end

  end

end
-- Chose function name javaTypes
function javaTypes(nodes )
print("caller: ", caller, "-> javaTypes")
caller="javaTypes"
  if isEmpty(nodes ) then
caller=""
      return 

  else
caller=""
      javaType(car(nodes ));

caller=""
      javaTypes(cdr(nodes ));

  end

end
-- Chose function name javaCompile
function javaCompile(filename )
print("caller: ", caller, "-> javaCompile")
local programStr ="" 
local tree =nil 
local program =nil 
caller="javaCompile"
  printf("%s" , "package quonverter;\n" );

caller="javaCompile"
  printf("%s" , "import java.nio.file.Files;\n" );

caller="javaCompile"
  printf("%s" , "import java.nio.file.Paths;\n" );

caller="javaCompile"
  printf("%s" , "import java.io.IOException;\n" );

caller="javaCompile"
  printf("%s" , "import java.io.UnsupportedEncodingException;\n" );

caller="javaCompile"
  printf("class MyProgram {\n" );

caller="javaCompile"
  programStr = luaReadFile(filename )
caller="javaCompile"
  tree = readSexpr(programStr , filename )
caller="javaCompile"
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="javaCompile"
  program = mergeIncludes(program )
caller="javaCompile"
  javaIncludes(cdr(assoc("includes" , program )));

caller="javaCompile"
  javaTypes(childrenof(cdr(assoc("types" , program ))));

caller="javaCompile"
  printf("public boolean globalStackTrace = false;\n" );

caller="javaCompile"
  printf("public boolean globalStepTrace = false;\n" );

caller="javaCompile"
  printf("public boolean globalTrace = false;\n" );

caller="javaCompile"
  printf("public String FILE = null;\n" );

caller="javaCompile"
  printf("public Integer LINE = 0;\n" );

caller="javaCompile"
  printf("public static Integer globalArgsCount = 0;\n" );

caller="javaCompile"
  printf("public static String globalArgs[];\n" );

caller="javaCompile"
  printf("\npublic boolean isNil(Box p) {\n    return p == null;\n}\n\n\n" );

caller="javaCompile"
  javaFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="javaCompile"
  printf("%s" , "public static void main(String args[]) {\nglobalArgs = args;\nglobalArgsCount = args.length;MyProgram mp = new MyProgram(); mp.start();\n}" );

caller="javaCompile"
  printf("}\n" );

end
-- Chose function name nodeFunctionArgs
function nodeFunctionArgs(tree )
print("caller: ", caller, "-> nodeFunctionArgs")
caller="nodeFunctionArgs"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      display(second(tree ));

caller=""
      if isNil(cddr(tree )) then
caller=""
          printf("" );

      else
caller=""
          printf("," );

      end

caller=""
      nodeFunctionArgs(cddr(tree ));

  end

end
-- Chose function name nodeLeaf
function nodeLeaf(thisNode ,indent )
print("caller: ", caller, "-> nodeLeaf")
caller="nodeLeaf"
  display(nodeFuncMap(codeof(thisNode )));

end
-- Chose function name nodeStructGetterExpression
function nodeStructGetterExpression(thisNode ,indent )
print("caller: ", caller, "-> nodeStructGetterExpression")
caller="nodeStructGetterExpression"
  if equalBox(boxString("structGetter" ), subnameof(thisNode )) then
caller=""
      nodeGetStruct(thisNode , indent );

  else
caller=""
      nodeLeaf(thisNode , indent );

  end

end
-- Chose function name nodeExpression
function nodeExpression(node ,indent )
print("caller: ", caller, "-> nodeExpression")
caller="nodeExpression"
  if isLeaf(node ) then
caller=""
      display(nodeFuncMap(codeof(node )));

  else
caller=""
      nodeSubExpression(node , indent );

  end

end
-- Chose function name nodeRecurList
function nodeRecurList(expr ,indent )
print("caller: ", caller, "-> nodeRecurList")
caller="nodeRecurList"
  if isEmpty(expr ) then
caller=""
      return 

  else
caller=""
      nodeExpression(car(expr ), indent );

caller=""
      if isNil(cdr(expr )) then
caller=""
          printf("" );

      else
caller=""
          printf(", " );

caller=""
          nodeRecurList(cdr(expr ), indent );

      end

  end

end
-- Chose function name nodeSubExpression
function nodeSubExpression(tree ,indent )
print("caller: ", caller, "-> nodeSubExpression")
local thing =nil 
caller="nodeSubExpression"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      if isNode(childrenof(tree )) then
caller=""
          nodeSubExpression(childrenof(tree ), indent );

      else
caller=""
          if isLeaf(tree ) then
caller=""
              display(nodeFuncMap(codeof(tree )));

          else
caller=""
              if equal(1 , listLength(childrenof(tree ))) then
caller=""
                  display(codeof(car(childrenof(tree ))));

caller=""
                  if equalBox(boxString("return" ), codeof(car(childrenof(tree )))) then
caller=""
                      printf("" );

                  else
caller=""
                      printf("()" );

                  end

              else
caller=""
                  thing = codeof(car(childrenof(tree )))
caller=""
                  if equalBox(boxSymbol("get-struct" ), thing ) then
caller=""
                      printf("%s.%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

                  else
caller=""
                      if equalBox(boxSymbol("new" ), thing ) then
caller=""
                          printf("{}" );

                      else
caller=""
                          printf("%s(" , stringify(nodeFuncMap(codeof(car(childrenof(tree ))))));

caller=""
                          nodeRecurList(cdr(childrenof(tree )), indent );

caller=""
                          printf(")" );

                      end

                  end

              end

          end

      end

  end

end
-- Chose function name nodeIf
function nodeIf(node ,indent )
print("caller: ", caller, "-> nodeIf")
caller="nodeIf"
  newLine(indent );

caller="nodeIf"
  printf("if ( " );

caller="nodeIf"
  nodeExpression(car(first(childrenof(node ))), 0 );

caller="nodeIf"
  printf(") {" );

caller="nodeIf"
  nodeBody(second(childrenof(node )), add1(indent ));

caller="nodeIf"
  newLine(indent );

caller="nodeIf"
  printf("} else {" );

caller="nodeIf"
  nodeBody(third(childrenof(node )), add1(indent ));

caller="nodeIf"
  newLine(indent );

caller="nodeIf"
  printf("}" );

end
-- Chose function name nodeGetStruct
function nodeGetStruct(node ,indent )
print("caller: ", caller, "-> nodeGetStruct")
caller="nodeGetStruct"
  newLine(indent );

caller="nodeGetStruct"
  printf("%s.%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

end
-- Chose function name nodeSet
function nodeSet(node ,indent )
print("caller: ", caller, "-> nodeSet")
caller="nodeSet"
  newLine(indent );

caller="nodeSet"
  printf("%s = " , stringify(first(codeof(node ))));

caller="nodeSet"
  nodeExpression(childrenof(node ), indent );

end
-- Chose function name nodeSetStruct
function nodeSetStruct(node ,indent )
print("caller: ", caller, "-> nodeSetStruct")
caller="nodeSetStruct"
  newLine(indent );

caller="nodeSetStruct"
  printf("%s.%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

caller="nodeSetStruct"
  nodeExpression(childrenof(node ), indent );

end
-- Chose function name nodeStatement
function nodeStatement(node ,indent )
print("caller: ", caller, "-> nodeStatement")
caller="nodeStatement"
  if equalBox(boxString("setter" ), subnameof(node )) then
caller=""
      nodeSet(node , indent );

  else
caller=""
      if equalBox(boxString("structSetter" ), subnameof(node )) then
caller=""
          nodeSetStruct(node , indent );

      else
caller=""
          if equalBox(boxString("if" ), subnameof(node )) then
caller=""
              nodeIf(node , indent );

          else
caller=""
              if equalBox(boxString("returnvoid" ), subnameof(node )) then
caller=""
                  newLine(indent );

caller=""
                  printf("return" );

              else
caller=""
                  newLine(indent );

caller=""
                  nodeExpression(childrenof(node ), indent );

              end

          end

      end

  end

caller="nodeStatement"
  printf(";\n" );

end
-- Chose function name nodeBody
function nodeBody(tree ,indent )
print("caller: ", caller, "-> nodeBody")
caller="nodeBody"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      printIndent(indent );

caller=""
      printf("%s" , "if (globalStepTrace) {console.log(new Error(\"StepTrace \\n\"));}\n" );

caller=""
      nodeStatement(car(tree ), indent );

caller=""
      nodeBody(cdr(tree ), indent );

  end

end
-- Chose function name nodeDeclarations
function nodeDeclarations(decls ,indent )
print("caller: ", caller, "-> nodeDeclarations")
local decl =nil 
caller="nodeDeclarations"
  if isEmpty(decls ) then
caller=""
      return 

  else
caller=""
      decl = car(decls )
caller=""
      printf("var %s = " , stringify(second(decl )));

caller=""
      display(nodeFuncMap(third(decl )));

caller=""
      printf(";\n" );

caller=""
      nodeDeclarations(cdr(decls ), indent );

  end

end
-- Chose function name nodeFunction
function nodeFunction(node )
print("caller: ", caller, "-> nodeFunction")
local name =nil 
caller="nodeFunction"
  name = subnameof(node )
caller="nodeFunction"
  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));

caller="nodeFunction"
  newLine(0 );

caller="nodeFunction"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      newLine(0 );

caller=""
      printf("function %s(" , stringify(subnameof(node )));

caller=""
      nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      printf(") {" );

caller=""
      newLine(1 );

caller=""
      nodeDeclarations(declarationsof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("\nif (globalTrace)\n    {printf(\"%s at %s:%s\\n\");}\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

      end

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
      end

caller=""
      nodeBody(childrenof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("\nif (globalTrace)\n    {printf(\"Leaving %s\\n\");}\n" , stringify(name ));

      end

caller=""
      printf("\n}\n" );

  end

end
-- Chose function name nodeForwardDeclaration
function nodeForwardDeclaration(node )
print("caller: ", caller, "-> nodeForwardDeclaration")
caller="nodeForwardDeclaration"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      printf("\n%s %s(" , stringify(nodeTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));

caller=""
      nodeFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      printf(");" );

  end

end
-- Chose function name nodeForwardDeclarations
function nodeForwardDeclarations(tree )
print("caller: ", caller, "-> nodeForwardDeclarations")
caller="nodeForwardDeclarations"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      nodeForwardDeclaration(car(tree ));

caller=""
      nodeForwardDeclarations(cdr(tree ));

  end

end
-- Chose function name nodeFunctions
function nodeFunctions(tree )
print("caller: ", caller, "-> nodeFunctions")
caller="nodeFunctions"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      nodeFunction(car(tree ));

caller=""
      nodeFunctions(cdr(tree ));

  end

end
-- Chose function name nodeIncludes
function nodeIncludes(nodes )
print("caller: ", caller, "-> nodeIncludes")
caller="nodeIncludes"
  printf("%s" , "function read_file(filename) {return fs.readFileSync(filename);}\n" );

caller="nodeIncludes"
  printf("%s" , "function write_file(filename, data) {fs.writeFileSync(filename, data);}\n" );

caller="nodeIncludes"
  printf("%s" , "var util = require('util');\n" );

caller="nodeIncludes"
  printf("%s" , "function printf() {process.stdout.write(util.format.apply(this, arguments));}\n" );

caller="nodeIncludes"
  printf("%s" , "var fs = require('fs');\n" );

caller="nodeIncludes"
  printf("%s" , "function equalString(a,b) {return a.toString()===b.toString() }\n" );

caller="nodeIncludes"
  printf("%s" , "function panic(s){console.trace(s);process.exit(1);}\n" );

caller="nodeIncludes"
  printf("%s" , "function dump(s){console.log(s)}" );

caller="nodeIncludes"
  printf("%s" , "function sub(a, b) { return a - b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function mult(a, b) { return a * b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function greaterthan(a, b) { return a > b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function subf(a, b) { return a - b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function multf(a, b) { return a * b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function greaterthanf(a, b) { return a > b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function equal(a, b) { return a == b; }\n" );

caller="nodeIncludes"
  printf("%s" , "function andBool(a, b) { return a == b;}\n" );

caller="nodeIncludes"
  printf("%s" , "function string_length(s) { return s.length;}\n" );

caller="nodeIncludes"
  printf("%s" , "function sub_string(str, start, len) {str = ''+str;return str.substring(start, start+len)};\n" );

caller="nodeIncludes"
  printf("%s" , "function stringConcatenate(a, b) { return a + b}\n" );

caller="nodeIncludes"
  printf("%s" , "function intToString(a) {}\n\n\n" );

caller="nodeIncludes"
  printf("%s" , "function gc_malloc( size ) {\nreturn {};\n}\n\n" );

caller="nodeIncludes"
  printf("%s" , "function makeArray(length) {\n   return [];\n}\n\n" );

caller="nodeIncludes"
  printf("%s" , "function at(arr, index) {\n  return arr[index];\n}\n\n" );

caller="nodeIncludes"
  printf("%s" , "function setAt(array, index, value) {\n    array[index] = value;\n}\n\n" );

caller="nodeIncludes"
  printf("%s" , "function getStringArray(index, strs) {\nreturn strs[index];\n}\n\n" );

caller="nodeIncludes"
  printf("%s" , "var NULL = null;" );

caller="nodeIncludes"
  printf("%s" , "var globalArgs;\nvar globalArgsCount;\nvar globalTrace = false;\nvar globalStepTrace = false;" );

caller="nodeIncludes"
  printf("%s" , "function character(num) {}" );

end
-- Chose function name nodeTypeDecl
function nodeTypeDecl(l )
print("caller: ", caller, "-> nodeTypeDecl")
caller="nodeTypeDecl"
  if greaterthan(listLength(l ), 2 ) then
caller=""
      printIndent(1 );

caller=""
      printf("%s %s %s;\n" , stringify(second(l )), stringify(nodeTypeMap(listLast(l ))), stringify(first(l )));

  else
caller=""
      printIndent(1 );

caller=""
      printf("%s %s;\n" , stringify(nodeTypeMap(listLast(l ))), stringify(car(l )));

  end

end
-- Chose function name nodeStructComponents
function nodeStructComponents(node )
print("caller: ", caller, "-> nodeStructComponents")
caller="nodeStructComponents"
  if isEmpty(node ) then
caller=""
      return 

  else
caller=""
      nodeTypeDecl(car(node ));

caller=""
      nodeStructComponents(cdr(node ));

  end

end
-- Chose function name nodeStruct
function nodeStruct(node )
print("caller: ", caller, "-> nodeStruct")
caller="nodeStruct"
  nodeStructComponents(cdr(car(node )));

end
-- Chose function name nodeTypeMap
function nodeTypeMap(aSym )
print("caller: ", caller, "-> nodeTypeMap")
local symMap =nil 
caller="nodeTypeMap"
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), nil ))
caller="nodeTypeMap"
  if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
      return cdr(assoc(stringify(aSym ), symMap ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name nodeFuncMap
function nodeFuncMap(aSym )
print("caller: ", caller, "-> nodeFuncMap")
local symMap =nil 
caller="nodeFuncMap"
  if equalString("symbol" , boxType(aSym )) then
caller=""
      symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("luaSubstring" ), boxSymbol("sub_string" ), alistCons(boxSymbol("luaReadFile" ), boxSymbol("read_file" ), alistCons(boxSymbol("luaWriteFile" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string.len" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), nil )))))))
caller=""
      if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
          return cdr(assoc(stringify(aSym ), symMap ))

      else
caller=""
          return aSym 

      end

  else
caller=""
      return aSym 

  end

end
-- Chose function name nodeType
function nodeType(node )
print("caller: ", caller, "-> nodeType")
end
-- Chose function name nodeTypes
function nodeTypes(nodes )
print("caller: ", caller, "-> nodeTypes")
caller="nodeTypes"
  if isEmpty(nodes ) then
caller=""
      return 

  else
caller=""
      nodeType(car(nodes ));

caller=""
      nodeTypes(cdr(nodes ));

  end

end
-- Chose function name nodeCompile
function nodeCompile(filename )
print("caller: ", caller, "-> nodeCompile")
local programStr ="" 
local tree =nil 
local program =nil 
caller="nodeCompile"
  programStr = luaReadFile(filename )
caller="nodeCompile"
  tree = readSexpr(programStr , filename )
caller="nodeCompile"
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="nodeCompile"
  program = mergeIncludes(program )
caller="nodeCompile"
  nodeIncludes(cdr(assoc("includes" , program )));

caller="nodeCompile"
  nodeTypes(childrenof(cdr(assoc("types" , program ))));

caller="nodeCompile"
  printf("\nvar globalStackTrace = NULL;\n" );

caller="nodeCompile"
  printf("\nfunction isNil(p) {\n    return p == NULL;\n}\n\n" );

caller="nodeCompile"
  nodeFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="nodeCompile"
  printf("\n" );

caller="nodeCompile"
  printf("const [asfdasdf, ...qwerqwer] = process.argv;" );

caller="nodeCompile"
  printf("globalArgs = qwerqwer;" );

caller="nodeCompile"
  printf("globalArgsCount = qwerqwer.length;" );

caller="nodeCompile"
  printf("%s" , "start();\n" );

end
-- Chose function name test0
function test0()
print("caller: ", caller, "-> test0")
caller="test0"
  if equalString(stringify(boxString("hello" )), stringify(boxString("hello" ))) then
caller=""
      printf("0.  pass string compare works\n" );

  else
caller=""
      printf("0.  pass string compare fails\n" );

  end

caller="test0"
  if equalString(stringify(boxString("hello" )), stringify(boxSymbol("hello" ))) then
caller=""
      printf("0.  pass string compare works\n" );

  else
caller=""
      printf("0.  pass string compare fails\n" );

  end

end
-- Chose function name test1
function test1()
print("caller: ", caller, "-> test1")
caller="test1"
  printf("1.  pass Function call and print work\n" );

end
-- Chose function name test2_do
function test2_do(message )
print("caller: ", caller, "-> test2_do")
caller="test2_do"
  printf("2.  pass Function call with arg works: %s\n" , message );

end
-- Chose function name test2
function test2()
print("caller: ", caller, "-> test2")
caller="test2"
  test2_do("This is the argument" );

end
-- Chose function name test3_do
function test3_do(b ,c )
print("caller: ", caller, "-> test3_do")
caller="test3_do"
  printf("3.1 pass Two arg call, first arg: %d\n" , b );

caller="test3_do"
  printf("3.2 pass Two arg call, second arg: %s\n" , c );

end
-- Chose function name test3
function test3()
print("caller: ", caller, "-> test3")
caller="test3"
  test3_do(42 , "Fourty-two" );

end
-- Chose function name test4_do
function test4_do()
print("caller: ", caller, "-> test4_do")
caller="test4_do"
  return "pass Return works" 

end
-- Chose function name returnThis
function returnThis(returnMessage )
print("caller: ", caller, "-> returnThis")
caller="returnThis"
  return returnMessage 

end
-- Chose function name test4
function test4()
print("caller: ", caller, "-> test4")
local message ="fail" 
caller="test4"
  message = test4_do()
caller="test4"
  printf("4.  %s\n" , message );

end
-- Chose function name test5
function test5()
print("caller: ", caller, "-> test5")
local message ="fail" 
caller="test5"
  message = returnThis("pass return passthrough string" )
caller="test5"
  printf("5.  %s\n" , message );

end
-- Chose function name test6
function test6()
print("caller: ", caller, "-> test6")
caller="test6"
  if true  then
caller=""
      printf("6.  pass If statement works\n" );

  else
caller=""
      printf("6.  fail If statement works\n" );

  end

end
-- Chose function name test7_do
function test7_do(count )
print("caller: ", caller, "-> test7_do")
caller="test7_do"
  count = sub(count , 1 )
caller="test7_do"
  if greaterthan(count , 0 ) then
caller=""
      count = test7_do(count )
  else
caller=""
      return count 

  end

caller="test7_do"
  return count 

end
-- Chose function name test7
function test7()
print("caller: ", caller, "-> test7")
caller="test7"
  if equal(0 , test7_do(10 )) then
caller=""
      printf("7.  pass count works\n" );

  else
caller=""
      printf("7.  fail count fails\n" );

  end

end
-- Chose function name beer
function beer()
print("caller: ", caller, "-> beer")
caller="beer"
  printf("%d bottle of beer on the wall, %d bottle of beer.  Take one down, pass it round, no bottles of beer on the wall\n" , 1 , 1 );

end
-- Chose function name plural
function plural(num )
print("caller: ", caller, "-> plural")
caller="plural"
  if equal(num , 1 ) then
caller=""
      return "" 

  else
caller=""
      return "s" 

  end

end
-- Chose function name beers
function beers(count )
print("caller: ", caller, "-> beers")
local newcount =0 
caller="beers"
  newcount = sub(count , 1 )
caller="beers"
  printf("%d bottle%s of beer on the wall, %d bottle%s of beer.  Take one down, pass it round, %d bottle%s of beer on the wall\n" , count , plural(count ), count , plural(count ), newcount , plural(newcount ));

caller="beers"
  if greaterthan(count , 1 ) then
caller=""
      count = beers(newcount )
  else
caller=""
      return count 

  end

caller="beers"
  return 0 

end
-- Chose function name test8
function test8()
print("caller: ", caller, "-> test8")
caller="test8"
  if equal(sub(sub(2 , 1 ), sub(3 , 1 )), -1 ) then
caller=""
      printf("8.  pass Nested expressions work\n" );

  else
caller=""
      printf("8.  fail Nested expressions don't work\n" );

  end

end
-- Chose function name test9
function test9()
print("caller: ", caller, "-> test9")
local answer =-999999 
caller="test9"
  answer = sub(sub(20 , 1 ), sub(3 , 1 ))
caller="test9"
  if equal(answer , 17 ) then
caller=""
      printf("9.  pass arithmetic works\n" );

  else
caller=""
      printf("9.  fail arithmetic\n" );

  end

end
-- Chose function name test10
function test10()
print("caller: ", caller, "-> test10")
local testString ="This is a test string" 
caller="test10"
  if equalString(testString , unBoxString(car(cons(boxString(testString ), nil )))) then
caller=""
      printf("10. pass cons and car work\n" );

  else
caller=""
      printf("10. fail cons and car fail\n" );

  end

end
-- Chose function name test12
function test12()
print("caller: ", caller, "-> test12")
local b =nil 
caller="test12"
  b = new(box , Box )
caller="test12"
b.str = "12. pass structure accessors\n" 
caller="test12"
  printf("%s" , b.str);

end
-- Chose function name test13
function test13()
print("caller: ", caller, "-> test13")
local testString ="Hello from the filesystem!" 
local contents ="" 
caller="test13"
  luaWriteFile("test.txt" , testString );

caller="test13"
  contents = luaReadFile("test.txt" )
caller="test13"
  if equalString(testString , contents ) then
caller=""
      printf("13. pass Read and write files\n" );

  else
caller=""
      printf("13. fail Read and write files\n" );

caller=""
      printf("Expected: %s\n" , testString );

caller=""
      printf("Got: %s\n" , contents );

  end

end
-- Chose function name test15
function test15()
print("caller: ", caller, "-> test15")
local a ="hello" 
local b =" world" 
local c ="" 
caller="test15"
  c = stringConcatenate(a , b )
caller="test15"
  if equalString(c , "hello world" ) then
caller=""
      printf("15. pass String concatenate\n" );

  else
caller=""
      printf("15. fail String concatenate\n" );

  end

end
-- Chose function name test16
function test16()
print("caller: ", caller, "-> test16")
local assocCell1 =nil 
local assList =nil 
local assocCell2 =nil 
local assocCell3 =nil 
caller="test16"
  assocCell1 = cons(boxString("Hello" ), boxString("world" ))
caller="test16"
  assocCell2 = cons(boxString("goodnight" ), boxString("moon" ))
caller="test16"
  assocCell3 = cons(boxSymbol("ohio" ), boxString("gozaimasu" ))
caller="test16"
  assList = cons(assocCell2 , emptyList())
caller="test16"
  assList = cons(assocCell1 , assList )
caller="test16"
  assList = cons(assocCell3 , assList )
caller="test16"
  if equalBox(cdr(assoc("Hello" , assList )), boxString("world" )) then
caller=""
      printf("16.1 pass Basic assoc works\n" );

  else
caller=""
      printf("16.1 fail Basic assoc fails\n" );

  end

caller="test16"
  if andBool(andBool(equalBox(cdr(assoc("Hello" , assList )), boxString("world" )), equalBox(cdr(assoc("goodnight" , assList )), boxString("moon" ))), equalBox(cdr(assoc("ohio" , assList )), boxString("gozaimasu" ))) then
caller=""
      printf("16.2 pass assoc list\n" );

  else
caller=""
      printf("16.2 fail assoc list\n" );

  end

end
-- Chose function name test17
function test17()
print("caller: ", caller, "-> test17")
local l =nil 
caller="test17"
  l = cons(boxInt(1 ), cons(boxInt(2 ), cons(boxInt(3 ), nil )))
caller="test17"
  if equalBox(car(l ), boxInt(1 )) then
caller=""
      printf("17. pass list literal works\n" );

  else
caller=""
      printf("17. fail list literal failed\n" );

  end

end
-- Chose function name test18
function test18()
print("caller: ", caller, "-> test18")
local val1 ="a" 
local val2 ="b" 
local val3 ="c" 
local l =nil 
caller="test18"
  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), nil )))
caller="test18"
  if equalList(l , cons(boxString("a" ), cons(boxString("b" ), cons(boxString("c" ), nil )))) then
caller=""
      printf("18. pass string list constructor works\n" );

  else
caller=""
      printf("18. fail string list constructor failed\n" );

  end

end
-- Chose function name test19
function test19()
print("caller: ", caller, "-> test19")
local val1 ="a" 
local val2 ="b" 
local val3 ="c" 
local l =nil 
local revlist =nil 
local answer =nil 
caller="test19"
  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), nil )))
caller="test19"
  answer = cons(boxString("c" ), cons(boxString(val2 ), cons(boxString(val1 ), nil )))
caller="test19"
  revlist = reverseList(l )
caller="test19"
  if equalList(answer , revlist ) then
caller=""
      printf("19. pass reverseList\n" );

  else
caller=""
      printf("19. fail reverseList\n" );

  end

end
-- Chose function name concatenateLists
function concatenateLists(oldL ,newL )
print("caller: ", caller, "-> concatenateLists")
caller="concatenateLists"
  return reverseRec(reverseList(oldL ), newL )

end
-- Chose function name test20
function test20()
print("caller: ", caller, "-> test20")
local val1 ="a" 
local val2 ="b" 
local val3 ="c" 
local l =nil 
local l2 =nil 
local l3 =nil 
local combined =nil 
local revlist =nil 
caller="test20"
  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), nil )))
caller="test20"
  l2 = cons(boxString("d" ), cons(boxString("e" ), cons(boxString("f" ), nil )))
caller="test20"
  l3 = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString("c" ), cons(boxString("d" ), cons(boxString("e" ), cons(boxString("f" ), nil ))))))
caller="test20"
  combined = concatenateLists(l , l2 )
caller="test20"
  if equalList(l3 , combined ) then
caller=""
      printf("21. pass concatenateLists\n" );

  else
caller=""
      printf("21. fail concatenateLists\n" );

  end

end
-- Chose function name test21
function test21()
print("caller: ", caller, "-> test21")
local val1 ="a" 
local val2 ="b" 
local val3 ="c" 
local l =nil 
local l2 =nil 
caller="test21"
  l = cons(boxString(val1 ), cons(boxString(val2 ), cons(boxString(val3 ), nil )))
caller="test21"
  l2 = cons(boxString("a" ), cons(boxString("b" ), cons(boxString("c" ), nil )))
caller="test21"
  if equalList(l , l2 ) then
caller=""
      printf("21. pass equalList\n" );

  else
caller=""
      printf("21. fail equalList\n" );

  end

end
-- Chose function name ansiFunctionArgs
function ansiFunctionArgs(tree )
print("caller: ", caller, "-> ansiFunctionArgs")
caller="ansiFunctionArgs"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      display(ansiTypeMap(first(tree )));

caller=""
      display(second(tree ));

caller=""
      if isNil(cddr(tree )) then
caller=""
          printf("" );

      else
caller=""
          printf("," );

      end

caller=""
      ansiFunctionArgs(cddr(tree ));

  end

end
-- Chose function name ansiLeaf
function ansiLeaf(thisNode ,indent )
print("caller: ", caller, "-> ansiLeaf")
caller="ansiLeaf"
  display(ansiFuncMap(codeof(thisNode )));

end
-- Chose function name ansiStructGetterExpression
function ansiStructGetterExpression(thisNode ,indent )
print("caller: ", caller, "-> ansiStructGetterExpression")
caller="ansiStructGetterExpression"
  if equalBox(boxString("structGetter" ), subnameof(thisNode )) then
caller=""
      ansiGetStruct(thisNode , indent );

  else
caller=""
      ansiLeaf(thisNode , indent );

  end

end
-- Chose function name ansiExpression
function ansiExpression(node ,indent )
print("caller: ", caller, "-> ansiExpression")
caller="ansiExpression"
  if isLeaf(node ) then
caller=""
      display(ansiFuncMap(codeof(node )));

  else
caller=""
      ansiSubExpression(node , indent );

  end

end
-- Chose function name ansiRecurList
function ansiRecurList(expr ,indent )
print("caller: ", caller, "-> ansiRecurList")
caller="ansiRecurList"
  if isEmpty(expr ) then
caller=""
      return 

  else
caller=""
      ansiExpression(car(expr ), indent );

caller=""
      if isNil(cdr(expr )) then
caller=""
          printf("" );

      else
caller=""
          printf(", " );

caller=""
          ansiRecurList(cdr(expr ), indent );

      end

  end

end
-- Chose function name ansiSubExpression
function ansiSubExpression(tree ,indent )
print("caller: ", caller, "-> ansiSubExpression")
local thing =nil 
caller="ansiSubExpression"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      if isNode(childrenof(tree )) then
caller=""
          ansiSubExpression(childrenof(tree ), indent );

      else
caller=""
          if isLeaf(tree ) then
caller=""
              display(ansiFuncMap(codeof(tree )));

          else
caller=""
              if equal(1 , listLength(childrenof(tree ))) then
caller=""
                  display(codeof(car(childrenof(tree ))));

caller=""
                  if equalBox(boxString("return" ), codeof(car(childrenof(tree )))) then
caller=""
                      printf("" );

                  else
caller=""
                      printf("()" );

                  end

              else
caller=""
                  thing = codeof(car(childrenof(tree )))
caller=""
                  if equalBox(boxSymbol("get-struct" ), thing ) then
caller=""
                      printf("%s->%s" , stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

                  else
caller=""
                      if equalBox(boxSymbol("new" ), thing ) then
caller=""
                          printf("malloc(sizeof(%s))" , stringify(codeof(third(childrenof(tree )))));

                      else
caller=""
                          printf("%s(" , stringify(ansiFuncMap(codeof(car(childrenof(tree ))))));

caller=""
                          ansiRecurList(cdr(childrenof(tree )), indent );

caller=""
                          printf(")" );

                      end

                  end

              end

          end

      end

  end

end
-- Chose function name ansiIf
function ansiIf(node ,indent )
print("caller: ", caller, "-> ansiIf")
caller="ansiIf"
  newLine(indent );

caller="ansiIf"
  printf("if ( " );

caller="ansiIf"
  ansiExpression(car(first(childrenof(node ))), 0 );

caller="ansiIf"
  printf(") {" );

caller="ansiIf"
  ansiBody(second(childrenof(node )), add1(indent ));

caller="ansiIf"
  newLine(indent );

caller="ansiIf"
  printf("} else {" );

caller="ansiIf"
  ansiBody(third(childrenof(node )), add1(indent ));

caller="ansiIf"
  newLine(indent );

caller="ansiIf"
  printf("}" );

end
-- Chose function name ansiSetStruct
function ansiSetStruct(node ,indent )
print("caller: ", caller, "-> ansiSetStruct")
caller="ansiSetStruct"
  newLine(indent );

caller="ansiSetStruct"
  printf("%s->%s = " , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

caller="ansiSetStruct"
  ansiExpression(childrenof(node ), indent );

end
-- Chose function name ansiGetStruct
function ansiGetStruct(node ,indent )
print("caller: ", caller, "-> ansiGetStruct")
caller="ansiGetStruct"
  newLine(indent );

caller="ansiGetStruct"
  printf("%s->%s" , stringify(first(codeof(node ))), stringify(second(codeof(node ))));

end
-- Chose function name ansiSet
function ansiSet(node ,indent )
print("caller: ", caller, "-> ansiSet")
caller="ansiSet"
  newLine(indent );

caller="ansiSet"
  printf("%s = " , stringify(first(codeof(node ))));

caller="ansiSet"
  ansiExpression(childrenof(node ), indent );

end
-- Chose function name ansiStatement
function ansiStatement(node ,indent )
print("caller: ", caller, "-> ansiStatement")
caller="ansiStatement"
  if equalBox(boxString("setter" ), subnameof(node )) then
caller=""
      ansiSet(node , indent );

  else
caller=""
      if equalBox(boxString("structSetter" ), subnameof(node )) then
caller=""
          ansiSetStruct(node , indent );

      else
caller=""
          if equalBox(boxString("if" ), subnameof(node )) then
caller=""
              ansiIf(node , indent );

          else
caller=""
              if equalBox(boxString("returnvoid" ), subnameof(node )) then
caller=""
                  newLine(indent );

caller=""
                  printf("return" );

              else
caller=""
                  newLine(indent );

caller=""
                  ansiExpression(childrenof(node ), indent );

              end

          end

      end

  end

caller="ansiStatement"
  printf(";\n" );

end
-- Chose function name ansiBody
function ansiBody(tree ,indent )
print("caller: ", caller, "-> ansiBody")
local code =nil 
caller="ansiBody"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      code = codeof(car(tree ))
caller=""
      if isNil(code ) then
      else
caller=""
          code = car(codeof(car(tree )))
caller=""
          printf("\nif (globalTrace)\n    snprintf(caller, 1024, \"from %s:%s\");\n" , stringify(getTagFail(code , boxString("filename" ), boxString("Unknown" ))), stringify(getTagFail(code , boxString("line" ), boxString("Unknown" ))));

      end

caller=""
      printIndent(indent );

caller=""
      printf("%s" , "if (globalStepTrace) printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__);\n" );

caller=""
      ansiStatement(car(tree ), indent );

caller=""
      ansiBody(cdr(tree ), indent );

  end

end
-- Chose function name ansiDeclarations
function ansiDeclarations(decls ,indent )
print("caller: ", caller, "-> ansiDeclarations")
local decl =nil 
caller="ansiDeclarations"
  if isEmpty(decls ) then
caller=""
      return 

  else
caller=""
      decl = car(decls )
caller=""
      printf("%s %s = " , stringify(ansiTypeMap(first(decl ))), stringify(second(decl )));

caller=""
      display(ansiFuncMap(third(decl )));

caller=""
      printf(";\n" );

caller=""
      ansiDeclarations(cdr(decls ), indent );

  end

end
-- Chose function name ansiFunction
function ansiFunction(node )
print("caller: ", caller, "-> ansiFunction")
local name =nil 
caller="ansiFunction"
  name = subnameof(node )
caller="ansiFunction"
  printf("\n\n//Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));

caller="ansiFunction"
  newLine(0 );

caller="ansiFunction"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      newLine(0 );

caller=""
      printf("%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));

caller=""
      ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      printf(") {" );

caller=""
      newLine(1 );

caller=""
      ansiDeclarations(declarationsof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("\nif (globalTrace)\n    printf(\"%s at %s:%s (%%s)\\n\", caller);\n" , stringify(name ), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

      end

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
      end

caller=""
      ansiBody(childrenof(node ), 1 );

caller=""
      if inList(toStr(name ), noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("\nif (globalTrace)\n    printf(\"Leaving %s\\n\");\n" , stringify(name ));

      end

caller=""
      printf("\n}\n" );

  end

end
-- Chose function name ansiForwardDeclaration
function ansiForwardDeclaration(node )
print("caller: ", caller, "-> ansiForwardDeclaration")
caller="ansiForwardDeclaration"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      printf("\n%s %s(" , stringify(ansiTypeMap(cdr(assoc("outtype" , cdr(node ))))), stringify(subnameof(node )));

caller=""
      ansiFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      printf(");" );

  end

end
-- Chose function name ansiForwardDeclarations
function ansiForwardDeclarations(tree )
print("caller: ", caller, "-> ansiForwardDeclarations")
caller="ansiForwardDeclarations"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      ansiForwardDeclaration(car(tree ));

caller=""
      ansiForwardDeclarations(cdr(tree ));

  end

end
-- Chose function name ansiFunctions
function ansiFunctions(tree )
print("caller: ", caller, "-> ansiFunctions")
caller="ansiFunctions"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      ansiFunction(car(tree ));

caller=""
      ansiFunctions(cdr(tree ));

  end

end
-- Chose function name ansiIncludes
function ansiIncludes(nodes )
print("caller: ", caller, "-> ansiIncludes")
caller="ansiIncludes"
  printf("%s" , "\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\nconst char* getEnv(char* key){return getenv(key);}\n void panic(char* s){abort();}\nint sub(int a, int b) { return a - b; }\nfloat mult(int a, int b) { return a * b; }\nint greaterthan(int a, int b) { return a > b; }\nfloat subf(float a, float b) { return a - b; }\nfloat multf(float a, float b) { return a * b; }\nint greaterthanf(float a, float b) { return a > b; }\nint equal(int a, int b) { return a == b; }\nint equalString(char* a, char* b) { return !strcmp(a,b); }\nint andBool(int a, int b) { return a == b;}\nint string_length(char* s) { return strlen(s);}\nchar* setSubString(char* target, int start,char *source){target[start]=source[0]; return target;}\nchar* sub_string(char* s, int start, int length) {\nchar* substr = calloc(length+1, 1);\nstrncpy(substr, s+start, length);\nreturn substr;\n}\n\n\n\nchar* stringConcatenate(char* a, char* b) {\nint len = strlen(a) + strlen(b) + 1;\nchar* target = calloc(len,1);\nstrncat(target, a, len);\nstrncat(target, b, len);\nreturn target;\n}\n\nchar* intToString(int a) {\nint len = 100;\nchar* target = calloc(len,1);\nsnprintf(target, 99, \"%d\", a);\nreturn target;\n}\n\ntypedef int*  array;\ntypedef int bool;\n#define true 1\n#define false 0\n\n\nvoid * gc_malloc( unsigned int size ) {\nreturn malloc( size);\n}\n\nint* makeArray(int length) {\n    int * array = gc_malloc(length*sizeof(int));\n    return array;\n}\n\nint at(int* arr, int index) {\n  return arr[index];\n}\n\nvoid setAt(int* array, int index, int value) {\n    array[index] = value;\n}\n\nchar * read_file(char * filename) {\nchar * buffer = 0;\nlong length;\nFILE * f = fopen (filename, \"rb\");\n\nif (f)\n{\n  fseek (f, 0, SEEK_END);\n  length = ftell (f);\n  fseek (f, 0, SEEK_SET);\n  buffer = malloc (length);\n  if (buffer == NULL) {\n  printf(\"Malloc failed!\\n\");\n  exit(1);\n}\n  if (buffer)\n  {\n    fread (buffer, 1, length, f);\n  }\n  fclose (f);\n}\nreturn buffer;\n}\n\n\nvoid write_file (char * filename, char * data) {\nFILE *f = fopen(filename, \"w\");\nif (f == NULL)\n{\n    printf(\"Error opening file!\");\n    exit(1);\n}\n\nfprintf(f, \"%s\", data);\n\nfclose(f);\n}\n\nchar* getStringArray(int index, char** strs) {\nreturn strs[index];\n}\n\nint start();  //Forwards declare the user's main routine\nchar* caller;\nchar** globalArgs;\nint globalArgsCount;\nbool globalTrace = false;\nbool globalStepTrace = false;\n\nint main( int argc, char *argv[] )  {\n  globalArgs = argv;\n  globalArgsCount = argc;\n  caller=calloc(1024,1);\n\n  return start();\n\n}\n\n" );

caller="ansiIncludes"
  printf("%s" , "char * character(int num) { char *string = malloc(2); if (!string) return 0; string[0] = num; string[1] = 0; return string; }" );

end
-- Chose function name ansiTypeDecl
function ansiTypeDecl(l )
print("caller: ", caller, "-> ansiTypeDecl")
caller="ansiTypeDecl"
  if greaterthan(listLength(l ), 2 ) then
caller=""
      printIndent(1 );

caller=""
      printf("%s %s %s;\n" , stringify(second(l )), stringify(ansiTypeMap(listLast(l ))), stringify(first(l )));

  else
caller=""
      printIndent(1 );

caller=""
      printf("%s %s;\n" , stringify(ansiTypeMap(listLast(l ))), stringify(car(l )));

  end

end
-- Chose function name ansiStructComponents
function ansiStructComponents(node )
print("caller: ", caller, "-> ansiStructComponents")
caller="ansiStructComponents"
  if isEmpty(node ) then
caller=""
      return 

  else
caller=""
      ansiTypeDecl(car(node ));

caller=""
      ansiStructComponents(cdr(node ));

  end

end
-- Chose function name ansiStruct
function ansiStruct(node )
print("caller: ", caller, "-> ansiStruct")
caller="ansiStruct"
  ansiStructComponents(cdr(car(node )));

end
-- Chose function name ansiTypeMap
function ansiTypeMap(aSym )
print("caller: ", caller, "-> ansiTypeMap")
local symMap =nil 
caller="ansiTypeMap"
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), nil ))
caller="ansiTypeMap"
  if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
      return cdr(assoc(stringify(aSym ), symMap ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name ansiFuncMap
function ansiFuncMap(aSym )
print("caller: ", caller, "-> ansiFuncMap")
local symMap =nil 
caller="ansiFuncMap"
  if equalString("symbol" , boxType(aSym )) then
caller=""
      symMap = alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("luaSubstring" ), boxSymbol("sub_string" ), alistCons(boxSymbol("luaReadFile" ), boxSymbol("read_file" ), alistCons(boxSymbol("luaWriteFile" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string.len" ), boxSymbol("string_length" ), alistCons(boxSymbol("nil" ), boxSymbol("NULL" ), nil )))))))
caller=""
      if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
          return cdr(assoc(stringify(aSym ), symMap ))

      else
caller=""
          return aSym 

      end

  else
caller=""
      return aSym 

  end

end
-- Chose function name ansiType
function ansiType(node )
print("caller: ", caller, "-> ansiType")
caller="ansiType"
  if equalBox(subnameof(node ), boxString("struct" )) then
caller=""
      printf("\ntypedef struct %s {\n" , stringify(first(codeof(node ))));

caller=""
      ansiStruct(cdr(codeof(node )));

caller=""
      printf("\n} %s;\n" , stringify(first(codeof(node ))));

  else
caller=""
      printf("typedef " );

caller=""
      ansiTypeDecl(codeof(node ));

  end

end
-- Chose function name ansiTypes
function ansiTypes(nodes )
print("caller: ", caller, "-> ansiTypes")
caller="ansiTypes"
  if isEmpty(nodes ) then
caller=""
      return 

  else
caller=""
      ansiType(car(nodes ));

caller=""
      ansiTypes(cdr(nodes ));

  end

end
-- Chose function name uniqueTarget
function uniqueTarget(a ,b )
print("caller: ", caller, "-> uniqueTarget")
end
-- Chose function name ansiCompile
function ansiCompile(filename )
print("caller: ", caller, "-> ansiCompile")
local foundationFuncs =nil 
local foundation =nil 
local programStr ="" 
local tree =nil 
local program =nil 
caller="ansiCompile"
  foundation = readSexpr(luaReadFile("foundationlibs/ansi.qon" ), "foundationlibs/ansi.qon" )
caller="ansiCompile"
  foundationFuncs = cdr(third(foundation ))
caller="ansiCompile"
  printf("//Scanning file...%s\n" , filename );

caller="ansiCompile"
  programStr = luaReadFile(filename )
caller="ansiCompile"
  printf("//Building sexpr\n" );

caller="ansiCompile"
  tree = readSexpr(programStr , filename )
caller="ansiCompile"
  tree = macrowalk(tree )
caller="ansiCompile"
  cons(boxString("a" ), cons(boxString("b" ), cons(boxString("c" ), nil )));

caller="ansiCompile"
  printf("//Building AST\n" );

caller="ansiCompile"
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="ansiCompile"
  printf("//Merging ASTs\n" );

caller="ansiCompile"
  program = mergeIncludes(program )
caller="ansiCompile"
  printf("//Printing program\n" );

caller="ansiCompile"
  ansiIncludes(cdr(assoc("includes" , program )));

caller="ansiCompile"
  ansiTypes(childrenof(cdr(assoc("types" , program ))));

caller="ansiCompile"
  printf("Box* globalStackTrace = NULL;\n" );

caller="ansiCompile"
  printf("\nbool isNil(list p) {\n    return p == NULL;\n}\n\n\n//Forward declarations\n" );

caller="ansiCompile"
  ansiForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="ansiCompile"
  printf("\n\n//End forward declarations\n\n" );

caller="ansiCompile"
  ansiFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="ansiCompile"
  printf("\n" );

end
-- Chose function name numbers
function numbers(num )
print("caller: ", caller, "-> numbers")
caller="numbers"
  if greaterthan(0 , num ) then
caller=""
      return cons(boxString("-" ), nil )

  else
caller=""
      return cons(boxString(stringify(boxInt(num ))), numbers(sub1(num )))

  end

end
-- Chose function name lexType
function lexType(abox )
print("caller: ", caller, "-> lexType")
caller="lexType"
  if equalString("string" , boxType(abox )) then
caller=""
      return "string" 

  else
caller=""
      if inList(boxString(luaSubstring(stringify(abox ), 0 , 1 )), numbers(9 )) then
caller=""
          return "number" 

      else
caller=""
          return "symbol" 

      end

  end

end
-- Chose function name perlLeaf
function perlLeaf(thisNode ,indent )
print("caller: ", caller, "-> perlLeaf")
caller="perlLeaf"
  if equalString("symbol" , lexType(codeof(thisNode ))) then
caller=""
      printf("%s" , dollar());

  else
caller=""
      printf("" );

  end

caller="perlLeaf"
  display(perlFuncMap(codeof(thisNode )));

end
-- Chose function name perlStructGetterExpression
function perlStructGetterExpression(thisNode ,indent )
print("caller: ", caller, "-> perlStructGetterExpression")
caller="perlStructGetterExpression"
  if equalBox(boxString("structGetter" ), subnameof(thisNode )) then
caller=""
      perlGetStruct(thisNode , indent );

  else
caller=""
      perlLeaf(thisNode , indent );

  end

end
-- Chose function name perlExpression
function perlExpression(node ,indent )
print("caller: ", caller, "-> perlExpression")
caller="perlExpression"
  if isLeaf(node ) then
caller=""
      perlLeaf(node , indent );

  else
caller=""
      perlSubExpression(node , indent );

  end

end
-- Chose function name perlRecurList
function perlRecurList(expr ,indent )
print("caller: ", caller, "-> perlRecurList")
caller="perlRecurList"
  if isEmpty(expr ) then
caller=""
      return 

  else
caller=""
      perlExpression(car(expr ), indent );

caller=""
      if isNil(cdr(expr )) then
caller=""
          printf("" );

      else
caller=""
          printf(", " );

caller=""
          perlRecurList(cdr(expr ), indent );

      end

  end

end
-- Chose function name perlSubExpression
function perlSubExpression(tree ,indent )
print("caller: ", caller, "-> perlSubExpression")
local thing =nil 
caller="perlSubExpression"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      if isNode(childrenof(tree )) then
caller=""
          perlSubExpression(childrenof(tree ), indent );

      else
caller=""
          if isLeaf(tree ) then
caller=""
              printf("%s" , dollar());

caller=""
              display(perlFuncMap(codeof(tree )));

          else
caller=""
              if equal(1 , listLength(childrenof(tree ))) then
caller=""
                  display(codeof(car(childrenof(tree ))));

caller=""
                  if equalBox(boxString("return" ), codeof(car(childrenof(tree )))) then
caller=""
                      printf("" );

                  else
caller=""
                      printf("()" );

                  end

              else
caller=""
                  thing = codeof(car(childrenof(tree )))
caller=""
                  if equalBox(boxSymbol("get-struct" ), thing ) then
caller=""
                      printf("%s%s->{%s}" , dollar(), stringify(codeof(second(childrenof(tree )))), stringify(codeof(third(childrenof(tree )))));

                  else
caller=""
                      if equalBox(boxSymbol("new" ), thing ) then
caller=""
                          printf("{}" );

                      else
caller=""
                          printf("%s(" , stringify(perlFuncMap(codeof(car(childrenof(tree ))))));

caller=""
                          perlRecurList(cdr(childrenof(tree )), indent );

caller=""
                          printf(")" );

                      end

                  end

              end

          end

      end

  end

end
-- Chose function name perlIf
function perlIf(node ,indent )
print("caller: ", caller, "-> perlIf")
caller="perlIf"
  newLine(indent );

caller="perlIf"
  printf("if ( " );

caller="perlIf"
  perlExpression(car(first(childrenof(node ))), 0 );

caller="perlIf"
  printf(") {" );

caller="perlIf"
  perlBody(second(childrenof(node )), add1(indent ));

caller="perlIf"
  newLine(indent );

caller="perlIf"
  printf("} else {" );

caller="perlIf"
  perlBody(third(childrenof(node )), add1(indent ));

caller="perlIf"
  newLine(indent );

caller="perlIf"
  printf("}" );

end
-- Chose function name perlSetStruct
function perlSetStruct(node ,indent )
print("caller: ", caller, "-> perlSetStruct")
caller="perlSetStruct"
  newLine(indent );

caller="perlSetStruct"
  printf("%s%s->{%s} = " , dollar(), stringify(first(codeof(node ))), stringify(second(codeof(node ))));

caller="perlSetStruct"
  perlExpression(childrenof(node ), indent );

end
-- Chose function name perlGetStruct
function perlGetStruct(node ,indent )
print("caller: ", caller, "-> perlGetStruct")
caller="perlGetStruct"
  newLine(indent );

caller="perlGetStruct"
  printf("%s%s->{%s}" , dollar(), stringify(first(codeof(node ))), stringify(second(codeof(node ))));

end
-- Chose function name perlSet
function perlSet(node ,indent )
print("caller: ", caller, "-> perlSet")
caller="perlSet"
  newLine(indent );

caller="perlSet"
  printf("%s%s = " , dollar(), stringify(first(codeof(node ))));

caller="perlSet"
  perlExpression(childrenof(node ), indent );

end
-- Chose function name assertNode
function assertNode(node )
print("caller: ", caller, "-> assertNode")
caller="assertNode"
  if isNode(node ) then
caller=""
      return 

  else
caller=""
      panic("Not a node!" );

  end

end
-- Chose function name perlStatement
function perlStatement(node ,indent )
print("caller: ", caller, "-> perlStatement")
local functionName =nil 
caller="perlStatement"
  assertNode(node );

caller="perlStatement"
  if equalBox(boxString("setter" ), subnameof(node )) then
caller=""
      perlSet(node , indent );

  else
caller=""
      if equalBox(boxString("structSetter" ), subnameof(node )) then
caller=""
          perlSetStruct(node , indent );

      else
caller=""
          if equalBox(boxString("if" ), subnameof(node )) then
caller=""
              perlIf(node , indent );

          else
caller=""
              if equalBox(boxString("returnvoid" ), subnameof(node )) then
caller=""
                  functionName = functionNameof(node )
caller=""
                  printf("\n#Returnvoid\n" );

caller=""
                  newLine(indent );

caller=""
                  newLine(indent );

caller=""
                  printf("return" );

              else
caller=""
                  if equalBox(boxString("return" ), subnameof(node )) then
caller=""
                      functionName = functionNameof(node )
caller=""
                      if inList(functionName , noStackTrace()) then
caller=""
                          printf("" );

                      else
caller=""
                          printf("\n#standard return: %s\n" , stringify(functionName ));

caller=""
                          newLine(indent );

caller=""
                          printf("%s%s%s" , "if (" , dollar(), "globalTrace) {printf(\"Leaving \\n\")}\n" );

                      end

caller=""
                      newLine(indent );

caller=""
                      perlExpression(childrenof(node ), indent );

                  else
caller=""
                      if inList(functionName , noStackTrace()) then
caller=""
                          printf("" );

                      else
caller=""
                          printf("\n#standard expression\n" );

                      end

caller=""
                      newLine(indent );

caller=""
                      perlExpression(childrenof(node ), indent );

caller=""
                      newLine(indent );

                  end

              end

          end

      end

  end

caller="perlStatement"
  printf(";\n" );

end
-- Chose function name perlBody
function perlBody(tree ,indent )
print("caller: ", caller, "-> perlBody")
caller="perlBody"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      printIndent(indent );

caller=""
      printf("%s%s%s" , "if (" , dollar(), "globalStepTrace) {printf(\"StepTrace %s:%d\\n\", __FILE__, __LINE__)}\n" );

caller=""
      perlStatement(car(tree ), indent );

caller=""
      perlBody(cdr(tree ), indent );

  end

end
-- Chose function name perlDeclarations
function perlDeclarations(decls ,indent )
print("caller: ", caller, "-> perlDeclarations")
local decl =nil 
caller="perlDeclarations"
  if isEmpty(decls ) then
caller=""
      return 

  else
caller=""
      decl = car(decls )
caller=""
      printf("my %s%s = " , dollar(), stringify(second(decl )));

caller=""
      display(perlConstMap(third(decl )));

caller=""
      printf(";\n" );

caller=""
      perlDeclarations(cdr(decls ), indent );

  end

end
-- Chose function name perlFunction
function perlFunction(node )
print("caller: ", caller, "-> perlFunction")
local name =nil 
caller="perlFunction"
  name = subnameof(node )
caller="perlFunction"
  printf("\n\n#Building function %s from line: %s" , stringify(name ), stringify(getTag(name , boxString("line" ))));

caller="perlFunction"
  newLine(0 );

caller="perlFunction"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      newLine(0 );

caller=""
      printf("sub %s" , stringify(subnameof(node )));

caller=""
      printf(" {" );

caller=""
      newLine(1 );

caller=""
      perlFunctionArgs(cdr(assoc("intype" , cdr(node ))));

caller=""
      newLine(1 );

caller=""
      perlDeclarations(declarationsof(node ), 1 );

caller=""
      printf("\nif (%sglobalTrace) { printf(\"%s at %s:%s\\n\") }\n" , dollar(), stringify(subnameof(node )), stringify(getTag(name , boxString("filename" ))), stringify(getTag(name , boxString("line" ))));

caller=""
      if inList(name , noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("" );

      end

caller=""
      perlBody(childrenof(node ), 1 );

caller=""
      if inList(name , noStackTrace()) then
caller=""
          printf("" );

      else
caller=""
          printf("" );

      end

caller=""
      printf("\n}\n" );

  end

end
-- Chose function name perlForwardDeclaration
function perlForwardDeclaration(node )
print("caller: ", caller, "-> perlForwardDeclaration")
caller="perlForwardDeclaration"
  if isNil(node ) then
caller=""
      return 

  else
caller=""
      printf("\nsub %s" , stringify(subnameof(node )));

caller=""
      printf(";" );

  end

end
-- Chose function name perlForwardDeclarations
function perlForwardDeclarations(tree )
print("caller: ", caller, "-> perlForwardDeclarations")
caller="perlForwardDeclarations"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      perlForwardDeclaration(car(tree ));

caller=""
      perlForwardDeclarations(cdr(tree ));

  end

end
-- Chose function name perlFunctions
function perlFunctions(tree )
print("caller: ", caller, "-> perlFunctions")
caller="perlFunctions"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      perlFunction(car(tree ));

caller=""
      perlFunctions(cdr(tree ));

  end

end
-- Chose function name dollar
function dollar()
print("caller: ", caller, "-> dollar")
caller="dollar"
  return character(36 )

end
-- Chose function name atSym
function atSym()
print("caller: ", caller, "-> atSym")
caller="atSym"
  return character(64 )

end
-- Chose function name perlIncludes
function perlIncludes(nodes )
print("caller: ", caller, "-> perlIncludes")
caller="perlIncludes"
  printf("%s\n" , "use strict;" );

caller="perlIncludes"
  printf("%s\n" , "my $caller;" );

caller="perlIncludes"
  printf("%s\n" , "use Carp;" );

caller="perlIncludes"
  dollar();

caller="perlIncludes"
  printf("%s\n" , "use Carp::Always;" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub greaterthan { " , dollar(), "_[0] > " , dollar(), "_[1] };" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub mult { " , dollar(), "_[0] * " , dollar(), "_[1] };" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub multf { " , dollar(), "_[0] * " , dollar(), "_[1] };" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub greaterthanf { " , dollar(), "_[0] > " , dollar(), "_[1] };" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub equalString { " , dollar(), "_[0] eq " , dollar(), "_[1] };" );

caller="perlIncludes"
  printf("sub read_file { my %sfile = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; local %s/ = undef; my %scont = <%sfh>; close %sfh; return %scont; }; \n" , dollar(), dollar(), dollar(), dollar(), dollar(), dollar(), dollar(), dollar(), dollar());

caller="perlIncludes"
  printf("sub write_file {my %sfile = shift; my %sdata = shift; %sfile || die \"Empty file name!!!\"; open my %sfh, '<', %sfile or die; print %sfh %sdata; close %sfh; } \n" , dollar(), dollar(), dollar(), dollar(), dollar(), dollar(), dollar(), dollar());

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub stringConcatenate { " , dollar(), "_[0] . " , dollar(), "_[1]}" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub subtract { " , dollar(), "_[0] - " , dollar(), "_[1]}" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub subf { " , dollar(), "_[0] - " , dollar(), "_[1]}" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub andBool { " , dollar(), "_[0] && " , dollar(), "_[1]}" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub equal { " , dollar(), "_[0] == " , dollar(), "_[1]}" );

caller="perlIncludes"
  printf("%s%s%s%s%s\n" , "sub panic { carp " , atSym(), "_; die \"" , atSym(), "_\"}" );

caller="perlIncludes"
  printf("sub intToString { return %s_[0]}\n" , dollar());

caller="perlIncludes"
  printf("sub character { return chr(%s_[0])}\n" , dollar());

caller="perlIncludes"
  printf("%s%s%s%s%s%s%s%s%s\n" , "sub getStringArray { my " , dollar(), "index = shift; my " , dollar(), "arr = shift; return " , dollar(), "arr->[" , dollar(), "index]}" );

end
-- Chose function name perlTypeDecl
function perlTypeDecl(l )
print("caller: ", caller, "-> perlTypeDecl")
end
-- Chose function name perlStructComponents
function perlStructComponents(node )
print("caller: ", caller, "-> perlStructComponents")
caller="perlStructComponents"
  if isEmpty(node ) then
caller=""
      return 

  else
caller=""
      perlTypeDecl(car(node ));

caller=""
      perlStructComponents(cdr(node ));

  end

end
-- Chose function name perlStruct
function perlStruct(node )
print("caller: ", caller, "-> perlStruct")
caller="perlStruct"
  perlStructComponents(cdr(car(node )));

end
-- Chose function name perlTypeMap
function perlTypeMap(aSym )
print("caller: ", caller, "-> perlTypeMap")
local symMap =nil 
caller="perlTypeMap"
  symMap = alistCons(boxSymbol("stringArray" ), boxSymbol("char**" ), alistCons(boxSymbol("string" ), boxSymbol("char*" ), nil ))
caller="perlTypeMap"
  if truthy(assoc(stringify(aSym ), symMap )) then
caller=""
      return cdr(assoc(stringify(aSym ), symMap ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name perlConstMap
function perlConstMap(aSym )
print("caller: ", caller, "-> perlConstMap")
local symMap =nil 
caller="perlConstMap"
  if equalString("symbol" , boxType(aSym )) then
caller=""
      symMap = alistCons(boxSymbol("false" ), boxSymbol("0" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), nil ))
caller=""
      return cdr(assocFail(stringify(aSym ), symMap , aSym ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name perlFuncMap
function perlFuncMap(aSym )
print("caller: ", caller, "-> perlFuncMap")
local symMap =nil 
caller="perlFuncMap"
  if equalString("symbol" , boxType(aSym )) then
caller=""
      symMap = alistCons(boxSymbol("sub" ), boxSymbol("subtract" ), alistCons(boxSymbol("=" ), boxSymbol("equal" ), alistCons(boxSymbol("luaSubstring" ), boxSymbol("substr" ), alistCons(boxSymbol("luaReadFile" ), boxSymbol("read_file" ), alistCons(boxSymbol("luaWriteFile" ), boxSymbol("write_file" ), alistCons(boxSymbol(">" ), boxSymbol("greaterthan" ), alistCons(boxSymbol("string.len" ), boxSymbol("length" ), alistCons(boxSymbol("nil" ), boxSymbol("undef" ), nil ))))))))
caller=""
      return cdr(assocFail(stringify(aSym ), symMap , aSym ))

  else
caller=""
      return aSym 

  end

end
-- Chose function name perlType
function perlType(node )
print("caller: ", caller, "-> perlType")
end
-- Chose function name perlTypes
function perlTypes(nodes )
print("caller: ", caller, "-> perlTypes")
caller="perlTypes"
  if isEmpty(nodes ) then
caller=""
      return 

  else
caller=""
      perlType(car(nodes ));

caller=""
      perlTypes(cdr(nodes ));

  end

end
-- Chose function name perlFunctionArgs
function perlFunctionArgs(tree )
print("caller: ", caller, "-> perlFunctionArgs")
caller="perlFunctionArgs"
  if isEmpty(tree ) then
caller=""
      return 

  else
caller=""
      printf("%s%s" , "my " , dollar());

caller=""
      display(second(tree ));

caller=""
      printf(" = shift;\n" );

caller=""
      perlFunctionArgs(cddr(tree ));

  end

end
-- Chose function name perlCompile
function perlCompile(filename )
print("caller: ", caller, "-> perlCompile")
local programStr ="" 
local tree =nil 
local program =nil 
caller="perlCompile"
  programStr = luaReadFile(filename )
caller="perlCompile"
  tree = readSexpr(programStr , filename )
caller="perlCompile"
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="perlCompile"
  program = mergeIncludes(program )
caller="perlCompile"
  perlIncludes(cdr(assoc("includes" , program )));

caller="perlCompile"
  perlTypes(childrenof(cdr(assoc("types" , program ))));

caller="perlCompile"
  printf("use strict;\n" );

caller="perlCompile"
  printf("use Carp;\n" );

caller="perlCompile"
  printf("use Data::Dumper;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "globalStackTrace = undef;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "globalTrace = undef;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "globalStepTrace = undef;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "globalArgs = undef;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "globalArgsCount = undef;\n" );

caller="perlCompile"
  printf("%s%s%s\n" , "my " , dollar(), "true = 1;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "false = 0;\n" );

caller="perlCompile"
  printf("%s%s%s" , "my " , dollar(), "undef;\n" );

caller="perlCompile"
  printf("%s%s%s" , "\nsub isNil {\n    return !defined(" , dollar(), "_[0]);\n}\n\n\n#Forward declarations\n" );

caller="perlCompile"
  perlForwardDeclarations(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="perlCompile"
  printf("\n\n#End forward declarations\n\n" );

caller="perlCompile"
  perlFunctions(cdr(assoc("children" , cdr(cdr(assoc("functions" , program ))))));

caller="perlCompile"
  printf(";\n" );

caller="perlCompile"
  printf("%s%s%s%s" , dollar(), "globalArgs = [ 1, " , atSym(), "ARGV];" );

caller="perlCompile"
  printf("%s%s%s%s" , dollar(), "globalArgsCount = scalar(" , atSym(), "ARGV)+1;\n" );

caller="perlCompile"
  printf("start();" );

end
-- Chose function name add
function add(a ,b )
print("caller: ", caller, "-> add")
caller="add"
  return sub(a , sub(0 , b ))

end
-- Chose function name addf
function addf(a ,b )
print("caller: ", caller, "-> addf")
caller="addf"
  return subf(a , subf(0 , b ))

end
-- Chose function name sub1
function sub1(a )
print("caller: ", caller, "-> sub1")
caller="sub1"
  return sub(a , 1 )

end
-- Chose function name add1
function add1(a )
print("caller: ", caller, "-> add1")
caller="add1"
  return add(a , 1 )

end
-- Chose function name clone
function clone(b )
print("caller: ", caller, "-> clone")
local newb =nil 
caller="clone"
  newb = makeBox()
caller="clone"
newb.typ = b.typ
caller="clone"
newb.tag = b.tag
caller="clone"
newb.lis = b.lis
caller="clone"
newb.str = b.str
caller="clone"
newb.i = b.i
caller="clone"
newb.lengt = b.lengt
caller="clone"
  return newb 

end
-- Chose function name newVoid
function newVoid()
print("caller: ", caller, "-> newVoid")
local newb =nil 
caller="newVoid"
  newb = makeBox()
caller="newVoid"
newb.voi = true 
caller="newVoid"
newb.typ = "void" 
caller="newVoid"
  return newb 

end
-- Chose function name cons
function cons(data ,l )
print("caller: ", caller, "-> cons")
local p =nil 
caller="cons"
  p = makePair()
caller="cons"
p.cdr = l 
caller="cons"
p.car = data 
caller="cons"
p.typ = "list" 
caller="cons"
  return p 

end
-- Chose function name stackDump
function stackDump()
print("caller: ", caller, "-> stackDump")
caller="stackDump"
  printf("" );

end
-- Chose function name nop
function nop()
print("caller: ", caller, "-> nop")
caller="nop"
  printf("" );

end
-- Chose function name car
function car(l )
print("caller: ", caller, "-> car")
caller="car"
  assertType("list" , l , 65 , "base.qon" );

caller="car"
  if isNil(l ) then
caller=""
      printf("Cannot call car on empty list!\n" );

caller=""
      panic("Cannot call car on empty list!\n" );

caller=""
      return nil 

  else
caller=""
      if isNil(l.car) then
caller=""
          return nil 

      else
caller=""
          return l.car

      end

  end

end
-- Chose function name cdr
function cdr(l )
print("caller: ", caller, "-> cdr")
caller="cdr"
  assertType("list" , l , 78 , "base.qon" );

caller="cdr"
  if isEmpty(l ) then
caller=""
      printf("Attempt to cdr an empty list!!!!\n" );

caller=""
      panic("Attempt to cdr an empty list!!!!\n" );

caller=""
      return nil 

  else
caller=""
      return l.cdr

  end

end
-- Chose function name isList
function isList(b )
print("caller: ", caller, "-> isList")
caller="isList"
  if isNil(b ) then
caller=""
      return true 

  else
caller=""
      return equalString("list" , b.typ)

  end

end
-- Chose function name emptyList
function emptyList()
print("caller: ", caller, "-> emptyList")
caller="emptyList"
  return nil 

end
-- Chose function name isEmpty
function isEmpty(b )
print("caller: ", caller, "-> isEmpty")
caller="isEmpty"
  if isNil(b ) then
caller=""
      return true 

  else
caller=""
      return false 

  end

end
-- Chose function name listLength
function listLength(l )
print("caller: ", caller, "-> listLength")
caller="listLength"
  if isEmpty(l ) then
caller=""
      return 0 

  else
caller=""
      return add1(listLength(cdr(l )))

  end

end
-- Chose function name alistCons
function alistCons(key ,value ,alist )
print("caller: ", caller, "-> alistCons")
caller="alistCons"
  return cons(cons(key , value ), alist )

end
-- Chose function name assoc
function assoc(searchTerm ,l )
print("caller: ", caller, "-> assoc")
local elem =nil 
caller="assoc"
  assertType("list" , l , 115 , "base.qon" );

caller="assoc"
  if isEmpty(l ) then
caller=""
      return boxBool(false )

  else
caller=""
      elem = car(l )
caller=""
      assertType("list" , elem , 121 , "base.qon" );

caller=""
      if isEmpty(elem ) then
caller=""
          return assoc(searchTerm , cdr(l ))

      else
caller=""
          if false  then
caller=""
              printf("Comparing %s and %s\n" , searchTerm , stringify(car(elem )));

          else
caller=""
              printf("" );

          end

caller=""
          if equalString(searchTerm , stringify(car(elem ))) then
caller=""
              return elem 

          else
caller=""
              return assoc(searchTerm , cdr(l ))

          end

      end

  end

end
-- Chose function name equalBox
function equalBox(a ,b )
print("caller: ", caller, "-> equalBox")
caller="equalBox"
  if isList(b ) then
caller=""
      return false 

  else
caller=""
      if equalString("string" , boxType(a )) then
caller=""
          return equalString(unBoxString(a ), stringify(b ))

      else
caller=""
          if equalString("bool" , boxType(a )) then
caller=""
              return andBool(unBoxBool(a ), unBoxBool(b ))

          else
caller=""
              if equalString("symbol" , boxType(a )) then
caller=""
                  if equalString("symbol" , boxType(b )) then
caller=""
                      return equalString(unBoxSymbol(a ), unBoxSymbol(b ))

                  else
caller=""
                      return false 

                  end

              else
caller=""
                  if equalString("int" , boxType(a )) then
caller=""
                      return equal(unBoxInt(a ), unBoxInt(b ))

                  else
caller=""
                      return false 

                  end

              end

          end

      end

  end

end
-- Chose function name displayList
function displayList(l ,indent )
print("caller: ", caller, "-> displayList")
local val =nil 
caller="displayList"
  if isEmpty(l ) then
caller=""
      return 

  else
caller=""
      if isList(l ) then
caller=""
          if isEmpty(l ) then
caller=""
              return 

          else
caller=""
              val = car(l )
caller=""
              if isList(val ) then
caller=""
                  newLine(indent );

caller=""
                  printf("%s" , openBrace());

caller=""
                  displayList(car(l ), add1(indent ));

caller=""
                  printf("%s" , closeBrace());

caller=""
                  displayList(cdr(l ), indent );

              else
caller=""
                  if equalString("string" , val.typ) then
caller=""
                      printf("\"%s\" " , unBoxString(val ));

                  else
caller=""
                      printf("%s " , stringify(val ));

                  end

caller=""
                  displayList(cdr(l ), indent );

              end

          end

      else
caller=""
          if equalString("string" , l.typ) then
caller=""
              printf("\"%s\" " , unBoxString(l ));

          else
caller=""
              printf("%s " , stringify(l ));

          end

      end

  end

end
-- Chose function name display
function display(l )
print("caller: ", caller, "-> display")
caller="display"
  if isEmpty(l ) then
caller=""
      printf("nil " );

caller=""
      return 

  else
caller=""
      if isList(l ) then
caller=""
          printf("[" );

caller=""
          displayList(l , 0 );

caller=""
          printf("]" );

      else
caller=""
          displayList(l , 0 );

      end

  end

end
-- Chose function name boxType
function boxType(b )
print("caller: ", caller, "-> boxType")
caller="boxType"
  return b.typ

end
-- Chose function name makeBox
function makeBox()
print("caller: ", caller, "-> makeBox")
local b =nil 
caller="makeBox"
  b = new(box , Box )
caller="makeBox"
b.tag = nil 
caller="makeBox"
b.car = nil 
caller="makeBox"
b.cdr = nil 
caller="makeBox"
b.lis = nil 
caller="makeBox"
b.typ = "None - error!" 
caller="makeBox"
  return b 

end
-- Chose function name makePair
function makePair()
print("caller: ", caller, "-> makePair")
caller="makePair"
  return makeBox()

end
-- Chose function name boxString
function boxString(s )
print("caller: ", caller, "-> boxString")
local b =nil 
caller="boxString"
  b = makeBox()
caller="boxString"
b.str = s 
caller="boxString"
b.lengt = string.len(s )
caller="boxString"
b.typ = "string" 
caller="boxString"
  return b 

end
-- Chose function name boxSymbol
function boxSymbol(s )
print("caller: ", caller, "-> boxSymbol")
local b =nil 
caller="boxSymbol"
  b = boxString(s )
caller="boxSymbol"
b.typ = "symbol" 
caller="boxSymbol"
  return b 

end
-- Chose function name boxBool
function boxBool(boo )
print("caller: ", caller, "-> boxBool")
local b =nil 
caller="boxBool"
  b = makeBox()
caller="boxBool"
b.boo = boo 
caller="boxBool"
b.typ = "bool" 
caller="boxBool"
  return b 

end
-- Chose function name boxInt
function boxInt(val )
print("caller: ", caller, "-> boxInt")
local b =nil 
caller="boxInt"
  b = makeBox()
caller="boxInt"
b.i = val 
caller="boxInt"
b.typ = "int" 
caller="boxInt"
  return b 

end
-- Chose function name assertType
function assertType(atype ,abox ,line ,file )
print("caller: ", caller, "-> assertType")
caller="assertType"
  if isNil(abox ) then
caller=""
      if equalString(atype , "nil" ) then
caller=""
          return 

      else
caller=""
          return 

      end

  else
caller=""
      if equalString(atype , boxType(abox )) then
caller=""
          return 

      else
caller=""
          printf("Assertion failure at line %d, in file %s: provided value is not a '%s'!  It was actually (%s):" , line , file , atype , abox.typ);

caller=""
          display(abox );

caller=""
          panic("Invalid type!" );

      end

  end

end
-- Chose function name unBoxString
function unBoxString(b )
print("caller: ", caller, "-> unBoxString")
caller="unBoxString"
  assertType("string" , b , 261 , "base.qon" );

caller="unBoxString"
  return b.str

end
-- Chose function name unBoxSymbol
function unBoxSymbol(b )
print("caller: ", caller, "-> unBoxSymbol")
caller="unBoxSymbol"
  return b.str

end
-- Chose function name unBoxBool
function unBoxBool(b )
print("caller: ", caller, "-> unBoxBool")
caller="unBoxBool"
  return b.boo

end
-- Chose function name unBoxInt
function unBoxInt(b )
print("caller: ", caller, "-> unBoxInt")
caller="unBoxInt"
  return b.i

end
-- Chose function name stringify_rec
function stringify_rec(b )
print("caller: ", caller, "-> stringify_rec")
caller="stringify_rec"
  if isNil(b ) then
caller=""
      return "" 

  else
caller=""
      return stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringify_rec(cdr(b ))))

  end

end
-- Chose function name stringify
function stringify(b )
print("caller: ", caller, "-> stringify")
caller="stringify"
  if isNil(b ) then
caller=""
      return "()" 

  else
caller=""
      if equalString("string" , boxType(b )) then
caller=""
          return unBoxString(b )

      else
caller=""
          if equalString("bool" , boxType(b )) then
caller=""
              if unBoxBool(b ) then
caller=""
                  return "true" 

              else
caller=""
                  return "false" 

              end

          else
caller=""
              if equalString("int" , boxType(b )) then
caller=""
                  return intToString(unBoxInt(b ))

              else
caller=""
                  if equalString("symbol" , boxType(b )) then
caller=""
                      return unBoxSymbol(b )

                  else
caller=""
                      if equalString("list" , boxType(b )) then
caller=""
                          return stringConcatenate("(" , stringConcatenate(stringify(car(b )), stringConcatenate(" " , stringConcatenate(stringify_rec(cdr(b )), ")" ))))

                      else
caller=""
                          return stringConcatenate("Unsupported type: " , boxType(b ))

                      end

                  end

              end

          end

      end

  end

end
-- Chose function name hasTag
function hasTag(aBox ,key )
print("caller: ", caller, "-> hasTag")
caller="hasTag"
  if isNil(aBox ) then
caller=""
      return false 

  else
caller=""
      return isNotFalse(assoc(stringify(key ), aBox.tag))

  end

end
-- Chose function name getTag
function getTag(aBox ,key )
print("caller: ", caller, "-> getTag")
caller="getTag"
  if false  then
caller=""
      printf("Getting %s from: " , stringify(key ));

caller=""
      display(alistKeys(aBox.tag));

caller=""
      printf("\n" );

  else
caller=""
      printf("" );

  end

caller="getTag"
  return cdr(assoc(stringify(key ), aBox.tag))

end
-- Chose function name getTagFail
function getTagFail(aBox ,key ,onFail )
print("caller: ", caller, "-> getTagFail")
caller="getTagFail"
  if hasTag(aBox , key ) then
caller=""
      return getTag(aBox , key )

  else
caller=""
      return onFail 

  end

end
-- Chose function name assocExists
function assocExists(key ,aBox )
print("caller: ", caller, "-> assocExists")
caller="assocExists"
  if isNil(aBox ) then
caller=""
      return false 

  else
caller=""
      return isNotFalse(assoc(key , aBox ))

  end

end
-- Chose function name assocFail
function assocFail(key ,aBox ,onFail )
print("caller: ", caller, "-> assocFail")
caller="assocFail"
  if assocExists(key , aBox ) then
caller=""
      return assoc(key , aBox )

  else
caller=""
      return cons(boxString(key ), onFail )

  end

end
-- Chose function name setTag
function setTag(key ,val ,aStruct )
print("caller: ", caller, "-> setTag")
caller="setTag"
aStruct.tag = alistCons(key , val , aStruct.tag)
caller="setTag"
  return aStruct 

end
-- Chose function name filterVoid
function filterVoid(l )
print("caller: ", caller, "-> filterVoid")
local token =nil 
caller="filterVoid"
  if isEmpty(l ) then
caller=""
      return emptyList()

  else
caller=""
      token = car(l )
caller=""
      if equalString("void" , token.typ) then
caller=""
          return filterVoid(cdr(l ))

      else
caller=""
          return cons(token , filterVoid(cdr(l )))

      end

  end

end
-- Chose function name filterTokens
function filterTokens(l )
print("caller: ", caller, "-> filterTokens")
local token =nil 
caller="filterTokens"
  if isEmpty(l ) then
caller=""
      return emptyList()

  else
caller=""
      token = car(l )
caller=""
      if equalString(boxType(token ), "symbol" ) then
caller=""
          if equalString("__LINE__" , stringify(token )) then
caller=""
              return cons(getTagFail(token , boxString("line" ), boxInt(-1 )), filterTokens(cdr(l )))

          else
caller=""
              if equalString("__COLUMN__" , stringify(token )) then
caller=""
                  return cons(getTagFail(token , boxString("column" ), boxInt(-1 )), filterTokens(cdr(l )))

              else
caller=""
                  if equalString("__FILE__" , stringify(token )) then
caller=""
                      return cons(getTagFail(token , boxString("filename" ), boxString("Unknown file" )), filterTokens(cdr(l )))

                  else
caller=""
                      return cons(token , filterTokens(cdr(l )))

                  end

              end

          end

      else
caller=""
          return cons(token , filterTokens(cdr(l )))

      end

  end

end
-- Chose function name finish_token
function finish_token(prog ,start ,len ,line ,column ,filename )
print("caller: ", caller, "-> finish_token")
local token =nil 
caller="finish_token"
  if greaterthan(len , 0 ) then
caller=""
      token = boxSymbol(luaSubstring(prog , start , len ))
caller=""
token.tag = alistCons(boxString("filename" ), boxString(filename ), alistCons(boxString("column" ), boxInt(column ), alistCons(boxString("line" ), boxInt(line ), alistCons(boxString("totalCharPos" ), boxInt(start ), nil ))))
caller=""
      return token 

  else
caller=""
      return newVoid()

  end

end
-- Chose function name readString
function readString(prog ,start ,len )
print("caller: ", caller, "-> readString")
local token ="" 
caller="readString"
  token = luaSubstring(prog , sub1(add(start , len )), 1 )
caller="readString"
  if equalString("\"" , token ) then
caller=""
      return luaSubstring(prog , start , sub1(len ))

  else
caller=""
      if equalString("\\" , token ) then
caller=""
          return readString(prog , start , add(2 , len ))

      else
caller=""
          return readString(prog , start , add1(len ))

      end

  end

end
-- Chose function name readComment
function readComment(prog ,start ,len )
print("caller: ", caller, "-> readComment")
local token ="" 
caller="readComment"
  token = luaSubstring(prog , sub1(add(start , len )), 1 )
caller="readComment"
  if isLineBreak(token ) then
caller=""
      return luaSubstring(prog , start , sub1(len ))

  else
caller=""
      return readComment(prog , start , add1(len ))

  end

end
-- Chose function name isWhiteSpace
function isWhiteSpace(s )
print("caller: ", caller, "-> isWhiteSpace")
caller="isWhiteSpace"
  if equalString(" " , s ) then
caller=""
      return true 

  else
caller=""
      if equalString("\t" , s ) then
caller=""
          return true 

      else
caller=""
          if equalString("\n" , s ) then
caller=""
              return true 

          else
caller=""
              if equalString("\r" , s ) then
caller=""
                  return true 

              else
caller=""
                  return false 

              end

          end

      end

  end

end
-- Chose function name isLineBreak
function isLineBreak(s )
print("caller: ", caller, "-> isLineBreak")
caller="isLineBreak"
  if equalString("\n" , s ) then
caller=""
      return true 

  else
caller=""
      if equalString("\r" , s ) then
caller=""
          return true 

      else
caller=""
          return false 

      end

  end

end
-- Chose function name incForNewLine
function incForNewLine(token ,val )
print("caller: ", caller, "-> incForNewLine")
caller="incForNewLine"
  if equalString("\n" , stringify(token )) then
caller=""
      return add1(val )

  else
caller=""
      return val 

  end

end
-- Chose function name annotateReadPosition
function annotateReadPosition(filename ,linecount ,column ,start ,newBox )
print("caller: ", caller, "-> annotateReadPosition")
caller="annotateReadPosition"
  return setTag(boxString("filename" ), boxString(filename ), setTag(boxString("column" ), boxInt(column ), setTag(boxString("line" ), boxInt(linecount ), setTag(boxString("totalCharPos" ), boxInt(start ), newBox ))))

end
-- Chose function name scan
function scan(prog ,start ,len ,linecount ,column ,filename )
print("caller: ", caller, "-> scan")
local token =nil 
local newString ="" 
local newBox =nil 
caller="scan"
  if false  then
caller=""
      printf("Scanning: line %d:%d\n" , linecount , column );

  else
caller=""
      printf("" );

  end

caller="scan"
  if greaterthan(string.len(prog ), sub(start , sub(0 , len ))) then
caller=""
      token = boxSymbol(luaSubstring(prog , sub1(add(start , len )), 1 ))
caller=""
token.tag = alistCons(boxString("totalCharPos" ), boxInt(start ), nil )
caller=""
      if isOpenBrace(token ) then
caller=""
          return cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(boxSymbol(openBrace()), scan(prog , add1(start ), 1 , linecount , add1(column ), filename )))

      else
caller=""
          if isCloseBrace(token ) then
caller=""
              return cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), cons(annotateReadPosition(filename , linecount , column , start , boxSymbol(closeBrace())), scan(prog , add(start , len ), 1 , linecount , add1(column ), filename )))

          else
caller=""
              if isWhiteSpace(stringify(token )) then
caller=""
                  return cons(finish_token(prog , start , sub1(len ), linecount , column , filename ), scan(prog , add(start , len ), 1 , incForNewLine(token , linecount ), 0 , filename ))

              else
caller=""
                  if equalBox(boxSymbol(";" ), token ) then
caller=""
                      return scan(prog , add(start , add1(add1(string.len(readComment(prog , add1(start ), len ))))), 1 , add1(linecount ), 0 , filename )

                  else
caller=""
                      if equalBox(boxSymbol("\"" ), token ) then
caller=""
                          newString = readString(prog , add1(start ), len )
caller=""
                          newBox = annotateReadPosition(filename , linecount , column , start , boxString(newString ))
caller=""
                          return cons(newBox , scan(prog , add(start , add1(add1(string.len(newString )))), 1 , linecount , add1(column ), filename ))

                      else
caller=""
                          return scan(prog , start , sub(len , -1 ), linecount , add1(column ), filename )

                      end

                  end

              end

          end

      end

  else
caller=""
      return emptyList()

  end

end
-- Chose function name isOpenBrace
function isOpenBrace(b )
print("caller: ", caller, "-> isOpenBrace")
caller="isOpenBrace"
  if equalBox(boxSymbol(openBrace()), b ) then
caller=""
      return true 

  else
caller=""
      if equalBox(boxSymbol("[" ), b ) then
caller=""
          return true 

      else
caller=""
          return false 

      end

  end

end
-- Chose function name openBrace
function openBrace()
print("caller: ", caller, "-> openBrace")
caller="openBrace"
  return "(" 

end
-- Chose function name isCloseBrace
function isCloseBrace(b )
print("caller: ", caller, "-> isCloseBrace")
caller="isCloseBrace"
  if equalBox(boxSymbol(closeBrace()), b ) then
caller=""
      return true 

  else
caller=""
      if equalBox(boxSymbol("]" ), b ) then
caller=""
          return true 

      else
caller=""
          return false 

      end

  end

end
-- Chose function name closeBrace
function closeBrace()
print("caller: ", caller, "-> closeBrace")
caller="closeBrace"
  return ")" 

end
-- Chose function name sexprTree
function sexprTree(l )
print("caller: ", caller, "-> sexprTree")
local b =nil 
caller="sexprTree"
  if isEmpty(l ) then
caller=""
      return emptyList()

  else
caller=""
      b = car(l )
caller=""
      if isOpenBrace(b ) then
caller=""
          return cons(sexprTree(cdr(l )), sexprTree(skipList(cdr(l ))))

      else
caller=""
          if isCloseBrace(b ) then
caller=""
              return emptyList()

          else
caller=""
              return setTag(boxString("line" ), getTagFail(b , boxString("line" ), boxInt(-1 )), cons(b , sexprTree(cdr(l ))))

          end

      end

  end

end
-- Chose function name skipList
function skipList(l )
print("caller: ", caller, "-> skipList")
local b =nil 
caller="skipList"
  if isEmpty(l ) then
caller=""
      return emptyList()

  else
caller=""
      b = car(l )
caller=""
      if isOpenBrace(b ) then
caller=""
          return skipList(skipList(cdr(l )))

      else
caller=""
          if isCloseBrace(b ) then
caller=""
              return cdr(l )

          else
caller=""
              return skipList(cdr(l ))

          end

      end

  end

end
-- Chose function name readSexpr
function readSexpr(aStr ,filename )
print("caller: ", caller, "-> readSexpr")
local tokens =nil 
local as =nil 
caller="readSexpr"
  tokens = emptyList()
caller="readSexpr"
  tokens = filterTokens(filterVoid(scan(aStr , 0 , 1 , 0 , 0 , filename )))
caller="readSexpr"
  as = sexprTree(tokens )
caller="readSexpr"
  return car(as )

end
-- Chose function name caar
function caar(l )
print("caller: ", caller, "-> caar")
caller="caar"
  return car(car(l ))

end
-- Chose function name cadr
function cadr(l )
print("caller: ", caller, "-> cadr")
caller="cadr"
  return car(cdr(l ))

end
-- Chose function name caddr
function caddr(l )
print("caller: ", caller, "-> caddr")
caller="caddr"
  return car(cdr(cdr(l )))

end
-- Chose function name cadddr
function cadddr(l )
print("caller: ", caller, "-> cadddr")
caller="cadddr"
  return car(cdr(cdr(cdr(l ))))

end
-- Chose function name caddddr
function caddddr(l )
print("caller: ", caller, "-> caddddr")
caller="caddddr"
  return car(cdr(cdr(cdr(cdr(l )))))

end
-- Chose function name cddr
function cddr(l )
print("caller: ", caller, "-> cddr")
caller="cddr"
  return cdr(cdr(l ))

end
-- Chose function name first
function first(l )
print("caller: ", caller, "-> first")
caller="first"
  return car(l )

end
-- Chose function name second
function second(l )
print("caller: ", caller, "-> second")
caller="second"
  return cadr(l )

end
-- Chose function name third
function third(l )
print("caller: ", caller, "-> third")
caller="third"
  return caddr(l )

end
-- Chose function name fourth
function fourth(l )
print("caller: ", caller, "-> fourth")
caller="fourth"
  return cadddr(l )

end
-- Chose function name fifth
function fifth(l )
print("caller: ", caller, "-> fifth")
caller="fifth"
  return caddddr(l )

end
-- Chose function name makeNode
function makeNode(name ,subname ,code ,children )
print("caller: ", caller, "-> makeNode")
caller="makeNode"
  return cons(boxSymbol("node" ), alistCons(boxSymbol("line" ), getTagFail(code , boxString("line" ), boxInt(-1 )), cons(cons(boxSymbol("name" ), boxString(name )), cons(cons(boxSymbol("subname" ), boxString(subname )), cons(cons(boxSymbol("code" ), code ), alistCons(boxSymbol("children" ), children , emptyList()))))))

end
-- Chose function name addToNode
function addToNode(key ,val ,node )
print("caller: ", caller, "-> addToNode")
caller="addToNode"
  return cons(boxSymbol("node" ), alistCons(key , val , cdr(node )))

end
-- Chose function name makeStatementNode
function makeStatementNode(name ,subname ,code ,children ,functionName )
print("caller: ", caller, "-> makeStatementNode")
caller="makeStatementNode"
  return addToNode(boxSymbol("functionName" ), functionName , makeNode(name , subname , code , children ))

end
-- Chose function name astExpression
function astExpression(tree )
print("caller: ", caller, "-> astExpression")
caller="astExpression"
  if isList(tree ) then
caller=""
      return makeNode("expression" , "expression" , nil , astSubExpression(tree ))

  else
caller=""
      return astSubExpression(tree )

  end

end
-- Chose function name astSubExpression
function astSubExpression(tree )
print("caller: ", caller, "-> astSubExpression")
caller="astSubExpression"
  if isEmpty(tree ) then
caller=""
      return emptyList()

  else
caller=""
      if isList(tree ) then
caller=""
          return cons(astExpression(car(tree )), astSubExpression(cdr(tree )))

      else
caller=""
          return makeNode("expression" , "leaf" , tree , nil )

      end

  end

end
-- Chose function name astIf
function astIf(tree ,fname )
print("caller: ", caller, "-> astIf")
caller="astIf"
  if equalBox(boxString("then" ), car(second(tree ))) then
caller=""
      nop();

  else
caller=""
      printf("Error at %s:%s!  If statement is missing the true branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));

caller=""
      panic("Missing true branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  end

caller="astIf"
  if equalBox(boxString("else" ), car(third(tree ))) then
caller=""
      nop();

  else
caller=""
      printf("Error at %s:%s!  If statement is missing the false branch.\n\n" , stringify(getTag(car(first(tree )), boxString("filename" ))), stringify(getTag(car(first(tree )), boxString("line" ))));

caller=""
      panic("Missing false branch in if statement!  All if statements must have a true and false branch, like this:\n\n(if hungryForApples\n(then (printf \"yes!\"))\n(else (printf \"no!\")))\n\n\n" );

  end

caller="astIf"
  return makeNode("statement" , "if" , tree , cons(cons(astExpression(first(tree )), nil ), cons(astBody(cdr(second(tree )), fname ), cons(astBody(cdr(third(tree )), fname ), nil ))))

end
-- Chose function name astSetStruct
function astSetStruct(tree )
print("caller: ", caller, "-> astSetStruct")
caller="astSetStruct"
  return makeNode("statement" , "structSetter" , tree , astExpression(third(tree )))

end
-- Chose function name astSet
function astSet(tree )
print("caller: ", caller, "-> astSet")
caller="astSet"
  return makeNode("statement" , "setter" , tree , astExpression(second(tree )))

end
-- Chose function name astGetStruct
function astGetStruct(tree )
print("caller: ", caller, "-> astGetStruct")
caller="astGetStruct"
  return makeNode("expression" , "structGetter" , tree , nil )

end
-- Chose function name astReturnVoid
function astReturnVoid(fname )
print("caller: ", caller, "-> astReturnVoid")
caller="astReturnVoid"
  return makeStatementNode("statement" , "returnvoid" , nil , nil , fname )

end
-- Chose function name astStatement
function astStatement(tree ,fname )
print("caller: ", caller, "-> astStatement")
caller="astStatement"
  if equalBox(boxString("if" ), car(tree )) then
caller=""
      return astIf(cdr(tree ), fname )

  else
caller=""
      if equalBox(boxString("set" ), car(tree )) then
caller=""
          return astSet(cdr(tree ))

      else
caller=""
          if equalBox(boxString("get-struct" ), car(tree )) then
caller=""
              printf("Choosing get-struct statement\n" );

caller=""
              return astGetStruct(cdr(tree ))

          else
caller=""
              if equalBox(boxString("set-struct" ), car(tree )) then
caller=""
                  return astSetStruct(cdr(tree ))

              else
caller=""
                  if equalBox(boxString("return" ), car(tree )) then
caller=""
                      if equal(listLength(tree ), 1 ) then
caller=""
                          return astReturnVoid(fname )

                      else
caller=""
                          return makeStatementNode("statement" , "return" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname )

                      end

                  else
caller=""
                      return makeStatementNode("statement" , "statement" , tree , makeNode("expression" , "expression" , tree , astExpression(tree )), fname )

                  end

              end

          end

      end

  end

end
-- Chose function name astBody
function astBody(tree ,fname )
print("caller: ", caller, "-> astBody")
caller="astBody"
  if isEmpty(tree ) then
caller=""
      return emptyList()

  else
caller=""
      return cons(astStatement(car(tree ), fname ), astBody(cdr(tree ), fname ))

  end

end
-- Chose function name linePanic
function linePanic(line ,message )
print("caller: ", caller, "-> linePanic")
caller="linePanic"
  printf("line %s: %s\n" , line , message );

caller="linePanic"
  panic(message );

end
-- Chose function name astFunction
function astFunction(tree )
print("caller: ", caller, "-> astFunction")
local line ="" 
local file ="" 
local fname =nil 
caller="astFunction"
  fname = second(tree )
caller="astFunction"
  line = stringify(getTag(fname , boxString("line" )))
caller="astFunction"
  file = stringify(getTag(fname , boxString("filename" )))
caller="astFunction"
  if greaterthan(1 , listLength(tree )) then
caller=""
      linePanic(line , "Malformed function, seems to be empty" );

  else
  end

caller="astFunction"
  if greaterthan(2 , listLength(tree )) then
caller=""
      linePanic(line , "Malformed function, expected function name" );

  else
  end

caller="astFunction"
  if greaterthan(3 , listLength(tree )) then
caller=""
      linePanic(line , "Malformed function, expected argument list" );

  else
  end

caller="astFunction"
  if greaterthan(4 , listLength(tree )) then
caller=""
      linePanic(line , "Malformed function, expected variable declarations" );

  else
  end

caller="astFunction"
  if greaterthan(5 , listLength(tree )) then
caller=""
      linePanic(line , "Malformed function, expected body" );

  else
  end

caller="astFunction"
  return alistCons(boxSymbol("line" ), getTag(fname , boxString("line" )), cons(cons(boxSymbol("name" ), boxString("function" )), cons(cons(boxSymbol("subname" ), second(tree )), cons(cons(boxSymbol("declarations" ), cdr(fourth(tree ))), cons(cons(boxSymbol("intype" ), third(tree )), cons(cons(boxSymbol("outtype" ), car(tree )), cons(cons(boxSymbol("children" ), astBody(cdr(fifth(tree )), fname )), emptyList())))))))

end
-- Chose function name astFunctionList
function astFunctionList(tree )
print("caller: ", caller, "-> astFunctionList")
caller="astFunctionList"
  if isEmpty(tree ) then
caller=""
      return emptyList()

  else
caller=""
      return cons(astFunction(car(tree )), astFunctionList(cdr(tree )))

  end

end
-- Chose function name astFunctions
function astFunctions(tree )
print("caller: ", caller, "-> astFunctions")
caller="astFunctions"
  if equalBox(boxString("functions" ), car(tree )) then
caller=""
      return makeNode("functions" , "functions" , tree , astFunctionList(cdr(tree )))

  else
caller=""
      panic("Functions section not found!  Every program must have a function section, even if you don't define any functions, although that is a rather pointless program.  Your function section should look like:'\n\n(return_type function_name (arg1 arg2 arg3 ...) (declare types) (body (statement)(statement)))\n\n\nThe function section must be directly after the types section." );

caller=""
      return nil 

  end

end
-- Chose function name loadLib
function loadLib(path )
print("caller: ", caller, "-> loadLib")
local programStr ="" 
local tree =nil 
local library =nil 
caller="loadLib"
  programStr = luaReadFile(path )
caller="loadLib"
  tree = readSexpr(programStr , path )
caller="loadLib"
  tree = macrowalk(tree )
caller="loadLib"
  library = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="loadLib"
  return library 

end
-- Chose function name astInclude
function astInclude(tree )
print("caller: ", caller, "-> astInclude")
caller="astInclude"
  return loadLib(stringify(tree ))

end
-- Chose function name astIncludeList
function astIncludeList(tree )
print("caller: ", caller, "-> astIncludeList")
caller="astIncludeList"
  if isEmpty(tree ) then
caller=""
      return emptyList()

  else
caller=""
      return cons(astInclude(car(tree )), astIncludeList(cdr(tree )))

  end

end
-- Chose function name astIncludes
function astIncludes(tree )
print("caller: ", caller, "-> astIncludes")
caller="astIncludes"
  if equalBox(boxString("includes" ), car(tree )) then
caller=""
      return makeNode("includes" , "includes" , tree , astIncludeList(cdr(tree )))

  else
caller=""
      panic("Includes section not found!  Every program must have an include section, even if you don't import any libraries.  Your include section should look like:'\n\n(includes file1.qon file.qon)\n\n\nThe includes section must be the first section of the file." );

caller=""
      return nil 

  end

end
-- Chose function name astStruct
function astStruct(tree )
print("caller: ", caller, "-> astStruct")
caller="astStruct"
  return makeNode("type" , "struct" , tree , nil )

end
-- Chose function name astType
function astType(tree )
print("caller: ", caller, "-> astType")
caller="astType"
  if isList(cadr(tree )) then
caller=""
      return astStruct(tree )

  else
caller=""
      return makeNode("type" , "type" , tree , nil )

  end

end
-- Chose function name astTypeList
function astTypeList(tree )
print("caller: ", caller, "-> astTypeList")
caller="astTypeList"
  if isEmpty(tree ) then
caller=""
      return emptyList()

  else
caller=""
      return cons(astType(car(tree )), astTypeList(cdr(tree )))

  end

end
-- Chose function name astTypes
function astTypes(tree )
print("caller: ", caller, "-> astTypes")
caller="astTypes"
  if equalBox(boxString("types" ), car(tree )) then
caller=""
      return makeNode("types" , "types" , tree , astTypeList(cdr(tree )))

  else
caller=""
      panic("Types section not found!  Every program must have a types section, even if you don't define any types" );

caller=""
      return boxString("Fuck java" )

  end

end
-- Chose function name declarationsof
function declarationsof(ass )
print("caller: ", caller, "-> declarationsof")
caller="declarationsof"
  return cdr(assoc("declarations" , cdr(ass )))

end
-- Chose function name codeof
function codeof(ass )
print("caller: ", caller, "-> codeof")
caller="codeof"
  return cdr(assoc("code" , cdr(ass )))

end
-- Chose function name functionNameof
function functionNameof(ass )
print("caller: ", caller, "-> functionNameof")
caller="functionNameof"
  return cdr(assoc("functionName" , cdr(ass )))

end
-- Chose function name nodeof
function nodeof(ass )
print("caller: ", caller, "-> nodeof")
caller="nodeof"
  if equalBox(boxBool(false ), assoc("node" , cdr(ass ))) then
caller=""
      return boxBool(false )

  else
caller=""
      return cdr(assoc("node" , cdr(ass )))

  end

end
-- Chose function name lineof
function lineof(ass )
print("caller: ", caller, "-> lineof")
caller="lineof"
  if equalBox(boxBool(false ), assoc("line" , cdr(ass ))) then
caller=""
      return boxInt(-1 )

  else
caller=""
      return cdr(assoc("line" , cdr(ass )))

  end

end
-- Chose function name subnameof
function subnameof(ass )
print("caller: ", caller, "-> subnameof")
caller="subnameof"
  return cdr(assoc("subname" , cdr(ass )))

end
-- Chose function name nameof
function nameof(ass )
print("caller: ", caller, "-> nameof")
caller="nameof"
  return cdr(assoc("name" , cdr(ass )))

end
-- Chose function name childrenof
function childrenof(ass )
print("caller: ", caller, "-> childrenof")
caller="childrenof"
  return cdr(assoc("children" , cdr(ass )))

end
-- Chose function name isNode
function isNode(val )
print("caller: ", caller, "-> isNode")
caller="isNode"
  if isEmpty(val ) then
caller=""
      return false 

  else
caller=""
      if isList(val ) then
caller=""
          if equalBox(boxSymbol("node" ), car(val )) then
caller=""
              return true 

          else
caller=""
              return false 

          end

      else
caller=""
          return false 

      end

  end

end
-- Chose function name truthy
function truthy(aVal )
print("caller: ", caller, "-> truthy")
caller="truthy"
  return isNotFalse(aVal )

end
-- Chose function name isNotFalse
function isNotFalse(aVal )
print("caller: ", caller, "-> isNotFalse")
caller="isNotFalse"
  if equalString(boxType(aVal ), "bool" ) then
caller=""
      if unBoxBool(aVal ) then
caller=""
          return true 

      else
caller=""
          return false 

      end

  else
caller=""
      return true 

  end

end
-- Chose function name isLeaf
function isLeaf(n )
print("caller: ", caller, "-> isLeaf")
caller="isLeaf"
  return equalBox(boxString("leaf" ), subnameof(n ))

end
-- Chose function name printIndent
function printIndent(ii )
print("caller: ", caller, "-> printIndent")
caller="printIndent"
  if greaterthan(ii , 0 ) then
caller=""
      printf("  " );

caller=""
      printIndent(sub1(ii ));

  else
caller=""
      return 

  end

end
-- Chose function name newLine
function newLine(indent )
print("caller: ", caller, "-> newLine")
caller="newLine"
  printf("\n" );

caller="newLine"
  printIndent(indent );

end
-- Chose function name noStackTrace
function noStackTrace()
print("caller: ", caller, "-> noStackTrace")
caller="noStackTrace"
  return cons(boxString("boxType" ), cons(boxString("stringify" ), cons(boxString("isEmpty" ), cons(boxString("unBoxString" ), cons(boxString("isList" ), cons(boxString("unBoxBool" ), cons(boxString("unBoxSymbol" ), cons(boxString("equalBox" ), cons(boxString("assoc" ), cons(boxString("inList" ), cons(boxString("unBoxInt" ), cons(boxString("listLength" ), cons(boxString("stroff" ), cons(boxString("troff" ), cons(boxString("tron" ), cons(boxString("stron" ), cons(boxString("car" ), cons(boxString("cdr" ), cons(boxString("cons" ), cons(boxString("stackTracePush" ), cons(boxString("stackTracePop" ), cons(boxString("assertType" ), cons(boxString("boxString" ), cons(boxString("boxSymbol" ), cons(boxString("boxInt" ), nil )))))))))))))))))))))))))

end
-- Chose function name toStr
function toStr(thing )
print("caller: ", caller, "-> toStr")
caller="toStr"
  return boxString(stringify(thing ))

end
-- Chose function name listLast
function listLast(alist )
print("caller: ", caller, "-> listLast")
caller="listLast"
  if isEmpty(cdr(alist )) then
caller=""
      return car(alist )

  else
caller=""
      return listLast(cdr(alist ))

  end

end
-- Chose function name treeCompile
function treeCompile(filename )
print("caller: ", caller, "-> treeCompile")
local programStr ="" 
local tree =nil 
local program =nil 
caller="treeCompile"
  programStr = luaReadFile(filename )
caller="treeCompile"
  tree = readSexpr(programStr , filename )
caller="treeCompile"
  return tree 

end
-- Chose function name astBuild
function astBuild(filename )
print("caller: ", caller, "-> astBuild")
local programStr ="" 
local tree =nil 
local program =nil 
caller="astBuild"
  programStr = luaReadFile(filename )
caller="astBuild"
  tree = readSexpr(programStr , filename )
caller="astBuild"
  program = alistCons(boxString("includes" ), astIncludes(first(tree )), alistCons(boxString("types" ), astTypes(second(tree )), alistCons(boxString("functions" ), astFunctions(third(tree )), nil )))
caller="astBuild"
  program = mergeIncludes(program )
caller="astBuild"
  return program 

end
-- Chose function name astCompile
function astCompile(filename )
print("caller: ", caller, "-> astCompile")
local programStr ="" 
local tree =nil 
local program =nil 
caller="astCompile"
  program = astBuild(filename )
caller="astCompile"
  display(program );

caller="astCompile"
  printf("\n" );

end
-- Chose function name concatLists
function concatLists(seq1 ,seq2 )
print("caller: ", caller, "-> concatLists")
caller="concatLists"
  if isNil(seq1 ) then
caller=""
      return seq2 

  else
caller=""
      return cons(car(seq1 ), concatLists(cdr(seq1 ), seq2 ))

  end

end
-- Chose function name alistKeys
function alistKeys(alist )
print("caller: ", caller, "-> alistKeys")
caller="alistKeys"
  if isNil(alist ) then
caller=""
      return nil 

  else
caller=""
      return cons(car(car(alist )), alistKeys(cdr(alist )))

  end

end
-- Chose function name mergeIncludes
function mergeIncludes(program )
print("caller: ", caller, "-> mergeIncludes")
caller="mergeIncludes"
  return merge_recur(childrenof(cdr(cdr(assoc("includes" , program )))), program )

end
-- Chose function name merge_recur
function merge_recur(incs ,program )
print("caller: ", caller, "-> merge_recur")
caller="merge_recur"
  if greaterthan(listLength(incs ), 0 ) then
caller=""
      return mergeInclude(car(incs ), merge_recur(cdr(incs ), program ))

  else
caller=""
      return program 

  end

end
-- Chose function name mergeInclude
function mergeInclude(inc ,program )
print("caller: ", caller, "-> mergeInclude")
local newProgram =nil 
local oldfunctionsnode =nil 
local oldfunctions =nil 
local newfunctions =nil 
local newFunctionNode =nil 
local functions =nil 
local oldtypesnode =nil 
local oldtypes =nil 
local newtypes =nil 
local newTypeNode =nil 
local types =nil 
caller="mergeInclude"
  if isNil(inc ) then
caller=""
      return program 

  else
caller=""
      functions = childrenof(cdr(assoc("functions" , inc )))
caller=""
      oldfunctionsnode = cdr(assoc("functions" , program ))
caller=""
      oldfunctions = childrenof(oldfunctionsnode )
caller=""
      newfunctions = concatLists(functions , oldfunctions )
caller=""
      newFunctionNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newfunctions , cdr(oldfunctionsnode )))
caller=""
      types = childrenof(cdr(assoc("types" , inc )))
caller=""
      oldtypesnode = cdr(assoc("types" , program ))
caller=""
      oldtypes = childrenof(oldtypesnode )
caller=""
      newtypes = concatLists(types , oldtypes )
caller=""
      newTypeNode = cons(boxSymbol("node" ), alistCons(boxSymbol("children" ), newtypes , cdr(oldtypesnode )))
caller=""
      newProgram = alistCons(boxString("functions" ), newFunctionNode , alistCons(boxString("types" ), newTypeNode , alistCons(boxString("includes" ), cons(boxSymbol("includes" ), nil ), newProgram )))
caller=""
      return newProgram 

  end

end
-- Chose function name macrowalk
function macrowalk(l )
print("caller: ", caller, "-> macrowalk")
local val =nil 
caller="macrowalk"
  if isEmpty(l ) then
caller=""
      return nil 

  else
caller=""
      if isList(l ) then
caller=""
          if equalString(stringConcatenate("box" , "List" ), stringify(car(l ))) then
caller=""
              return car(doBoxList(cdr(l )))

          else
          end

caller=""
          if equalString(stringConcatenate("string" , "List" ), stringify(car(l ))) then
caller=""
              return car(doStringList(cdr(l )))

          else
          end

caller=""
          return cons(macrowalk(car(l )), macrowalk(cdr(l )))

      else
caller=""
          return l 

      end

  end

end
-- Chose function name macrosingle
function macrosingle(l ,search ,replace )
print("caller: ", caller, "-> macrosingle")
local val =nil 
caller="macrosingle"
  if isEmpty(l ) then
caller=""
      return nil 

  else
caller=""
      if isList(l ) then
caller=""
          return cons(macrosingle(car(l ), search , replace ), macrosingle(cdr(l ), search , replace ))

      else
caller=""
          if equalString(search , stringify(l )) then
caller=""
              printf("---Matched!: %s\n" , stringify(l ));

caller=""
              val = clone(l )
caller=""
val.str = replace 
caller=""
              return val 

          else
          end

caller=""
          return l 

      end

  end

end
-- Chose function name doBoxList
function doBoxList(l )
print("caller: ", caller, "-> doBoxList")
caller="doBoxList"
  if isNil(l ) then
caller=""
      return cons(boxSymbol("nil" ), nil )

  else
caller=""
      return cons(cons(boxSymbol("cons" ), cons(first(l ), doBoxList(cdr(l )))), nil )

  end

end
-- Chose function name doStringList
function doStringList(l )
print("caller: ", caller, "-> doStringList")
local newlist =nil 
local ret =nil 
caller="doStringList"
  if isNil(l ) then
caller=""
      return cons(boxSymbol("nil" ), nil )

  else
caller=""
      newlist = cons(boxSymbol("boxString" ), cons(first(l ), newlist ))
caller=""
      ret = cons(cons(boxSymbol("cons" ), cons(newlist , doStringList(cdr(l )))), nil )
caller=""
      return ret 

  end

end
-- Chose function name argList
function argList(count ,pos ,args )
print("caller: ", caller, "-> argList")
caller="argList"
  if greaterthan(count , pos ) then
caller=""
      return cons(boxString(getStringArray(pos , args )), argList(count , add1(pos ), args ))

  else
caller=""
      return nil 

  end

end
-- Chose function name listReverse
function listReverse(l )
print("caller: ", caller, "-> listReverse")
caller="listReverse"
  if isNil(l ) then
caller=""
      return nil 

  else
caller=""
      return cons(car(l ), listReverse(cdr(l )))

  end

end
-- Chose function name inList
function inList(item ,l )
print("caller: ", caller, "-> inList")
caller="inList"
  if isNil(l ) then
caller=""
      return false 

  else
caller=""
      if equalBox(car(l ), item ) then
caller=""
          return true 

      else
caller=""
          return inList(item , cdr(l ))

      end

  end

end
-- Chose function name equalList
function equalList(a ,b )
print("caller: ", caller, "-> equalList")
caller="equalList"
  if isNil(a ) then
caller=""
      if isNil(b ) then
caller=""
          return true 

      else
caller=""
          return true 

      end

  else
  end

caller="equalList"
  if equalBox(car(a ), car(b )) then
caller=""
      return equalList(cdr(a ), cdr(b ))

  else
caller=""
      return false 

  end

end
-- Chose function name reverseRec
function reverseRec(oldL ,newL )
print("caller: ", caller, "-> reverseRec")
caller="reverseRec"
  if isEmpty(oldL ) then
caller=""
      return newL 

  else
caller=""
      return reverseRec(cdr(oldL ), cons(first(oldL ), newL ))

  end

end
-- Chose function name reverseList
function reverseList(l )
print("caller: ", caller, "-> reverseList")
caller="reverseList"
  return reverseRec(l , nil )

end
-- Chose function name tron
function tron()
print("caller: ", caller, "-> tron")
caller="tron"
  globalTrace = true 
end
-- Chose function name troff
function troff()
print("caller: ", caller, "-> troff")
caller="troff"
  globalTrace = false 
end
-- Chose function name stron
function stron()
print("caller: ", caller, "-> stron")
caller="stron"
  globalStepTrace = true 
end
-- Chose function name stroff
function stroff()
print("caller: ", caller, "-> stroff")
caller="stroff"
  globalStepTrace = false 
end
-- Chose function name start
function start()
print("caller: ", caller, "-> start")
local runTests =false 
local cmdLine =nil 
local filename =nil 
local runPerl =false 
local runJava =false 
local runAst =false 
local runNode =false 
local runLua =false 
local runTree =false 
caller="start"
  cmdLine = listReverse(argList(globalArgsCount , 0 , globalArgs ))
caller="start"
  if greaterthan(listLength(cmdLine ), 1 ) then
caller=""
      filename = second(cmdLine )
  else
caller=""
      filename = boxString("compiler.qon" )
  end

caller="start"
  runTests = inList(boxString("--test" ), cmdLine )
caller="start"
  runJava = inList(boxString("--java" ), cmdLine )
caller="start"
  runPerl = inList(boxString("--perl" ), cmdLine )
caller="start"
  runAst = inList(boxString("--ast" ), cmdLine )
caller="start"
  runTree = inList(boxString("--tree" ), cmdLine )
caller="start"
  runNode = inList(boxString("--node" ), cmdLine )
caller="start"
  runLua = inList(boxString("--lua" ), cmdLine )
caller="start"
  globalTrace = inList(boxString("--trace" ), cmdLine )
caller="start"
  globalStepTrace = inList(boxString("--steptrace" ), cmdLine )
caller="start"
  if runTests  then
caller=""
      test0();

caller=""
      test1();

caller=""
      test2();

caller=""
      test3();

caller=""
      test4();

caller=""
      test5();

caller=""
      test6();

caller=""
      test7();

caller=""
      test8();

caller=""
      test9();

caller=""
      test10();

caller=""
      test12();

caller=""
      test13();

caller=""
      test15();

caller=""
      test16();

caller=""
      test17();

caller=""
      test18();

caller=""
      test19();

caller=""
      test20();

caller=""
      test21();

caller=""
      printf("\n\nAfter all that hard work, I need a beer...\n" );

caller=""
      beers(9 );

  else
caller=""
      if runTree  then
caller=""
          display(macrowalk(treeCompile(unBoxString(filename ))));

      else
caller=""
          if runAst  then
caller=""
              astCompile(unBoxString(filename ));

          else
caller=""
              if runNode  then
caller=""
                  nodeCompile(unBoxString(filename ));

caller=""
                  printf("\n" );

              else
caller=""
                  if runPerl  then
caller=""
                      perlCompile(unBoxString(filename ));

caller=""
                      printf("\n" );

                  else
caller=""
                      if runJava  then
caller=""
                          javaCompile(unBoxString(filename ));

caller=""
                          printf("\n" );

                      else
caller=""
                          if runLua  then
caller=""
                              luaCompile(unBoxString(filename ));

caller=""
                              printf("\n" );

                          else
caller=""
                              ansiCompile(unBoxString(filename ));

caller=""
                              printf("\n" );

                          end

                      end

                  end

              end

          end

      end

  end

caller="start"
  return 0 

end

function main()
globalArgs = arg
globalArgsCount = #arg
start()
end
main()
