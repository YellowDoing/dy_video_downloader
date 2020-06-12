package com.hg.vd;

import android.Manifest;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import java.io.File;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {


    private final VDPlugin vdPlugin= new VDPlugin();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getFlutterEngine().getPlugins().add(vdPlugin);
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0);


    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        String action = intent.getAction();
        String type = intent.getType();
        if (Intent.ACTION_SEND.equals(action) && type != null) {
            //过滤链接，获取http连接地址
            final String finalUrl = intent.getStringExtra(Intent.EXTRA_TEXT);
            vdPlugin.getChannel().invokeMethod("download",finalUrl);
        }
    }
}
