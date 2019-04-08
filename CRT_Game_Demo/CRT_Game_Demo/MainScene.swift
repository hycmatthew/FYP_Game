//
//  MainScene.swift
//  CRT_Game_Demo
//
//  Created by Matthew Chan on 14/2/2019.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene{
    var game_layer = SKSpriteNode()
    var alpha_layer = SKSpriteNode()
    
    var stat_layer = SKSpriteNode()
    var level_label = SKLabelNode()
    var timer_label = SKLabelNode()
    var winRate_arr = [SKSpriteNode()]
    
    var text1_layer = SKSpriteNode()
    var text2_layer = SKSpriteNode()
    var text3_layer = SKSpriteNode()
    var text1_label = SKLabelNode()
    var text2_label = SKLabelNode()
    var text3_label = SKLabelNode()
    
    var hints_layer = SKSpriteNode()
    
    var hints_btn = SKSpriteNode()
    var hints_label = SKLabelNode()
    var textfield = UITextField()
    var submit_btn = SKSpriteNode()
    
    var result_layer = SKSpriteNode()
    var resultlayer_label = SKLabelNode()
    var resultlayer_score = SKLabelNode()
    var resultlayer_comment = SKLabelNode()
    var resultlayer_btn = SKLabelNode()
    
    var end_layer = SKSpriteNode()
    var endlayer_label = SKLabelNode()
    var endlayer_score = SKLabelNode()
    var endlayer_btn = SKLabelNode()
    
    var option_layer = SKSpriteNode()
    var optionlayer_optionbtn = SKSpriteNode()
    var optionlayer_soundbtn = SKSpriteNode()
    var optionlayer_menubtn = SKSpriteNode()
    
    var layer_arr = [SKSpriteNode()]
    var dataset_arr = [[Int()]]
    var questnum_arr = [Int()]
    var num_arr = [Int()]
    var remain_arr = [Int()]
    
    var player_arr = [GameSprite()]
    var enemy_arr = [GameSprite()]
    //==================== Number Setting ====================
    let gameDefault = UserDefaults.standard
    var theLang = 0
    var soundOn = true
    var player_level = 1
    
    var map_num = 1
    var level_num = 0
    var allowTouch = false
    var isPassLevel = false
    var isOptionShow = false
    
    var quest_ans = 0
    var hints_num = 0
    var hints_logic = false
    var time_count = 0.0
    var correct_record = 0
    
    //==================== Game Data Setting ====================
    let map_nama_arr = ["NaN", "Yong", "Zhai", "Sai", "Wei", "Dai", "Zhao", "Qi", "Chu"]
    let map_maxlevel = [3,3,3,4,5,5,5,6,7]
    let hints_level_logic = [3,3,2,1,1,1,1,1,1,1]
    let soundOn_img = SKTexture.init(imageNamed: "sound_on")
    let soundOff_img = SKTexture.init(imageNamed: "sound_off")
    let win_texture = SKTexture.init(imageNamed: "pass_icon")
    let lose_texture = SKTexture.init(imageNamed: "fail_icon")
    
    var halfWidth:CGFloat = 0
    var halfHeight:CGFloat = 0
    var max_level = 0
    let layer_posy = CGFloat(200)
    let layer_width = 600
    
    //==================== Sound Action Setting ====================
    let clickSound = SKAction.playSoundFileNamed("sound_click.wav", waitForCompletion: false)
    let moveSound = SKAction.playSoundFileNamed("sound_move.wav", waitForCompletion: false)
    let failSound = SKAction.playSoundFileNamed("sound_fail.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.white
        
        self.getDataFunction()
        
        hints_num = hints_level_logic[map_num]
        max_level = map_maxlevel[map_num]
        
        dataset_arr.removeAll()
        layer_arr.removeAll()
        winRate_arr.removeAll()
        questnum_arr.removeAll()
        
        let filePath = Bundle.main.path(forResource: "crt_data", ofType: "txt")
        let the_url = NSURL.fileURL(withPath: filePath!)
        
        do{
            let the_str = try String.init(contentsOf: the_url)
            let lines = the_str.components(separatedBy: "\n")
            for line in lines {
                let elements = line.components(separatedBy: " ")
                var temp_arr = [Int()]
                temp_arr.removeAll()
                for element in elements{
                    if let thenum = Int(element){
                        temp_arr.append(thenum)
                    }
                }
                if(temp_arr.count>1){
                    if(temp_arr.contains(11)){
                        if(map_num>2){
                           dataset_arr.append(temp_arr)
                        }
                    }else{
                        dataset_arr.append(temp_arr)
                    }
                }
            }
        }catch{
            print("error")
        }
        
        self.getRandomQuestionLogic()
        self.createGameScene()
        self.gameStartAnimation()
        self.scaleTheGameLayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(allowTouch){
            self.view?.endEditing(true)
            for t in touches {
                let positionInScene = t.location(in: game_layer)
                //print(self.view?.bounds.size)
                
                if(hints_btn.contains(positionInScene) && hints_btn.isHidden == false){
                    self.gameSoundFunction(num: 2)
                    self.showHintsFunction()
                }
                if(submit_btn.contains(positionInScene)){
                    self.gameSoundFunction(num: 2)
                    self.answerFunction()
                }
                if(isPassLevel){
                    let positionInResult = t.location(in: result_layer)
                    let positionInEnd = t.location(in: end_layer)
                    if(level_num == max_level){
                        if(endlayer_btn.contains(positionInEnd)){
                            self.gameSoundFunction(num: 1)
                            self.gameEndAnimation()
                        }
                    }else{
                        if(resultlayer_btn.contains(positionInResult)){
                            self.gameSoundFunction(num: 1)
                            self.levelSetupFunction()
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let positionInOption = t.location(in: option_layer)
            
            if(optionlayer_optionbtn.contains(positionInOption)){
                self.showGameMenuLogic()
            }
            if(optionlayer_soundbtn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                self.updateGameSoundFunction()
            }
            if(optionlayer_menubtn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                self.backToMenuScene()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //============================== Set Scene ==============================
    func createGameScene(){
        halfWidth = self.getTheDeviceSize().width/2
        halfHeight = self.getTheDeviceSize().height/2
        
        game_layer = SKSpriteNode.init(color: SKColor.white, size: self.getTheDeviceSize())
        game_layer.position = CGPoint.init(x: 0, y: 0)
        game_layer.zPosition = 0
        self.addChild(game_layer)
        
        alpha_layer = SKSpriteNode.init(color: .white, size: self.getTheDeviceSize())
        alpha_layer.alpha = 0.7
        alpha_layer.position = CGPoint.init(x: 0, y: 0)
        alpha_layer.zPosition = 500
        alpha_layer.isHidden = true
        self.addChild(alpha_layer)
        
        let device_width = self.getTheDeviceSize().width
        
        let background = SKSpriteNode.init(imageNamed: "game_bg")
        background.position = CGPoint.init(x: 0, y: 0)
        background.size = CGSize.init(width: device_width, height: device_width*3/4)
        background.zPosition = 0
        game_layer.addChild(background)
        
        let cloud_bg = SKSpriteNode.init(imageNamed: "bg_cloud")
        cloud_bg.position = CGPoint.init(x: 0, y: 0)
        cloud_bg.size = CGSize.init(width: device_width, height: device_width*3/4)
        cloud_bg.zPosition = 1
        game_layer.addChild(cloud_bg)
        
        let cloud_action1 = SKAction.move(by: CGVector.init(dx: 50, dy: 0), duration: 5)
        cloud_action1.timingMode = .easeInEaseOut
        let cloud_action2 = SKAction.move(by: CGVector.init(dx: -50, dy: 0), duration: 5)
        cloud_action2.timingMode = .easeInEaseOut
        let final_action = SKAction.repeatForever(SKAction.sequence([cloud_action1,cloud_action2]))
        cloud_bg.run(final_action)
        
        //============================== Top Layer ==============================
        stat_layer = SKSpriteNode.init(color: SKColor.clear, size: CGSize.init(width: self.size.width, height: 50))
        stat_layer.position = CGPoint.init(x: 0, y: halfHeight-25)
        stat_layer.zPosition = 100
        game_layer.addChild(stat_layer)
        
        level_label = SKLabelNode.init(text: "Qin - Level 1")
        level_label.position = CGPoint.init(x: 100-halfWidth, y: 0)
        self.setGameSceneLabel(item: level_label, type: 2, fsize: 24, pos: 2)
        stat_layer.addChild(level_label)
        
        for x in 0...6 {
            let icon  = SKSpriteNode.init(imageNamed: "pass_icon")
            icon.position = CGPoint.init(x: 200+CGFloat(x*35)-halfWidth, y: 0)
            icon.size = CGSize.init(width: 30, height: 30)
            icon.isHidden = true
            stat_layer.addChild(icon)
            winRate_arr.insert(icon, at: x)
        }
        
        timer_label = SKLabelNode.init(text: "0")
        timer_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: timer_label, type: 2, fsize: 30, pos: 2)
        stat_layer.addChild(timer_label)
        
        //============================== Main Game Scene ==============================
        let layer_pos_x = 350-halfWidth
        
        text1_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text1_layer.alpha = 0.9
        text1_layer.position = CGPoint.init(x: layer_pos_x, y: layer_posy)
        text1_layer.zPosition = 100
        game_layer.addChild(text1_layer)
        layer_arr.append(text1_layer)
        
        text2_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text2_layer.alpha = 0.9
        text2_layer.position = CGPoint.init(x: layer_pos_x, y: text1_layer.position.y-130)
        text2_layer.zPosition = 100
        game_layer.addChild(text2_layer)
        layer_arr.append(text2_layer)
        
        text3_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text3_layer.alpha = 0.9
        text3_layer.position = CGPoint.init(x: layer_pos_x, y: text2_layer.position.y-130)
        text3_layer.zPosition = 100
        game_layer.addChild(text3_layer)
        layer_arr.append(text3_layer)
        
        text1_label = SKLabelNode.init(text: " ")
        text1_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text1_label, type: 3, fsize: 20, pos: 2)
        text1_label.zPosition = 10
        text1_layer.addChild(text1_label)
        
        text2_label = SKLabelNode.init(text: " ")
        text2_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text2_label, type: 3, fsize: 20, pos: 2)
        text2_label.zPosition = 10
        text2_layer.addChild(text2_label)
        
        text3_label = SKLabelNode.init(text: " ")
        text3_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text3_label, type: 3, fsize: 20, pos: 2)
        text3_label.zPosition = 10
        text3_layer.addChild(text3_label)
        
        //let btm_pos_y = -halfHeight/3-50
        
        submit_btn = SKSpriteNode.init(imageNamed: "submit_btn")
        submit_btn.position = CGPoint.init(x: halfWidth-150, y: halfHeight/10)
        submit_btn.size = CGSize.init(width: 80, height: 80)
        submit_btn.zPosition = 100
        game_layer.addChild(submit_btn)
        
        //============================== Hints Layer ==============================
        let hints_posy:CGFloat = -120
        
        hints_btn = SKSpriteNode.init(imageNamed: "key_icon")
        hints_btn.position = CGPoint.init(x: layer_pos_x, y: hints_posy)
        hints_btn.size = CGSize.init(width: 70, height: 70)
        hints_btn.zPosition = 100
        game_layer.addChild(hints_btn)
        
        hints_label = SKLabelNode.init(text: "Hints x"+String(hints_num))
        hints_label.position = CGPoint.init(x: 150, y: 0)
        self.setGameSceneLabel(item: hints_label, type: 4, fsize: 28, pos: 2)
        hints_label.zPosition = 100
        hints_btn.addChild(hints_label)
        
        hints_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 180))
        hints_layer.alpha = 0.9
        hints_layer.position = CGPoint.init(x: layer_pos_x, y: text1_layer.position.y-345)
        hints_layer.zPosition = 100
        hints_layer.isHidden = true
        game_layer.addChild(hints_layer)
        
        let layer_color = SKColor.init(red: 248/255, green: 245/255, blue: 236/255, alpha: 1)
        //============================== Result Layer ==============================
        result_layer = SKSpriteNode.init(color: layer_color, size: CGSize.init(width: 450, height: 350))
        result_layer.position = CGPoint.init(x: 0, y: 100)
        result_layer.zPosition = 200
        result_layer.isHidden = true
        game_layer.addChild(result_layer)
        self.createRoundCornerOfLayer(layer: result_layer, length: 10)
        
        resultlayer_label = SKLabelNode.init(text: " ")
        resultlayer_label.position = CGPoint.init(x: 0, y: 100)
        self.setGameSceneLabel(item: resultlayer_label, type: 11, fsize: 24, pos: 2)
        resultlayer_label.zPosition = 10
        result_layer.addChild(resultlayer_label)
        
        resultlayer_score = SKLabelNode.init(text: " ")
        resultlayer_score.position = CGPoint.init(x: 0, y: 40)
        self.setGameSceneLabel(item: resultlayer_score, type: 11, fsize: 28, pos: 2)
        resultlayer_score.zPosition = 10
        result_layer.addChild(resultlayer_score)
        
        resultlayer_comment = SKLabelNode.init(text: " ")
        resultlayer_comment.position = CGPoint.init(x: 0, y: -20)
        self.setGameSceneLabel(item: resultlayer_comment, type: 11, fsize: 28, pos: 2)
        resultlayer_comment.zPosition = 10
        result_layer.addChild(resultlayer_comment)
        
        resultlayer_btn = SKLabelNode.init(text: "Next Level")
        resultlayer_btn.position = CGPoint.init(x: 0, y: -120)
        self.setGameSceneLabel(item: resultlayer_btn, type: 12, fsize: 36, pos: 2)
        resultlayer_btn.zPosition = 10
        result_layer.addChild(resultlayer_btn)
        
        //============================== End Layer ==============================
        end_layer = SKSpriteNode.init(color: layer_color, size: CGSize.init(width: 450, height: 350))
        end_layer.position = CGPoint.init(x: 0, y: 100)
        end_layer.zPosition = 200
        end_layer.isHidden = true
        game_layer.addChild(end_layer)
        self.createRoundCornerOfLayer(layer: end_layer, length: 10)
        
        endlayer_label = SKLabelNode.init(text: " ")
        endlayer_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: endlayer_label, type: 11, fsize: 30, pos: 2)
        endlayer_label.zPosition = 10
        end_layer.addChild(endlayer_label)
        
        endlayer_score = SKLabelNode.init(text: " ")
        endlayer_score.position = CGPoint.init(x: 0, y: -50)
        self.setGameSceneLabel(item: endlayer_score, type: 11, fsize: 30, pos: 2)
        endlayer_score.zPosition = 10
        end_layer.addChild(endlayer_score)
        
        endlayer_btn = SKLabelNode.init(text: "Back To The Map")
        endlayer_btn.position = CGPoint.init(x: 0, y: -120)
        self.setGameSceneLabel(item: endlayer_btn, type: 12, fsize: 36, pos: 2)
        endlayer_btn.zPosition = 10
        end_layer.addChild(endlayer_btn)
        
        //============================== Pause Layer ==============================
        option_layer = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 50, height: 50))
        option_layer.position = CGPoint.init(x: halfWidth-50, y: halfHeight-50)
        option_layer.zPosition = 200
        game_layer.addChild(option_layer)
        
        optionlayer_optionbtn = SKSpriteNode.init(imageNamed: "option_icon")
        optionlayer_optionbtn.position = CGPoint.init(x: 0, y: 0)
        optionlayer_optionbtn.size = CGSize.init(width: 45, height: 45)
        optionlayer_optionbtn.zPosition = 1
        option_layer.addChild(optionlayer_optionbtn)
        
        optionlayer_soundbtn = SKSpriteNode.init(texture: soundOff_img)
        optionlayer_soundbtn.position = CGPoint.init(x: 100, y: 0)
        optionlayer_soundbtn.size = CGSize.init(width: 40, height: 40)
        optionlayer_soundbtn.zPosition = 1
        option_layer.addChild(optionlayer_soundbtn)
        if(soundOn){
            optionlayer_soundbtn.texture = soundOff_img
        }
        
        optionlayer_menubtn = SKSpriteNode.init(imageNamed: "home_btn")
        optionlayer_menubtn.position = CGPoint.init(x: 200, y: 0)
        optionlayer_menubtn.size = CGSize.init(width: 40, height: 40)
        optionlayer_menubtn.zPosition = 1
        option_layer.addChild(optionlayer_menubtn)
        
        self.createEnemyBase()
        self.createPlayerBase()
        self.setTextfieldFunction()
    }
    
    func createPlayerBase(){
        for x in 1...8 {
            let item = GameSprite.init()
            item.setGameSprite(type_num: 1, num: x)
            item.setPlayerPosition(win_width: halfWidth)
            game_layer.addChild(item)
            player_arr.append(item)
        }
    }
    
    func createEnemyBase(){
        for x in 1...8 {
            let item = GameSprite.init()
            item.setGameSprite(type_num: 2, num: x)
            item.setEnemyPosition(win_width: halfWidth)
            game_layer.addChild(item)
            enemy_arr.append(item)
        }
    }
    
    func soldierResetFunction(){
        for item in player_arr {
            item.setPlayerPosition(win_width: halfWidth)
        }
        for item in enemy_arr {
            item.setEnemyPosition(win_width: halfWidth)
        }
    }
    
    //============================== Game Logic ==============================
    func showHintsFunction(){
        hints_layer.removeAllChildren()
        
        hints_num -= 1
        hints_btn.isHidden = true
        hints_layer.isHidden = false
        hints_label.text = "Hints x\(hints_num)"
        
        let total_num = num_arr[0]*num_arr[1]*num_arr[2]
        
        let text_label1 = SKLabelNode.init(text: "\(num_arr[0])x\(num_arr[1])x\(num_arr[2])=\(total_num)")
        text_label1.position = CGPoint.init(x: 0, y: 60)
        self.setGameSceneLabel(item: text_label1, type: 3, fsize: 24, pos: 2)
        text_label1.zPosition = 10
        hints_layer.addChild(text_label1)
        
        for x in 0...2 {
            var tempnum_arr = [Int()]
            tempnum_arr.removeAll()
            for y in 0...2{
                if(x != y){
                    tempnum_arr.append(num_arr[y])
                }
            }
            
            var temp_num = 1
            for num in tempnum_arr{
                temp_num *= num
            }
            print(temp_num)
            
            var final_num = temp_num
            while(final_num%num_arr[x] != 1){
                final_num += temp_num
            }
            
            let text_label2 = SKLabelNode.init(text: "\(final_num)x\(remain_arr[x])=\(remain_arr[x]*final_num)")
            text_label2.position = CGPoint.init(x: 0, y: 20-(x*40))
            self.setGameSceneLabel(item: text_label2, type: 3, fsize: 24, pos: 2)
            text_label2.zPosition = 10
            hints_layer.addChild(text_label2)
        }
    }
    
    func answerFunction(){
        self.pauseTimerFunction()
        self.hideGameItemFunction()
        let the_value = Int(textfield.text!)
        var isCorrect = false
        
        if(the_value == self.quest_ans){
            isCorrect = true
            self.correct_record += 1
        }
        
        for item in player_arr {
            item.setAttackAction(isWin: isCorrect)
        }
        for item in enemy_arr {
            item.setAttackAction(isWin: !isCorrect)
        }
        
        let waitAction = SKAction.wait(forDuration: 5)
        let logicAction = SKAction.run {
            self.isPassLevel = true

            self.levelPassFunction(result: isCorrect)
            self.updateWinRateFunction(isWin: isCorrect)
        }
        self.run(SKAction.sequence([waitAction, logicAction])){
            if(!isCorrect){
                self.gameSoundFunction(num: 3)
            }
        }
    }
    
    func levelPassFunction(result: Bool){
        hints_layer.isHidden = true
        
        if(level_num == max_level){
            self.setEndLayerFunction()
            self.layerShowAnimation(layer: end_layer)
        }else{
            self.setResultCommentLabelFunction(isWin: result)
            self.layerShowAnimation(layer: result_layer)
        }
    }

    func setResultCommentLabelFunction(isWin: Bool){
        resultlayer_label.text = "Level \(level_num)"
        
        if(isWin){
            resultlayer_score.text = String("Time Taken: ")+String.init(format: "%.1f", time_count)
            switch time_count {
            case 0...30:
                resultlayer_comment.text = "Awesome!"
            case 30...60:
                resultlayer_comment.text = "This is a good result"
            case 60...180:
                resultlayer_comment.text = "Not bad"
            default:
                resultlayer_comment.text = "You can solve it"
            }
        }else{
            resultlayer_score.text = "Wrong Answer!"
            resultlayer_comment.text = "The correct answer is \(quest_ans)"
        }
    }
    
    func setEndLayerFunction(){
        var star_num = 0
        
        if(CGFloat(correct_record) >= CGFloat(max_level)/2){
            if(correct_record == max_level){
                star_num = 3
            }else if(correct_record == max_level-1){
                star_num = 2
            }else{
                star_num = 1
            }
        }
        
        for x in 0...2 {
            let star_back = SKSpriteNode.init(imageNamed: "star_icon")
            star_back.position = CGPoint.init(x: 120*(x-1), y: 110)
            star_back.size = CGSize.init(width: 224, height: 224)
            star_back.alpha = 0.4
            star_back.zPosition = 5
            end_layer.addChild(star_back)
            
            if(x < star_num){
                let star_img = SKSpriteNode.init(imageNamed: "star_icon")
                star_img.position = CGPoint.init(x: 120*(x-1), y: 110)
                star_img.size = CGSize.init(width: 224, height: 224)
                star_img.isHidden = true
                star_img.zPosition = 10
                end_layer.addChild(star_img)
                
                star_img.size = CGSize.init(width: 320, height: 320)
                let waitAction = SKAction.wait(forDuration: Double(x)*0.5)
                let showAction = SKAction.run {
                    star_img.isHidden = false
                }
                let scaleAction = SKAction.scale(to: CGSize.init(width: 224, height: 224), duration: 0.5)
                star_img.run(SKAction.sequence([waitAction, showAction, scaleAction]))
            }
        }
        if(star_num>0){
            self.saveMapNumberFunction()
        }
        endlayer_label.text = String(map_nama_arr[map_num])
        endlayer_score.text = "\(correct_record)/\(max_level)"
    }
    
    func backToMenuScene(){
        textfield.removeFromSuperview()
        self.view?.endEditing(true)
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    //============================== Update Game Logic ==============================
    
    func updateWinRateFunction(isWin: Bool){
        for x in 0...winRate_arr.count-1{
            if(x == level_num-1){
                winRate_arr[x].isHidden = false
                if(isWin){
                    winRate_arr[x].texture = win_texture
                }else{
                    winRate_arr[x].texture = lose_texture
                }
            }
        }
    }
    
    func updateLevelFunction(){
        level_label.text = map_nama_arr[map_num]+" - Level "+String(level_num)
    }
    
    func timerSetupFunction(){
        time_count = 0.0
        let waitAction = SKAction.wait(forDuration: 0.1)
        let countAction = SKAction.run {
            self.time_count += 0.1
            self.timer_label.text = String(Int(self.time_count))
        }
        let seqAction = SKAction.repeatForever(SKAction.sequence([waitAction, countAction]))
        self.run(seqAction, withKey: "time_action")
    }
    
    func pauseTimerFunction(){
        self.removeAction(forKey: "time_action")
    }
    
    func showGameItemFunction(){
        if(hints_num > 0){
            self.hints_btn.isHidden = false
        }else{
            self.hints_btn.isHidden = true
        }
        
        self.textfield.text = ""
        self.submit_btn.isHidden = false
        self.textfield.isHidden = false
        self.showEquationAnimation()
    }
    
    func hideGameItemFunction(){
        hints_btn.isHidden = true
        textfield.isHidden = true
        submit_btn.isHidden = true
        hints_layer.isHidden = true
        
        for item in layer_arr {
            item.isHidden = true
        }
    }
    
    //============================== Set Math Logic ==============================
    
    func getRandomQuestionLogic(){
        var temp_arr = [Int()]
        temp_arr.removeAll()
        for x in 0...dataset_arr.count-1{
            temp_arr.append(x)
        }
        
        for _ in 0...max_level-1{
            let nonNilElements = temp_arr.compactMap { $0 }
            var ranNum = nonNilElements.randomElement()!
            if(ranNum >= nonNilElements.count){
                ranNum -= 1
            }
            
            questnum_arr.append(ranNum)
            temp_arr.remove(at: ranNum)
        }
    }
    
    func setMathLogic(){
        num_arr.removeAll()
        remain_arr.removeAll()
        
        let ranNum = questnum_arr[self.level_num-1]
        
        quest_ans = dataset_arr[ranNum][0]
        var isfirstnum = true
        for item in dataset_arr[ranNum]{
            if(isfirstnum){
                isfirstnum = false
            }else{
                let num = item
                let remainder = quest_ans%num
                num_arr.append(num)
                remain_arr.append(remainder)
            }
        }
        print("ran Num \(ranNum) ans Num \(quest_ans)")
        
        text1_label.text = "When the solders stood \(num_arr[0]) in a row, there were \(remain_arr[0]) left over."
        text2_label.text = "When the solders stood \(num_arr[1]) in a row, there were \(remain_arr[1]) left over."
        text3_label.text = "When the solders stood \(num_arr[2]) in a row, there were \(remain_arr[2]) left over."
    }
    
    
    //============================== Game Animation ==============================
    
    func gameStartAnimation(){
        self.hideGameItemFunction()
        stat_layer.isHidden = true
        
        let start_label = SKLabelNode.init(text: map_nama_arr[map_num])
        start_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: start_label, type: 1, fsize: 72, pos: 2)
        start_label.zPosition = 100
        self.addChild(start_label)
        
        let waitAction = SKAction.wait(forDuration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        start_label.run(SKAction.sequence([waitAction, fadeOut])){
            self.allowTouch = true
            self.stat_layer.isHidden = false
            self.levelSetupFunction()
        }
    }
    
    func levelSetupFunction(){
        isPassLevel = false
        level_num += 1
        
        self.layerHideAnimation(layer: result_layer)
        self.showGameItemFunction()
        self.soldierResetFunction()
        
        self.setMathLogic()
        self.timerSetupFunction()
        self.updateLevelFunction()
    }
    
    func showEquationAnimation(){
        for x in 0...2{
            layer_arr[x].isHidden = false
            layer_arr[x].position.y = layer_posy
            let set_pos = CGPoint.init(x: 350-halfWidth, y: layer_posy-(CGFloat(x)*(layer_arr[x].size.height+10)))
            let move_action = SKAction.move(to: set_pos, duration: 0.25*Double(x))
            layer_arr[x].run(move_action)
        }
    }
    func gameEndAnimation(){
        //textfield.isHidden = true
        textfield.removeFromSuperview()
        self.view?.endEditing(true)
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = MapScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func showGameMenuLogic(){
        if(isOptionShow){
            let moveAction = SKAction.move(to: CGPoint.init(x: halfWidth-50, y: halfHeight-50), duration: 0.7)
            moveAction.timingMode = .easeInEaseOut
            option_layer.run(moveAction){
                self.isOptionShow = false
            }
        }else{
            let moveAction = SKAction.move(to: CGPoint.init(x: halfWidth-250, y: halfHeight-50), duration: 0.7)
            moveAction.timingMode = .easeInEaseOut
            option_layer.run(moveAction){
                self.isOptionShow = true
            }
        }
    }
    
    func layerShowAnimation(layer: SKSpriteNode){
        layer.isHidden = false
        let scaleAction1 = SKAction.scale(to: 0.5, duration: 0)
        let scaleAction2 = SKAction.scale(to: 1.25, duration: 0.25)
        let scaleAction3 = SKAction.scale(to: 1, duration: 0.15)
        
        layer.run(SKAction.sequence([scaleAction1, scaleAction2, scaleAction3]))
    }
    
    func layerHideAnimation(layer: SKSpriteNode){
        let scaleAction1 = SKAction.scale(to: 0.1, duration: 0.2)
        layer.run(scaleAction1){
            layer.isHidden = true
        }
    }
    
    //============================== Basic Logic ==============================
    
    func createRoundCornerOfLayer(layer: SKSpriteNode, length: CGFloat){
        
        let set_size = CGSize.init(width: (length*2)+layer.size.width, height: (length*2)+layer.size.height)
        
        let round_shape = SKShapeNode.init(rectOf: set_size, cornerRadius: length)
        round_shape.position = CGPoint.init(x: 0, y: 0)
        round_shape.fillColor = layer.color
        round_shape.strokeColor = layer.color
        layer.addChild(round_shape)
    }
    
    func setGameSceneLabel(item: SKLabelNode, type: Int, fsize: Int, pos: Int){
        item.fontSize = CGFloat(fsize)
        item.verticalAlignmentMode = .center
        
        switch type {
        case 1:
            //================== Game Start Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.black
        case 2:
            //================== Area Top Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 3:
            //================== Equation Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 4:
            //================== Hints Label Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 11:
            //================== Result Layer Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.init(red: 166/255, green: 149/255, blue: 141/255, alpha: 1)
        case 12:
            //================== Result Layer Button Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.init(red: 166/255, green: 149/255, blue: 141/255, alpha: 1)
        default:
            break
        }
        
        switch pos {
        case 1:
            item.horizontalAlignmentMode = .left
        case 2:
            item.horizontalAlignmentMode = .center
        case 3:
            item.horizontalAlignmentMode = .right
        default:
            break
        }
    }
    
    func getTheDeviceSize()->CGSize{
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height{
            case 1792:
                print("iPhone XR")
                return CGSize.init(width: 1334, height: 616)
            case 2436:
                print("iPhone X")
                return CGSize.init(width: 1334, height: 616)
            case 2688:
                print("iPhone XS MAX")
                return CGSize.init(width: 1334, height: 616)
            default:
                return CGSize.init(width: 1334, height: 750)
            }
        }
        if UIDevice().userInterfaceIdiom == .pad{
            print("iPad")
            return CGSize.init(width: 1334, height: 1000)
        }
        return CGSize.init(width: 1334, height: 750)
    }
    
    func scaleTheGameLayer(){
        if UIDevice().userInterfaceIdiom == .pad{
            game_layer.xScale = 0.75
            game_layer.yScale = 0.75
        }
    }
    
    func setTextfieldFunction(){
        let tf_pos_x = (self.view?.bounds.size.width)!*2/3
        let tf_pos_y = (self.view?.bounds.size.height)!*2/5
        
        textfield = UITextField.init(frame: CGRect.init(x: tf_pos_x, y: tf_pos_y, width: 120, height: 44))
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .numberPad
        textfield.borderStyle = .bezel
        self.view?.addSubview(textfield)
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height{
            case 1792, 2436, 2688:
                print("iPhone XS")
                textfield.frame = CGRect.init(x: tf_pos_x+20, y: tf_pos_y, width: 120, height: 40)
            default:
                textfield.frame = CGRect.init(x: tf_pos_x, y: tf_pos_y, width: 120, height: 40)
            }
        }
        if UIDevice().userInterfaceIdiom == .pad{
            print("iPad")
            textfield.frame = CGRect.init(x: tf_pos_x+20, y: tf_pos_y+10, width: 160, height: 60)
        }
    }
    
    func gameSoundFunction(num: Int){
        if(soundOn){
            switch num {
            case 1:
                self.run(clickSound)
            case 2:
                self.run(moveSound)
            case 3:
                self.run(failSound)
            default:
                break
            }
        }
    }
    
    //======================================== Save Data ========================================
    func getDataFunction(){
        
        if(isKeyPresentInUserDefaults(key: "curLang") == false){
            gameDefault.set(0, forKey: "curLang")
            /* 0: EN , 1: SC , 2: TC */
        }else{
            theLang = gameDefault.integer(forKey: "curLang")
        }
        
        if(isKeyPresentInUserDefaults(key: "soundStat") == false){
            gameDefault.set(true, forKey: "soundStat")
        }else{
            soundOn = gameDefault.bool(forKey: "soundStat")
        }
        
        if(isKeyPresentInUserDefaults(key: "playerLevel") == false){
            gameDefault.set(1, forKey: "playerLevel")
        }else{
            player_level = gameDefault.integer(forKey: "playerLevel")
        }
        
        if(isKeyPresentInUserDefaults(key: "curLevel") == false){
            gameDefault.set(1, forKey: "curLevel")
        }else{
            map_num = gameDefault.integer(forKey: "curLevel")
        }
    }
    
    func updateGameSoundFunction(){
        if(soundOn == true){
            soundOn = false
        }else{
            soundOn = true
        }
        
        if(soundOn == true){
            optionlayer_soundbtn.texture = soundOn_img
        }else{
            optionlayer_soundbtn.texture = soundOff_img
        }
        gameDefault.set(soundOn, forKey: "soundStat")
    }
    
    func saveMapNumberFunction(){
        if(map_num == player_level){
            player_level += 1
            gameDefault.set(player_level, forKey: "playerLevel")
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
