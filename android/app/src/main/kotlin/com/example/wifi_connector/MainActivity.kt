package com.example.wifi_connector

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkRequest
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSuggestion
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Cria o canal com o mesmo nome do flutter
        val connectorChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wifi_connector/connector")
        // Define o handler para o canal
        connectorChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                // Se for o método connectWifi, executa a função de conectar na rede wifi
                "connectWifi" -> {
                    // Obtém o ssid e a senha dos argumentos do método
                    val ssid = call.argument<String>("ssid")
                    val senha = call.argument<String>("senha")

                    // Chama a função de conectar na rede wifi com o ssid e a senha
                    connectWifi(ssid, senha, result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun connectWifi(ssid: String?, senha: String?, result: MethodChannel.Result) {
        if (ssid == null || senha == null) {
            result.error("Invalid arguments", "SSID and password cannot be null", null)
            return
        }
        val wifiNetworkSuggestion = WifiNetworkSuggestion.Builder()
            .setSsid(ssid)
            .setWpa2Passphrase(senha)
            .setIsAppInteractionRequired(true) // This forces user interaction for connection
            .build()
        val suggestionsList = listOf(wifiNetworkSuggestion)
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val status = wifiManager.addNetworkSuggestions(suggestionsList)
        if (status == WifiManager.STATUS_NETWORK_SUGGESTIONS_SUCCESS) {
            result.success("Network suggestion added")
        } else {
            result.error("Failed to add network suggestion", "Status code: $status", null)
        }
    }
}

