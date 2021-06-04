//
//  GameScene.swift
//  Project17
//
//  Created by MacBook Air on 21.11.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    weak var viewController: GameViewController!
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var enemies = 0
    var sprite: SKSpriteNode!
    var spaceship: SKSpriteNode!
    var isGameOver = false
    var isGameStarted = false
    var gameTimer: Timer?
    var flapTimer: Timer?
    var scoreLabel: SKLabelNode!
    var finalLabel: SKLabelNode!
    var worm: SKSpriteNode!
    var loveLabel: SKLabelNode!
    var score = 0
    var sprites = 0
    var isFly = true
    var lvl = 3
    var iss = true
    var play = false
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        backgroundColor = .black

       
//        let background = SKSpriteNode(imageNamed: "background")
//        background.size = CGSize(width: 1304, height: 896)
//        background.position = CGPoint(x: 414, y: 450)
////        background.blendMode = .replace
//        background.zPosition = -1
//        addChild(background)
        starfield = SKEmitterNode(fileNamed: "starfield\(lvl)")!
        starfield.position = CGPoint(x: 414, y: 450)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        

        player = SKSpriteNode(imageNamed: "flappyUp")
        player.name = "ghost"
        player.size = CGSize(width: 75, height: 50)
        player.position = CGPoint(x: 60, y: 450)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 50))
//        if player.physicsBody == nil {
//            print("Error 1")
//        } else {
//            print("Ok 1")
//        }
        player.physicsBody?.contactTestBitMask = 1
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.affectedByGravity = false
        
        addChild(player)
        
        flapTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(flappy), userInfo: nil, repeats: true)
        
    }
    
    @objc func flappy() {
        let lowerWings = SKAction.setTexture(SKTexture(imageNamed: "flappyDown"))
        let midWings = SKAction.setTexture(SKTexture(imageNamed: "flappyMid"))
        let raiseWings = SKAction.setTexture(SKTexture(imageNamed: "flappyUp"))
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.3)
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 0.3)
        let wait = SKAction.wait(forDuration: 0.15)
        if !isGameStarted {
            let sequence = SKAction.sequence([ moveUp,   moveDown])
            childNode(withName: "ghost")?.run(sequence)
        }
        if isGameStarted {
            if isFly {
                let rotateDown = SKAction.rotate(byAngle: -0.5, duration: 0.5)
                childNode(withName: "ghost")?.run(rotateDown)
            }
            
        }
        let sequence2 = SKAction.sequence([midWings, wait, lowerWings,wait, raiseWings,wait])
        childNode(withName: "ghost")?.run(sequence2)
    }
    
    func startGame() {
        isGameStarted = true
//        flapTimer?.invalidate()
        
//        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
//        scoreLabel.position = CGPoint(x: 16, y: 16)
//        scoreLabel.horizontalAlignmentMode = .left
//        scoreLabel.text = "Score : \(score)"
//        scoreLabel.zPosition = 1
//        addChild(scoreLabel)

        score = 0

//        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
       
        gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func createEnemy() {


        let y1h = [50, 100, 200, 250]
        let y1 = y1h.randomElement()
        var y2 = Int()
        if y1 == 50 {
            y2 = 700
        } else if y1 == 100 {
            y2 = 750
        } else if y1 == 200 {
            y2 = 850
        } else if y1 == 250 {
            y2 = 900
        }
        sprite = SKSpriteNode(imageNamed: "pipeDown")
        sprite.name = "pipe"
        sprite.size = CGSize(width: 100, height: 600)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 425))
        sprite.position = CGPoint(x: 540, y:  y1!)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.collisionBitMask = 1
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        sprite.physicsBody?.affectedByGravity = false
        addChild(sprite)
        
        
        sprite = SKSpriteNode(imageNamed: "pipeUp")
        sprite.name = "pipe"
        sprite.position = CGPoint(x: 540, y:  y2)
        sprite.size = CGSize(width: 100, height: 600)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 438))
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.collisionBitMask = 1
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        addChild(sprite)
        
//        worm = SKSpriteNode(imageNamed: "worm")
//        worm.name = "worm"
//        worm.size = CGSize(width: 100, height: 150)
//        worm.position = CGPoint(x: 540, y: y2 - 330)
//        worm.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
//        worm.physicsBody?.contactTestBitMask = 1
//        worm.physicsBody?.categoryBitMask = 1
//        worm.physicsBody?.collisionBitMask = 2
//        worm.physicsBody?.linearDamping = 0
//        worm.physicsBody?.angularDamping = 0
//        worm.physicsBody?.affectedByGravity = false
//        worm.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
//        addChild(worm)
        

    
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameStarted {
            if isFly {
                player.position.y = player.position.y - 6
                
            }
//            player.position.y = player.position.y - 7
            if !isGameOver {
                score += 1
//                scoreLabel.text = "Score : \(score)"
            }
            if score == 100 {
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
                starfield.removeFromParent()
                lvl = 2
                starfield = SKEmitterNode(fileNamed: "starfield\(lvl)")!
                starfield.position = CGPoint(x: 414, y: 450)
                starfield.advanceSimulationTime(10)
                addChild(starfield)
                starfield.zPosition = -0.9
            }
            if score == 400 {
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
                starfield.removeFromParent()
                lvl = 1
                starfield = SKEmitterNode(fileNamed: "starfield\(lvl)")!
                starfield.position = CGPoint(x: 414, y: 450)
                starfield.advanceSimulationTime(10)
                addChild(starfield)
                starfield.zPosition = -0.9
            }
            if score == 800 {
                
                gameTimer?.invalidate()
                
                spaceship = SKSpriteNode(imageNamed: "spaceship")
                spaceship.name = "spaceship"
                spaceship.size = CGSize(width: 150, height: 150)
                spaceship.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 200))
                spaceship.position = CGPoint(x: 540, y:  450)
                spaceship.physicsBody?.categoryBitMask = 1
                spaceship.physicsBody?.collisionBitMask = 2
                spaceship.physicsBody?.contactTestBitMask = 1
                spaceship.physicsBody?.linearDamping = 0
                spaceship.physicsBody?.angularDamping = 0
                spaceship.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
//                player.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
                spaceship.physicsBody?.affectedByGravity = false
                addChild(spaceship)
                
            }
        }
        
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        viewController.tapLabel.isHidden = true
        if play {
            if !isGameStarted {
                startGame()
                viewController.tapLabel.isHidden = true
                print("www")
            }
            isFly = false
            let Y = player.position.y.advanced(by: 65)
            player.zRotation = CGFloat(0.4)
            let position = CGPoint(x: 60, y: Y)
            let moveAction = SKAction.move(to: position, duration: 0.2)
            let wait = SKAction.wait(forDuration: 0.1)
            let sequence2 = SKAction.sequence([moveAction, wait])
                   
            childNode(withName: "ghost")?.run(sequence2) { [weak self] in
               self?.isFly = true
           }
        }
//        let moveAction = SKAction.move(to: touch.location(in: self), duration: 0.1)
//        childNode(withName: "bullet")?.run(moveAction)
//        let lowerWings = SKAction.setTexture(SKTexture(imageNamed: "flappyDown"))
//        let raiseWings = SKAction.setTexture(SKTexture(imageNamed: "flappyUp"))
//        let midWings = SKAction.setTexture(SKTexture(imageNamed: "flappyMid"))
//        let rotateUp = SKAction.rotate(byAngle: 0.25, duration: 0.1)
//        let rotateDown = SKAction.rotate(byAngle: 0, duration: 0.2)
//        let sequence = SKAction.sequence([rotateUp, rotateDown])
//        let wait = SKAction.wait(forDuration: 0.15)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()

        isGameOver = true
        isGameStarted = false
        gameTimer?.invalidate()
        if contact.bodyA.collisionBitMask == 2 {
            let enter = SKAction.setTexture(SKTexture(imageNamed:"spaceshipFlap"))
            childNode(withName: "spaceship")?.run(enter)
        } else if contact.bodyB.collisionBitMask == 2 {
            starfield.removeFromParent()
            lvl = 4
            starfield = SKEmitterNode(fileNamed: "starfield\(lvl)")!
            starfield.position = CGPoint(x: 414, y: 450)
            starfield.advanceSimulationTime(10)
            addChild(starfield)
            starfield.zPosition = -0.9
            let enter = SKAction.setTexture(SKTexture(imageNamed:"spaceshipFlap"))
            childNode(withName: "spaceship")?.run(enter)
            finalLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
            finalLabel.position = CGPoint(x: 80, y: 600)
            finalLabel.horizontalAlignmentMode = .left
            finalLabel.text = "You flyed away..."
            addChild(finalLabel)
            spaceship.physicsBody?.velocity = CGVector(dx: 150, dy: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene2(size: self.size)
                newGame.viewController = self.viewController
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.viewController.tapLabel.isHidden = false
                }
            }
            
        } else {
            if iss {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let newGame = GameScene(size: self.size)
                    newGame.viewController = self.viewController
                    let transition = SKTransition.doorway(withDuration: 1.5)
                    self.view?.presentScene(newGame, transition: transition)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.viewController.playButton.isHidden = false
                        self.viewController.nameLabel.isHidden = false
                        self.viewController.nameText.isHidden = false
                    }
                   
                }
            }
        }
    }
    
}
