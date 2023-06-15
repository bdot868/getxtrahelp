package com.app.xtrahelpuser.Utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import com.tbruyelle.rxpermissions2.RxPermissions;

import com.app.xtrahelpuser.R;


public class PermissionUtils {

    public static final int PERMISSION_SMS = 1;
    public static final int PERMISSION_CAMERA_PICTURE = 2;
    public static final int PERMISSION_CAMERA_VIDEO = 3;
    public static final int PERMISSION_GALLERY = 4;
    public static final int PERMISSION_READ_CONTACTS = 6;
    public static final int PERMISSION_MICROPHONE = 7;
    public static final int PERMISSION_BASIC = 8;
    public static final int PERMISSION_GALLERY_VIDEO = 10;
    public static final int PERMISSION_GALLERY_AUDIO = 11;
    public static final int PERMISSION_CALENDER = 12;


    private static final int REQUEST_CAMERA_PICTURE_PERMISSION_SETTING = 1501;
    private static final int REQUEST_CAMERA_VIDEO_PERMISSION_SETTING = 1502;
    private static final int REQUEST_READ_CONTACTS_PERMISSION_SETTING = 1504;
    private static final int REQUEST_BASIC_PERMISSIONS_SETTING = 1506;
    private static final int REQUEST_GALLERY_PERMISSION_SETTING = 1507;
    private static final int REQUEST_MICROPHONE_PERMISSION_SETTING = 1505;
    private static final int REQUEST_GALLERY_VIDEO_PERMISSION_SETTING = 1509;
    private static final int REQUEST_GALLERY_AUDIO_PERMISSION_SETTING = 1511;
    private static final int REQUEST_CALENDER_PERMISSION_SETTING = 1512;

    private Context context;
    private Activity activity;
    private Fragment fragment;

    PermissionSettingsListener listener;

    public PermissionUtils(Activity activity) {
        this.activity = activity;
        this.context = activity;
        listener = PermissionSettingsListener.EMPTY;
    }

    public PermissionUtils(Fragment fragment) {
        this.fragment = fragment;
        this.context = fragment.getActivity();
        listener = PermissionSettingsListener.EMPTY;
    }

    public interface PermissionSettingsListener {
        void onPermissionGranted(int permission);

        void onPermissionDenied(int permission);

        PermissionSettingsListener EMPTY = new PermissionSettingsListener() {
            @Override
            public void onPermissionGranted(int permission) {

            }

            @Override
            public void onPermissionDenied(int permission) {

            }
        };
    }

    public void setListener(PermissionSettingsListener listener) {
        this.listener = listener;
    }

    @SuppressLint("NewApi")
    public void requestSMSPermission() {
        final RxPermissions rxPermissions = new RxPermissions((FragmentActivity) context);
        rxPermissions.request(Manifest.permission.RECEIVE_SMS)
                .subscribe(granted -> {
                    if (granted) { // Always true pre-M
                        listener.onPermissionGranted(PERMISSION_SMS);
                    } else {
                        Activity activity = this.activity != null ? this.activity : fragment.getActivity();
                        boolean showRationale = activity.shouldShowRequestPermissionRationale(Manifest.permission.RECEIVE_SMS);
                        if (!showRationale) {
                            AlertDialog alertDialog = new AlertDialog.Builder(context, R.style.MyAlertDialogTheme)
                                    .setMessage(R.string.msg_otp_detection_disabled)
                                    .setPositiveButton(R.string.ok, (dialog, which) -> {
                                        listener.onPermissionGranted(PERMISSION_SMS);
                                    })
                                    .create();
                            alertDialog.setOnCancelListener(dialog -> {
                                listener.onPermissionDenied(PERMISSION_SMS);
                            });
                            alertDialog.show();
                        } else {
                            AlertDialog alertDialog = new AlertDialog.Builder(context, R.style.MyAlertDialogTheme)
                                    .setTitle(R.string.title_permission_denied)
                                    .setMessage(R.string.msg_sms_permission_denied)
                                    .setNegativeButton(R.string.btn_i_am_sure, null)
                                    .setPositiveButton(R.string.btn_retry, (dialog1, which1) -> {
                                        rxPermissions
                                                .request(Manifest.permission.RECEIVE_SMS)
                                                .subscribe(granted1 -> {
                                                    if (granted1) {
                                                        listener.onPermissionGranted(PERMISSION_SMS);
                                                    } else {
                                                        listener.onPermissionDenied(PERMISSION_SMS);
                                                    }
                                                });
                                    })
                                    .create();
                            alertDialog.setOnCancelListener(dialog -> {
                                listener.onPermissionDenied(PERMISSION_SMS);
                            });
                            alertDialog.show();
                        }
                    }
                });
    }

    public void requestPermission(int permission) {
        switch (permission) {
            case PERMISSION_BASIC:
                requestPermissions(PERMISSION_BASIC, R.string.msg_basic_permissions,
                        R.string.msg_basic_permissions_denied,
                        REQUEST_BASIC_PERMISSIONS_SETTING, Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_CONTACTS);
                break;
            case PERMISSION_CAMERA_PICTURE:
                requestPermissions(PERMISSION_CAMERA_PICTURE, R.string.msg_camera_picture_permission,
                        R.string.msg_camera_picture_permission_denied,
                        REQUEST_CAMERA_PICTURE_PERMISSION_SETTING, Manifest.permission.CAMERA,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE);
                break;
            case PERMISSION_CAMERA_VIDEO:
                requestPermissions(PERMISSION_CAMERA_VIDEO, R.string.msg_camera_video_permission,
                        R.string.msg_camera_video_permission_denied,
                        REQUEST_CAMERA_VIDEO_PERMISSION_SETTING, Manifest.permission.CAMERA,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE);
                break;
            case PERMISSION_GALLERY:
                requestPermissions(PERMISSION_GALLERY, R.string.msg_gallery_permission,
                        R.string.msg_gallery_permission_denied,
                        REQUEST_GALLERY_PERMISSION_SETTING, Manifest.permission.WRITE_EXTERNAL_STORAGE);
                break;
            case PERMISSION_READ_CONTACTS:
                requestPermissions(PERMISSION_READ_CONTACTS, R.string.msg_contacts_permission,
                        R.string.msg_contacts_permission_denied,
                        REQUEST_READ_CONTACTS_PERMISSION_SETTING, Manifest.permission.READ_CONTACTS);
                break;
            case PERMISSION_GALLERY_VIDEO:
                requestPermissions(PERMISSION_GALLERY_VIDEO, R.string.msg_gallery_video_permission,
                        R.string.msg_gallery_video_permission_denied,
                        REQUEST_GALLERY_VIDEO_PERMISSION_SETTING, Manifest.permission.WRITE_EXTERNAL_STORAGE);
                break;
            case PERMISSION_MICROPHONE:
                requestPermissions(PERMISSION_MICROPHONE, R.string.msg_microphone_permission,
                        R.string.msg_microphone_permission_denied,
                        REQUEST_MICROPHONE_PERMISSION_SETTING, Manifest.permission.RECORD_AUDIO);
                break;
            case PERMISSION_GALLERY_AUDIO:
                requestPermissions(PERMISSION_GALLERY_AUDIO, R.string.msg_gallery_audio_permission,
                        R.string.msg_gallery_audio_permission_denied,
                        REQUEST_GALLERY_AUDIO_PERMISSION_SETTING, Manifest.permission.WRITE_EXTERNAL_STORAGE);
                break;
            case PERMISSION_CALENDER:
                requestPermissions(PERMISSION_CALENDER, R.string.msg_calender_permission,
                        R.string.msg_calender_permission_denied,
                        REQUEST_CALENDER_PERMISSION_SETTING , Manifest.permission.WRITE_CALENDAR, Manifest.permission.READ_CALENDAR);
                break;
        }
    }

    @SuppressLint("NewApi")
    private void requestPermissions(int permission, int messageRequest, int messageOnDenied,
                                    int requestCode, String... permissions) {
        RxPermissions rxPermissions = new RxPermissions((FragmentActivity) context);
        rxPermissions.request(permissions)
                .subscribe(granted -> {
                    if (granted) { // Always true pre-M
                        listener.onPermissionGranted(permission);
                    } else {
                        Activity activity = this.activity != null ? this.activity : fragment.getActivity();
                        boolean showRationale = false;
                        for (String p : permissions) {
                            showRationale = activity.shouldShowRequestPermissionRationale(p);
                            if (showRationale) break;
                        }
                        if (!showRationale) {
                            final boolean[] openSettings = {false};
                            AlertDialog alertDialog = new AlertDialog.Builder(context, R.style.MyAlertDialogTheme)
                                    .setMessage(messageRequest)
                                    .setPositiveButton(R.string.action_yes, (dialog, which) -> {
                                        openSettings[0] = true;
                                        openAppPermissionSettings(requestCode);
                                    })
                                    .setNegativeButton(R.string.action_no, null)
                                    .create();
                            alertDialog.setOnDismissListener(dialog -> {
                                if (!openSettings[0]) {
                                    listener.onPermissionDenied(permission);
                                }
                            });
                            alertDialog.show();
                        } else {
                            final boolean[] retry = {false};
                            AlertDialog alertDialog = new AlertDialog.Builder(activity)
                                    .setTitle(R.string.title_permission_denied)
                                    .setMessage(messageOnDenied)
                                    .setNegativeButton(R.string.btn_i_am_sure, null)
                                    .setPositiveButton(R.string.btn_retry, (dialog1, which1) -> {
                                        retry[0] = true;
                                        rxPermissions
                                                .request(permissions)
                                                .subscribe(granted1 -> {
                                                    if (granted1) {
                                                        listener.onPermissionGranted(permission);
                                                    } else {
                                                        listener.onPermissionDenied(permission);
                                                    }
                                                });
                                    })
                                    .create();
                            alertDialog.setOnDismissListener(dialog -> {
                                if (!retry[0]) {
                                    listener.onPermissionDenied(permission);
                                }
                            });
                            alertDialog.show();
                        }
                    }
                }, Throwable::printStackTrace);
    }

    private void openAppPermissionSettings(int requestCode) {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", context.getPackageName(), null);
        intent.setData(uri);
        if (activity != null) {
            activity.startActivityForResult(intent, requestCode);
        } else if (fragment != null) {
            fragment.startActivityForResult(intent, requestCode);
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CAMERA_PICTURE_PERMISSION_SETTING && checkCameraPermission() &&
                checkWriteStoragePermission()) {
            listener.onPermissionGranted(PERMISSION_CAMERA_PICTURE);
        } else if (requestCode == REQUEST_CAMERA_VIDEO_PERMISSION_SETTING && checkCameraPermission() &&
                checkWriteStoragePermission()) {
            listener.onPermissionGranted(PERMISSION_CAMERA_VIDEO);
        } else if (requestCode == REQUEST_GALLERY_PERMISSION_SETTING && checkWriteStoragePermission()) {
            listener.onPermissionGranted(PERMISSION_GALLERY);
        } else if (requestCode == REQUEST_READ_CONTACTS_PERMISSION_SETTING && checkReadContactsPermission()) {
            listener.onPermissionGranted(PERMISSION_READ_CONTACTS);
        } else if (requestCode == REQUEST_GALLERY_VIDEO_PERMISSION_SETTING && checkWriteStoragePermission()) {
            listener.onPermissionGranted(PERMISSION_GALLERY_VIDEO);
        } else if (requestCode == REQUEST_GALLERY_AUDIO_PERMISSION_SETTING && checkWriteStoragePermission()) {
            listener.onPermissionGranted(PERMISSION_GALLERY_AUDIO);
        } else if (requestCode == REQUEST_MICROPHONE_PERMISSION_SETTING && checkMicrophonePermission()) {
            listener.onPermissionGranted(PERMISSION_READ_CONTACTS);
        }else if (requestCode == REQUEST_CALENDER_PERMISSION_SETTING && checkCalenderReadPermission() && checkCalenderWritePermission()) {
            listener.onPermissionGranted(PERMISSION_CALENDER);
        }
    }

    public boolean checkCameraPermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED);
    }

    public static boolean checkStoragePermission(Context context) {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkWriteStoragePermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkReadContactsPermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkReadStoragePermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkMicrophonePermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkCalenderReadPermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.READ_CALENDAR) != PackageManager.PERMISSION_GRANTED);
    }

    public boolean checkCalenderWritePermission() {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context,
                        Manifest.permission.WRITE_CALENDAR) != PackageManager.PERMISSION_GRANTED);
    }
}
