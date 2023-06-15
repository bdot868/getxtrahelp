package com.app.xtrahelpcaregiver.Adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;

import com.app.xtrahelpcaregiver.Utils.Const;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

//import static com.google.android.gms.internal.zzagy.runOnUiThread;

public class AdpOfDestinationAddress extends ArrayAdapter<String> implements Filterable {
    private static final String LOG_TAG = "AdpOfDesinationAddress";
    private static final String PLACES_API_BASE = "https://maps.googleapis.com/maps/api/place";
    //private static final String PLACE_DETAILS = "https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJYxUdQVlO4DsRQrA4CSlYRf4&key=AIzaSyCLZcxTxWWEAqqK71XKRmTG39g8N0eg1Ak";
    private static final String TYPE_AUTOCOMPLETE = "/autocomplete";
    private static final String OUT_JSON = "/json";

    public AdpOfDestinationAddress(Context context, int resource, int text1) {
        super(context, resource, text1);

    }

    @Override
    public int getCount() {
        return Const.placeList.size();
    }

    @Override
    public String getItem(int position) {
        return Const.placeList.get(position).getDescription();
    }

    @Override
    public Filter getFilter() {
        Filter filter = new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                FilterResults filterResults = new FilterResults();
                if (constraint != null) {
                    Const.placeList = (ArrayList<AddressDataWithPlace>) autoComplete(constraint.toString());
                    filterResults.values = Const.placeList;
                    filterResults.count = Const.placeList.size();
                }
                return filterResults;
            }

            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {

                if (results != null && results.count > 0) {
                    notifyDataSetChanged();
                } else {
                    notifyDataSetInvalidated();
                }

            }
        };
        return filter;
    }

    @SuppressLint("LongLogTag")
    public static List<AddressDataWithPlace> autoComplete(String input) {
        HttpURLConnection conn = null;
        final StringBuilder jsonResults = new StringBuilder();
        try {
            StringBuilder sb = new StringBuilder(PLACES_API_BASE + TYPE_AUTOCOMPLETE + OUT_JSON);
            sb.append("?key=" + Const.GOOGLE_MAP_API_KEY_FOR_PLACE);
            //   sb.append("&components=country:" + Const.countrCodeKey);
            sb.append("&input=" + URLEncoder.encode(input, "utf8"));
            URL url = new URL(sb.toString());
            conn = (HttpURLConnection) url.openConnection();
            InputStreamReader in = new InputStreamReader(conn.getInputStream());
            int read;
            char[] buff = new char[1024];
            while ((read = in.read(buff)) != -1) {
                jsonResults.append(buff, 0, read);
            }
        } catch (MalformedURLException e) {
            Log.e(LOG_TAG, "Error processing Places API URL", e);
            return new ArrayList<AddressDataWithPlace>();
        } catch (IOException e) {
            Log.e(LOG_TAG, "Error connecting to Places API", e);
            return new ArrayList<AddressDataWithPlace>();
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }

        try {
            JSONObject jsonObj = new JSONObject(jsonResults.toString());
            JSONArray predsJsonArray = jsonObj.getJSONArray("predictions");
            Const.placeList = new ArrayList<AddressDataWithPlace>();

            for (int i = 0; i < predsJsonArray.length(); i++) {

                AddressDataWithPlace addressDataWithPlace2 = new AddressDataWithPlace();
                addressDataWithPlace2.setDescription(predsJsonArray.getJSONObject(i).getString("description"));
                addressDataWithPlace2.setPlace_id(predsJsonArray.getJSONObject(i).getString("place_id"));
                if (Const.placeList == null) {
                    Const.placeList = new ArrayList<>();
                }
                Const.placeList.add(addressDataWithPlace2);
                try {

                } catch (Exception e) {

                }
            }
        } catch (JSONException e) {
            Log.e(LOG_TAG, "Cannot process JSON results", e);
        }

        return Const.placeList;
    }

}