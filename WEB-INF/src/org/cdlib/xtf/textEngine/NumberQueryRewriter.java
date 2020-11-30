package org.cdlib.xtf.textEngine;


import java.util.Set;

import org.apache.lucene.index.Term;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.spans.SpanTermQuery;
import org.cdlib.xtf.textIndexer.rewriter.NumberRewriter;

/**
 * Reescreve em uma query lucene números sem separador de milhar ou zeros à esquerda e datas com '/' como separador.
 *
 * @author Marcos Fragomeni
 */
public class NumberQueryRewriter extends XtfQueryRewriter
{
  private NumberRewriter numberRewriter = new NumberRewriter();
  private Set tokenizedFields;

  /** Construct a new rewriter to use the given map  */
  public NumberQueryRewriter(Set tokFields) {
    this.tokenizedFields = tokFields;
  }

  /**
   * Rewrite a term query. This is only called for artificial queries
   * introduced by XTF system itself, and therefore we don't map here.
   */
  protected Query rewrite(TermQuery q) {
    return q;
  }

  /**
   * Rewrite a span term query. Maps plural words to singular, but only
   * for tokenized fields.
   *
   * @param q  The query to rewrite
   * @return   Rewritten version, or 'q' unchanged if no changed needed.
   */
  protected Query rewrite(SpanTermQuery q)
  {
    if(!tokenizedFields.contains(q.getField())) {
        return q;
    }
    Term t = q.getTerm();
    Term newTerm = new Term(t.field(), numberRewriter.rewrite(t.text()));
    return copyBoost(q, new SpanTermQuery(newTerm, q.getTermLength()));
  }
} // class PluralFoldingRewriter
