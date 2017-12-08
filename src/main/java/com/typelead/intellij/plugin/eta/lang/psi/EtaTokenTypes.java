package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.psi.tree.IElementType;

public interface EtaTokenTypes {

  IElementType ITas = new EtaTokenType("ITas"); // Haskell keywords
  IElementType ITcase = new EtaTokenType("ITcase");
  IElementType ITclass = new EtaTokenType("ITclass");
  IElementType ITdata = new EtaTokenType("ITdata");
  IElementType ITdefault = new EtaTokenType("ITdefault");
  IElementType ITderiving = new EtaTokenType("ITderiving");
  IElementType ITdo = new EtaTokenType("ITdo");
  IElementType ITelse = new EtaTokenType("ITelse");
  IElementType IThiding = new EtaTokenType("IThiding");
  IElementType ITforeign = new EtaTokenType("ITforeign");
  IElementType ITif = new EtaTokenType("ITif");
  IElementType ITimport = new EtaTokenType("ITimport");
  IElementType ITin = new EtaTokenType("ITin");
  IElementType ITinfix = new EtaTokenType("ITinfix");
  IElementType ITinfixl = new EtaTokenType("ITinfixl");
  IElementType ITinfixr = new EtaTokenType("ITinfixr");
  IElementType ITinstance = new EtaTokenType("ITinstance");
  IElementType ITlet = new EtaTokenType("ITlet");
  IElementType ITmodule = new EtaTokenType("ITmodule");
  IElementType ITnewtype = new EtaTokenType("ITnewtype");
  IElementType ITof = new EtaTokenType("ITof");
  IElementType ITqualified = new EtaTokenType("ITqualified");
  IElementType ITthen = new EtaTokenType("ITthen");
  IElementType ITtype = new EtaTokenType("ITtype");
  IElementType ITwhere = new EtaTokenType("ITwhere");

  IElementType ITforall = new EtaTokenType("ITforall"); // GHC extension keywords
  IElementType ITexport = new EtaTokenType("ITexport");
  IElementType ITlabel = new EtaTokenType("ITlabel");
  IElementType ITdynamic = new EtaTokenType("ITdynamic");
  IElementType ITsafe = new EtaTokenType("ITsafe");
  IElementType ITinterruptible = new EtaTokenType("ITinterruptible");
  IElementType ITunsafe = new EtaTokenType("ITunsafe");
  IElementType ITstdcallconv = new EtaTokenType("ITstdcallconv");
  IElementType ITccallconv = new EtaTokenType("ITccallconv");
  IElementType ITcapiconv = new EtaTokenType("ITcapiconv");
  IElementType ITprimcallconv = new EtaTokenType("ITprimcallconv");
  IElementType ITjavascriptcallconv = new EtaTokenType("ITjavascriptcallconv");
  IElementType ITmdo = new EtaTokenType("ITmdo");
  IElementType ITfamily = new EtaTokenType("ITfamily");
  IElementType ITrole = new EtaTokenType("ITrole");
  IElementType ITgroup = new EtaTokenType("ITgroup");
  IElementType ITby = new EtaTokenType("ITby");
  IElementType ITusing = new EtaTokenType("ITusing");
  IElementType ITpattern = new EtaTokenType("ITpattern");
  IElementType ITstatic = new EtaTokenType("ITstatic");

  // Pragmas, see note [Pragma source text] in BasicTypes
  IElementType ITinline_prag = new EtaTokenType("ITinline_prag"); // SourceText InlineSpec RuleMatchInfo
  IElementType ITspec_prag = new EtaTokenType("ITspec_prag"); // SourceText -- SPECIALISE
  IElementType ITspec_inline_prag = new EtaTokenType("ITspec_inline_prag"); // SourceText Bool -- SPECIALISE INLINE (or NOINLINE)
  IElementType ITsource_prag = new EtaTokenType("ITsource_prag"); // SourceText
  IElementType ITrules_prag = new EtaTokenType("ITrules_prag"); // SourceText
  IElementType ITwarning_prag = new EtaTokenType("ITwarning_prag"); // SourceText
  IElementType ITdeprecated_prag = new EtaTokenType("ITdeprecated_prag"); // SourceText
  IElementType ITline_prag = new EtaTokenType("ITline_prag");
  IElementType ITscc_prag = new EtaTokenType("ITscc_prag"); // SourceText
  IElementType ITgenerated_prag = new EtaTokenType("ITgenerated_prag"); // SourceText
  IElementType ITcore_prag = new EtaTokenType("ITcore_prag"); // SourceText -- hdaume: core annotations
  IElementType ITunpack_prag = new EtaTokenType("ITunpack_prag"); // SourceText
  IElementType ITnounpack_prag = new EtaTokenType("ITnounpack_prag"); // SourceText
  IElementType ITann_prag = new EtaTokenType("ITann_prag"); // SourceText
  IElementType ITclose_prag = new EtaTokenType("ITclose_prag");
  IElementType IToptions_prag = new EtaTokenType("IToptions_prag"); // String
  IElementType ITinclude_prag = new EtaTokenType("ITinclude_prag"); // String
  IElementType ITlanguage_prag = new EtaTokenType("ITlanguage_prag");
  IElementType ITvect_prag = new EtaTokenType("ITvect_prag"); // SourceText
  IElementType ITvect_scalar_prag = new EtaTokenType("ITvect_scalar_prag"); // SourceText
  IElementType ITnovect_prag = new EtaTokenType("ITnovect_prag"); // SourceText
  IElementType ITminimal_prag = new EtaTokenType("ITminimal_prag"); // SourceText
  IElementType IToverlappable_prag = new EtaTokenType("IToverlappable_prag"); // SourceText -- instance overlap mode
  IElementType IToverlapping_prag = new EtaTokenType("IToverlapping_prag"); // SourceText -- instance overlap mode
  IElementType IToverlaps_prag = new EtaTokenType("IToverlaps_prag"); // SourceText -- instance overlap mode
  IElementType ITincoherent_prag = new EtaTokenType("ITincoherent_prag"); // SourceText -- instance overlap mode
  IElementType ITctype = new EtaTokenType("ITctype"); // SourceText

  IElementType ITdotdot = new EtaTokenType("ITdotdot"); // reserved symbols
  IElementType ITcolon = new EtaTokenType("ITcolon");
  IElementType ITdcolon = new EtaTokenType("ITdcolon");
  IElementType ITequal = new EtaTokenType("ITequal");
  IElementType ITlam = new EtaTokenType("ITlam");
  IElementType ITlcase = new EtaTokenType("ITlcase");
  IElementType ITvbar = new EtaTokenType("ITvbar");
  IElementType ITlarrow = new EtaTokenType("ITlarrow");
  IElementType ITrarrow = new EtaTokenType("ITrarrow");
  IElementType ITat = new EtaTokenType("ITat");
  IElementType ITtilde = new EtaTokenType("ITtilde");
  IElementType ITtildehsh = new EtaTokenType("ITtildehsh");
  IElementType ITdarrow = new EtaTokenType("ITdarrow");
  IElementType ITminus = new EtaTokenType("ITminus");
  IElementType ITbang = new EtaTokenType("ITbang");
  IElementType ITstar = new EtaTokenType("ITstar");
  IElementType ITdot = new EtaTokenType("ITdot");

  IElementType ITbiglam = new EtaTokenType("ITbiglam"); // GHC-extension symbols

  IElementType ITocurly = new EtaTokenType("ITocurly"); // special symbols
  IElementType ITccurly = new EtaTokenType("ITccurly");
  IElementType ITvocurly = new EtaTokenType("ITvocurly");
  IElementType ITvccurly = new EtaTokenType("ITvccurly");
  IElementType ITobrack = new EtaTokenType("ITobrack");
  IElementType ITopabrack = new EtaTokenType("ITopabrack"); // [:, for parallel arrays with -XParallelArrays
  IElementType ITcpabrack = new EtaTokenType("ITcpabrack"); // :], for parallel arrays with -XParallelArrays
  IElementType ITcbrack = new EtaTokenType("ITcbrack");
  IElementType IToparen = new EtaTokenType("IToparen");
  IElementType ITcparen = new EtaTokenType("ITcparen");
  IElementType IToubxparen = new EtaTokenType("IToubxparen");
  IElementType ITcubxparen = new EtaTokenType("ITcubxparen");
  IElementType ITsemi = new EtaTokenType("ITsemi");
  IElementType ITcomma = new EtaTokenType("ITcomma");
  IElementType ITunderscore = new EtaTokenType("ITunderscore");
  IElementType ITbackquote = new EtaTokenType("ITbackquote");
  IElementType ITsimpleQuote = new EtaTokenType("ITsimpleQuote"); // '

  IElementType ITvarid = new EtaTokenType("ITvarid"); // FastString -- identifiers
  IElementType ITconid = new EtaTokenType("ITconid"); // FastString
  IElementType ITvarsym = new EtaTokenType("ITvarsym"); // FastString
  IElementType ITconsym = new EtaTokenType("ITconsym"); // FastString
  IElementType ITqvarid = new EtaTokenType("ITqvarid"); // (FastString,FastString)
  IElementType ITqconid = new EtaTokenType("ITqconid"); // (FastString,FastString)
  IElementType ITqvarsym = new EtaTokenType("ITqvarsym"); // (FastString,FastString)
  IElementType ITqconsym = new EtaTokenType("ITqconsym"); // (FastString,FastString)
  IElementType ITprefixqvarsym = new EtaTokenType("ITprefixqvarsym"); // (FastString,FastString)
  IElementType ITprefixqconsym = new EtaTokenType("ITprefixqconsym"); // (FastString,FastString)

  IElementType ITdupipvarid = new EtaTokenType("ITdupipvarid"); // FastString -- GHC extension: implicit param: ?x

  IElementType ITchar = new EtaTokenType("ITchar"); // SourceText Char -- Note [Literal source text] in BasicTypes
  IElementType ITstring = new EtaTokenType("ITstring"); // SourceText FastString -- Note [Literal source text] in BasicTypes
  IElementType ITinteger = new EtaTokenType("ITinteger"); // SourceText Integer -- Note [Literal source text] in BasicTypes
  IElementType ITrational = new EtaTokenType("ITrational"); // FractionalLit

  IElementType ITprimchar = new EtaTokenType("ITprimchar"); // SourceText Char -- Note [Literal source text] in BasicTypes
  IElementType ITprimstring = new EtaTokenType("ITprimstring"); // SourceText ByteString -- Note [Literal source text] @BasicTypes
  IElementType ITprimint = new EtaTokenType("ITprimint"); // SourceText Integer -- Note [Literal source text] in BasicTypes
  IElementType ITprimword = new EtaTokenType("ITprimword"); // SourceText Integer -- Note [Literal source text] in BasicTypes
  IElementType ITprimfloat = new EtaTokenType("ITprimfloat"); // FractionalLit
  IElementType ITprimdouble = new EtaTokenType("ITprimdouble"); // FractionalLit

  // Template Haskell extension tokens
  IElementType ITopenExpQuote = new EtaTokenType("ITopenExpQuote"); // [| or [e|
  IElementType ITopenPatQuote = new EtaTokenType("ITopenPatQuote"); // [p|
  IElementType ITopenDecQuote = new EtaTokenType("ITopenDecQuote"); // [d|
  IElementType ITopenTypQuote = new EtaTokenType("ITopenTypQuote"); // [t|
  IElementType ITcloseQuote = new EtaTokenType("ITcloseQuote"); // |]
  IElementType ITopenTExpQuote = new EtaTokenType("ITopenTExpQuote"); // [||
  IElementType ITcloseTExpQuote = new EtaTokenType("ITcloseTExpQuote"); // ||]
  IElementType ITidEscape = new EtaTokenType("ITidEscape"); // FastString $x
  IElementType ITparenEscape = new EtaTokenType("ITparenEscape"); // $(
  IElementType ITidTyEscape = new EtaTokenType("ITidTyEscape"); // FastString $$x
  IElementType ITparenTyEscape = new EtaTokenType("ITparenTyEscape"); // $$(
  IElementType ITtyQuote = new EtaTokenType("ITtyQuote"); // ''
  IElementType ITquasiQuote = new EtaTokenType("ITquasiQuote"); //(FastString,FastString,RealSrcSpan)
  // ITquasiQuote(quoter, quote, loc)
  // represents a quasi-quote of the form
  // [quoter| quote |]
  IElementType ITqQuasiQuote = new EtaTokenType("ITqQuasiQuote"); //(FastString,FastString,FastString,RealSrcSpan)
  // ITqQuasiQuote(Qual, quoter, quote, loc)
  // represents a qualified quasi-quote of the form
  // [Qual.quoter| quote |]

  // Arrow notation extension
  IElementType ITproc = new EtaTokenType("ITproc");
  IElementType ITrec = new EtaTokenType("ITrec");
  IElementType IToparenbar = new EtaTokenType("IToparenbar"); // (|
  IElementType ITcparenbar = new EtaTokenType("ITcparenbar"); // |)
  IElementType ITlarrowtail = new EtaTokenType("ITlarrowtail"); // -<
  IElementType ITrarrowtail = new EtaTokenType("ITrarrowtail"); // >-
  IElementType ITLLarrowtail = new EtaTokenType("ITLLarrowtail"); // -<<
  IElementType ITRRarrowtail = new EtaTokenType("ITRRarrowtail"); // >>-

  IElementType ITunknown = new EtaTokenType("ITunknown"); // String // Used when the lexer can't make sense of it
  IElementType ITeof = new EtaTokenType("ITeof"); // end of file token

  // Documentation annotations
  IElementType ITdocCommentNext = new EtaTokenType("ITdocCommentNext"); // String -- something beginning '-- |'
  IElementType ITdocCommentPrev = new EtaTokenType("ITdocCommentPrev"); // String -- something beginning '-- ^'
  IElementType ITdocCommentNamed = new EtaTokenType("ITdocCommentNamed"); // String -- something beginning '-- $'
  IElementType ITdocSection = new EtaTokenType("ITdocSection"); // Int String -- a section heading
  IElementType ITdocOptions = new EtaTokenType("ITdocOptions"); // String -- doc options (prune, ignore-exports, etc)
  IElementType ITdocOptionsOld = new EtaTokenType("ITdocOptionsOld"); // String -- doc options declared "-- # ..."-style
  IElementType ITlineComment = new EtaTokenType("ITlineComment"); // String -- comment starting by "--"
  IElementType ITblockComment = new EtaTokenType("ITblockComment"); // String -- comment in {- -}
}
