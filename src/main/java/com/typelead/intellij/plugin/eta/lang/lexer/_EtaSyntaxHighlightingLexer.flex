package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.*;
import com.intellij.psi.tree.IElementType;
import static com.intellij.psi.TokenType.*;
import com.intellij.util.containers.ContainerUtil;
import com.intellij.util.containers.Stack;
import static com.typelead.intellij.plugin.eta.lang.psi.EtaTokenTypes.*;

/**
 * Adapted from the HaskForce syntax highlighting lexer.
 * https://github.com/carymrobbins/intellij-haskforce/blob/b56877753775ee13db9474a59c183f47d5ab8ead/src/com/haskforce/highlighting/_HaskellSyntaxHighlightingLexer.flex
 *
 * Use `./gradlew runJFlex` from the command line to generate this lexer.
 */


%%

%{
  private int commentLevel;
  private int qqLevel;
  private int indent;
  private Stack<Integer> stateStack = ContainerUtil.newStack();
  private int yychar;
  // Shared varsym token to ensure that shebang lex failures return the same
  // token as normal varsyms.
  public static final IElementType SHARED_VARSYM_TOKEN = ITvarsym;
  public _EtaSyntaxHighlightingLexer() {
    this((java.io.Reader)null);
  }
%}

/*
 * Missing lexemes: by, haddock things.
 *
 * Comments: one line too many in dashes-comments.
 */

%public
%class _EtaSyntaxHighlightingLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%char
%eof{  return;
%eof}

EOL=\r|\n|\r\n
LINE_WS=[\ \t\f]
WHITE_SPACE=({LINE_WS}|{EOL})+

VARIDREGEXP=([a-z_][a-zA-Z_0-9']+(\.[a-zA-Z_0-9']*)*)|[a-z]|[A-Z][a-zA-Z_0-9']*(\.[A-Z][a-zA-Z_0-9']*)*\.[a-z][a-zA-Z_0-9']*
// Unlike HaskellParsingLexer, we don't lex the unit type () as a CONID.
// The reason is that brace matching breaks.  The HaskellAnnotator takes care
// of the appropriate highlighting for unit type ().
CONID=[A-Z][a-zA-Z_0-9']*(\.[A-Z][a-zA-Z_0-9']*)*
INFIXVARID=`[a-zA-Z_0-9][a-zA-Z_0-9'.]*`
CHARTOKEN='(\\.|[^'])'#?
INTEGERTOKEN=(0(o|O)[0-7]+|0(x|X)[0-9a-fA-F]+|[0-9]+)#?#?
FLOATTOKEN=([0-9]+\.[0-9]+((e|E)(\+|\-)?[0-9]+)?|[0-9]+((e|E)(\+|\-)?[0-9]+))#?#?
COMMENT=--([^\!\#\$\%\&\*\+\.\/\<\=\>\?\@\\\^\|\~\:\r\n][^\r\n]*\n?|[\r\n])
HADDOCK=--\ [\^\|]([^\r\n]*\n?|[\r\n])
CPPIF=#(if|elif|else|endif|define|ifdef|undef|include|pragma)([^\r\n]*)
// Unicode syntax also supported: https://www.haskell.org/ghc/docs/7.2.1/html/users_guide/syntax-extns.html
ASCSYMBOL=[\!\#\$\%\&\*\+\.\/\<\=\>\?\@\\\^\|\-\~\:↢↣⤛⤜★]

STRINGGAP=\\[ \t\n\x0B\f\r]*\n[ \t\n\x0B\f\r]*\\
MAYBEQVARID=({CONID}\.)*{VARIDREGEXP}

// Avoid "COMMENT" since that collides with the token definition above.
%state INCOMMENT, INSTRING, INPRAGMA, INQUASIQUOTE, INQUASIQUOTEHEAD, INSHEBANG

%%
<YYINITIAL> {
  "#!"                {
                        if (yychar == 0) {
                            yybegin(INSHEBANG);
                            return ITlineComment;
                        }
                        return SHARED_VARSYM_TOKEN;
                      }
  {WHITE_SPACE}       { return WHITE_SPACE; }

  "class"             { return ITclass; }
  "data"              { return ITdata; }
  "default"           { return ITdefault; }
  "deriving"          { return ITderiving; }
  "export"            { return ITexport; }
  "foreign"           { return ITforeign; }
  "instance"          { return ITinstance; }
  "family"            { return ITfamily; }
  "module"            { return ITmodule; }
  "newtype"           { return ITnewtype; }
  "type"              { return ITtype; }
  "where"             { return ITwhere; }
  "as"                { return ITas; }
  "import"            { return ITimport; }
  "infix"             { return ITinfix; }
  "infixl"            { return ITinfixl; }
  "infixr"            { return ITinfixr; }
  "qualified"         { return ITqualified; }
  "hiding"            { return IThiding; }
  "case"              { return ITcase; }
  "mdo"               { return ITmdo; }
  "do"                { return ITdo; }
  "rec"               { return ITrec; }
  "else"              { return ITelse; }
  "#else"             { return ITlineComment; } // TODO: highlighting cpp as comment
  "#endif"            { return ITlineComment; } // TODO: highlighting cpp as comment
  "if"                { return ITif; }
  "in"                { return ITin; }
  "let"               { return ITlet; }
  "of"                { return ITof; }
  "then"              { return ITthen; }
  ("forall"|"∀")      { return ITforall; }

  "\\&"               { return BAD_CHARACTER; } // TODO: what is this?
  "(#"                { return IToubxparen; }
  "#)"                { return ITcubxparen; }
  "("                 { return IToparen; }
  ")"                 { return ITcparen; }
  "|"                 { return ITvbar; }
  ","                 { return ITcomma; }
  ";"                 { return ITsemi; }
  "[|"                { return ITopenExpQuote; }
  ("["{MAYBEQVARID}"|") {
                            yypushback(yytext().length() - 1);
                            qqLevel++;
                            stateStack.push(YYINITIAL);
                            yybegin(INQUASIQUOTEHEAD);
                            return ITopenExpQuote;
                        }
  "|]"                { return ITcloseQuote; }
  "["                 { return ITobrack; }
  "]"                 { return ITcbrack; }
  "''"                { return ITtyQuote; }
  "`"                 { return ITbackquote; }
  "\""                {
                        yybegin(INSTRING);
                        return ITstring;
                      }
  "{-#"               {
                        yybegin(INPRAGMA);
                        return ITinline_prag; // TODO: all pragmas as inline?
                      }
  "{-"                {
                        commentLevel = 1;
                        yybegin(INCOMMENT);
                        return ITblockComment;
                      }
  "{"                 { return ITocurly; }
  "}"                 { return ITccurly; }
  "'"                 { return ITsimpleQuote; }
  "$("                { return ITparenEscape; }
  ("$"{VARIDREGEXP})  { return ITidEscape; }
  "_"                 { return ITunderscore; }
  ".."                { return ITdotdot; }
  ":"                 { return ITcolon; }
  ("::"|"∷")          { return ITdcolon; }
  "="                 { return ITequal; }
  "\\"                { return ITvarsym; } // TODO: highlight as a regular varsym?
  ("<-"|"←")          { return ITlarrow; }
  ("->"|"→")          { return ITrarrow; }
  "@"                 { return ITat; }
  "~"                 { return ITtilde; }
  ("=>"|"⇒")          { return ITdarrow; }
  (":"{ASCSYMBOL}+)   { return ITconsym; }
  ({ASCSYMBOL}+)      { return SHARED_VARSYM_TOKEN; }

  {VARIDREGEXP}       { return ITvarid; }
  {CONID}             { return ITconid; }
  {INFIXVARID}        { return ITvarid; }
  {CHARTOKEN}         { return ITchar; }
  {INTEGERTOKEN}      { return ITinteger; }
  {FLOATTOKEN}        { return ITrational; }
  {HADDOCK}           { return ITblockComment; } // TODO: more work for ITdocComment*
  {COMMENT}           { return ITlineComment; }
  {CPPIF}             { return ITlineComment; } // TODO: highlighting cpp as comment

  [^] { return BAD_CHARACTER; }
}

<INSHEBANG> {
  [^\n\r]+  { yybegin(YYINITIAL); return ITlineComment; } // TODO: shebang as comment
  [\n\r]    { yybegin(YYINITIAL); return WHITE_SPACE; }
}

<INCOMMENT> {
    "-}"              {
                        commentLevel--;
                        if (commentLevel == 0) {
                            yybegin(YYINITIAL);
                            return ITblockComment;
                        }
                        return ITblockComment;
                      }

    "{-"              {
                        commentLevel++;
                        return ITblockComment;
                      }

    [^-{}]+           { return ITblockComment; }
    [^]               { return ITblockComment; }
}

<INSTRING> {
    \"                              {
                                        yybegin(YYINITIAL);
                                        return ITstring;
                                    }
    \\(\\|{EOL}|[a-z0-9])           { return ITstring; }
    ({STRINGGAP}|\\\"|[^\"\\\n])+   { return ITstring; }

    [^]                             { return BAD_CHARACTER; }
}

<INPRAGMA> {
    "#-}"           {
                        yybegin(YYINITIAL);
                        return ITline_prag; // TODO: all as line pragmas?
                    }
    [^-}#]+         { return ITline_prag; }
    [^]             { return ITline_prag; }
}

<INQUASIQUOTE> {
    "|]"                    {
                                qqLevel--;
                                yybegin(stateStack.pop());
                                if (qqLevel == 0) {
                                    return ITcloseQuote;
                                }
                                return ITquasiQuote; // TODO: will this work for qqtext?
                            }

    ("["{MAYBEQVARID}"|")   {
                                yypushback(yytext().length() - 1);
                                qqLevel++;
                                stateStack.push(INQUASIQUOTE);
                                yybegin(INQUASIQUOTEHEAD);
                                return ITquasiQuote; // TODO: will this work for qqtext?
                            }
    [^|\]\[]+               { return ITquasiQuote; } // TODO: will this work for qqtext?
    [^]                     { return ITquasiQuote; } // TODO: will this work for qqtext?
}

<INQUASIQUOTEHEAD> {
  "|"                       {
                                yybegin(INQUASIQUOTE);
                                return ITvbar;
                            }
  {VARIDREGEXP}             { return ITvarid; }
  {CONID}                   { return ITconid; }
  "."                       { return ITdot;}
  {EOL}+                    {
                                indent = 0;
                                return WHITE_SPACE;
                            }
  [\ \f\t]+                 { return WHITE_SPACE; }
  [^]                       { return BAD_CHARACTER; }
}
