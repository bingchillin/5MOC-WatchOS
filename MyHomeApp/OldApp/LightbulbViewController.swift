
import UIKit
import HomeKit

//https://developer.apple.com/documentation/homekit/characteristic-types#Light
class LightbulbViewController: UIViewController {

    static func newInstance(home: HMHome, accessory: HMAccessory) -> LightbulbViewController {
        let controller = LightbulbViewController()
        controller.home = home
        controller.accessory = accessory
        return controller
    }
    
    var home: HMHome!
    @IBOutlet weak var brightnessSlider: UISlider!
    var accessory: HMAccessory!
    
    var lightbulbService: HMService? {
        return self.accessory.services.first { service in
            return service.serviceType == HMServiceTypeLightbulb
        }
    }
    
    var brightnessCharacteristic: HMCharacteristic? {
        return self.lightbulbService?.characteristics.first { ch in
            return ch.characteristicType == HMCharacteristicTypeBrightness
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bc = self.brightnessCharacteristic {
            self.brightnessSlider.isEnabled = bc.properties.contains(where: { el in
                el == HMCharacteristicPropertyWritable
            })
            bc.readValue { err in
                DispatchQueue.main.async {
                    // sliderValue 0-100
                    if let value = bc.value as? Float {
                        self.brightnessSlider.value = value
                    }
                }
            }
        }
    }

    @IBAction func handleBrighnessSlide(_ sender: UISlider) {
        self.brightnessCharacteristic?.writeValue(sender.value, completionHandler: { err in
            print(err)
        })
    }
    
}
