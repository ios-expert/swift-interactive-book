//
//  StartController.swift
//  True Story
//
//  Created by Maxim on 13/10/2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class StartController: UIViewController, WebControllerProtocol {
    
    @IBOutlet weak var startHolder: UIView!
    @IBOutlet weak var loadingIndicatorHolder: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var web: WebController?
    var rawData: Data? = nil
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Localization strings stored in Localizable.strings file
        translateUI()
        
        // Siri tells localized welcome message
        SpeakController.shared().speak("SiriWelcome".localized())
    }

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            if let nextScene = segue.destination as? GameController {
                // Pass data to new controller
                nextScene.rawData = rawData
                // Translate navigation button
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localized(), style: .plain, target: nil, action: nil)
            }
        }
    }
    
    // MARK: - BUTTONS
    @IBAction func ruButtonClicked(_ sender: Any) {
        UserDefaults.standard.set("ru", forKey: "AppLanguage")
        SpeakController.shared().speak("SiriTranslate".localized())
        translateUI()
    }
    
    @IBAction func enButtonClicked(_ sender: Any) {
        UserDefaults.standard.set("en", forKey: "AppLanguage")
        SpeakController.shared().speak("SiriTranslate".localized())
        translateUI()
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        setLoadingIndicatorState(visible: true)
        SpeakController.shared().speak("SiriStart".localized())
        
        // Init WebController and download file from https url
        web = WebController(self, attemptsCount: 5, delaySeconds: 5)
        web?.sendGetRequestToServer(url: AppData.shared().dbUrl())
    }
    
    func setLoadingIndicatorState(visible: Bool) {
        loadingIndicatorHolder.isHidden = !visible
        self.view.isUserInteractionEnabled = !visible
    }
    
    func translateUI() {
        topLabel.text = "Header".localized()
        middleLabel.text = "Welcome".localized()
        startButton.setTitle("Start".localized(), for: .normal)
    }
    
    // MARK: - CALLBACK FUNCTION FROM WEB CONTROLLER
    func dataFromServer(data: Data?, error: Error?) {
        setLoadingIndicatorState(visible: false)
        if error != nil {
            self.showErrorMessage("Server is not responsible, try later".localized())
        } else if data != nil {
            self.rawData = data
            self.performSegue(withIdentifier: "goToGame", sender: self)
        }
    }
    
    func showErrorMessage(_ message: String) {
        let title = "Error".localized()
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}
