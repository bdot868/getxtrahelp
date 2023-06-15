package com.app.xtrahelpcaregiver.CustomView;

import static android.content.Context.LAYOUT_INFLATER_SERVICE;

import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.app.xtrahelpcaregiver.R;
import com.google.android.exoplayer2.ExoPlayerFactory;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.extractor.DefaultExtractorsFactory;
import com.google.android.exoplayer2.extractor.ExtractorsFactory;
import com.google.android.exoplayer2.source.ExtractorMediaSource;
import com.google.android.exoplayer2.source.MediaSource;
import com.google.android.exoplayer2.trackselection.AdaptiveTrackSelection;
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector;
import com.google.android.exoplayer2.trackselection.TrackSelection;
import com.google.android.exoplayer2.trackselection.TrackSelector;
import com.google.android.exoplayer2.ui.SimpleExoPlayerView;
import com.google.android.exoplayer2.upstream.BandwidthMeter;
import com.google.android.exoplayer2.upstream.DataSource;
import com.google.android.exoplayer2.upstream.DefaultBandwidthMeter;
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory;
import com.google.android.exoplayer2.util.Util;


public class VideoPopupView extends PopupWindow {
    VideoView videoView;
    RelativeLayout relativeBack;
    ProgressBar progressbar;
    SimpleExoPlayerView exoPlayer;
    SimpleExoPlayer player;

    View view;
    Context mContext;
    RelativeLayout rl_custom_layout;
    ProgressBar loading;
    ViewGroup parent;

    public VideoPopupView(Context ctx, View v, String videoUrl) {
        super(((LayoutInflater) ctx.getSystemService(LAYOUT_INFLATER_SERVICE)).inflate(R.layout.popup_full_screen_video, null), ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        if (Build.VERSION.SDK_INT >= 21) {
            setElevation(5.0f);
        }
        this.mContext = ctx;
        this.view = getContentView();
        RelativeLayout relativeBack = (RelativeLayout) this.view.findViewById(R.id.relativeBack);
        setOutsideTouchable(true);
        setFocusable(true);
        relativeBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Dismiss the popup window
                dismiss();
            }
        });

        BandwidthMeter bandwidthMeter = new DefaultBandwidthMeter();
        TrackSelection.Factory videoTrackSelectionFactory = new AdaptiveTrackSelection.Factory(bandwidthMeter);
        TrackSelector trackSelector = new DefaultTrackSelector(videoTrackSelectionFactory);

        player = ExoPlayerFactory.newSimpleInstance(mContext, trackSelector);

        SimpleExoPlayerView simpleExoPlayerView = view.findViewById(R.id.exoplayer);
        simpleExoPlayerView.setPlayer(player);

        player.setRepeatMode(Player.REPEAT_MODE_ALL);
        player.setPlayWhenReady(true);
        DataSource.Factory dataSourceFactory = new DefaultDataSourceFactory(mContext, Util.getUserAgent(mContext, "com.app.infalliblecare"));
//        simpleExoPlayerView.setShutterBackgroundColor(getColor(R.color.transparent));
        ExtractorsFactory extractorsFactory = new DefaultExtractorsFactory();

// This is the MediaSource representing the media to be played.
        Uri videoUri = Uri.parse(videoUrl);
        MediaSource videoSource = new ExtractorMediaSource(videoUri, dataSourceFactory, extractorsFactory, null, null);


// Prepare the player with the source.
        player.prepare(videoSource);

        setAnimationStyle(R.style.popup_window_animation_phone);
        showAtLocation(v, Gravity.CENTER, 0, 0);
    }
}
