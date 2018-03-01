package com.typelead.intellij.utils.parser;

import com.intellij.lang.ASTNode;
import com.intellij.lang.PsiBuilder;
import com.intellij.lang.PsiParser;
import com.intellij.psi.tree.IElementType;
import org.jetbrains.annotations.NotNull;

/**
 * Simple parser which returns a flat tree tokens from the lexer.
 * Useful for providing a stub parser for languages which don't need a parse tree.
 */
public class SimplePsiParser implements PsiParser {
    @NotNull
    @Override
    public ASTNode parse(@NotNull IElementType root, @NotNull PsiBuilder builder) {
        PsiBuilder.Marker marker = builder.mark();
        while (!builder.eof()) {
            builder.advanceLexer();
        }
        marker.done(root);
        return builder.getTreeBuilt();
    }
}
