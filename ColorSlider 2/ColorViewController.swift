//
//  ViewController.swift
//  ColorSlider 2
//
//  Created by Евгения Аникина on 18.03.2022.
//

import UIKit

class ColorViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    // MARK: - Class properties
    var delegate: ColorViewControllerDelegate!
    var color: UIColor! {
        didSet {
            guard isViewLoaded else { return }
            updateViews()
        }
    }

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 20

        addToolbar(for: redTextField, greenTextField, blueTextField)
        updateViews()
    }

    // MARK: - IBActions
    @IBAction func sliderMoved(_ sender: UISlider) {
        switch sender {
        case redSlider:
            updateColorComponents(red: CGFloat(redSlider.value), green: nil, blue: nil)
        case greenSlider:
            updateColorComponents(red: nil, green: CGFloat(greenSlider.value), blue: nil)
        default:
            updateColorComponents(red: nil, green: nil, blue: CGFloat(blueSlider.value))
        }
        updateViews()
    }
    
    @IBAction func DoneButtonPressed() {
        if let delegate = delegate, let color = colorView.backgroundColor {
            delegate.updateBackgroundColor(with: color)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    private func addToolbar(for textFields: UITextField...) {
        let toolbar = createToolbar()
        textFields.forEach() { textField in textField.inputAccessoryView = toolbar }
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.items = [flexibleItem, doneItem]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    @objc private func doneTapped() {
        view.endEditing(true)
    }
    
    private func updateViews() {
        updateSliders(redSlider, greenSlider, blueSlider)
        updateLabels(redValueLabel, greenValueLabel, blueValueLabel)
        updateTextFields(redTextField, greenTextField, blueTextField)
        updateColorView()
    }
    
    private func updateLabels(_ labels: UILabel...) {
        guard !labels.isEmpty else { return }
        
        let colorComponents = getColorComponents(from: color)
        
        labels.forEach() { label in
            switch label {
            case redValueLabel:
                redValueLabel.text = getColorText(from: colorComponents.red)
            case greenValueLabel:
                greenValueLabel.text = getColorText(from: colorComponents.green)
            default:
                blueValueLabel.text = getColorText(from: colorComponents.blue)
            }
        }
    }
    
    private func updateSliders(_ sliders: UISlider...) {
        let colorComponents = getColorComponents(from: color)
        
        redSlider.value = Float(colorComponents.red)
        greenSlider.value = Float(colorComponents.green)
        blueSlider.value = Float(colorComponents.blue)
    }
    
    private func updateTextFields(_ textFields: UITextField...) {
        guard !textFields.isEmpty else { return }
        
        let colorComponents = getColorComponents(from: color)
        
        textFields.forEach() { textField in
            switch textField {
            case redTextField:
                redTextField.text = getColorText(from: colorComponents.red)
            case greenTextField:
                greenTextField.text = getColorText(from: colorComponents.green)
            case blueTextField:
                blueTextField.text = getColorText(from: colorComponents.blue)
            default:
                break
            }
        }
    }

    private func updateColorView() {
        colorView.backgroundColor = color
    }
    
    private func updateColorComponents(red: CGFloat?, green: CGFloat?, blue: CGFloat?) {
        let currentColor = getColorComponents(from: color)
        
        color = UIColor(red: red ?? currentColor.red,
                        green: green ?? currentColor.green,
                        blue: blue ?? currentColor.blue,
                        alpha: CGFloat(1.0))
    }
    
    private func getColorText(from value: CGFloat) -> String {
        String(format: "%.2f", value)
    }
    
    private func getColorComponents(from color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (red, green, blue)
    }
}

extension ColorViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let isValidData = isValidData(of: textField)
        
        if (!isValidData) {
            showAlert(title: "Oops", message: "Wrong data format")
            
        }
        return isValidData
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case redTextField:
            updateColorComponents(red: getNumberFromTextField(redTextField), green: nil, blue: nil)
        case greenTextField:
            updateColorComponents(red: nil, green: getNumberFromTextField(greenTextField), blue: nil)
        default:
            updateColorComponents(red: nil, green: nil, blue: getNumberFromTextField(blueTextField))
        }
    }
    
    private func isValidData(of textField: UITextField) -> Bool {
        guard let text = textField.text, Float(text) != nil else { return false }
        return true
    }
    
    private func getNumberFromTextField(_ textField: UITextField) -> CGFloat {
        CGFloat(correctValue(Float(textField.text ?? "") ?? 0.0))
    }
    
    private func correctValue(_ value: Float) -> Float {
        let boundedValue = min(max(value, 0.0), 1.0)
        return round(boundedValue * 100) / 100
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
