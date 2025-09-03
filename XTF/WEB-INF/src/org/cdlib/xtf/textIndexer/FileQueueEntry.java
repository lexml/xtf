package org.cdlib.xtf.textIndexer;

/// /////////////////////////////////////////////////////////////////////////
class FileQueueEntry {
    public final IndexSource idxSrc;
    public boolean deleteFirst;

    public FileQueueEntry(IndexSource idxSrc, boolean deleteFirst) {
        this.idxSrc = idxSrc;
        this.deleteFirst = deleteFirst;
    }
} // private class FileQueueEntry
