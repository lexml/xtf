
package org.cdlib.xtf.textIndexer.rewriter;

/**
 * Aplica regras de reescrita a uma string.
 *
 * @author Marcos Fragomeni
 */
public class RegexRewriter {

    private RegexRewriteRule[] rules;

    public RegexRewriter(RegexRewriteRule... rules) {
        this.rules = rules;
    }

    public String rewrite(String s) {

        if (s == null) {
            return null;
        }

        for(RegexRewriteRule rule: rules) {
            s = rule.rewrite(s);
        }

        return s;

    }

}
