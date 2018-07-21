module IntelliJ.Plugin.Util.ParserBuilder where

import P

import Control.Monad.Reader.Class (MonadReader, ask)
import Control.Monad.Trans.Reader (ReaderT(..))

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Psi.Tree.IElementType

-- | Wrapper around IntelliJ's PsiBuilder for building Monadic parsers.
newtype Psi s a = Psi { runPsi :: ReaderT PsiBuilder (Java s) a }
  deriving
    ( Functor
    , Applicative
    , Monad
    , MonadReader PsiBuilder
    )

data MarkResult
  = MarkDone IElementType
  | MarkCollapse IElementType
  | MarkError JString

calling :: Java PsiBuilder a -> Psi s a
calling m = do
  b <- ask
  liftJava $ b <.> m

liftJava :: Java s a -> Psi s a
liftJava j = Psi $ ReaderT $ const j

markStart :: Psi s (MarkResult, a) -> Psi s a
markStart p = do
  marker <- calling psiBuilderMark
  (markRes, parseRes) <- p
  liftJava $ case markRes of
    MarkDone el     -> marker <.> markerDone el
    MarkCollapse el -> marker <.> markerCollapse el
    MarkError msg   -> marker <.> markerError msg
  return parseRes

markDone :: IElementType -> Psi s (MarkResult, ())
markDone el = return (MarkDone el, ())

markError :: JString -> Psi s (MarkResult, ())
markError msg = return (MarkError msg, ())

lookAhead :: Int -> Psi s IElementType
lookAhead n = calling $ psiBuilderLookAhead n

getTreeBuilt :: Psi s ASTNode
getTreeBuilt = calling psiBuilderGetTreeBuilt

isEOF :: Psi s Bool
isEOF = calling psiBuilderEof

advanceLexer :: Psi s ()
advanceLexer = calling psiBuilderAdvanceLexer

remapAdvance :: IElementType -> Psi s ()
remapAdvance el = calling (psiBuilderRemapCurrentToken el) >> advanceLexer

getTokenType :: Psi s IElementType
getTokenType = calling psiBuilderGetTokenType

expectTokenAdvance :: IElementType -> Psi s Bool
expectTokenAdvance el = expectAdvance ((el ==) <$> getTokenType) $ "Expected " <> toStringJava el

expectAdvance :: Psi s Bool -> JString -> Psi s Bool
expectAdvance p msg = do
  x <- p
  when (not x) $ builderError msg
  advanceLexer
  return x

advanceWhile :: Psi s Bool -> Psi s () -> Psi s ()
advanceWhile p b = whileM_ matched $ b >> advanceLexer
  where
  matched = do
    eof <- isEOF
    x <- p
    return $ not eof && x

whenTokenIs :: (IElementType -> Bool) -> Psi s () -> Psi s ()
whenTokenIs p b = do
  el <- getTokenType
  when (p el) b

builderError :: JString -> Psi s ()
builderError msg = calling $ psiBuilderError msg

whileM_ :: Monad m => m Bool -> m a -> m ()
whileM_ p f = go
  where
  go = do
    x <- p
    if x then f >> go else return ()

---------
-- FFI --
---------

data PsiBuilder = PsiBuilder
  @com.intellij.lang.PsiBuilder
  deriving Class

type instance Inherits PsiBuilder = '[Object]

foreign import java unsafe "getProject" psiBuilderGetProject :: Java PsiBuilder Project

instance GetProject PsiBuilder where
  getProject = psiBuilderGetProject

foreign import java unsafe "advanceLexer" psiBuilderAdvanceLexer :: Java PsiBuilder ()

foreign import java unsafe "getTokenType" psiBuilderGetTokenType :: Java PsiBuilder IElementType

foreign import java unsafe "lookAhead" psiBuilderLookAhead :: Int -> Java PsiBuilder IElementType

foreign import java unsafe "remapCurrentToken" psiBuilderRemapCurrentToken :: IElementType -> Java PsiBuilder ()

foreign import java unsafe "mark" psiBuilderMark :: Java PsiBuilder Marker

foreign import java unsafe "error" psiBuilderError :: JString -> Java PsiBuilder ()

foreign import java unsafe "eof" psiBuilderEof :: Java PsiBuilder Bool

foreign import java unsafe "getTreeBuilt" psiBuilderGetTreeBuilt :: Java PsiBuilder ASTNode

data Marker = Marker
  @com.intellij.lang.PsiBuilder.Marker
  deriving Class

type instance Inherits Marker = '[Object]

foreign import java unsafe "done" markerDone :: IElementType -> Java Marker ()

foreign import java unsafe "collapse" markerCollapse :: IElementType -> Java Marker ()

foreign import java unsafe "error" markerError :: JString -> Java Marker ()
