//
//  ViewController.swift
//  IFtalkDemo
//
//  Created by john on 2019/12/27.
//  Copyright © 2019 qt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var result:String?
    var button:UIButton?
    var isStart:Bool = false
    var titleLabel:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        titleLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
        titleLabel?.backgroundColor = UIColor.cyan
        titleLabel?.numberOfLines = 0
        view.addSubview(titleLabel!)
        
        
        button = UIButton.init(type: .custom)
        button?.frame = CGRect(x: 50, y: 400, width: 100, height: 40)
        button?.setTitle("语音识别", for: .normal)
        button?.setTitleColor(.white, for: .normal)
        button?.backgroundColor = UIColor.red
        view.addSubview(button!)
        button?.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
    }
    
    @objc func buttonAction(btn:UIButton){
//        iFlyRecognizerView.delegate = self
//        view.addSubview(iFlyRecognizerView)
//        let ret = iFlyRecognizerView.start()
//        if ret {
//
//        }
        
//        let ret = iFlySpeechRecognizer.startListening()
//        if ret {
//
//        }
        VoiceRecognition.sharedInstance.initUI(type: .normal, view: self.view) { (str, ret) in
            self.titleLabel?.text = str
            print("录音状态\(ret)")
        }
    }
    
//    //MARK -语音类带jiemian
//    lazy var iFlyRecognizerView:IFlyRecognizerView = {
//        let iFlyRecognizerView = IFlyRecognizerView.init(center: self.view.center)
//        iFlyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
//        //asr_audio_path是录音文件名,设置value为nil或者为空取消保存,默认保存目录在 Library/cache下。
//        iFlyRecognizerView?.setParameter("asrview.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
//        return iFlyRecognizerView!
//    }()
//
//    //MARK -无界面展示
//    lazy var iFlySpeechRecognizer:IFlySpeechRecognizer = {
//        let iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
//        iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
//        iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
//        iFlySpeechRecognizer?.delegate = self
//        return iFlySpeechRecognizer!
//    }()
    
    @IBAction func nextClick(_ sender: UIButton) {
        let record = RecordController()
        navigationController?.pushViewController(record, animated: true)
    }
}

//extension ViewController : IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate{
//    func onCompleted(_ error: IFlySpeechError!) {
//        print("完成了")
//        print(error.errorCode)
//    }
//    //MARK -有界面识别结果处理
//    func onResult(_ resultArray: [Any]!, isLast: Bool) {
//        responseData(resultArray)
//    }
//
//    //无界面识别处理
//    func onResults(_ results: [Any]!, isLast: Bool) {
//        responseData(results)
//    }
//    //数据解析
//    private func responseData(_ result:[Any]!) {
//        let resultString = NSMutableString()
//        let dic:Dictionary = result?[0] as! Dictionary<String, Any>
//        for (key, value) in dic {
//            print(value)
//            resultString.append(key)
//        }
//        print("语音识别结果" + (resultString as String))
//        let data = resultString.data(using: String.Encoding.utf8.rawValue)!
//        do {
//            let resultDic = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//            let resultStr = NSMutableString()
//            if let array_ws:Array = resultDic["ws"] as? [[String:AnyObject]]{
//                for (_,value) in array_ws.enumerated() {
//                    let temp:Array = value["cw"] as! Array<Any>
//                    let dic_cw:Dictionary = temp[0] as! Dictionary<String,AnyObject>
//                    resultStr.append(dic_cw["w"] as! String)
//                }
//                print(resultStr)
//            }
//            if resultStr == "" || resultStr == "。" || resultStr == "," {
//                self.titleLabel?.text = ""
//            }else{
//                self.titleLabel?.text = "内容：" +  (resultStr as String)
//            }
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//        }
//    }
//}
