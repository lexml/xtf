package org.cdlib.xtf.textIndexer.rewriter;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regra de reescrita baseada em expressão regular.
 */
public abstract class RegexRewriteRule {

    private Pattern pattern;

    public RegexRewriteRule(String regex) {
        pattern = Pattern.compile(regex);
    }

    public String rewrite(String s) {
        Matcher m = pattern.matcher(s);
        if(m.matches()) {
            return doRewrite(m);
        }
        return s;
    }

    protected abstract String doRewrite(Matcher m);

}

