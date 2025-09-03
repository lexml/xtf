package org.cdlib.xtf.textIndexer;

/// /////////////////////////////////////////////////////////////////////////
public class MetaField implements Cloneable {
    public final String name;
    public String value;
    public final boolean store;
    public final boolean index;
    public boolean tokenize;
    public final boolean isFacet;
    public final boolean spell;
    public final float wordBoost;

    public MetaField(String name, boolean store, boolean index,
                     boolean tokenize, boolean isFacet, boolean spell,
                     float wordBoost) {
        this.name = name;
        this.store = store;
        this.index = index;
        this.tokenize = tokenize;
        this.isFacet = isFacet;
        this.spell = spell;
        this.wordBoost = wordBoost;
    }

    // Creates an exact copy of this field and its value.
    public Object clone() {
        try {
            return super.clone();
        } catch (CloneNotSupportedException e) {
            throw new RuntimeException(e);
        }
    } // clone()
} // private class MetaField
