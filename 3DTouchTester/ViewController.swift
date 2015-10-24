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
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var compatible = false
    var fillColor: UIColor!
    var finalCheckReady = false
    var finalCheckDone = false

    var forceAmount: CGFloat = 0.0
    lazy var timer = NSTimer()
    var timerIsRunning = false
    var seconds = 0
    
    let hotPink = UIColor(red: 255, green: 45/255, blue: 150/255, alpha: 1)
    let pink = UIColor(red: 255, green: 165/255, blue: 255, alpha: 1)
    let green = UIColor(red: 210/255, green: 232/255, blue: 139/255, alpha: 1)
    let red = UIColor(red: 219/255, green: 58/255, blue: 50/255, alpha: 1)
    let gray = UIColor(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
    let yellow = UIColor(red: 237/255, green: 187/255, blue: 17/255, alpha: 1)
    let darkYellow = UIColor(red: 153/255, green: 125/255, blue: 10/255, alpha: 1)
    let blue = UIColor(red: 45/255, green: 168/255, blue: 255, alpha: 1)
    
    @IBOutlet weak var infoBrdLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var non6BaseView: Non6BaseView!
    @IBOutlet weak var non6BtnColorView: UIView!
    @IBOutlet weak var non6BtnTopView: Non6BtnTop!
    @IBOutlet weak var nonTapLabel: UILabel!

    
    @IBOutlet weak var binaryLabel: UILabel!
    @IBOutlet weak var testingLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var infoBoardView: InfoBoard!
    @IBOutlet weak var infoBoardLabel: UILabel!
    @IBOutlet weak var sixSignalColorView: Signal!
    @IBOutlet weak var sixSignalLight: UIView!
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
        
        checkForceCapability()
        setTapGestures()
        animateSixSignal()
        animateSixSignalLight()
        
        if !confirm6() {
            not6Adjustments()
        }
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
    
    func checkForceCapability() {
        switch self.traitCollection.forceTouchCapability {
        case .Available: compatible = true
        default:
            compatible = false
        }
    }
    
//MARK: Non iPhone6 functions
    func confirm6() -> Bool {
        let minimumHeight:CGFloat = 667.0
        return view.frame.height >= minimumHeight
        
    }
    
    func not6Adjustments() {
        let warningString = "Warning!\nUnsupported Device."
        non6BaseView.hidden = false
        warningLabel.text = warningString
        warningLabel.hidden = false
        infoBrdLeadConstraint.constant += 20
    }
    
    func enableFinalCheckBtn() {
        afterDelay(0.4){
            self.btnLabel.textColor = UIColor.clearColor()
            self.finalCheckReady = true
            self.btnPressLabel.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        }
    }

    
//MARK: Tap Gesture functions
    func setTapGestures() {
        let tapCenter = UITapGestureRecognizer(target: self, action: "handleTap")
        let tapNon = UITapGestureRecognizer(target: self, action: "handleTap")
        btnCenter.addGestureRecognizer(tapCenter)
        non6BtnTopView.addGestureRecognizer(tapNon)
    }
    
    func handleTap() {
        if finalCheckReady {
            infoBoardLabel.text = "01110100 01100101 01110011 01110100"
            animateBtnConnector()
            animateSpring()
            animateBtnCenter()
            afterDelay(1.1){self.finalCheckDone = true}
            finalCheckReady = false
        } else if !compatible && finalCheckDone {
            if !timerIsRunning {
                startTimer()
            } else {
                resetTimer()
            }
        }
    }

    
//MARK: Set Up Touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches!)
            if compatible {
                binaryLabel.textColor = UIColor.whiteColor()
                percentageLabel.text = "0%"
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
            if compatible {
                binaryLabel.textColor = UIColor.whiteColor()
                percentageLabel.text = "0%"
            }
        }
    }
    
    func handleTouch(touch:UITouch) {
        if finalCheckDone {
            if compatible {
                forceAmount = touch.force / touch.maximumPossibleForce
                let percent = Int(forceAmount * 100)
                let percentString = String(percent)
                
                binaryLabel.textColor = UIColor(white: 0.7, alpha: CGFloat(Double(percent) * 0.01))
                percentageLabel.text = percentString + "%"
            }
        } else {
            print("Not Ready")
        }
    }
    
    func testTouches(touches: Set<UITouch>) {
        // Get the first touch and its location
        let touch = touches.first
        let touchLocation = touch!.locationInView(self.view)
        
        let btnViewFrame = view.convertRect(btnCenter.frame, fromView: btnCenter.superview)
        
        if CGRectContainsPoint(btnViewFrame, touchLocation) {
            handleTouch(touch!)
        }
    }
   
    
//MARK: Timer functions
    func startTimer() {
        if !timerIsRunning {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countTime", userInfo: nil, repeats: true)
            timerIsRunning = true
        }
    }
    
    func countTime() {
        seconds += 1
        percentageLabel.text = String(seconds)
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 0
        percentageLabel.text = "0"
        timerIsRunning = false
    }
    

//MARK: Set Up Views
    func setUpImageViews() {
        
        signalLampImgView.image = PressureStyleKit.imageOfLightUpCircleOff
        btnSignalImgView.image = PressureStyleKit.imageOfBtnSignalTest
        btnBaseImgView.image = PressureStyleKit.imageOfButtonBase
    }
    
    
//MARK: Animation Functions
    func animateSixSignal() {
        afterDelay(0.6){
            self.testingLabel.text = "Testing.  "
            self.afterDelay(0.5){
                self.testingLabel.text = "Testing.. "
                self.afterDelay(0.4){
                    self.testingLabel.text = "Testing..."
                    self.afterDelay(0.5){
                        if self.compatible {
                            self.testingLabel.text = "Verified"
                            self.sixSignalColorView.backgroundColor = self.pink
                        } else {
                            self.testingLabel.text = "Failed"
                            self.sixSignalColorView.backgroundColor = self.red
                        }
                        self.animateSixSignalConnector()
                    }
                }
            }
        }
    }
    
    func animateSixSignalLight() {
        let loop:UIViewAnimationOptions = [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat]
        UIView.animateWithDuration(0.7, delay: 0.0, options: loop, animations: {
            self.sixSignalLight.backgroundColor = self.darkYellow
        }, completion: nil)

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
                    self.fillColor = self.green
                    self.infoBoardLabel.text = "Final Check.\nTap button to confirm force sensitivity."
                } else {
                    lightColor = PressureStyleKit.imageOfLightUpCircleFail
                    self.fillColor = self.red
                    self.infoBoardLabel.textColor = self.fillColor
                    self.infoBoardLabel.text = "Unsupported Device.\nTap button to continue."
                }
                self.enableFinalCheckBtn()
                self.signalLampImgView.image = lightColor}).animateWithDuration(0.4, animations: {
                self.verticalFill.backgroundColor = self.fillColor
                self.btnBaseImgView.backgroundColor = self.green
                self.non6BtnColorView.backgroundColor = self.green
                self.nonTapLabel.textColor = self.gray
                })
    }
    
    func animateBtnConnector() {
        let btnCXPos = btnConnectorView.frame.origin.x
        let btnCYPos = btnConnectorView.frame.origin.y
        
        btnBaseImgView.backgroundColor = self.yellow
        non6BtnColorView.backgroundColor = self.yellow
        nonTapLabel.textColor = UIColor.clearColor()
        btnPressLabel.textColor = UIColor.clearColor()
        btnLabel.textColor = UIColor.whiteColor()
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
                        self.infoBoardLabel.text = "Unsupported Device\nSwitching to\nTimer Mode."
                        self.afterDelay(1.2){
                            self.percentageLabel.textColor = self.blue
                            self.infoBoardLabel.textColor = self.blue
                            self.forceLabel.textColor = self.blue
                            self.percentageLabel.text = "0"
                            self.forceLabel.text = "SECONDS"
                            self.infoBoardLabel.text = "Timer Mode\nTap button to start and stop timer."
                        }
                    } else {
                        self.percentageLabel.textColor = self.pink
                        self.infoBoardLabel.text = "System Ready.\nHold the button to begin testing."
                    }
                    self.btnLabel.textColor = UIColor.clearColor()
                    self.btnHoldLabel.textColor = self.gray
                }
            }).animateWithDuration(0.3, animations: {
                self.btnBaseImgView.backgroundColor = self.green
                self.non6BtnColorView.backgroundColor = self.green
                self.nonTapLabel.textColor = self.gray
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
            }, completion: {finish in
                let userDefaults = NSUserDefaults.standardUserDefaults()
//MARK: ********fix spring height on return from view!! ******
                userDefaults.setDouble(Double(self.springView.frame.height), forKey: "SpringHeight")
            })
    }
    
    func animateBtnCenter() {
        let duration = 1.0
        let delay = 0.0
        let fullRotation = CGFloat(M_PI * 2)
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

//MARK: Dispatch function
    func afterDelay(seconds: Double, closure: ()->() ) {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue(), closure)
    }
}

