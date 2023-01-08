//
//  SettingsViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var temperatureUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var userName: TitledTextField!
    @IBOutlet weak var userPictureButton: UIButton!
    @IBOutlet weak var tempUnitLabel: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    
    private let settingCellIdentifier = "SettingCell"
    
    private var datasOfCurrentCityTableView = [City]()
    private var datasOfDestinationCityTableView = [City]()
    
    /// List of Language Enum with alphabetical sorting
    private var languagesList: [Languages] = (Languages.allCases.map { $0 }).sorted { $0.description < $1.description }
    
    
    // MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate and DataSource
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        self.settingsTableView.dataSource = self
        self.settingsTableView.delegate = self
        userName.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupUserSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueToSearchCity {
            let VC = segue.destination as? SearchCityViewController
            let cityType = sender as? CityType
            VC?.cityType = cityType ?? .current
        }
    }
    
    
    // MARK: IBAction
    @IBAction func temperatureUnitChange(_ sender: Any) {
        let temperatureUnitIndex = temperatureUnitSegmentedControl.selectedSegmentIndex
        let temperatureUnit: TemperatureUnit
        if temperatureUnitIndex == 0 {
            temperatureUnit = .Kelvin
        } else if temperatureUnitIndex == 1 {
            temperatureUnit = .Celsius
        } else {
            temperatureUnit = .Fahrenheit
        }
        UserSettings.temperatureUnit = temperatureUnit
        NotificationCenter.default.post(name: .newTemperatureUnit, object: nil)
    }
    
    @IBAction func didClickUserPictureButton(_ sender: Any) {
        showImagePickerOption()
    }
    
    @IBAction func validateButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func userNamehasBeenEdited(_ sender: Any) {
        if let userName = userName.text {
            UserSettings.userName = userName
        }
    }
    
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    
    // MARK: private function
    private func setupUI() {
        // ValidateButton
        validateButton.setTitle("validate".localized(), for: .normal)
        // UserPicture
        userPictureButton.layer.masksToBounds = true
        userPictureButton.layer.cornerRadius = 50
        // userNameTextField
        userName.placeholder = "username".localized()
        userName.title = "username".localized()
        // temperature Unit, SegmentControl
        tempUnitLabel.text = "temp.unit.label".localized()
        temperatureUnitSegmentedControl.removeAllSegments()
        TemperatureUnit.allCases.forEach {
            temperatureUnitSegmentedControl.insertSegment(withTitle: $0.rawValue,
                                                          at: temperatureUnitSegmentedControl.numberOfSegments,
                                                          animated: false)
        }
    }
    
    /// Function to refresh the screen with the updated userPicture, userName, settingsTableView and temperatureUnit.
    private func setupUserSettings() {
        // UserPictureButton
        if let userPicture = UserSettings.userPicture {
            addImageInUserPicture(image: userPicture)
        } else {
            userPictureButton.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill"),
                                                for: UIControl.State.normal)
        }
        // TextField
        userName.text = UserSettings.userName
        // TableView
        settingsTableView.reloadData()
        // SelectedSegment
        switch UserSettings.temperatureUnit {
            case .Kelvin: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 0
            case .Celsius: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 1
            case .Fahrenheit: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 2
        }
    }
    
    /// Dismiss Keyboard
    private func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
}



// MARK: UITableView
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Number of sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Number of cells in each section
    }
    
    // Add cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellIdentifier, for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "language".localized()
            cell.detailTextLabel?.text = UserSettings.userLanguage.description
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "current.city".localized()
            if let city = UserSettings.currentCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.userLanguage)
            } else {
                cell.detailTextLabel?.text = "city.not.specified".localized()
            }
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "destination.city".localized()
            if let city = UserSettings.destinationCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.userLanguage)
            } else {
                cell.detailTextLabel?.text = "city.not.specified".localized()
            }
        } else { }
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    // When user clicks on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: .segueToSearchLanguage, sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: .segueToSearchCity, sender: CityType.current)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: .segueToSearchCity, sender: CityType.destination)
        }
    }
}


// MARK: UITextField
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss KeyBoard
        return true
    }
}


// MARK: ImagePicker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Function displaying a popup to choose the source (library or camera) in order to add an image.
    private func showImagePickerOption() {
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .default) { _ in
            self.cameraAuthorization()
        }
        let libraryAction = UIAlertAction(title: "library".localized(), style: .default) { _ in
            self.photosAutorization()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil)
        self.alertUser(title: "pick.photo".localized(),
                       message: "image.picker.alert.user.message".localized(),
                       actions: [cameraAction, libraryAction, cancelAction], preferredStyle: .actionSheet)
    }

    /// Function verifying and/or requesting authorizations for the use of the camera
    private func cameraAuthorization() {
        // Authorization for Camera
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.imagePicker(sourceType: .camera)
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.imagePicker(sourceType: .camera)
                    }
                }
            }
        case .denied: // The user has previously denied access.
                let settingsAction = UIAlertAction(title: "settings".localized(), style: .default) { _ in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil)
                self.alertUser(title: "settings".localized(),
                               message: "no.permission.access.camera.message".localized(),
                               actions: [settingsAction, cancelAction])
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            return
        }
    }

    /// Function verifying and/or requesting authorizations for the use of the library
    private func photosAutorization() {
        // Authorization for Photos
        var authorizationStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        switch authorizationStatus {
        case .authorized: // The user has previously granted access to the photo.
            self.imagePicker(sourceType: .photoLibrary)
        case .limited:
            self.imagePicker(sourceType: .photoLibrary)
        case .notDetermined: // The user has not yet been asked for photos access.
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            self.imagePicker(sourceType: .photoLibrary)
                        } else if status == .limited {
                            self.imagePicker(sourceType: .photoLibrary)
                        }
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.imagePicker(sourceType: .photoLibrary)
                    }
                }
            }
        case .denied: // The user has previously denied access.
                let settingsAction = UIAlertAction(title: "settings".localized(), style: .default) { _ in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil)
                self.alertUser(title: "settings".localized(),
                               message: "no.permission.access.library.message".localized(),
                               actions: [settingsAction, cancelAction])
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            fatalError()
        }
    }

    private func imagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.present(imagePicker, animated: true) {}
    }
    
    // When the user selects an image or takes a photo
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            UserSettings.userPicture = image
            addImageInUserPicture(image: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // To add the photo to the button
    func addImageInUserPicture(image: UIImage) {
        userPictureButton.setImage(image, for: .normal)
        userPictureButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
    }

}
