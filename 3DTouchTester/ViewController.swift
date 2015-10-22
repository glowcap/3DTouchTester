//
//  ViewController.swift
//  3DTouchTester
//
//  Created by Daymein Gregorio on 10/21/15.
//  Copyright © 2015 Daymein Gregorio. All rights reserved.
//

import UIKit
import Dispatch
import iAd

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var compatible = true
    var fillColor: UIColor!
    var finalCheckReady = false
    var finalCheckDone = false
    
    @IBOutlet weak var binaryLabel: UILabel!
    @IBOutlet weak var testingLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var infoBoardLabel: UILabel!
    @IBOutlet weak var sixSignalImgView: UIImageView!
    @IBOutlet weak var signalLampImgView: UIImageView!
    @IBOutlet weak var sixSignalConnectorView: SignalConnector!
    
    @IBOutlet weak var verticalFill: UIView!
    @IBOutlet weak var horizontalFill: UIView!
    @IBOutlet weak var btnSignalImgView: UIImageView!
    @IBOutlet weak var springView: Spring!
    @IBOutlet weak var btnCenter: BtnCenter!
    @IBOutlet weak var btnHoldLabel: UILabel!
    @IBOutlet weak var btnPressLabel: UILabel!
    @IBOutlet weak var btnLabel: UILabel!
    @IBOutlet weak var btnBaseImgView: UIImageView!
    @IBOutlet weak var btnConnectorView: BtnConnector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTestLabelText()
        assignTaptoButtonCenter()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpImageViews()
        binaryLabel.text = "00110011 01000100 00100000 01110100\n01101111 01110101 01100011 01101000"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: Setup Gesture Recognizer
    func assignTaptoButtonCenter() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        
        tap.delegate = self
        btnCenter.addGestureRecognizer(tap)
    }
    
    func handleTap() {
        if finalCheckReady {
            infoBoardLabel.text = "01110100 01100101 01110011 01110100"
            animateBtnConnector()
            animateSpring()
            animateBtnCenter()
            afterDelay(1.1){self.finalCheckDone = true}
            finalCheckReady = false
        } else if finalCheckDone {
            print("Test Force Here")
            percentageLabel.text = "88%"
        } else {
            print("not yet")
        }
    }
    
//MARK: Set Up Views
    func setUpImageViews() {
        sixSignalImgView.image = PressureStyleKit.imageOfTesting6s
        signalLampImgView.image = PressureStyleKit.imageOfLightUpCircleOff
        btnSignalImgView.image = PressureStyleKit.imageOfBtnSignalTest
        btnBaseImgView.image = PressureStyleKit.imageOfButtonBaseOff
    }
    
    
//MARK: Animation Functions
    func animateTestLabelText() {
        afterDelay(0.6){
            self.testingLabel.text = "Testing.  "
            self.sixSignalImgView.image = PressureStyleKit.imageOfTesting6s
            self.afterDelay(0.5){
                self.testingLabel.text = "Testing.. "
                self.sixSignalImgView.image = PressureStyleKit.imageOfTesting6sWhite
                self.afterDelay(0.4){
                    self.testingLabel.text = "Testing..."
                    self.sixSignalImgView.image = PressureStyleKit.imageOfTesting6s
                    self.afterDelay(0.5){
                        if self.compatible {
                            self.testingLabel.text = "Verified"
                            self.sixSignalImgView.image = PressureStyleKit.imageOfYes6s
                        } else {
                            self.testingLabel.text = "Failed"
                            self.sixSignalImgView.image = PressureStyleKit.imageOfNo6s
                        }
                        self.animateSixSignalConnector()
                    }
                }
            }
        }
    }
    

    func animateSixSignalConnector() {
        let sixXPos = sixSignalConnectorView.frame.origin.x
        let sixYPos = sixSignalConnectorView.frame.origin.y
        
        UIView.animateAndChainWithDuration(1.0, delay: 0.0, options: [], animations: {
            self.sixSignalConnectorView.frame = CGRect(x: sixXPos + 18, y: sixYPos,
                width: self.sixSignalConnectorView.frame.width,
                height: self.sixSignalConnectorView.frame.height)
            }, completion: {finish in
                var lightColor:UIImage!
                if self.compatible {
                    lightColor = PressureStyleKit.imageOfLightUpCircleOn
                    self.fillColor = UIColor(red: 180/255, green: 207/255, blue: 63/255, alpha: 1)
                    self.infoBoardLabel.text = "Final Check.\nTap button to confirm force sensitivity."
                } else {
                    lightColor = PressureStyleKit.imageOfLightUpCircleFail
                    self.fillColor = UIColor(red: 255, green: 63/255, blue: 27/255, alpha: 1)
                }
                self.enableFinalCheckBtn()
                self.signalLampImgView.image = lightColor}).animateWithDuration(0.4, animations: {
                self.verticalFill.backgroundColor = self.fillColor
                })
    }
    
    
    func animateBtnConnector() {
        let btnCXPos = btnConnectorView.frame.origin.x
        let btnCYPos = btnConnectorView.frame.origin.y
        
        UIView.animateAndChainWithDuration(1.0, delay: 0.0, options: [], animations: {
            self.btnConnectorView.frame = CGRect(x: btnCXPos, y: btnCYPos - 30,
                width: self.btnConnectorView.frame.width,
                height: self.btnConnectorView.frame.height)
            }, completion: nil).animateWithDuration(0.4, animations: {
                    self.horizontalFill.backgroundColor = self.fillColor
                self.afterDelay(0.4){
                    if !self.compatible {
                        self.forceLabel.text = "ERROR!"
                        self.forceLabel.textColor = self.fillColor
                        self.infoBoardLabel.textColor = self.fillColor
                        self.infoBoardLabel.text = "Error!\nSwitching to\nTimer Mode."
                        self.afterDelay(1.0){
                            self.forceLabel.text = "SECONDS"
                            self.infoBoardLabel.text = "Timer Mode\nHold button to display time held."
                            
                        }
                    } else {
                        self.percentageLabel.textColor = self.fillColor
                        self.infoBoardLabel.text = "System Ready.\nHold the button to begin testing."
                    }
                    self.btnPressLabel.textColor = UIColor.clearColor()
                    self.btnHoldLabel.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
                    
                }
            })
    }
    
    
    func animateSpring() {
        let btnSXPos = btnSignalImgView.frame.origin.x
        let btnSYPos = btnSignalImgView.frame.origin.y
        
        let sWidth = springView.bounds.width
        let sHeight = springView.bounds.height
        
        UIView.animateWithDuration(0.5, delay: 0.4, options: [], animations: {
            self.afterDelay(0.4){
                if self.compatible {
                    self.btnSignalImgView.image = PressureStyleKit.imageOfBtnSignalGreen
                } else {
                    self.btnSignalImgView.image = PressureStyleKit.imageOfBtnSignalRed
                }
            }
            
            self.btnSignalImgView.frame = CGRect(x: btnSXPos, y: btnSYPos - 14,
                width: self.btnSignalImgView.frame.width,
                height: self.btnSignalImgView.frame.height)
            self.springView.frame = CGRect(x: self.springView.frame.origin.x - 3,
                y: self.springView.frame.origin.y,
                width: sWidth + 5, height: sHeight - 15)
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, animations: {
            
            }, completion: nil)
    }
    
    
    func animateBtnCenter() {
        let duration = 1.0
        let delay = 0.0
        let fullRotation = CGFloat(M_PI)
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            }, completion: nil)
    }
    

//MARK: Gerneral Logic
    func enableFinalCheckBtn() {
        afterDelay(0.4){
            self.btnLabel.textColor = UIColor.clearColor()
            self.finalCheckReady = true
            self.btnPressLabel.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        }
    }
    
    
    func afterDelay(seconds: Double, closure: ()->() ) {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue(), closure)
    }
}

