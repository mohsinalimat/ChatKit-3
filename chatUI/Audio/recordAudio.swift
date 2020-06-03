//
//  recordAudio.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/1/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class recordAudio: UIView, AVAudioRecorderDelegate {
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.text = "00.00"
        lab.textColor = .systemGray2
        lab.font = UIFont.systemFont(ofSize: 55, weight: .black)
        return lab
    }()
    
    private let recordButton: UIButton = {
        let butt = UIButton()
        butt.setTitle("Record", for: .normal)
        butt.titleLabel?.textColor = .white
        butt.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        butt.backgroundColor = .lightRed
        butt.layer.cornerRadius = 55/2
        butt.addTarget(self, action: #selector(didPressRecord), for: UIControl.Event.touchUpInside)
        butt.tag = 0
        return butt
    }()
    
    private let CancelButton: UIButton = {
        let butt = UIButton()
        butt.setTitle("Cancel", for: .normal)
        butt.titleLabel?.textColor = .white
        butt.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        butt.backgroundColor = .systemGray2
        butt.layer.cornerRadius = 55/2
        butt.addTarget(self, action: #selector(didPressCancel), for: UIControl.Event.touchUpInside)
        butt.tag = 0
        return butt
    }()
    
    private var stackView: UIStackView = {
         let stackView = UIStackView()
         stackView.backgroundColor = .clear
         stackView.axis = .horizontal
         stackView.distribution = .fill
         stackView.alignment = .fill
         stackView.spacing = 10
         stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
         stackView.isLayoutMarginsRelativeArrangement = true
         return stackView
     }()
    
    private var sendWidth = NSLayoutConstraint()
    private var cancelWidth = NSLayoutConstraint()
    private var selectedWidth = CGFloat()
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var meterTimer: Timer! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                     //   self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    func setupUIElements() {
        selectedWidth = (UIScreen.main.bounds.width  - 50 )
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.addSubview(timeLab)
        self.addSubview(stackView)
        self.stackView.addArrangedSubview(CancelButton)
        self.stackView.addArrangedSubview(recordButton)
        
        self.timeLab.center(inView: self, yConstant: -40)
        self.stackView.center(inView: self, yConstant: 70)
        
        self.sendWidth = self.recordButton.widthAnchor.constraint(equalToConstant: selectedWidth)
        self.cancelWidth = self.CancelButton.widthAnchor.constraint(equalToConstant: 0)
        self.recordButton.anchor(height: 55)
        self.CancelButton.anchor(height: 55)
        NSLayoutConstraint.activate([cancelWidth,sendWidth])
   
        
    }
    
    /// Record
    @objc private func didPressRecord(_ sender: UIButton) {
        if sender.tag == 0 {
            self.recordButton.tag = 1
            self.recordButton.setTitle("Send", for: .normal)
            self.recordButton.backgroundColor = .mainBlue
            self.sendWidth.constant = selectedWidth / 2
            self.cancelWidth.constant = selectedWidth / 2
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            startRecording()
        } else {
            finishRecording(success: true)
        }
   
    }
    
    /// cancel
    @objc private func didPressCancel(_ sender: Any?) {
        audioRecorder.stop()
        self.recordButton.tag = 0
        self.recordButton.setTitle("Record", for: .normal)
        self.recordButton.backgroundColor = .lightRed
        self.sendWidth.constant = selectedWidth
        self.cancelWidth.constant = 0
        self.timeLab.text = "0.00"
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
     }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)

        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
          
        } else {
           
         
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            timeLab.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
}
