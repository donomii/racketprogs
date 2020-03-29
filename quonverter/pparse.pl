     use Parse::RecDescent;
     $::RD_HINT   = 1;
     $::RD_WARN   = 1;
     $::RD_ERRORS = 1;
	my $text = join(" ", <>);

my $grammar = '
	includes: "Includes:" {print "(includes)\n"} | <error>
	typeHeader: "Types:" {print "(types\n"} | <error>
	typeDecls: typedef|structdef
	types: typeHeader typeDecls(s?) | <error>
	typedefBody: identifier "is" identifier(s) ";" { print "($item[1] @{$item[3]})\n";1;}
	typedef: "type" typedefBody
	structHeader: "type" identifier "is" "struct" "("  {print "($item[2] (struct \n"}
	structdef: structHeader typedefBody(s?) ")" ";" { print "))\n";1;}
	identifier: /[A-Za-z_*][A-Za-z0-9_*]*/
	atom: identifier { $return = $item[1] }| <perl_quotelike> { $return = join("", @{$item[1]}) }| /[0-9.-]*/ {$return=$item[1]}
	expression: identifier "(" expression(s? /,/) ")" { $return =  "($item[1] @{$item[3]} )" } | atom { $return =  $item[1] }
	return: "return" "(" expression ")" ";" { $return = "($item[1] $item[3])\n" }
	expressionStatement: expression ";" { $return =  $item[1] }
	ifStatement: "if" expression "then" statement(s?) "else" statement(s?) "end" { $return =  "( if $item[2] (then @{$item[4]}) (else @{$item[6]}))\n"}
	setStatement: identifier "=" expression ";" { $return = "(set $item[1] $item[3])\n" }
	nullReturn: "return" ";" { $return =  "(return)\n" }
	statement: ifStatement | setStatement | nullReturn | return | expressionStatement | <error>
	fun: "fu" identifier "(" argList ")" "->" identifier declare statement(s)  "end" "function" { $return =  "($item[7] $item[2] (@{$item[4]})\n(declare $item[8])\n@{$item[9]})\n " } | <error>
	functions: "Functions:" fun(s?) {print "@{$item[2]}" }
	arg: identifier ":" identifier  { $return = "$item[3] $item[1]" }
	argList: arg(s? /,/) { $return = $item[1] }
	declare1: identifier ":" identifier expression { $return = "($item[1] $item[3] $item[4])\n" }
	declare: declare1(s?) "in" { $return = "(@{$item[1]})\n" } | <error>
	program: includes types functions | <error>
';
# 
     # Generate a parser from the specification in $grammar:

         my $parser = new Parse::RecDescent ($grammar);


     # Parse $text using rule 'startrule' (which must be
     # defined in $grammar):

     use Data::Dumper;
        print Dumper($parser->program($text));
