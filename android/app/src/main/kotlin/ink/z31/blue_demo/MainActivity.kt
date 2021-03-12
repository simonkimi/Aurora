package ink.z31.blue_demo

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import ink.z31.blue_demo.data.BleDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "ink.z31.blue_demo/method"
        private const val FIND_DEVICE = 1
        private const val REQUEST_FINE_LOCATION_PERMISSIONS = 0;
    }

    private var bluetoothAdapter: BluetoothAdapter? = null
    private lateinit var pendingCall: MethodCall
    private lateinit var pendingResult: Result
    private lateinit var channel: MethodChannel

    private val scanResultSet = mutableSetOf<BleDevice>()


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()

        channel = MethodChannel(flutterEngine.dartExecutor, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> result.success(bluetoothAdapter != null)
                "isOn" -> result.success(bluetoothAdapter!!.isEnabled)
                "on" -> result.success(bluetoothAdapter!!.enable())
                "startScan" -> {
                    if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                            != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(
                                this,
                                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                                REQUEST_FINE_LOCATION_PERMISSIONS)
                        pendingCall = call
                        pendingResult = result
                        return@setMethodCallHandler;
                    }
                    startScan(call, result)
                }
            }


        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_FINE_LOCATION_PERMISSIONS) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startScan(pendingCall, pendingResult)
            } else {
                pendingResult.error("Permission denied", "No permission", null)
            }

        }
    }

    private fun startScan(call: MethodCall, result: Result) {
        val scanner = bluetoothAdapter!!.bluetoothLeScanner
        if (scanner == null) {
            result.error("Scanner is null", "bluetoothLeScanner is null", null)
        }
        scanResultSet.clear()
        scanner.startScan(object : ScanCallback() {
            override fun onScanResult(callbackType: Int, scanResult: ScanResult?) {
                super.onScanResult(callbackType, scanResult)
                scanResult?.let {
                    scanResultSet.add(BleDevice(
                            mac = it.device.address,
                            name = it.device.name
                    ))
                    invokeMethodUIThread("scanResult", scanResultSet.toList())
                }
            }
        })
    }

    private fun invokeMethodUIThread(name: String, objects: Any) {
        activity.runOnUiThread { channel.invokeMethod(name, objects) }
    }
}



