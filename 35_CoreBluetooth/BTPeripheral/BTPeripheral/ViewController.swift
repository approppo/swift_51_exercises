import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    let CHARACTERISTIC_ID = CBUUID(string: "B6187EC7-681B-49F7-BE07-9BBF746614CC")
    let SERVICE_ID = CBUUID(string: "1F869C89-68CA-49D8-8954-90B77841550C")
    var peripheralManager : CBPeripheralManager?
    var characteristic : CBMutableCharacteristic?

    var sendingEOM = false
    var dataToSend : Data?
    var dataIndex = 0
    let DATA_LENGTH = 20

    var ready = false {
        didSet {
            textView.backgroundColor = ready ? .green : .red
        }
    }

    @IBOutlet weak var textView: UITextView!

    @IBAction func send(_ sender: Any) {
        if ready {
            if let text = textView.text,
                let data = text.data(using: .utf8) {
                textView.text = "";
                textView.resignFirstResponder()
                dataToSend = data
                dataIndex = 0
                send()
            }
        }
    }

    @IBAction func clear(_ sender: Any) {
        textView.text = ""
    }

    // tag::viewdidload[]
    override func viewDidLoad() {
        super.viewDidLoad()

        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        characteristic = CBMutableCharacteristic(type: CHARACTERISTIC_ID,
                                                 properties: .notify,
                                                 value: nil,
                                                 permissions: .readable)
        ready = false
    }
    // end::viewdidload[]

    // tag::didupdatestate[]
    // Called when the CBPeripheralManager object is ready and powered on
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state != .poweredOn {
            return
        }

        let transferService = CBMutableService(type: SERVICE_ID,
                                               primary: true)
        transferService.characteristics = [characteristic!]
        peripheralManager?.add(transferService)

        let advertisement = [CBAdvertisementDataServiceUUIDsKey : [SERVICE_ID]]
        peripheralManager?.startAdvertising(advertisement)
    }
    // end::didupdatestate[]

    // tag::didsubscribeto[]
    // Catch when someone subscribes to our characteristic, then start sending them data
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           central: CBCentral,
                           didSubscribeTo characteristic: CBCharacteristic) {
        ready = true
        dataIndex = 0
    }
    // end::didsubscribeto[]

    // tag::didunsuscribe[]
    // The Central has unsuscribed
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           central: CBCentral,
                           didUnsubscribeFrom characteristic: CBCharacteristic) {
        ready = false
    }
    // end::didunsuscribe[]

    // tag::isready[]
    // This callback comes in when the PeripheralManager is ready to
    // send the next chunk of data. This is to ensure that packets
    // will arrive in the order they are sent
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        send()
    }
    // end::isready[]

    // tag::send[]
    // This method actually sends the data
    func send() {
        if sendingEOM {
            sendEndOfMessage()
            return
        }

        if dataIndex >= dataToSend!.count {
            // No data left, do nothing
            return
        }

        // There's data left, so send until the callback fails, or we're done.
        var didSend = true;

        while didSend {
            var amountToSend = dataToSend!.count - dataIndex
            if amountToSend > DATA_LENGTH {
                // There is a maximum of 20 bytes per packet
                amountToSend = DATA_LENGTH
            }

            // Copy the data we want to send
            let chunk = NSData(bytes: (dataToSend! as NSData).bytes + dataIndex,
                               length: amountToSend)

            // Send the data
            didSend = peripheralManager!.updateValue(chunk as Data,
                                                     for: characteristic!,
                                                     onSubscribedCentrals: nil)

            // If it didn't work, drop out and wait for the callback
            if !didSend {
                return
            }

            // It did send, so update our index
            dataIndex += amountToSend

            // Was it the last one?
            if dataIndex >= dataToSend!.count {
                // It was - send an EOM
                sendEndOfMessage()
                return
            }
        }
    }
    // end::send[]

    // tag::sendeom[]
    // Sends a special code to the Central to indicate that we're done sending data
    func sendEndOfMessage() {
        // We set this flag so that if the call to updateValue() fails, it will try again later
        sendingEOM = true
        let EOM = "EOM".data(using: .utf8)!
        let sent = peripheralManager!.updateValue(EOM,
                                                  for: characteristic!,
                                                  onSubscribedCentrals: nil)
        if sent {
            sendingEOM = false
        }
    }
    // end::sendeom[]
}
