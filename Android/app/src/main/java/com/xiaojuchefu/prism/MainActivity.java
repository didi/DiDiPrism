package com.xiaojuchefu.prism;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.eastwood.common.adapter.QuickAdapter;
import com.eastwood.common.adapter.ViewHelper;
import com.xiaojuchefu.prism.monitor.PrismMonitor;
import com.xiaojuchefu.prism.monitor.model.EventData;
import com.xiaojuchefu.prism.playback.PlaybackHelper;
import com.xiaojuchefu.prism.playback.PrismPlayback;
import com.xiaojuchefu.prism.playback.model.EventInfo;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    List<EventData> mPlaybackEvents = new ArrayList<>(100);
    PrismMonitor.OnPrismMonitorListener mOnPrismMonitorListener = new PrismMonitor.OnPrismMonitorListener() {
        @Override
        public void onEvent(EventData eventData) {
            Log.d("onEvent2", eventData.getUnionId());
            mPlaybackEvents.add(eventData);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Button startButton = findViewById(R.id.btn_start);
        final Button stopButton = findViewById(R.id.btn_stop);
        final View playbackLayout = findViewById(R.id.ll_playback);

        startButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPlaybackEvents.clear();
                PrismMonitor.getInstance().start();
                PrismMonitor.getInstance().addOnPrismMonitorListener(mOnPrismMonitorListener);
                startButton.setEnabled(false);
                stopButton.setEnabled(true);
                playbackLayout.setVisibility(View.GONE);

                startActivity(new Intent(MainActivity.this, TestActivity.class));
            }
        });
        stopButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PrismMonitor.getInstance().stop();
                PrismMonitor.getInstance().removeOnPrismMonitorListener(mOnPrismMonitorListener);
                startButton.setEnabled(true);
                stopButton.setEnabled(false);
                playbackLayout.setVisibility(View.VISIBLE);
            }
        });

        findViewById(R.id.btn_playback_text).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showTextPlayback();
            }
        });
        findViewById(R.id.btn_playback_action).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, TestActivity.class));
                playbackLayout.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        PrismPlayback.getInstance().playback(mPlaybackEvents);
                    }
                }, 1000);
            }
        });

    }

    private void showTextPlayback() {
        int count = mPlaybackEvents.size();
        List<EventInfo> eventInfos = new ArrayList<>(count);
        long currentTime = mPlaybackEvents.get(0).eventTime;

        for (int i = 0; i < count; i++) {
            EventData eventData = mPlaybackEvents.get(i);
            EventInfo eventInfo = PlaybackHelper.convertEventInfo(eventData);
            if (eventInfo == null) continue;

            if (eventInfo.eventType == 0) {
                eventInfo.content = PlaybackHelper.getClickInfo(eventInfo);
            } else if (eventInfo.eventType == 1 && eventInfos.size() > 0) {
                EventInfo lastEventInfo = eventInfos.get(eventInfos.size() - 1);
                if (lastEventInfo.eventType == 6) {
                    eventInfo.content = "(返回上级页面)";
                }
            } else if (eventInfo.eventType == 4) {
                if (i + 1 < count) {
                    EventData nextEventData = mPlaybackEvents.get(i + 1);
                    if (nextEventData.eventType == 5) {
                        i++;
                        continue;
                    }
                }

                if (eventInfos.size() > 0) {
                    EventInfo lastEventInfo = eventInfos.get(eventInfos.size() - 1);
                    if (lastEventInfo.eventType == 0) {
                        eventInfo.content = "(页面弹出弹窗)";
                    }
                }
            } else if (eventInfo.eventType == 5 && eventInfos.size() > 0) {
                EventInfo lastEventInfo = eventInfos.get(eventInfos.size() - 1);
                if (lastEventInfo.eventType == 0) {
                    eventInfo.content = "(页面弹窗被关闭)";
                }
            } else if (eventInfo.eventType == 6) {
                String activityName = eventInfo.eventData.get("an");
                if (TextUtils.isEmpty(activityName)) {
                    return;
                }
                eventInfo.content = "跳转至 " + activityName;
            }

            eventInfo.takeTime = eventData.eventTime - currentTime;

            eventInfos.add(eventInfo);
            currentTime = eventData.eventTime;
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("文字回放");
        builder.setView(R.layout.playback_text);
        builder.setNegativeButton("关闭", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });
        AlertDialog alertDialog = builder.create();
        alertDialog.show();

        ListView listView = alertDialog.findViewById(R.id.listview);
        listView.setAdapter(new QuickAdapter<EventInfo>(this, R.layout.playback_text_item, eventInfos) {
            @Override
            protected void convert(int position, ViewHelper helper, EventInfo item) {
                helper.setText(R.id.tv_text_playback_event, item.eventDesc);
                helper.setText(R.id.tv_playback_content_text, item.content);
                helper.setText(R.id.tv_text_playback_time, item.takeTime / 1000 + "' " + item.takeTime % 1000 / 100 + "\"");
            }
        });

    }

}
