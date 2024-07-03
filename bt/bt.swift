import IOBluetooth
// See https://developer.apple.com/reference/iobluetooth/iobluetoothdevice
// for API details.
class BluetoothDevices {
    func pairedDevices() -> [Any] {
        print("Bluetooth devices:")
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return []
        }
        return devices
//        for item in devices {
//            if let device = item as? IOBluetoothDevice {
//                print("Name: \(device.name)")
//                print("Paired?: \(device.isPaired())")
//                print("Connected?: \(device.isConnected())")
//            }
//        }
    }
    func getConnectedDevices() -> [String] {
        guard let devices = IOBluetoothDevice.pairedDevices() else{
            print("NONE")
            return []
        }
        var temp = [String]()
        for item in devices {
            if let device = item as? IOBluetoothDevice{
                if(device.isConnected()){
                    temp.append(device.name)
                }
            }
        }
        return temp
    }
}

