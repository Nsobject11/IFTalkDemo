//
//  VoiceRecognition.swift
//  IFtalkDemo
//
//  Created by john on 2019/12/30.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit
///是否显示UI 显示UI时view毕传
enum VoiceUIType : String{
    case normal
    case withoutUI
}
typealias VoiceStrBlcok = (_ str:String,_ ret:Bool) -> Void
class VoiceRecognition: NSObject {
    var VType:VoiceUIType = .normal
    var Subview:UIView?
    var isRet:Bool = false
    var voiceBlock:VoiceStrBlcok?
    static let sharedInstance: VoiceRecognition = {
        let instance = VoiceRecognition()
        return instance
    }()
    
    func initUI(type:VoiceUIType,view:UIView?,block:@escaping VoiceStrBlcok){
        self.VType = type
        self.Subview = view
        if type == .normal {
            iFlyRecognizerView.delegate = self
            view!.addSubview(iFlyRecognizerView)
            let ret = iFlyRecognizerView.start()
            isRet = ret
        }else{
            let ret = iFlySpeechRecognizer.startListening()
            isRet = ret
        }
        self.voiceBlock = block
    }
    
    private func removeDelegate() {
        if VType == .normal {
            iFlyRecognizerView.cancel()
            iFlyRecognizerView.delegate = nil
            iFlyRecognizerView.setParameter("", forKey: IFlySpeechConstant.params())
        }else{
            iFlySpeechRecognizer.cancel()
            iFlySpeechRecognizer.delegate = nil
            iFlySpeechRecognizer.setParameter("", forKey: IFlySpeechConstant.params())
        }
    }
    
    //MARK -语音类带jiemian
    lazy var iFlyRecognizerView:IFlyRecognizerView = {
        let iFlyRecognizerView = IFlyRecognizerView.init(center: self.Subview!.center)
        iFlyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        //asr_audio_path是录音文件名,设置value为nil或者为空取消保存,默认保存目录在 Library/cache下。
        iFlyRecognizerView?.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        return iFlyRecognizerView!
    }()
    
    //MARK -无界面展示
    lazy var iFlySpeechRecognizer:IFlySpeechRecognizer = {
        let iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
        iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
        iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        iFlySpeechRecognizer?.delegate = self
        return iFlySpeechRecognizer!
    }()
}

extension VoiceRecognition : IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate{
    func onCompleted(_ error: IFlySpeechError!) {
        print("录音完成了")
        print(error.errorCode)
        removeDelegate()
    }
    //MARK -有界面识别结果处理
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        responseData(resultArray)
    }
    
    //无界面识别处理
    func onResults(_ results: [Any]!, isLast: Bool) {
        responseData(results)
    }
    //数据解析
    private func responseData(_ result:[Any]!) {
        let resultString = NSMutableString()
        let dic:Dictionary = result?[0] as! Dictionary<String, Any>
        for (key, value) in dic {
            print(value)
            resultString.append(key)
        }
        let data = resultString.data(using: String.Encoding.utf8.rawValue)!
        do {
            let resultDic = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            let resultStr = NSMutableString()
            if let array_ws:Array = resultDic["ws"] as? [[String:AnyObject]]{
                for (_,value) in array_ws.enumerated() {
                    let temp:Array = value["cw"] as! Array<Any>
                    let dic_cw:Dictionary = temp[0] as! Dictionary<String,AnyObject>
                    resultStr.append(dic_cw["w"] as! String)
                } 
                print(resultStr)
            }
            if resultStr == "" || resultStr == "。" || resultStr == "," {
//                self.voiceBlock!("",isRet)
            }else{
                self.voiceBlock!(resultStr as String,isRet)
                print("语音识别结果" + (resultStr as String))
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
}
