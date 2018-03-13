module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Lexer.AbstractEtaParsingLexer where

import P.Base
import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import FFI.Com.IntelliJ.Psi.Tree (IElementType)

import Data.IORef
import Foreign.StablePtr
import qualified Language.Eta.Parser.Lexer as L

data AbstractEtaParsingLexer = AbstractEtaParsingLexer
  @com.typelead.intellij.plugin.eta.lang.lexer.AbstractEtaParsingLexer
  deriving Class

type instance Inherits AbstractEtaParsingLexer = '[Object, Lexer]

foreign import java unsafe "@field myPStatePtr" getMyPStatePtr
  :: (a <: AbstractEtaParsingLexer) => Java a (StablePtr (IORef L.PState))
foreign import java unsafe "@field myPStatePtr" setMyPStatePtr
  :: (a <: AbstractEtaParsingLexer) => StablePtr (IORef L.PState) -> Java a ()

foreign import java unsafe "@field done" getDone
  :: (a <: AbstractEtaParsingLexer) => Java a Bool
foreign import java unsafe "@field done" setDone
  :: (a <: AbstractEtaParsingLexer) => Bool -> Java a ()

foreign import java unsafe "@field myState" getMyState
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myState" setMyState
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()

foreign import java unsafe "@field myTokenStart" getMyTokenStart
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myTokenStart" setMyTokenStart
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()

foreign import java unsafe "@field myTokenEnd" getMyTokenEnd
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myTokenEnd" setMyTokenEnd
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()

foreign import java unsafe "@field myBuffer" getMyBuffer
  :: (a <: AbstractEtaParsingLexer) => Java a CharSequence
foreign import java unsafe "@field myBuffer" setMyBuffer
  :: (a <: AbstractEtaParsingLexer) => CharSequence -> Java a ()

foreign import java unsafe "@field myBufferEnd" getMyBufferEnd
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myBufferEnd" setMyBufferEnd
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()

foreign import java unsafe "@field myTokenType" getMyTokenType
  :: (a <: AbstractEtaParsingLexer) => Java a IElementType
foreign import java unsafe "@field myTokenType" setMyTokenType
  :: (a <: AbstractEtaParsingLexer) => IElementType -> Java a ()

foreign import java unsafe "@field myNextTokenType" getMyNextTokenType
  :: (a <: AbstractEtaParsingLexer) => Java a IElementType
foreign import java unsafe "@field myNextTokenType" setMyNextTokenType
  :: (a <: AbstractEtaParsingLexer) => IElementType -> Java a ()

foreign import java unsafe "@field myNextTokenStart" getMyNextTokenStart
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myNextTokenStart" setMyNextTokenStart
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()

foreign import java unsafe "@field myNextTokenEnd" getMyNextTokenEnd
  :: (a <: AbstractEtaParsingLexer) => Java a Int
foreign import java unsafe "@field myNextTokenEnd" setMyNextTokenEnd
  :: (a <: AbstractEtaParsingLexer) => Int -> Java a ()
