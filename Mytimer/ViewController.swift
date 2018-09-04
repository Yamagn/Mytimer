//
//  ViewController.swift
//  Mytimer
//
//  Created by ymgn on 2018/09/01.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // タイマーの変数を作成
    var timer : Timer?
    
    // カウント（経過時間）の変数を作成
    var count = 0
    
    // 設定値を扱うキーを設定
    let settingKey = "timer_value"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        
        // UserDefaultsに初期値を登録
        settings.register(defaults: [settingKey:10])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        // タイマーを停止
        stopTimer()
        
        // 画面遷移を行う
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが実行中だったらスタートしない
            if nowTimer.isValid == true {
                // 何も処理しない
                return
            }
        }
        
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        // タイマーを停止
        stopTimer()
    }
    
    // 画面の更新をする(戻り値: remainCount:残り時間)
    func displayUpdate() -> Int {
        
        // UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        
        // 取得した秒数をtimerValuesに渡す
        let timerValue = settings.integer(forKey: settingKey)
        
        // 残り時間(remainCount)を生成
        let remainCount = timerValue - count
        
        // remainCount(残り時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        
        // 残り時間を戻り値に設定
        return remainCount
    }
    
    // 経過時間の処理
    @objc func timerInterrupt(_ timer:Timer) {
        // count(経過時間)に+1していく
        count += 1
        
        // remainCount(残り時間)が0以下のとき、タイマーを止める
        if displayUpdate() <= 0 {
            // 初期化処理
            count = 0
            
            // タイマー停止
            timer.invalidate()
            
            // ダイアログの作成
            let alertcController = UIAlertController(title: "終了", message: "タイマー終了の時間です", preferredStyle: .alert)
            
            // ダイアログに表示させるOKボタン
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            // アクションを追加
            alertcController.addAction(defaultAction)
            
            // ダイアログの表示
            present(alertcController, animated: true, completion: nil)
        }
        
    }
    
    func stopTimer() {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                // タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    // 画面の切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        // カウント(経過時間)をゼロにする
        count = 0
        
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
    
}

