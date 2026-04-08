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
%token K_IF
%token K_THEN
%token K_ELSE
%token K_WHILE
%token K_END
%token K_DO

%token OP_ASSIGN
%token OP_NEG
%token OP_RELATION
%token OP_ADD
%token OP_MULT

%token T_IDENT
%token T_INTEGER
%token T_DECIMAL
%token T_STRING

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
        | IfStatement
            { cout << "RULE: Statement ::= IfStatement" << endl; }
        | WhileStatement
            { cout << "RULE: Statement ::= WhileStatement" << endl; }
        ;
Assignment : T_IDENT OP_ASSIGN Expression
            { cout << "RULE: Assignment ::= identifier := Expression" << endl; }
        ;
WriteStatement : K_WRITE K_LPAREN Expression K_RPAREN
            { cout << "RULE: WriteStatement ::= WRITE ( Expression )" << endl; }
        ;

IfStatement : K_IF Expression K_THEN StatementSequence K_ELSE StatementSequence K_END
            { cout << "RULE: IfStatement ::= IF Expression THEN StatementSequence ELSE StatementSequence END" << endl; }
        | K_IF Expression K_THEN StatementSequence K_END
            { cout << "RULE: IfStatement ::= IF Expression THEN StatementSequence END" << endl; }
        ;
        
WhileStatement : K_WHILE Expression K_DO StatementSequence K_END
            { cout << "RULE: WhileStatement ::= WHILE Expression DO StatementSequence END" << endl; }
        ;

Expression : SimpleExpression
            { cout << "RULE: Expression ::= SimpleExpression" << endl; }
        | SimpleExpression OP_RELATION Expression
            { cout << "RULE: Expression ::= SimpleExpression OP_RELATION Expression" << endl; }
        ;

SimpleExpression : Term
            { cout << "RULE: SimpleExpression ::= Term" << endl; }
        | Term OP_ADD SimpleExpression
            { cout << "RULE: SimpleExpression ::= Term OP_ADD SimpleExpression" << endl; }
        ;

Term : Factor
            { cout << "RULE: Term ::= Factor" << endl; }
        | Factor OP_MULT Term
            { cout << "RULE: Term ::= Factor OP_MULT Term" << endl; }
        ;

Factor : T_INTEGER
            { cout << "RULE: Factor ::= T_INTEGER" << endl; }
        | T_DECIMAL
            { cout << "RULE: Factor ::= T_DECIMAL" << endl; }
        | T_STRING
            { cout << "RULE: Factor ::= T_STRING" << endl; }
        | T_IDENT
            { cout << "RULE: Factor ::= T_IDENT" << endl; }
        | K_LPAREN Expression K_RPAREN
            { cout << "RULE: Factor ::= ( Expression )" << endl; }
        | OP_NEG Factor
            { cout << "RULE: Factor ::= ~ Factor" << endl; }
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
    failcode = yyparse();
    
    if (failcode)
        cout << "INVALID!" << endl;
    else
        cout << "VALID" << endl;
    return 0;
}