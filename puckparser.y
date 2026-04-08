/********************************************************
* hint.y
********************************************************/
// -- PREAMBLE ------------------------------------------
%{
#include <iostream>
using namespace std;

// Things from Flex that Bison needs to know
extern int yylex();
extern int line_num;
extern char* yytext;

// Prototype for Bison's error message function
int yyerror(const char *p);
%}

//-- TOKEN DEFINITIONS --
// what tokens to expect from Flex

%token K_SC
%token K_LPAREN
%token K_RPAREN
%token K_WRITE

%token OP_ASSIGN

%token T_IDENT
%token T_INTEGER
%token T_DECIMAL

%%

//-- GRAMMAR RULES ------------------------------------
/* NOTE: Bison likes the start symbol to be the first rule */
StatementSequence : Statement
                    { cout << "RULE: StatementSequence ::= Statement" << endl; }
                | Statement K_SC StatementSequence
                    { cout << "RULE: StatementSequence ::= Statement ; StatementSequence" << endl; }

Statement : Assignment
            { cout << "RULE: Statement ::= Assignment" << endl; }
        | WriteStatement
            { cout << "RULE: Statement ::= WriteStatement" << endl; }
        ;
Assignment : T_IDENT OP_ASSIGN T_DECIMAL
            { cout << "RULE: Assignment ::= T_IDENT := T_DECIMAL" << endl; }
            ;
WriteStatement : K_WRITE K_LPAREN T_INTEGER K_RPAREN
            { cout << "RULE: WriteStatement ::= WRITE ( T_INTEGER )" << endl;
            }
;
%% //-- EPILOGUE ---------------------------------------------
// Bison error function
int yyerror(const char *p)
{
    cout << "ERROR: In line " << line_num << " with token \'"
    << yytext << "\'" << endl;
    return 0;
}
int main()
{
    int failcode;
    cout << "Hello Flex + Bison" << endl;
    failcode = yyparse();
    
    if (failcode)
        cout << "INVALID!" << endl;
    else
        cout << "CORRECT" << endl;
    return 0;
}