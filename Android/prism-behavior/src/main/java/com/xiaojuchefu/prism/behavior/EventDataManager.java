package com.xiaojuchefu.prism.behavior;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.xiaojuchefu.prism.monitor.PrismConstants;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Set;

public class EventDataManager {

    private final static String SP_PRISM_BEHAVIOR_DAILY_KEY = "prism_behavior_daily_key";
    private final static String SP_PRISM_BEHAVIOR_DAILY_DATA = "prism_behavior_daily_data";

    private static EventDataManager sEventDataManager;
    SharedPreferences mDailyKey;
    SharedPreferences.Editor mDailyKeyEditor;
    SharedPreferences mDailyData;
    SharedPreferences.Editor mDailyDataEditor;
    private long mCurrentDayTime;
    private List<BehaviorData> mEventDataList = new ArrayList<>();
    private WeakReference<Activity> mMainActivity;

    private EventDataManager() {
    }

    public static EventDataManager getInstance() {
        if (sEventDataManager == null) {
            synchronized (EventDataManager.class) {
                if (sEventDataManager == null) {
                    sEventDataManager = new EventDataManager();
                }
            }
        }
        return sEventDataManager;
    }

    public void init(Context context) {
        Application application = (Application) context.getApplicationContext();
        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

            }

            @Override
            public void onActivityStarted(@NonNull Activity activity) {

            }

            @Override
            public void onActivityResumed(@NonNull Activity activity) {
                mMainActivity = new WeakReference<>(activity);
            }

            @Override
            public void onActivityPaused(@NonNull Activity activity) {

            }

            @Override
            public void onActivityStopped(@NonNull Activity activity) {

            }

            @Override
            public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

            }

            @Override
            public void onActivityDestroyed(@NonNull Activity activity) {
                if (mMainActivity != null && mMainActivity.get() == activity) {
                    Log.d("PrismBehavior", "mainActivity destroyed.");
                    saveData(mCurrentDayTime);
                }
            }
        });
        mCurrentDayTime = getDayTime(System.currentTimeMillis());

        mDailyKey = context.getSharedPreferences(SP_PRISM_BEHAVIOR_DAILY_KEY, Context.MODE_PRIVATE);
        mDailyKeyEditor = mDailyKey.edit();
        mDailyData = context.getSharedPreferences(SP_PRISM_BEHAVIOR_DAILY_DATA, Context.MODE_PRIVATE);
        mDailyDataEditor = mDailyData.edit();
    }

    public void onEvent(BehaviorData behaviorData) {
        long dayTime = getDayTime(behaviorData.eventTime);
        if (dayTime == 0) {
            return;
        }

        if (dayTime != mCurrentDayTime) {
            saveData(dayTime);
            mCurrentDayTime = dayTime;
        }

        mEventDataList.add(behaviorData);

        if (behaviorData.eventType == PrismConstants.Event.BACKGROUND) {
            saveData(dayTime);
        }
    }

    public void saveData() {
        saveData(mCurrentDayTime);
    }

    private void saveData(long dayTime) {
        if (mEventDataList.isEmpty()) {
            return;
        }

        String currentDayTimeKeyData = mDailyKey.getString(String.valueOf(mCurrentDayTime), "[]");
        String[] currentDayTimeKeyItems = GsonUtils.fromJson(currentDayTimeKeyData, String[].class);
        String nextDayTimeKey = String.valueOf(System.currentTimeMillis());
        mDailyDataEditor.putString(nextDayTimeKey, eventDataToString(mEventDataList));
        if (currentDayTimeKeyItems.length > 0) {
            currentDayTimeKeyItems = Arrays.copyOf(currentDayTimeKeyItems, currentDayTimeKeyItems.length + 1);
            currentDayTimeKeyItems[currentDayTimeKeyItems.length - 1] = nextDayTimeKey;
        } else {
            currentDayTimeKeyItems = new String[]{nextDayTimeKey};
        }
        mDailyKeyEditor.putString(String.valueOf(mCurrentDayTime), GsonUtils.toJson(currentDayTimeKeyItems));

        if (dayTime != mCurrentDayTime) {
            Set<String> allKey = mDailyKey.getAll().keySet();
            for (String key : allKey) {
                long keyTime = Long.parseLong(key);
                if (keyTime + 86400000L * 30 < mCurrentDayTime) {
                    String dayTimeKeyData = mDailyKey.getString(key, "[]");
                    String[] dayTimeKeyItems = GsonUtils.fromJson(dayTimeKeyData, String[].class);
                    for (String dayTimeKey : dayTimeKeyItems) {
                        mDailyDataEditor.remove(dayTimeKey);
                    }
                    mDailyKeyEditor.remove(key);
                }
            }
            mCurrentDayTime = dayTime;
        }

        mDailyKeyEditor.commit();
        mDailyDataEditor.commit();
        mEventDataList.clear();
    }

    public List<String> getEventDataList(long fromTime) {
        long fromDayTime = getDayTime(fromTime);
        Set<String> keySet = mDailyKey.getAll().keySet();
        ArrayList<Long> dayTimes = new ArrayList<>(keySet.size());
        for (String key : keySet) {
            Long dayTime = Long.valueOf(key);
            if (dayTime >= fromDayTime) {
                dayTimes.add(dayTime);
            }
        }
        Long[] temp = dayTimes.toArray(new Long[dayTimes.size()]);
        Arrays.sort(temp, new Comparator<Long>() {
            @Override
            public int compare(Long o1, Long o2) {
                if (o1 > o2) {
                    return 1;
                } else if (o1 < o2) {
                    return -1;
                } else {
                    return 0;
                }
            }
        });

        List<String> eventDataList = new ArrayList<>();

        for (Long dayTime : temp) {
            String dayTimeKeyData = mDailyKey.getString(dayTime.toString(), "[]");
            String[] dayTimeKeyItems = GsonUtils.fromJson(dayTimeKeyData, String[].class);
            for (String keyItem : dayTimeKeyItems) {
                if(Long.parseLong(keyItem) >= fromTime) {
                    String json = mDailyData.getString(keyItem, "[]");
                    List<String> data = GsonUtils.fromJsonArray(json, String.class);
                    eventDataList.addAll(data);
                }
            }
        }

        return eventDataList;
    }

    public static long getDayTime(long eventTime) {
        try {
            Date date = new Date(eventTime);
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            date = simpleDateFormat.parse(simpleDateFormat.format(date));
            return date.getTime();
        } catch (Exception e) {
            return 0;
        }
    }

    public long getEarliestDayTime() {
        long earliestDayTime = Long.MAX_VALUE;
        Set<String> keySet = mDailyKey.getAll().keySet();
        for (String key : keySet) {
            long dayTime = Long.valueOf(key);
            if (dayTime < earliestDayTime) {
                earliestDayTime = dayTime;
            }
        }
        return earliestDayTime;
    }

    private String eventDataToString(List<BehaviorData> behaviorDataList) {
        String[] stringBuilder = new String[behaviorDataList.size()];
        for (int i = 0; i < behaviorDataList.size(); i++) {
            BehaviorData behaviorData = behaviorDataList.get(i);
            stringBuilder[i] = behaviorData.eventId;
        }
        return GsonUtils.toJson(stringBuilder);
    }

}
