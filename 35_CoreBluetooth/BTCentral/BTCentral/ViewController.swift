import UIKit
import CoreBluetooth

enum State {
    case idle
    case foundPeripheral
    case scanningServices
    case scanningCharacteristics
    case ready
}

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager : CBCentralManager?
    var discoveredPeripheral : CBPeripheral?
    var data : Data?
    var state = State.idle {
        didSet {
            switch state {
            case .idle:
                textView.backgroundColor = .red
            case .foundPeripheral:
                textView.backgroundColor = .orange
            case .scanningServices:
                textView.backgroundColor = .purple
            case .scanningCharacteristics:
                textView.backgroundColor = .yellow
            case .ready:
                textView.backgroundColor = .green
            }
        }
    }
    
    // tag::uuid[]
    let CHARACTERISTIC_ID = CBUUID(string: "B6187EC7-681B-49F7-BE07-9BBF746614CC")
    let SERVICE_ID = CBUUID(string: "1F869C89-68CA-49D8-8954-90B77841550C")
    // end::uuid[]
    
    @IBOutlet weak var textView: UITextView!
    
    // tag::viewdidload[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        data = Data()
        state = .idle
    }
    // end::viewdidload[]
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cleanup()
        centralManager?.stopScan()
    }
    
    // tag::scan[]
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Only start scanning if the power is on
        if central.state != .poweredOn {
            return
        }
        
        scan()
    }
    
    func scan() {
        let opts = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        centralManager?.scanForPeripherals(withServices: [SERVICE_ID],
                                           options: opts)
    }
    // end::scan[]
    
    // tag::discover[]
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if RSSI.intValue > -15 {
            return
        }
        
        // Reject if the signal strength is too low to be close enough
        // ("close" is around -22 dB)
        if RSSI.intValue < -35 {
            return
        }
        
        print("Discovered \(String(describing: peripheral.name!)) at \(RSSI)")
        state = .foundPeripheral
        
        // Ok, it's in range - have we already seen it?
        if peripheral != discoveredPeripheral {
            discoveredPeripheral = peripheral
            
            // Connect!
            print("Connecting to peripheral \(String(describing: peripheral.name!))")
            centralManager?.connect(peripheral, options: nil)
        }
    }
    // end::discover[]
    
    // tag::fail[]
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        print("Failed to connect to peripheral \(String(describing: peripheral.name!))")
        cleanup()
    }
    // end::fail[]
    
    // tag::connect[]
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        data = Data()
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_ID])
        state = .scanningServices
    }
    // end::connect[]
    
    // tag::disconnect[]
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        print("Peripheral disconnected")
        discoveredPeripheral = nil
        state = .idle
        scan()
    }
    // end::disconnect[]
    
    // tag::characteristics[]
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Error discovering services")
            cleanup()
            return
        }
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CHARACTERISTIC_ID],
                                               for: service)
        }
        state = .scanningCharacteristics
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if error != nil {
            print("Error discovering characteristics")
            cleanup()
            return
        }
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == CHARACTERISTIC_ID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        state = .ready
    }
    // end::characteristics[]
    
    // tag::receive[]
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if error != nil {
            print("Error updating value for characteristic")
            cleanup()
            return
        }
        
        let str = String(data: characteristic.value!, encoding: .utf8)
        
        if str == "EOM" {
            // We received the "End Of Message" signal, we can display our string
            let message = String(data: data!, encoding: .utf8)!
            textView.text = """
            \(textView.text ?? "")
            \(Date().description): \(message)
            """
            
            // Reset the data placeholder
            data = Data()
            return
        }
        
        // Append the new data to the one already received
        data?.append(characteristic.value!)
    }
    // end::receive[]
    
    func cleanup() {
        if let peripheral = discoveredPeripheral {
            if peripheral.state != .connected {
                return
            }
            
            if let servs = peripheral.services {
                for serv in servs {
                    if let chars = serv.characteristics {
                        for char in chars {
                            if char.uuid == CHARACTERISTIC_ID && char.isNotifying {
                                peripheral.setNotifyValue(false, for: char)
                            }
                        }
                    }
                }
            }
            centralManager?.cancelPeripheralConnection(peripheral)
            state = .idle
        }
    }
}
