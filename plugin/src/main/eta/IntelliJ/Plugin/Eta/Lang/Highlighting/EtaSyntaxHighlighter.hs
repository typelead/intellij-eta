module IntelliJ.Plugin.Eta.Lang.Highlighting.EtaSyntaxHighlighter where

import P
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as M

import FFI.Com.IntelliJ.Lexer.Lexer
import FFI.Com.IntelliJ.OpenApi.Editor.Colors.TextAttributesKey
import FFI.Com.IntelliJ.OpenApi.Editor.DefaultLanguageHighlighterColors
import FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighterBase
import FFI.Com.IntelliJ.Psi.Tree.IElementType
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Lexer.EtaSyntaxHighlightingLexer
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Psi.EtaTokenTypes

data {-# CLASS "com.typelead.intellij.eta.lang.highlighting.EtaSyntaxHighlighter" #-}
  EtaSyntaxHighlighter = EtaSyntaxHighlighter (Object# EtaSyntaxHighlighter)
  deriving Class

type instance Inherits EtaSyntaxHighlighter = '[SyntaxHighlighterBase]

foreign import java unsafe "@new" newEtaSyntaxHighlighter :: Java a EtaSyntaxHighlighter

foreign export java getHighlightingLexer :: Java EtaSyntaxHighlighter Lexer
getHighlightingLexer = superCastJ newEtaSyntaxHighlightingLexer

foreign export java getTokenHighlights
  :: IElementType
  -> Java EtaSyntaxHighlighter TextAttributesKeyArray
getTokenHighlights tokenType =
  case maybeFromJava tokenType >>= \t -> M.lookup t keys of
    Nothing -> return emptyTextAttributesKeyArray
    Just x -> arrayFromList [x]

{-# NOINLINE keys #-}
keys :: Map IElementType TextAttributesKey
keys = mkMap
  [ standardKeywords =: kETA_RESERVED_ID
  , reservedSymbols =: kETA_RESERVED_OP
  , [jITobrack, jITcbrack] =: kETA_BRACKETS
  , [jIToparen, jITcparen] =: kETA_PARENTHESES
  , [jITocurly, jITccurly] =: kETA_BRACES
  , [jITstring] =: kETA_STRING
  , pragmas =: kETA_PRAGMA
  , [jITcomma] =: kETA_COMMA
  , [jITsemi] =: kETA_SEMICOLON
  , [jITconid, jITqconid] =: kETA_CONID
  , haddocks =: kETA_HADDOCK
  , [jITinteger] =: kETA_INTEGER
  , [jITrational] =: kETA_FLOAT
  , [jITlineComment, jITblockComment] =: kETA_COMMENT
  , [jITchar] =: kETA_CHAR
  , [jITvarsym, jITqvarsym] =: kETA_VARSYM
  , [jITconsym, jITqconsym] =: kETA_CONSYM
  ]
  where
  mkMap ks = M.fromList $ ks >>= \(ks', v) -> [(k, v) | k <- ks']
  (=:) = (,)

kETA_RESERVED_ID = createTextAttributesKey "ETA_RESERVED_ID" kKEYWORD
kETA_RESERVED_OP = createTextAttributesKey "ETA_RESERVED_OP" kPREDEFINED_SYMBOL
kETA_COMMA = createTextAttributesKey "ETA_COMMA" kCOMMA
kETA_SEMICOLON = createTextAttributesKey "ETA_SEMICOLON" kSEMICOLON
kETA_BRACKETS = createTextAttributesKey "ETA_BRACKETS" kBRACKETS
kETA_PARENTHESES = createTextAttributesKey "ETA_PARENTHESES" kPARENTHESES
kETA_BRACES = createTextAttributesKey "ETA_BRACES" kBRACES
kETA_NESTED_COMMENT = createTextAttributesKey "ETA_NESTED_COMMENT" kBLOCK_COMMENT
kETA_HADDOCK = createTextAttributesKey "ETA_HADDOCK" kDOC_COMMENT
kETA_COMMENT = createTextAttributesKey "ETA_COMMENT" kLINE_COMMENT
kETA_INTEGER = createTextAttributesKey "ETA_INTEGER" kNUMBER
kETA_FLOAT = createTextAttributesKey "ETA_FLOAT" kNUMBER
kETA_CHAR = createTextAttributesKey "ETA_CHAR" kNUMBER
kETA_CONID = createTextAttributesKey "ETA_CONID" kINSTANCE_FIELD
kETA_VARID = createTextAttributesKey "ETA_VARID" kFUNCTION_CALL
kETA_PARAMETER = createTextAttributesKey "ETA_PARAMETER" kPARAMETER
kETA_INFIXVARID = createTextAttributesKey "ETA_INFIXVARID" kFUNCTION_CALL
kETA_VARSYM = createTextAttributesKey "ETA_VARSYM" kOPERATION_SIGN
kETA_CONSYM = createTextAttributesKey "ETA_CONSYM" kPREDEFINED_SYMBOL
kETA_PRAGMA = createTextAttributesKey "ETA_PRAGMA" kMETADATA
kETA_STRING = createTextAttributesKey "ETA_STRING" kSTRING
kETA_QUASIQUOTE = createTextAttributesKey "ETA_QUASIQUOTE" kSTRING
kETA_ESCAPE = createTextAttributesKey "ETA_ESCAPE" kVALID_STRING_ESCAPE

standardKeywords =
  [ jITas
  , jITcase
  , jITclass
  , jITdata
  , jITdefault
  , jITderiving
  , jITdo
  , jITelse
  , jIThiding
  , jITforeign
  , jITif
  , jITimport
  , jITin
  , jITinfix
  , jITinfixl
  , jITinfixr
  , jITinstance
  , jITlet
  , jITmodule
  , jITnewtype
  , jITof
  , jITqualified
  , jITthen
  , jITtype
  , jITwhere
  ]

reservedSymbols =
  [ jITdotdot
  , jITcolon
  , jITdcolon
  , jITequal
  , jITlam
  , jITlcase
  , jITvbar
  , jITlarrow
  , jITrarrow
  , jITat
  , jITtilde
  , jITtildehsh
  , jITdarrow
  , jITminus
  , jITbang
  , jITstar
  , jITdot
  ]

pragmas =
  [ jITinline_prag
  , jITspec_prag
  , jITspec_inline_prag
  , jITsource_prag
  , jITrules_prag
  , jITwarning_prag
  , jITdeprecated_prag
  , jITline_prag
  , jITscc_prag
  , jITgenerated_prag
  , jITcore_prag
  , jITunpack_prag
  , jITnounpack_prag
  , jITann_prag
  , jITclose_prag
  , jIToptions_prag
  , jITinclude_prag
  , jITlanguage_prag
  , jITvect_prag
  , jITvect_scalar_prag
  , jITnovect_prag
  , jITminimal_prag
  , jIToverlappable_prag
  , jIToverlapping_prag
  , jIToverlaps_prag
  , jITincoherent_prag
  , jITctype
  ]

haddocks =
  [ jITdocCommentNext
  , jITdocCommentPrev
  , jITdocCommentNamed
  , jITdocSection
  , jITdocOptions
  , jITdocOptionsOld
  ]
