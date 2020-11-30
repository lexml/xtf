
package org.cdlib.xtf.textIndexer.rewriter;

import java.util.regex.Matcher;

/**
 * Reescreve números sem separador de milhar ou zeros à esquerda e datas com '/' como separador.
 *
 * @author Marcos Fragomeni
 */
public class NumberRewriter extends RegexRewriter {

    private static final RegexRewriteRule[] rules = {
         // Remove separador de milhar e zeros à esquerda de números
         new RegexRewriteRule("^\\d{1,3}(?:\\.\\d{3})+$|^0+[1-9]\\d*$") {

             @Override
             public String doRewrite(Matcher m) {
                 String ret = m.group().replace(".", "");
                 return NumberRewriter.removeZerosEsquerda(ret);
             }

         },
         // Normaliza datas para dd/mm/aaaa
         new RegexRewriteRule("^(\\d{2})([/.-])(\\d{2})\\2(\\d{4})$") {

             @Override
             public String doRewrite(Matcher m) {
                 return m.group(1) + "/" + m.group(3) + "/" + m.group(4);
             }

         }
    };

    private static String removeZerosEsquerda(String str) {
        int i;
        for(i = 0; i < str.length() && str.charAt(i) == '0'; i++);
        return i == 0? str: str.substring(i);
    }

    public NumberRewriter() {
        super(rules);
    }

//    public static void main(String[] args) {
//        NumberRewriter nr = new NumberRewriter();
//        System.out.println(nr.rewrite("0.002.000"));
//        System.out.println(nr.rewrite("0002000"));
//        System.out.println(nr.rewrite("2000"));
//    }

}
