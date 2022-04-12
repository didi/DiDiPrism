package com.xiaojuchefu.prism.monitor.handler;

import android.view.View;

public interface IViewContainerHandler {

    boolean handleContainer(View view);

    String getContainerSymbol(View view);

    String getContainerUrl(View view);

}
