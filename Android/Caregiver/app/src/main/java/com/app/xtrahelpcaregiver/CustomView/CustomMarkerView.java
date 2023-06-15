package com.app.xtrahelpcaregiver.CustomView;

import android.content.Context;
import android.widget.TextView;

import com.app.xtrahelpcaregiver.R;
import com.github.mikephil.charting.components.MarkerView;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;

import java.util.ArrayList;

public class CustomMarkerView extends MarkerView {

    private TextView yValue;
    ArrayList<String> labels;

    public CustomMarkerView(Context context, int layoutResource, ArrayList<String> labels) {
        super(context, layoutResource);
        // this markerview only displays a textview
        yValue =  findViewById(R.id.tvContent);
        this.labels = labels;
    }

    // callbacks everytime the MarkerView is redrawn, can be used to update the
    // content (user-interface)
    @Override
    public void refreshContent(Entry e, Highlight highlight) {
        yValue.setText("$" + e.getVal()+"0"); // set the entry-value as the display text
    }

    /**
     * Use this to return the desired offset you wish the MarkerView to have on the x-axis. By returning -(getWidth() /
     * 2) you will center the MarkerView horizontally.
     *
     * @param xpos the position on the x-axis in pixels where the marker is drawn
     * @return
     */
    @Override
    public int getXOffset(float xpos) {
        return -(getWidth() / 2);
    }

    /**
     * Use this to return the desired position offset you wish the MarkerView to have on the y-axis. By returning
     * -getHeight() you will cause the MarkerView to be above the selected value.
     *
     * @param ypos the position on the y-axis in pixels where the marker is drawn
     * @return
     */
    @Override
    public int getYOffset(float ypos) {
        return -getHeight();
    }
}