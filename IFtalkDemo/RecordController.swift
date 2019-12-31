//
//  RecordController.swift
//  IFtalkDemo
//
//  Created by john on 2019/12/30.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
enum LanguageType : String{
    case normal = "zh_cn"
    case English = "en_us"
}
class RecordController: UIViewController {
    let haveView:Bool = false //是否显示录音UI界面
    var type:LanguageType = .normal
    var iFlySpeechRecognizer:IFlySpeechRecognizer?
    var iflyRecognizerView:IFlyRecognizerView?
    @IBOutlet weak var txtDes: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecord()
    }
    //MARK -开始语音识别
    private func startRecord(){
        if !haveView {//不显示录音界面
            if iFlySpeechRecognizer == nil {
                initRecognizer()
            }
            iFlySpeechRecognizer?.cancel()
            iFlySpeechRecognizer?.setParameter("1", forKey: "audio_source")
            iFlySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
            iFlySpeechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
            iFlySpeechRecognizer?.delegate = self
            guard let ret = iFlySpeechRecognizer?.startListening() else { return }
            if ret {//正在录
                
            }else{//
                
            }
        }else{
            if iflyRecognizerView == nil {
                initRecognizer()
            }
            iflyRecognizerView?.setParameter("1", forKey: "audio_source")
            iflyRecognizerView?.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
            iflyRecognizerView?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
            guard let ret = iflyRecognizerView?.start() else { return}
            if ret {//正在录
                
            }else{//
                
            }
        }
    }
    
    private func initRecognizer(){
        if !haveView {//不显示录音界面
            if iFlySpeechRecognizer == nil {
               iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
            }
            iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
            iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
             iFlySpeechRecognizer?.delegate = self
            if iFlySpeechRecognizer != nil {
                //语音输入超时时间
                iFlySpeechRecognizer?.setParameter("30000", forKey: IFlySpeechConstant.speech_TIMEOUT())
                //后端点超时
                iFlySpeechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.vad_EOS())
                //前端点超时
                iFlySpeechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.vad_BOS())
                //网络连接超时时间
                iFlySpeechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
                //合成、识别、唤醒、评测、声纹等业务采样率
                iFlySpeechRecognizer?.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
                //语言
                iFlySpeechRecognizer?.setParameter(self.type.rawValue, forKey: IFlySpeechConstant.language())
                //语言区域。
                iFlySpeechRecognizer?.setParameter("mandarin", forKey: IFlySpeechConstant.accent())
                //语言区域。
                iFlySpeechRecognizer?.setParameter("1", forKey: IFlySpeechConstant.asr_PTT())
            }
        }else{//显示录音界面
            //recognition singleton with view
            if (iflyRecognizerView == nil) {
                iflyRecognizerView = IFlyRecognizerView.init(center: view.center) 
            }
            iflyRecognizerView?.setParameter("", forKey: IFlySpeechConstant.params())
            iflyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
            iflyRecognizerView?.delegate = self
            if iflyRecognizerView != nil {
                //语音输入超时时间
                iflyRecognizerView?.setParameter("30000", forKey: IFlySpeechConstant.speech_TIMEOUT())
                //后端点超时
                iflyRecognizerView?.setParameter("3000", forKey: IFlySpeechConstant.vad_EOS())
                //前端点超时
                iflyRecognizerView?.setParameter("3000", forKey: IFlySpeechConstant.vad_BOS())
                //网络连接超时时间
                iflyRecognizerView?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
                //合成、识别、唤醒、评测、声纹等业务采样率
                iflyRecognizerView?.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
                //语言
                iflyRecognizerView?.setParameter(self.type.rawValue, forKey: IFlySpeechConstant.language())
                //语言区域。
                iflyRecognizerView?.setParameter("mandarin", forKey: IFlySpeechConstant.accent())
                //语言区域。
                iflyRecognizerView?.setParameter("1", forKey: IFlySpeechConstant.asr_PTT())
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !haveView{
            iFlySpeechRecognizer?.cancel()
            iFlySpeechRecognizer?.delegate = nil
            iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
            
        }else{
            iflyRecognizerView?.cancel()
            iflyRecognizerView?.delegate = nil
            iflyRecognizerView?.setParameter("", forKey: IFlySpeechConstant.params())
        }
    }
}

extension RecordController:IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate{
    //无界面展示
    func onResults(_ results: [Any]!, isLast: Bool) {
        let resultString = NSMutableString.init()
        let dic:Dictionary = results?[0] as! Dictionary<String, Any>
        for (_, value) in dic {
           resultString.append(value as! String)
        }
    }
    
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        let resultString = NSMutableString.init()
        let dic:Dictionary = resultArray?[0] as! Dictionary<String, Any>
        for (_, value) in dic {
            resultString.append(value as! String)
        } 
    }
    
    func onCompleted(_ error: IFlySpeechError!) {
        print("识别成功")
    }
}
