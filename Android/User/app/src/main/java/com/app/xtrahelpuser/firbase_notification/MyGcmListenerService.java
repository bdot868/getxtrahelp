package com.app.xtrahelpuser.firbase_notification;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.app.xtrahelpcaregiver.Utils.Const;
import com.app.xtrahelpuser.R;
import com.app.xtrahelpuser.Response.PushNotificationResponse;
import com.app.xtrahelpuser.Ui.ChattingActivity;
import com.app.xtrahelpuser.Ui.DashboardActivity;
import com.app.xtrahelpuser.Ui.JobDetailActivity;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.google.gson.Gson;

import org.apache.commons.lang3.StringEscapeUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ExecutionException;


public class MyGcmListenerService extends FirebaseMessagingService {
    private static final String TAG = "MyGcmListenerService";
    boolean foreGround = false;
    String notificationMsg = "M";
    String notificationTitle = "T";
    String title = "T";
    private String CHANNEL_ID = "xtraHelpUser";
    private String CHANNEL_NAME = "xtraHelp User";

    @Override
    public void onNewToken(String token) {
        Log.e(TAG, "Refreshed token: " + token);
    }

    @Override
    public void handleIntent(Intent intent) {
        try {
            foreGround = new ForegroundCheckTask().execute(this).get();
            Log.e(TAG, "foreGround: " + foreGround);
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Gson gson = new Gson();
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            Log.e(TAG, "payload:" + bundle.getString("payload"));
            try {
                String test = bundle.getString("payload");
                Log.e("test-->", "onMessageReceived: " + test);
                pushNotificationResponse = gson.fromJson(test, PushNotificationResponse.class);
                if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase(Const.chatinbox)) {
                    notificationTitle = pushNotificationResponse.getMessages().getMessageData().getTitle();
                    notificationMsg = pushNotificationResponse.getMessages().getMessageData().getDesc();
                    title = pushNotificationResponse.getMessages().getMessageData().getTitle();
                } else {
                    notificationTitle = pushNotificationResponse.getMessages().getMessageData().getTitle();
                    notificationMsg = pushNotificationResponse.getMessages().getMessageData().getDesc();
                    title = pushNotificationResponse.getMessages().getMessageData().getTitle();
                }
                pushNotification();
            } catch (Exception e) {
                Log.e(TAG, "handleIntent: +" + e.toString());
            }
        }
    }

    PushNotificationResponse pushNotificationResponse = new PushNotificationResponse();

    @Override
    public void onMessageReceived(RemoteMessage message) {

    }

    public void pushNotification() {
        if (notificationTitle == null)
            notificationTitle = getString(R.string.app_name);

        ArrayList<Intent> activity = new ArrayList<>();
        NotificationManager mNotificationManager = (NotificationManager) getSystemService(MyGcmListenerService.this.NOTIFICATION_SERVICE);
        Intent intent = null;
        PendingIntent pIntent = null;

        if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase(Const.chatinbox)) {

            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class);
            activity.add(intent1);
            intent = new Intent(MyGcmListenerService.this, ChattingActivity.class);
//            intent.putExtra(ChattingActivity.USERID, pushNotificationResponse.getMessages().getMessageData().getSend_from());
//            intent.putExtra(ChattingActivity.USERNAME, pushNotificationResponse.getMessages().getMessageData().getReceiverName());
//            intent.putExtra(ChattingActivity.ISUSERMESSAGE, true);
//            intent.putExtra(ChattingActivity.FROMDETAIL, false);
            activity.add(intent);

        } else if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("cancelUpcomingJobByCaregiver")
                || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("caregiverSubstituteJobByCaregiver")
                || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("transactionSuccessForJobPayment")
                || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("declineExtraTimeRequestOfCurrentJobByCaregiver")
                || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("acceptExtraTimeRequestOfCurrentJobByCaregiver")
                || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("transactionSuccessForAdditionaHoursJobPayment")
        ) {
            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class);
            activity.add(intent1);
            intent = new Intent(MyGcmListenerService.this, JobDetailActivity.class);
            intent.putExtra(JobDetailActivity.Companion.getJOBID(), pushNotificationResponse.getMessages().getMessageData().getModel_id() + "");
            intent.putExtra(JobDetailActivity.Companion.getISUSERRELATEDJOB(), true);
            intent.putExtra(JobDetailActivity.Companion.getISFEEDBACK(), false);
            activity.add(intent);
        } else if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("ongoingJobReviewRequestUser")) {
            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class);
            activity.add(intent1);
            intent = new Intent(MyGcmListenerService.this, JobDetailActivity.class);
            intent.putExtra(JobDetailActivity.Companion.getJOBID(), pushNotificationResponse.getMessages().getMessageData().getModel_id() + "");
            intent.putExtra(JobDetailActivity.Companion.getISUSERRELATEDJOB(), true);
            intent.putExtra(JobDetailActivity.Companion.getISFEEDBACK(), true);
            activity.add(intent);
        } else if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("applyUserJobByCaregiver")) {
            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class);
            activity.add(intent1);
            intent = new Intent(MyGcmListenerService.this, JobDetailActivity.class);
            intent.putExtra(JobDetailActivity.Companion.getJOBID(), pushNotificationResponse.getMessages().getMessageData().getModel_id() + "");
            intent.putExtra(JobDetailActivity.Companion.getISUSERRELATEDJOB(), false);
            intent.putExtra(JobDetailActivity.Companion.getISFEEDBACK(), false);
            activity.add(intent);
        } else if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("caregiverSubstituteJobRequestByCaregiverToUser")) {
            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class)
                    .putExtra(DashboardActivity.Companion.getFROMSUBSTITUTE(), true);
            activity.add(intent1);
        } else if (pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("transactionFailForJobPayment") || pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase("cancelUpcomingJobByAutoSystemForUser")) {
            Intent intent1 = new Intent(MyGcmListenerService.this, DashboardActivity.class)
                    .putExtra(DashboardActivity.Companion.getTOUPCOMING(), true);
            activity.add(intent1);
        }

        if (foreGround && pushNotificationResponse.getMessages().getCategory().equalsIgnoreCase(Const.chatinbox)) {

        } else {
            Intent[] intents = activity.toArray(new Intent[activity.size()]);
            try {
                pIntent = PendingIntent.getActivities(MyGcmListenerService.this, getNotificationId(), intents, PendingIntent.FLAG_UPDATE_CURRENT);
            } catch (Exception e) {
                e.printStackTrace();
            }

            int color = getResources().getColor(R.color.txtOrange);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                String CHANNEL_ID = "my_channel_01";
                CharSequence name = "Notification Channel";
                String Description = "Application Notifications";
                int importance = NotificationManager.IMPORTANCE_HIGH;
                NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID, name, importance);
                mChannel.setDescription(StringEscapeUtils.unescapeJava(Description));
                mChannel.enableLights(true);
                mChannel.setLightColor(Color.RED);
                mChannel.enableVibration(true);
                mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
                mChannel.setShowBadge(false);
                mNotificationManager.createNotificationChannel(mChannel);

                Notification notification = new Notification.Builder(this, CHANNEL_ID)
                        .setAutoCancel(true)
                        .setContentTitle(StringEscapeUtils.unescapeJava(title))
                        .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
                        .setContentText(StringEscapeUtils.unescapeJava("" + notificationMsg))
                        .setSmallIcon(R.drawable.noti_logo)
                        .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                        .setNumber(1)
                        .setContentIntent(pIntent)
                        .setColor(color)
                        .setChannelId(CHANNEL_ID)
                        .build();
                mNotificationManager.notify(getNotificationId(), notification);

            }

            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
                        this)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle(StringEscapeUtils.unescapeJava(notificationTitle))
                        .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
                        .setStyle(new NotificationCompat.BigTextStyle().bigText("" + title))
                        .setAutoCancel(true)
                        .setContentText(StringEscapeUtils.unescapeJava("" + notificationMsg))
                        .setColor(color)
                        .setContentIntent(pIntent)
                        .setAutoCancel(true)
                        .setNumber(1);
                mNotificationManager.notify(getNotificationId(), mBuilder.build());

            } else {
                Notification notification = new Notification.Builder(this)
                        .setAutoCancel(true)
                        .setContentTitle(StringEscapeUtils.unescapeJava(title))
                        .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
                        .setContentText(StringEscapeUtils.unescapeJava("" + notificationMsg))
                        .setSmallIcon(R.drawable.noti_logo)
                        .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                        .setNumber(1)
                        .setContentIntent(pIntent)
                        .setColor(color)
                        .setAutoCancel(true)
                        .build();
                mNotificationManager.notify(getNotificationId(), notification);
            }
        }
    }

    private static int getNotificationId() {
        Random rnd = new Random();
        return 100 + rnd.nextInt(9000);
    }

    public class ForegroundCheckTask extends AsyncTask<Context, Void, Boolean> {

        @Override
        protected Boolean doInBackground(Context... params) {
            final Context context = params[0].getApplicationContext();
            return isAppOnForeground(context);
        }

        private boolean isAppOnForeground(Context context) {
            ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
            if (appProcesses == null) {
                return false;
            }
            final String packageName = context.getPackageName();
            for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
                if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND && appProcess.processName.equals(packageName)) {
                    return true;
                }
            }
            return false;
        }
    }
}