package com.xiaojuchefu.prism.monitor.model;

public class ViewTag {

    public int tagId;
    public String tagSymbol;
    public boolean append;

    public ViewTag(int tagId, String tagSymbol) {
        this(tagId, tagSymbol, true);
    }

    public ViewTag(int tagId, String tagSymbol, boolean append) {
        this.tagId = tagId;
        this.tagSymbol = tagSymbol;
        this.append = append;
    }

}
