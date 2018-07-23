//
//  FilterViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,HeaderViewProtocol,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
   
    

    @IBOutlet weak var institutionTitleLabel: UILabel!
    @IBOutlet weak var ageGroupLabel: UILabel!
    @IBOutlet weak var programmeTypeLabel: UILabel!
    @IBOutlet weak var institutionText: UITextField!
    @IBOutlet weak var ageGroupText: UITextField!
    @IBOutlet weak var programmeTypeText: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var pickerToolBar: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var institutionButton: UIButton!
    @IBOutlet weak var ageGroupButton: UIButton!
    @IBOutlet weak var programmeButton: UIButton!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet var institutionView: UIView!
    @IBOutlet var ageGroupView: UIView!
    @IBOutlet var programmeTypeView: UIView!
    
    var picker = UIPickerView()
    var institutionArray = NSArray()
    var ageGroupArray = NSArray()
    var programmeTypeArray = NSArray()
    var selectedInstitution = String()
    var selectedageGroup = String()
    var selectedProgramme = String()
    var selectedRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        institutionArray = ["Any Education"," Years of Culture Education","Public Art Education","MIA Education"]
        ageGroupArray = ["Any Age Group","B","C"]
        programmeTypeArray = ["Any Topic", "Museums", "Qatar"]
        setupUI()
       
    }
    func setupUI() {
        headerView.headerViewDelegate = self
        headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
        headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top:14, left:19, bottom: 14, right:19)
        headerView.headerTitle.text = NSLocalizedString("FILTER_LABEL", comment: "FILTER_LABEL in the Filter page")
        institutionText.delegate = self
        ageGroupText.delegate = self
        programmeTypeText.delegate = self
        addPickerView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didTapInstitutionButton(_ sender: UIButton) {
        institutionText.becomeFirstResponder()
         self.institutionButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func didTapageGroupButton(_ sender: UIButton) {
        ageGroupText.becomeFirstResponder()
         self.ageGroupButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func didTapProgrammeTypeButton(_ sender: UIButton) {
        programmeTypeText.becomeFirstResponder()
         self.programmeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func didTapClear(_ sender: UIButton) {
        self.clearButton.backgroundColor = UIColor.profilePink
        self.clearButton.setTitleColor(UIColor.whiteColor, for: .normal)
         self.clearButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func didTapFilter(_ sender: UIButton) {
        self.filterButton.backgroundColor = UIColor.viewMycultureBlue
        self.filterButton.setTitleColor(UIColor.white, for: .normal)
         self.filterButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func institutionButtonTouchDown(_ sender: UIButton) {
        self.institutionButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func ageGroupButtonTouchDown(_ sender: UIButton) {
        self.ageGroupButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func programmeTypeButtonTouchDown(_ sender: UIButton) {
        
        self.programmeButton.transform = CGAffineTransform(scaleX: 0.7, y:0.7)
    }
    @IBAction func clearButtonTouchDown(_ sender: UIButton) {
        self.clearButton.backgroundColor = UIColor.profileLightPink
        self.clearButton.setTitleColor(UIColor.viewMyFavDarkPink, for: .normal)
        self.clearButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func filterButtonTouchDown(_ sender: UIButton) {
        self.filterButton.backgroundColor = UIColor.viewMycultureLightBlue
        self.filterButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        self.filterButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    func addPickerView() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-200, width: self.view.frame.width, height: 200)
        picker.backgroundColor = UIColor.whiteColor
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        institutionText.inputView = picker
        institutionText.inputAccessoryView = pickerToolBar
        ageGroupText.inputView = picker
        ageGroupText.inputAccessoryView = pickerToolBar
        programmeTypeText.inputView = picker
        programmeTypeText.inputAccessoryView = pickerToolBar

    }
    
    //MARK: header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let myScreenRect: CGRect = UIScreen.main.bounds
        let pickerHeight : CGFloat = 200
        UIView.beginAnimations( "animateView", context: nil)
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height+50  > (myScreenRect.size.height - pickerHeight-50)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height+50 ) - (myScreenRect.size.height - pickerHeight-100)
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
        if (textField == institutionText) {
            picker.tag = 0
            institutionView.backgroundColor = UIColor.filterTextSelectedGray
            ageGroupView.backgroundColor = UIColor.white
            programmeTypeView.backgroundColor = UIColor.white
        }
        else if(textField == ageGroupText) {
            picker.tag = 1
            institutionView.backgroundColor = UIColor.white
            ageGroupView.backgroundColor = UIColor.filterTextSelectedGray
            programmeTypeView.backgroundColor = UIColor.white
        }
        else {
            picker.tag = 2
            institutionView.backgroundColor = UIColor.white
            ageGroupView.backgroundColor = UIColor.white
            programmeTypeView.backgroundColor = UIColor.filterTextSelectedGray
        }
        picker.reloadAllComponents()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.beginAnimations( "animateView", context: nil)
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        institutionText.resignFirstResponder()
        ageGroupText.resignFirstResponder()
        programmeTypeText.resignFirstResponder()
        
        return true
    }

    //MARK: Pickerview delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(picker.tag == 0) {
            return institutionArray.count
        }
        else if(picker.tag == 1) {
            return ageGroupArray.count
        }
        else {
            return programmeTypeArray.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedRow = row
        if(picker.tag == 0) {
            selectedInstitution = (institutionArray[row] as? String)!
            institutionText.text = (institutionArray[row] as? String)!
            return institutionArray[row] as? String;
        }
        else if(picker.tag == 1) {
            selectedageGroup = (ageGroupArray[row] as? String)!
            ageGroupText.text = (ageGroupArray[row] as? String)!
            return ageGroupArray[row] as? String;
        }
        else {
            selectedProgramme = (programmeTypeArray[row] as? String)!
            programmeTypeText.text = (programmeTypeArray[row] as? String)!
            return programmeTypeArray[row] as? String;
        }
        
        
    }
    //MARK: Picker ToolBar Actions
    
    @IBAction func didTapPrevious(_ sender: UIButton) {
       
        picker.selectRow(selectedRow-1, inComponent: 0, animated: true)
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        picker.selectRow(selectedRow+1, inComponent: 0, animated: true)
    }
    @IBAction func didTapPickerClose(_ sender: UIButton) {
        if (picker.tag == 0) {
            institutionText.text = selectedInstitution
        }
        else if(picker.tag == 1) {
            ageGroupText.text = selectedageGroup
        }
        else {
            programmeTypeText.text = selectedProgramme
        }
        institutionText.resignFirstResponder()
        ageGroupText.resignFirstResponder()
        programmeTypeText.resignFirstResponder()
    }
    
    

}
