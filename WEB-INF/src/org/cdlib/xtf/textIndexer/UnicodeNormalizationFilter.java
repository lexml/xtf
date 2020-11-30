
package org.cdlib.xtf.textIndexer;

import java.io.IOException;

import org.apache.lucene.analysis.Token;
import org.apache.lucene.analysis.TokenFilter;
import org.apache.lucene.analysis.TokenStream;
import org.cdlib.xtf.util.Normalizer;

/**
 * Apply Unicode Normalization to the tokens.
 * 
 * @see java.text.Normalizer
 * 
 * @author Marcos Fragomeni
 */
public class UnicodeNormalizationFilter extends TokenFilter {

    public UnicodeNormalizationFilter(TokenStream input) {
        super(input);
    }

    @Override
    public Token next() throws IOException {

        Token t = input.next();

        if (t == null) {
            return null;
        }

        String normalizedText = Normalizer.normalize(t.termText());
        t.setTermText(normalizedText);

        return t;

    }
}
