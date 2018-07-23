module IntelliJ.Plugin.Util.ParserBuilder where

import P

import Control.Monad.Reader.Class (MonadReader, ask)
import Control.Monad.Trans.Reader (ReaderT(..))

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Psi.Tree.IElementType

-- | Wrapper around IntelliJ's PsiBuilder for building Monadic parsers.
newtype Psi s a = Psi { unPsi :: ReaderT PsiBuilder (Java s) a }
  deriving
    ( Functor
    , Applicative
    , Monad
    , MonadReader PsiBuilder
    )

evalPsi :: PsiBuilder -> Psi s a -> Java s a
evalPsi b (Psi (ReaderT f)) = f b

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

markDone :: (a <: IElementType) => a -> Psi s (MarkResult, ())
markDone el = return (MarkDone $ superCast el, ())

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

getTokenType :: Psi s (Maybe IElementType)
getTokenType = calling psiBuilderGetTokenType

withTokenType :: (IElementType -> Psi s ()) -> Psi s ()
withTokenType f = getTokenType >>= \case
  Just el -> f el
  Nothing -> builderError "Unexpected end of input"

expectTokenAdvance :: IElementType -> Psi s ()
expectTokenAdvance el = withTokenType $ \t ->
  if t == el then advanceLexer else builderError $ "Expected " <> toStringJava el

expectTokenOneOfAdvance :: [IElementType] -> Psi s ()
expectTokenOneOfAdvance els = getTokenType >>= \case
  Nothing -> builderError msg
  Just el -> if el `elem` els then advanceLexer else builderError msg
  where
  msg = "Expected one of " <> (fold $ intersperse ", " $ map toStringJava els)

expectAdvance :: Psi s Bool -> JString -> Psi s ()
expectAdvance p msg = do
  x <- p
  when (not x) $ builderError msg
  advanceLexer
  return ()

maybeTokenAdvance :: IElementType -> Psi s Bool
maybeTokenAdvance el = getTokenType >>= \case
  Just t -> if t == el then advanceLexer >> return True else return False
  Nothing -> return False

maybeTokenOneOfAdvance :: [IElementType] -> Psi s Bool
maybeTokenOneOfAdvance els = getTokenType >>= \case
  Just t -> if t `elem` els then advanceLexer >> return True else return False
  Nothing -> return False

maybeAdvance :: Psi s Bool -> Psi s Bool
maybeAdvance p = do
  r <- p
  when r advanceLexer
  return r

advanceWhile :: Psi s Bool -> Psi s () -> Psi s ()
advanceWhile p b = whileM_ matched $ b >> advanceLexer
  where
  matched = do
    eof <- isEOF
    x <- p
    return $ not eof && x

whenTokenIs :: (IElementType -> Bool) -> Psi s () -> Psi s ()
whenTokenIs p b = withTokenType $ \el -> when (p el) b

builderError :: JString -> Psi s ()
builderError msg = calling $ psiBuilderError msg

consumeUntilEOF = advanceWhile (return True) $ return ()

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

foreign import java unsafe "@interface getProject" psiBuilderGetProject :: Java PsiBuilder Project

instance GetProject PsiBuilder where
  getProject = psiBuilderGetProject

foreign import java unsafe "@interface advanceLexer" psiBuilderAdvanceLexer :: Java PsiBuilder ()

foreign import java unsafe "@interface getTokenType" psiBuilderGetTokenType :: Java PsiBuilder (Maybe IElementType)

foreign import java unsafe "@interface lookAhead" psiBuilderLookAhead :: Int -> Java PsiBuilder IElementType

foreign import java unsafe "@interface remapCurrentToken" psiBuilderRemapCurrentToken :: IElementType -> Java PsiBuilder ()

foreign import java unsafe "@interface mark" psiBuilderMark :: Java PsiBuilder Marker

foreign import java unsafe "@interface error" psiBuilderError :: JString -> Java PsiBuilder ()

foreign import java unsafe "@interface eof" psiBuilderEof :: Java PsiBuilder Bool

foreign import java unsafe "@interface getTreeBuilt" psiBuilderGetTreeBuilt :: Java PsiBuilder ASTNode

data Marker = Marker
  @com.intellij.lang.PsiBuilder$Marker
  deriving Class

type instance Inherits Marker = '[Object]

foreign import java unsafe "@interface done" markerDone :: IElementType -> Java Marker ()

foreign import java unsafe "@interface collapse" markerCollapse :: IElementType -> Java Marker ()

foreign import java unsafe "@interface error" markerError :: JString -> Java Marker ()
