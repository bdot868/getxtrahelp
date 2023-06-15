package com.app.xtrahelpcaregiver.apiCalling


import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitClient {

    //Live
    private const val BASE_URL = "https://app.getxtrahelp.com/api/" // Development
    const val IMAGE_URL = "https://app-xtrahelp/assets/uploads/" // Development
    const val webSocketUrl = "wss://app.getxtrahelp.com:9023"

    //Test
//    private const val BASE_URL = "http://project.greatwisher.com/app-xtrahelp/api/" // Development
//    const val IMAGE_URL = "http://project.greatwisher.com/app-xtrahelp/assets/uploads/" // Development
//    const val webSocketUrl = "ws://project.greatwisher.com:9023"


    //    private const val BASE_URL = "http://project.greatwisher.com/app-xtrahelp/api/"
    //    private const val BASE_URL = "http://192.168.0.108/app-xtrahelp/api/"

    
    val getClient: APIService
        get() {
            val gson = GsonBuilder()
                .setLenient()
                .create()
            val interceptor = HttpLoggingInterceptor()
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
            val client = OkHttpClient.Builder()
                .addInterceptor(interceptor)
                .connectTimeout(100, TimeUnit.SECONDS)
                .readTimeout(100, TimeUnit.SECONDS)
                .build()
            val retrofit = Retrofit.Builder()
                .baseUrl(BASE_URL)
                .client(client)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build()

            return retrofit.create(APIService::class.java)

        }
}