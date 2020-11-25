package com.xiaojuchefu.prism;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.eastwood.common.adapter.QuickAdapter;
import com.eastwood.common.adapter.QuickRecyclerAdapter;
import com.eastwood.common.adapter.ViewHelper;

import java.util.ArrayList;
import java.util.List;

public class TestActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getSupportActionBar().setTitle("请随意点击下面控件后返回");

        setContentView(R.layout.activity_test);

        ViewPager viewPager = findViewById(R.id.viewpager);
        viewPager.setOffscreenPageLimit(3);
        viewPager.setAdapter(new PagerAdapter() {
            @Override
            public int getCount() {
                return 50;
            }

            @Override
            public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
                return view == object;
            }

            @Override
            public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
                container.removeView((View) object);
            }

            @NonNull
            @Override
            public Object instantiateItem(@NonNull ViewGroup container, int position) {
                View view = LayoutInflater.from(TestActivity.this).inflate(R.layout.item_view, container, false);
                Button button = view.findViewById(R.id.btn);
                button.setText("viewpage button " + position);
                container.addView(view);
                return view;
            }
        });

        List<String> data = new ArrayList<>();
        for (int i = 0; i < 100; i++) {
            data.add("BUTTON " + i);
        }
        ListView listView = findViewById(R.id.listview);
        listView.setAdapter(new QuickAdapter<String>(this, R.layout.item_view, data) {
            @Override
            protected void convert(int position, ViewHelper helper, String item) {
                helper.setText(R.id.btn, item);
            }
        });

        RecyclerView recyclerView = findViewById(R.id.recyclerview);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(new QuickRecyclerAdapter<String>(this, data) {
            @Override
            protected void convert(int position, ViewHelper helper, String item) {
                helper.setText(R.id.btn, item);
            }

            @Override
            protected int getItemType(int position) {
                return 0;
            }

            @Override
            protected int getItemLayoutId(int type) {
                return R.layout.item_view;
            }
        });


        findViewById(R.id.btn_show_dialog).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new AlertDialog.Builder(TestActivity.this)
                        .setTitle("this is a dialog")
                        .setNegativeButton("关闭", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {

                            }
                        }).create().show();
            }
        });
        findViewById(R.id.btn_start_activity).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(TestActivity.this, TestActivity.class));
            }
        });
    }

}
