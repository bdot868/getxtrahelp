package com.app.xtrahelpcaregiver.Utils;

import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.MimeTypeMap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class FileUtils {
    public static final String DOCUMENTS_DIR = "documents";
    private static final boolean DEBUG = false; // Set to true to enable logging

    private FileUtils() {
        throw new AssertionError("No Instances");
    }

    public static String getImagePathFromContentUri(Context context, Uri uri) {
        String[] filePathColumn = {MediaStore.Images.Media.DATA};
        Cursor cursor = null;
        try {
            cursor = context.getContentResolver().query(uri,
                    filePathColumn, null, null, null);

            if (cursor.moveToFirst()) {
                return cursor.getString(cursor.getColumnIndex(filePathColumn[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return null;
    }

    public static String getMusicPathFromContentUri(Context context, Uri uri) {
        String[] filePathColumn = {MediaStore.Audio.Media.DATA};
        Cursor cursor = null;
        try {
            cursor = context.getContentResolver().query(uri,
                    filePathColumn, null, null, null);

            if (cursor.moveToFirst()) {
                return cursor.getString(cursor.getColumnIndex(filePathColumn[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return null;
    }

    public static String getVideoPathFromContentUri(Context context, Uri uri) {
        String[] filePathColumn = {MediaStore.Video.Media.DATA};
        Cursor cursor = null;
        try {
            cursor = context.getContentResolver().query(uri,
                    filePathColumn, null, null, null);

            if (cursor.moveToFirst()) {
                return cursor.getString(cursor.getColumnIndex(filePathColumn[0]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return null;
    }

    public static String getMimeType(String path) {
        String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(getExtension(path.toLowerCase()));
        if (mimeType == null) {
            return "";
        }
        return mimeType;
    }

    public static String getExtension(String path) {
        String extension = "";
        if (path != null) {
            int i = path.lastIndexOf('.');
            if (i > 0) {
                extension = path.substring(i + 1);
            }
        }
        return extension;
    }

    public static String readableFileSize(String path) {
        if (path == null) {
            return "";
        }
        return readableFileSize(new File(path).length());
    }

    public static String readableFileSize(long size) {
        if (size <= 0) return "0";
        final String[] units = new String[]{"B", "kB", "MB", "GB", "TB"};
        int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
        return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + " " + units[digitGroups];
    }

//
//    public static Intent getOpenFileIntent(Context context, String filePath) {
//        Intent intent = new Intent(Intent.ACTION_VIEW);
//        intent.setDataAndType(FileUtilsNew.getUriFromFile(context, new File(filePath)), getMimeType(filePath));
//        return intent;
//    }

    public static int getMediaDuration(String path) {
        if (TextUtils.isEmpty(path)) {
            return 0;
        }

        MediaMetadataRetriever mmr = null;
        try {
            mmr = new MediaMetadataRetriever();
            mmr.setDataSource(path);
            String durationStr = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            return (int) (Long.parseLong(durationStr) / 1000);
        } finally {
            if (mmr != null) {
                mmr.release();
            }
        }
    }

    public static String getMediaDurationString(String path) {
        try {
            long duration = getMediaDuration(path);
            return mediaDurationToString((int) duration);
        } catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
    }

    public static String mediaDurationToString(int duration) {
        int minutes = duration / 60;
        int seconds = duration % 60;
        return String.format("%02d", minutes) + ":"
                + String.format("%02d", seconds);
    }

    public static void deleteFiles(Context context, List<String> paths) {
        for (String path : paths) {
            new File(path).delete();
        }
        rescanMediaStore(context, paths.toArray(new String[paths.size()]));
    }

    /**
     * Update in gallery
     */
    public static void rescanMediaStore(Context context, String[] paths) {
        MediaScannerConnection.scanFile(context, paths, null, null);
    }

    public static File saveDrawableToFile(Context context, int drawableResc, File file) {
        Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), drawableResc);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);

            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);

            fos.close();

        } catch (IOException e) {
            Log.e("app", e.getMessage());
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        }
        return file;
    }

    public static void copy(File src, File dst) {
        try {
            InputStream in = new FileInputStream(src);
            OutputStream out = new FileOutputStream(dst);

            // Transfer bytes from in to out
            byte[] buf = new byte[1024];
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            in.close();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //    public static void copy(Context context, Uri srcUri, File dstFile) {
//        try {
//            InputStream inputStream = context.getContentResolver().openInputStream(srcUri);
//            if (inputStream == null) return;
//            OutputStream outputStream = new FileOutputStream(dstFile);
//            IOUtils.copy(inputStream, outputStream);
//            inputStream.close();
//            outputStream.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//
    public static Uri getUriFromFile(Context context, File file) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            try {
                return FileProvider.getUriForFile(context, context.getApplicationContext().getPackageName() + ".provider", file);
            } catch (IllegalArgumentException e) {
                Log.e("getUriFromFile : ", "" + e.toString());
                return null;
            }
        } else {
            return Uri.fromFile(file);
        }
    }
//
//    public static String getFilePathFromURI(Context context, Uri contentUri) {
//        //copy file and send new file path as getting file from source Uri is not working in Android N
//        String fileName = FileUtilsNew.getFileName(contentUri);
//        if (!TextUtils.isEmpty(fileName)) {
//            File dir = new File(Config.HOME_DIR_PATH, Config.HIDDEN_IMAGE_DIR);
//            if (!dir.exists()) dir.mkdirs();
//
//            File dstFile = new File(dir.getPath() + File.separator + fileName);
//            FileUtilsNew.copy(context, contentUri, dstFile);
//            return dstFile.getAbsolutePath();
//        }
//        return null;
//    }

    public static String getFileName(Uri uri) {
        if (uri == null) return null;
        String fileName = null;
        String path = uri.getPath();
        int cut = path.lastIndexOf('/');
        if (cut != -1) {
            fileName = path.substring(cut + 1);
        }
        return fileName;
    }

    public static String getFileName(File file) {
        if (file == null) return null;
        String fileName = null;
        String path = file.getAbsolutePath();
        int cut = path.lastIndexOf('/');
        if (cut != -1) {
            fileName = path.substring(cut + 1);
        }
        return fileName;
    }

    /**
     * copying the entire folder with its contents
     *
     * @param source       source folder
     * @param target       target folder
     * @param replaceFiles target folder files that should be replaced or not
     */
    public static void copyFolder(File source, File target, boolean replaceFiles) {
        if (source.isDirectory()) {
            if (!target.exists()) {
                target.mkdir();
            }

            String[] children = source.list();
            for (int i = 0; i < source.listFiles().length; i++) {

                copyFolder(new File(source, children[i]),
                        new File(target, children[i]), replaceFiles);
            }
        } else if (replaceFiles || !target.exists()) {
            copy(source, target);
        }
    }

    /**
     * @param directory parent directory
     * @param extension for example, ".csv"
     * @return list of all files having extension from parent directory
     */
    public static ArrayList<File> getFiles(File directory, String extension) {
        ArrayList<File> inFiles = new ArrayList<File>();
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (!file.isDirectory() && file.getName().endsWith(extension)) {
                    inFiles.add(file);
                }
            }
        }
        return inFiles;
    }
//
//    public static void zipAndReplaceFile(File file) {
//        String fileName = getFileName(file);
//        zip(new File[]{file}, file.getParent() + File.separator + FilenameUtils.removeExtension(fileName) + ".zip");
//        file.delete();
//    }

    public static void zip(File[] files, String zipFilePath) {
        int buffer = 1024;
        try {
            BufferedInputStream origin = null;
            FileOutputStream dest = new FileOutputStream(zipFilePath);
            ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(dest));
            byte data[] = new byte[buffer];

            for (int i = 0; i < files.length; i++) {
                FileInputStream fi = new FileInputStream(files[i]);
                origin = new BufferedInputStream(fi, buffer);

                String path = files[i].getAbsolutePath();
                ZipEntry entry = new ZipEntry(path.substring(path.lastIndexOf("/") + 1));
                out.putNextEntry(entry);
                int count;

                while ((count = origin.read(data, 0, buffer)) != -1) {
                    out.write(data, 0, count);
                }
                origin.close();
            }

            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getPath(final Context context, final Uri uri) {
        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                if (id != null && id.startsWith("raw:")) {
                    return id.substring(4);
                }
                String[] contentUriPrefixesToTry = new String[]{
                        "content://downloads/public_downloads",
                        "content://downloads/my_downloads",
                };

                for (String contentUriPrefix : contentUriPrefixesToTry) {
//                    Uri contentUri = ContentUris.withAppendedId(Uri.parse(contentUriPrefix), Long.valueOf(id));
                    try {
                        String path = getDataColumn(context, uri, null, null);
                        if (path != null) {
                            return path;
                        }
                    } catch (Exception e) {
                    }
                }
                // path could not be retrieved using ContentResolver, therefore copy file to accessible cache using streams
                String fileName = getFileName(context, uri);
                File cacheDir = getDocumentCacheDir(context);
                File file = generateFileName(fileName, cacheDir);
                String destinationPath = null;
                if (file != null) {
                    destinationPath = file.getAbsolutePath();
                    saveFileFromUri(context, uri, destinationPath);
                }

                return destinationPath;
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                    final String selection = "_id=?";
                    final String[] selectionArgs = new String[]{
                            split[1]
                    };

                    return getDataColumn(context, contentUri, selection, selectionArgs);

                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                    final String selection = "_id=?";
                    final String[] selectionArgs = new String[]{
                            split[1]
                    };

                    return getDataColumn(context, contentUri, selection, selectionArgs);

                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                    final String selection = "_id=?";
                    final String[] selectionArgs = new String[]{
                            split[1]
                    };

                    return getDataColumn(context, contentUri, selection, selectionArgs);

                }
                else {
                    final String id = DocumentsContract.getDocumentId(uri);
                    if (id != null && id.startsWith("raw:")) {
                        return id.substring(4);
                    }
                    String[] contentUriPrefixesToTry = new String[]{
                            "content://downloads/public_downloads",
                            "content://downloads/my_downloads",
                    };

                    for (String contentUriPrefix : contentUriPrefixesToTry) {
//                    Uri contentUri = ContentUris.withAppendedId(Uri.parse(contentUriPrefix), Long.valueOf(id));
                        try {
                            String path = getDataColumn(context, uri, null, null);
                            if (path != null) {
                                return path;
                            }
                        } catch (Exception e) {
                        }
                    }
                    // path could not be retrieved using ContentResolver, therefore copy file to accessible cache using streams
                    String fileName = getFileName(context, uri);
                    File cacheDir = getDocumentCacheDir(context);
                    File file = generateFileName(fileName, cacheDir);
                    String destinationPath = null;
                    if (file != null) {
                        destinationPath = file.getAbsolutePath();
                        saveFileFromUri(context, uri, destinationPath);
                    }

                    return destinationPath;
                }
            }else if (isGoogleDriveUri(uri)) {
                return getDriveFilePath(uri, context);
            }
        }
//        else if (isGoogleDriveUri(uri)){
//            return getDriveFilePath(uri, context);
//        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            if (isGoogleDriveUri(uri)){
                return getDriveFilePath(uri, context);
            }else {
                return getDataColumn(context, uri, null, null);
            }
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }


    private static boolean isGoogleDriveUri(Uri uri) {
        return "com.google.android.apps.docs.storage".equals(uri.getAuthority()) || "com.google.android.apps.docs.storage.legacy".equals(uri.getAuthority());
    }

    public static String getDataColumn(Context context, Uri uri, String selection, String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }


    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }


    public static String getFileName(@NonNull Context context, Uri uri) {
        String mimeType = context.getContentResolver().getType(uri);
        String filename = null;

        if (mimeType == null && context != null) {
            String path = getPath(context, uri);
            if (path == null) {
                filename = getName(uri.toString());
            } else {
                File file = new File(path);
                filename = file.getName();
            }
        } else {
            Cursor returnCursor = context.getContentResolver().query(uri, null,
                    null, null, null);
            if (returnCursor != null) {
                int nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                returnCursor.moveToFirst();
                filename = returnCursor.getString(nameIndex);
                returnCursor.close();
            }
        }

        return filename;
    }

    public static String getName(String filename) {
        if (filename == null) {
            return null;
        }
        int index = filename.lastIndexOf('/');
        return filename.substring(index + 1);
    }

    private static void saveFileFromUri(Context context, Uri uri, String destinationPath) {
        InputStream is = null;
        BufferedOutputStream bos = null;
        try {
            is = context.getContentResolver().openInputStream(uri);
            bos = new BufferedOutputStream(new FileOutputStream(destinationPath, false));
            byte[] buf = new byte[1024];
            is.read(buf);
            do {
                bos.write(buf);
            } while (is.read(buf) != -1);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (is != null) is.close();
                if (bos != null) bos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static File getDocumentCacheDir(@NonNull Context context) {
        File dir = new File(context.getCacheDir(), DOCUMENTS_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        logDir(context.getCacheDir());
        logDir(dir);

        return dir;
    }

    private static void logDir(File dir) {
        if (!DEBUG) return;
        File[] files = dir.listFiles();
        for (File file : files) {

        }
    }

    @Nullable
    public static File generateFileName(@Nullable String name, File directory) {
        if (name == null) {
            return null;
        }

        File file = new File(directory, name);

        if (file.exists()) {
            String fileName = name;
            String extension = "";
            int dotIndex = name.lastIndexOf('.');
            if (dotIndex > 0) {
                fileName = name.substring(0, dotIndex);
                extension = name.substring(dotIndex);
            }

            int index = 0;

            while (file.exists()) {
                index++;
                name = fileName + '(' + index + ')' + extension;
                file = new File(directory, name);
            }
        }

        try {
            if (!file.createNewFile()) {
                return null;
            }
        } catch (IOException e) {
            return null;
        }

        logDir(directory);

        return file;
    }

    private static String getDriveFilePath(Uri uri, Context context) {
        Uri returnUri = uri;
        Cursor returnCursor = context.getContentResolver().query(returnUri, null, null, null, null);
        /*
         * Get the column indexes of the data in the Cursor,
         *     * move to the first row in the Cursor, get the data,
         *     * and display it.
         * */
        int nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
        int sizeIndex = returnCursor.getColumnIndex(OpenableColumns.SIZE);
        returnCursor.moveToFirst();
        String name = (returnCursor.getString(nameIndex));
        String size = (Long.toString(returnCursor.getLong(sizeIndex)));
        File file = new File(context.getCacheDir(), name);
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            FileOutputStream outputStream = new FileOutputStream(file);
            int read = 0;
            int maxBufferSize = 1 * 1024 * 1024;
            int bytesAvailable = inputStream.available();

            //int bufferSize = 1024;
            int bufferSize = Math.min(bytesAvailable, maxBufferSize);

            final byte[] buffers = new byte[bufferSize];
            while ((read = inputStream.read(buffers)) != -1) {
                outputStream.write(buffers, 0, read);
            }
            Log.e("File Size", "Size " + file.length());
            inputStream.close();
            outputStream.close();
            Log.e("File Path", "Path " + file.getPath());
            Log.e("File Size", "Size " + file.length());
        } catch (Exception e) {
            Log.e("Exception", e.getMessage());
        }
        return file.getPath();
    }

}