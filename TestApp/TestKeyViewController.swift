
import UIKit
import Alamofire
import CryptoSwift
import CommonCrypto
import RxSwift

// MARK: AES
struct AES {
    private let key: Data
    private let iv: Data
    
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Failed set key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error")
            return nil
        }
        self.key = keyData
        self.iv  = ivData
    }
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

// MARK: KeychainTest
final class KeychainTest {
    
    static let standard = KeychainTest()
    private init() {}
    
    func save(_ data: Data, service: String, account: String) {
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}




class TestKeyViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var pwdBtn: UIButton!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var pwdRenewLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    
    weak var serverAnswerTimer: Timer?
    weak var pwdTapBtnTimer: Timer?
    weak var oneDayStartTimer: Timer?
    var secondsServerWait = 10
    var secondsBtnWait = 20
    var secondsOneDay = 300
    var pwdRenewed = "Пароль продлен!"
    var pwdError = "Ошибка попробуйте через 5 минут"
    var test = 2
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 60
        pwdBtn.layer.cornerRadius = 15
        keyLabel.text = random(digits: 6)
        let accessLogin = "Khabibullin.AR"
        let dataLogin = Data(accessLogin.utf8)
        KeychainTest.standard.save(dataLogin, service: "login", account: "GPN")
        //        if UserDefaults.standard.bool(forKey: "oneTapInDay") {
        //            pwdBtn.isEnabled = UserDefaults.standard.bool(forKey: "oneTapInDay")
        //        }
    }
    
    @IBAction func actionBtn(_ sender: UIButton) {
        keychainQuery()
        secondsServerWait = 10
        secondsBtnWait = 20
        secondsOneDay = 300
        test = 1
        createServerTimer()
    }
    
    @objc func tapBtnTimer() {
        if secondsServerWait != 0 {
            pwdBtn.isEnabled = false
            UIView.animate(withDuration: 0.7) {
                self.pwdRenewLabel.text = "Ожидайте ответа о продлении пароля: \(self.secondsServerWait)"
            }
            secondsServerWait -= 1
        }
        else if secondsServerWait == 0 {
            self.serverAnswerTimer?.invalidate()
            if test == 1 {
                pwdRenewLabel.text = pwdRenewed
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                                        self.pwdRenewLabel.text = ""
//                                }
                pwdBtn.isEnabled = true
            }
            if test != 1 {
                createBtnTimer()
            }
        }
    }
    @objc func pwdBtnTimer() {
        if secondsBtnWait != 0 {
                self.pwdRenewLabel.text = "Ошибка! Попробовать снова через: \(self.secondsBtnWait)"
            secondsBtnWait -= 1
        }
        else if secondsBtnWait == 0 {
            pwdRenewLabel.text = ""
            pwdBtn.isEnabled = true
            self.pwdTapBtnTimer?.invalidate()
        }
    }
    @objc func oneDayTimer() {
        if secondsOneDay != 0 {
            UserDefaults.standard.set(pwdBtn.isEnabled = false, forKey: "oneTapInDay")
            pwdBtn.isEnabled = false
            pwdRenewLabel.text = "Вы уже продлили пароль на сутки"
            secondsOneDay -= 1
        }
        else {
            self.oneDayStartTimer?.invalidate()
            pwdBtn.isEnabled = true
            UserDefaults.standard.removeObject(forKey: "oneTapInDay")
        }
    }
    
    func createDayTimer() {
        oneDayStartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(oneDayTimer), userInfo: nil, repeats: true)
    }
    
    func createServerTimer() {
        serverAnswerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tapBtnTimer), userInfo: nil, repeats: true)
    }
    func createBtnTimer() {
        pwdTapBtnTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(pwdBtnTimer), userInfo: nil, repeats: true)
    }
    func currentTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print(hour)
        print(minutes)
    }
    func keychainQuery() {
        guard let dataTest = KeychainTest.standard.read(service: "login", account: "GPN") else {return}
        let accessTokenTest = String(data: dataTest, encoding: .utf8)
        let disposableKey = keyLabel.text
        let key128   = "1234567890123456"
        let key256   = "12345678901234561234567890123456"
        let iv       = "abcdefghijklmnop"
        let aes128 = AES(key: key128, iv: iv)
        let aes256 = AES(key: key256, iv: iv)
        
        let encryptedLogin = aes128?.encrypt(string: accessTokenTest ?? "no data")
        let decryptedLogin = aes128?.decrypt(data: encryptedLogin)
        print("==================== AES login ===================")
        print(encryptedLogin)
        print(decryptedLogin)
        let encryptedKey = aes128?.encrypt(string: disposableKey ?? "no data")
        let decryptedKey = aes128?.decrypt(data: encryptedKey)
        print("==================== AES key ===================")
        print(encryptedKey)
        print(decryptedKey)
        
}
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}
 
