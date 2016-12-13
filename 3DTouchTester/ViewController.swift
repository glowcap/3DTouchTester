//
//  ViewController.swift
//  3DTouchTester
//
//  Created by Daymein Gregorio on 10/21/15.
//  Copyright © 2015 Daymein Gregorio. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let userDefaults = UserDefaults.standard
    
    var compatible = false
    var fillColor: UIColor!
    var finalCheckReady = false
    var finalCheckDone = false

    var forceAmount: CGFloat = 0.0
    lazy var timer = Timer()
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
    

    @IBOutlet weak var closeAdsBtn: UIButton!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("called")
//            if userDefaults.boolForKey("springSet") == true {
//                animateSpring(0.1, delay: 0.0)
//            }

        setUpImageViews()
        binaryLabel.text = "00110011 01000100 00100000 01110100\n01101111 01110101 01100011 01101000"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForceCapability() {
        switch self.traitCollection.forceTouchCapability {
        case .available: compatible = true
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
        non6BaseView.isHidden = false
        warningLabel.text = warningString
        warningLabel.isHidden = false
        infoBrdLeadConstraint.constant += 20
    }
    
    func enableFinalCheckBtn() {
        afterDelay(0.4){
            self.btnLabel.textColor = UIColor.clear
            self.finalCheckReady = true
            self.btnPressLabel.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        }
    }

    
//MARK: Tap Gesture functions
    func setTapGestures() {
        let tapCenter = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        let tapNon = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        btnCenter.addGestureRecognizer(tapCenter)
        non6BtnTopView.addGestureRecognizer(tapNon)
    }
    
    func handleTap() {
        if finalCheckReady {
            infoBoardLabel.text = "01110100 01100101 01110011 01110100"
            animateBtnConnector()
            animateSpring(0.5, delay: 0.4)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
            if compatible {
                binaryLabel.textColor = UIColor.white
                percentageLabel.text = "0%"
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finalCheckDone {
            testTouches(touches)
            if compatible {
                binaryLabel.textColor = UIColor.white
                percentageLabel.text = "0%"
            }
        }
    }
    
    func handleTouch(_ touch:UITouch) {
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
    
    func testTouches(_ touches: Set<UITouch>) {
        // Get the first touch and its location
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        
        let btnViewFrame = view.convert(btnCenter.frame, from: btnCenter.superview)
        
        if btnViewFrame.contains(touchLocation) {
            handleTouch(touch!)
        }
    }
   
    
//MARK: Timer functions
    func startTimer() {
        if !timerIsRunning {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.countTime), userInfo: nil, repeats: true)
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
        let loop:UIViewAnimationOptions = [UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.repeat]
        UIView.animate(withDuration: 0.7, delay: 0.0, options: loop, animations: {
            self.sixSignalLight.backgroundColor = self.darkYellow
        }, completion: nil)

    }

    func animateSixSignalConnector() {
        let sixXPos = sixSignalConnectorView.frame.origin.x
        let sixYPos = sixSignalConnectorView.frame.origin.y
        
        UIView.animateAndChain(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.sixSignalConnectorView.frame = CGRect(x: sixXPos + 18, y: sixYPos,
                                                       width: self.sixSignalConnectorView.frame.width,
                                                       height: self.sixSignalConnectorView.frame.height)
        }, completion: {finish in
            print("completed")
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
            self.signalLampImgView.image = lightColor
        }).animate(withDuration: 0.4, animations: {
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
        nonTapLabel.textColor = UIColor.clear
        btnPressLabel.textColor = UIColor.clear
        btnLabel.textColor = UIColor.white
        
        UIView.animateAndChain(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.btnConnectorView.frame = CGRect(x: btnCXPos, y: btnCYPos - 30,
            width: self.btnConnectorView.frame.width,
            height: self.btnConnectorView.frame.height)
        }, completion: nil).animate(withDuration: 0.4, animations: {
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
                self.btnLabel.textColor = UIColor.clear
                self.btnHoldLabel.textColor = self.gray
            }
        }).animate(withDuration: 0.3, animations: {
            self.btnBaseImgView.backgroundColor = self.green
            self.non6BtnColorView.backgroundColor = self.green
            self.nonTapLabel.textColor = self.gray
        })
    }
    
    func animateSpring(_ duration: Double, delay: Double) {
        let btnSXPos = btnSignalImgView.frame.origin.x
        let btnSYPos = btnSignalImgView.frame.origin.y
        
        let sWidth = springView.bounds.width
        let sHeight = springView.bounds.height
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
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
                self.userDefaults.set(true, forKey: "springSet")
            })
    }
    
    func animateBtnCenter() {
        let duration = 1.0
        let delay = 0.0
        let fullRotation = CGFloat(M_PI * 2)
        let options = UIViewKeyframeAnimationOptions.calculationModePaced
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.btnCenter.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
            })
            }, completion: nil)
    }

    
//MARK: Dispatch function
    func afterDelay(_ seconds: Double, closure: @escaping ()->() ) {
        let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

