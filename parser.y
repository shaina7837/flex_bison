%{
/* C++ Declarations */ 
#include <iostream>
#include <fstream>
using namespace std;

extern "C" {
	int yylex ();
	int yyparse ();
}
extern "C" FILE *yyin;
void yyerror(const char *str);

ofstream fout;
char ch;

%}
/*Bison declatation*/
/*
%union is used to declare the types for various tokens used. 
It is particularly used when we need to used more than one type
*/
%union{
	char* txt;
}
/*
tokens declarations of type txt i.e. char* 
*/
%token <txt> BODY
%token <txt> TEXT
%token <txt> SPACE
%token <txt> TAB
%token <txt> NEWLINE
%token <txt> LEFTTAG
%token <txt> RIGHTTAG
%token <txt> PARA
%token <txt> BOLD
%token <txt> ITALIC
%token <txt> LIST
%token <txt> END

%%
html_to_latex: /*empty*/
	| html_to_latex BODY { fout << "\\begin{document}" <<endl; }
	| html_to_latex END { fout << "\\end"; }
	| html_to_latex PARA { fout << "\\section "; }
	| html_to_latex BOLD { fout << "\\bf "; }
	| html_to_latex ITALIC { fout << "\\it "; }
	| html_to_latex LIST { fout << "\\item "; }
	| html_to_latex LEFTTAG { fout << "{ "; }
	| html_to_latex RIGHTTAG { fout << ""; }
	| html_to_latex TEXT {fout << $<txt>1 << $<txt>2; } 
	| html_to_latex SPACE { fout << " "; }
	| html_to_latex NEWLINE { fout << "\n"; } 
/* Grammar Rules */
	
%%

void yyerror(const char *str) /*definition of functions returning error*/
{
	cout << "Error:" << str << endl;
	exit(-1);
}

int main(int argc, char **argv) /*definition of main function */
{
	if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) { /*open the first argument file and put it in yyin FILE variable */
                perror(argv[1]);
                return (1);
        }
  }

  fout.open("output.tex", ofstream::out | ofstream::trunc); /* create a output file output.tex and 
  put the resultant code into it */
  
  while(!feof(yyin)) /*until input file doesn't end */
  {
      yyparse(); /*keep on calling above grammar rules */
  }
  fout.close(); /* close the output file */
}


