
package org.cdlib.xtf.textIndexer.rewriter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.lucene.analysis.Token;
import org.apache.lucene.analysis.TokenFilter;
import org.apache.lucene.analysis.TokenStream;
import org.cdlib.xtf.util.Normalizer;

/**
 * Aplica regras de reescrita de números a um TokenStream.
 *
 * @author Marcos Fragomeni
 */
public class NumberRewriteFilter extends TokenFilter {

    private static NumberRewriter rewriter = new NumberRewriter();

    public NumberRewriteFilter(TokenStream input) {
        super(input);
    }

    @Override
    public Token next() throws IOException {

        Token t = input.next();

        if (t == null) {
            return null;
        }

        t.setTermText(rewriter.rewrite(t.termText()));

        return t;

    }

}
