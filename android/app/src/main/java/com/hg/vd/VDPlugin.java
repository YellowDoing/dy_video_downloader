package com.hg.vd;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import org.jsoup.Jsoup;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class VDPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {

    private final String CHANNEL_NAME = "com.hg.dy";
    private MethodChannel channel;
    private Context context;

    public MethodChannel getChannel() {
        return channel;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
        channel.setMethodCallHandler(this);
        context = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getPath":
                result.success(Environment.getExternalStorageDirectory().getPath());
                break;

            case "getVideoThumbnail":
                result.success(getVideoThumbnailAndDuration(call.arguments()));
                break;

            case "share":
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.setType("video/mp4");
                if (Build.VERSION.SDK_INT < 24)
                    intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(new File((String) call.arguments())));
                else{
                    intent.putExtra(Intent.EXTRA_STREAM, FileProvider.getUriForFile(context, "com.hg.vd.fileprovider", new File((String) call.arguments())));
                    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                }
                context.startActivity(intent);
                result.success(null);
                break;
                
            case "test":
                Toast.makeText(context, "hhhhhhhh", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    /**
     * 获取视频文件缩略图
     *
     * @param videoPath 视频文件的路径  如:/storage/emulated/0/IM/video/1523343139288.mp4
     */
    public Map<String, Object> getVideoThumbnailAndDuration(String videoPath) {
        Map<String, Object> map = new HashMap<>();
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            retriever.setDataSource(videoPath);
            Bitmap bitmap = retriever.getFrameAtTime();
            int duration = Integer.parseInt(retriever.extractMetadata
                    (MediaMetadataRetriever.METADATA_KEY_DURATION)) / 1000;

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
            byte[] data = baos.toByteArray();

            map.put("thumbnail", data);
            map.put("duration", duration);
            bitmap.recycle();
        } catch (IllegalArgumentException ex) {
            ex.printStackTrace();
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        } finally {
            try {
                retriever.release();
            } catch (RuntimeException ex) {
                ex.printStackTrace();
            }
        }
        return map;
    }

}
