//
//  GameSprite.swift
//  CRT_Game_Demo
//
//  Created by Matthew Chan on 14/2/2019.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

import UIKit
import SpriteKit

class GameSprite: SKSpriteNode {
    var type = Int()
    var pos_num = 0
    var isActive = false
    var isAction = false
    var canAttack = false
    var isDead = false
    
    
    var moveSpeed = CGFloat(0)
    var range = CGFloat(0)
    var fireRate = CGFloat(0)
    
    var itemSprite = SKSpriteNode()
    var waitTexture = [SKTexture()]
    var moveTexture = [SKTexture()]
    var attackTexture = [SKTexture()]
    var deadTexture = [SKTexture()]
    
    init(){
        super.init(texture: nil, color: SKColor.clear, size: CGSize.init(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGameSprite(type_num: Int, num: Int){
        self.type = type_num
        self.pos_num = num
        
        self.size = CGSize.init(width: 20, height: 20)
        self.moveSpeed = 95
        self.range = 50
        self.fireRate = 0.85
        
        self.waitTexture = [SKTexture.init(imageNamed: "soldier_idle1"), SKTexture.init(imageNamed: "soldier_idle2"), SKTexture.init(imageNamed: "soldier_idle3"), SKTexture.init(imageNamed: "soldier_idle4"), SKTexture.init(imageNamed: "soldier_idle5"),  SKTexture.init(imageNamed: "soldier_idle6"), SKTexture.init(imageNamed: "soldier_idle7")]
        self.moveTexture = [SKTexture.init(imageNamed: "soldier_run1"), SKTexture.init(imageNamed: "soldier_run2"), SKTexture.init(imageNamed: "soldier_run3"), SKTexture.init(imageNamed: "soldier_run4"), SKTexture.init(imageNamed: "soldier_run5"), SKTexture.init(imageNamed: "soldier_run6"), SKTexture.init(imageNamed: "soldier_run7")]
        self.attackTexture = [SKTexture.init(imageNamed: "soldier_att1"), SKTexture.init(imageNamed: "soldier_att2"), SKTexture.init(imageNamed: "soldier_att3"), SKTexture.init(imageNamed: "soldier_att4"), SKTexture.init(imageNamed: "soldier_att5"), SKTexture.init(imageNamed: "soldier_att6"), SKTexture.init(imageNamed: "soldier_att7"), SKTexture.init(imageNamed: "soldier_att8")]
        self.deadTexture = [SKTexture.init(imageNamed: "soldier_die1"), SKTexture.init(imageNamed: "soldier_die2"), SKTexture.init(imageNamed: "soldier_die3"), SKTexture.init(imageNamed: "soldier_die4"), SKTexture.init(imageNamed: "soldier_die5"), SKTexture.init(imageNamed: "soldier_die6"), SKTexture.init(imageNamed: "soldier_die7")]
        
        
        itemSprite = SKSpriteNode.init(texture: waitTexture[0])
        itemSprite.size = CGSize.init(width: 128, height: 95)
        itemSprite.position = CGPoint.init(x: 0, y: itemSprite.size.height/2)
        self.addChild(itemSprite)
        
        if(type_num != 1){
            itemSprite.xScale = -1
        }
        
        self.setDefaultAction()
    }
    
    //========================= Sprite Action =========================
    
    func clearActionFunction(){
        self.removeAllActions()
        self.itemSprite.removeAllActions()
    }
    
    func setMoveAroundAction(){
        let move_num:CGFloat = 75
        let waitAction = SKAction.wait(forDuration: TimeInterval(2))
        let wait2Action = SKAction.wait(forDuration: TimeInterval(move_num/self.moveSpeed))
        
        let wait_group = SKAction.group([waitAction, SKAction.run {
            self.setDefaultAction()
            }])
        let moveleft_group = SKAction.group([wait2Action, SKAction.run {
            self.setMoveAction(setPos: self.position.x-move_num)
            }])
        let moveright_group = SKAction.group([wait2Action, SKAction.run {
            self.setMoveAction(setPos: self.position.x+move_num)
            }])
        self.run(SKAction.repeatForever(SKAction.sequence([wait_group, moveleft_group, wait_group, moveright_group])))
    }
    
    func setDefaultAction(){
        self.itemSprite.removeAllActions()
        let action = SKAction.animate(with: self.waitTexture, timePerFrame: 0.15)
        self.itemSprite.run(SKAction.repeatForever(action), withKey: "wait_animation")
    }
    
    func setMoveAction(setPos: CGFloat){
        self.setEnemyFaceDirection(getPos: setPos)
        
        let action = SKAction.animate(with: self.moveTexture, timePerFrame: 0.15)
        self.itemSprite.run(SKAction.repeatForever(action))
        
        let count_time = abs(setPos-self.position.x)/self.moveSpeed
        let moveAction = SKAction.moveTo(x: setPos, duration: TimeInterval(count_time))
        self.run(moveAction, withKey: "move_animation")
    }
    
    func setAttackAction(isWin: Bool){
        var count_time = abs(self.position.x+25)/self.moveSpeed
        self.clearActionFunction()
        if(self.type == 1){
            self.setMoveAction(setPos: -30)
        }else{
            self.setMoveAction(setPos: 30)
            count_time = abs(self.position.x-25)/self.moveSpeed
        }
        let waitAction = SKAction.wait(forDuration: TimeInterval(count_time))
        let attAction = SKAction.run {
            self.removeAction(forKey: "move_animation")
            self.setAttackAnimation(isWin: isWin)
        }
        self.run(SKAction.sequence([waitAction, attAction]))
    }
    
    func setAttackAnimation(isWin: Bool){
        self.removeAction(forKey: "move_action")
        self.itemSprite.removeAction(forKey: "move_animation")
        var set_timer = 0
        let num_arr = [2,3,5,8]
        let num2_arr = [3,5,7]
        
        if(isWin){
            for num in num_arr {
                if(self.pos_num == num){
                    set_timer = 1
                }
            }
        }else{
            set_timer = 1
            for num in num2_arr {
                if(self.pos_num == num){
                    set_timer = 2
                }
            }
        }
        
        let count_time = fireRate/CGFloat(self.attackTexture.count)
        let animation = SKAction.animate(with: self.attackTexture, timePerFrame: TimeInterval(count_time))
        let waitAction = SKAction.wait(forDuration: TimeInterval(fireRate))
        let checkAction = SKAction.run {
            set_timer -= 1
            if(set_timer == 0){
                self.setSoldierDeadFunction()
            }
        }
        self.itemSprite.run(SKAction.repeat(animation, count: 2)){
            self.setDefaultAction()
        }
        
        self.run(SKAction.repeat(SKAction.sequence([waitAction, checkAction]), count: 2))
    }
    
    func setSoldierDeadFunction(){
        self.isDead = true
        
        self.removeAllActions()
        self.itemSprite.removeAllActions()
        let count_time = 1.5/CGFloat(self.deadTexture.count)
        let animation = SKAction.animate(with: self.deadTexture, timePerFrame: TimeInterval(count_time))
        self.itemSprite.run(animation)
        
        let waitAction = SKAction.wait(forDuration: 1)
        let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1.5)
        self.run(SKAction.sequence([waitAction, alphaAction]))
    }
    
    func setEnemyFaceDirection(getPos: CGFloat){
        let countx = getPos-self.position.x
        if countx>0 {
            self.itemSprite.xScale = 1
        }else{
            self.itemSprite.xScale = -1
        }
    }
    
    func setPlayerPosition(win_width: CGFloat){
        var set_xpos = 400-win_width
        if(pos_num%2 == 0){
            set_xpos = 450-win_width
        }
        self.position = CGPoint.init(x: set_xpos, y: CGFloat(20*pos_num)-250)
        self.resetSpriteFunction()
    }
    
    func setEnemyPosition(win_width: CGFloat){
        var set_xpos = win_width-400
        if(pos_num%2 == 0){
            set_xpos = win_width-450
        }
        self.position = CGPoint.init(x: set_xpos, y: CGFloat(20*pos_num)-250)
        self.resetSpriteFunction()
    }
    
    func resetSpriteFunction(){
        self.isDead = false
        self.zPosition = CGFloat(20-pos_num)
        self.alpha = 1.0
        itemSprite.texture = waitTexture[0]
        self.clearActionFunction()
        self.setDefaultAction()
    }
}

