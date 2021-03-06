import UIKit
import SceneKit
enum ColliderType: Int {
    case ball     = 0b0001
    case boxes  = 0b0100
    //case bar    = 0b0100
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    var isShot=false;
    var tmp=false;
    var startLocation = CGPoint()
    var ballPosition: SCNVector3!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var chanceLabel: UILabel!
    var chances = 5
    var level = 1
    //var scnView: SCNView!
    var scnScene: SCNScene!
    var panGesture = UIPanGestureRecognizer()
    var verticalCameraNode: SCNNode!
    var additionalCameraNode: SCNNode!
    var ballNode: SCNNode!
    var boxNodes: [SCNNode] = []
    var lastContactNode: SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
        nextLevel(level: 1)
    }
    
    func setupScene() {
        //scnView = self.view as! SCNView
        scnView.delegate = self
        
        scnScene = SCNScene(named: "freekickerArt.scnassets/Scene/model.scn")
        scnView.scene = scnScene
        scnScene.physicsWorld.contactDelegate = self
        //scnView.showsStatistics = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.shootBall(_:)))
        scnView.addGestureRecognizer(panGesture)
        self.chanceLabel.text = String(chances)
        self.levelLabel.text = String(level)
    }
    
    func setupNodes() {
        
        verticalCameraNode = scnScene.rootNode.childNode(withName: "cameraa", recursively: true)!
        additionalCameraNode = scnScene.rootNode.childNode(withName: "newcamera", recursively: true)!

        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively:
            true)!
        ballPosition =  ballNode.position
        ballNode.physicsBody?.contactTestBitMask = ColliderType.boxes.rawValue 
        
        var i=0
        while i<6{
            let box = "box" + String(i+1)
            
            let boxNode = scnScene.rootNode.childNode(withName: box, recursively:
                true)!
            boxNodes.append(boxNode)
            i=i+1
        }
    }
    
    func setupSounds() {
    }
    func resetGame(){
        
        ballNode.physicsBody?.velocity = SCNVector3Zero
        ballNode.physicsBody?.angularVelocity = SCNVector4Zero
        ballNode.position = ballPosition
        isShot=false
        tmp=false
    }
    func nextLevel(level: Int){
        switch level{
        case 1:
            resetBoxes()
        case 2:
            resetBoxes()
            boxNodes[0].isHidden = false
            boxNodes[1].isHidden = false
        case 3:
            resetBoxes()
            boxNodes[2].isHidden = false
            boxNodes[3].isHidden = false
            //ballNode.position = SCNVector3(x: 3756, y: 6, z: -1305)
            //verticalCameraNode.position = SCNVector3(x: 3698, y: 37, z: -1193)
            //scnView.pointOfView = additionalCameraNode
        case 4:
            resetBoxes()
            boxNodes[4].isHidden = false
            boxNodes[5].isHidden = false
            scnView.pointOfView = verticalCameraNode
        case 5:
            resetBoxes()
            boxNodes[1].isHidden = false
            boxNodes[3].isHidden = false
            boxNodes[5].isHidden = false
        case 6:
            resetBoxes()
            boxNodes[0].isHidden = false
            boxNodes[2].isHidden = false
            boxNodes[4].isHidden = false
        default:
            print("anan")
        }
    }
    func resetBoxes(){
        var i=0
        while i<6{
            
            boxNodes[i].isHidden = true
            
            i=i+1
        }
    }
    override var shouldAutorotate: Bool { return true }
    
    override var prefersStatusBarHidden: Bool { return false }
    
    @objc func shootBall(_ sender: UIPanGestureRecognizer){
        
        
        
        if(!isShot){
            if(sender.state == UIGestureRecognizer.State.began){
                startLocation = sender.location(in: self.view)
                
            }
            else if (sender.state == UIGestureRecognizer.State.ended) {
                tmp=false
            }
            else if (sender.state == UIGestureRecognizer.State.cancelled) {
                tmp=false
            }
        }
        if (sender.state == UIGestureRecognizer.State.changed){
            let stopLocation = sender.location(in: self.view)
            let dx = stopLocation.x - startLocation.x;
            let dy = startLocation.y - stopLocation.y;
            //let distance = sqrt(dx*dx + dy*dy );
            print(dy)
            if dy > 200{
                if(dy > 450){
                    let force = SCNVector3(x: Float(dx), y: Float(dy/2) , z: Float(-450))
                    ballNode.physicsBody?.applyForce(force, asImpulse: false)
                }
                else{
                    let force = SCNVector3(x: Float(dx), y: Float(dy/2) , z: Float(-1*(dy)))
                    ballNode.physicsBody?.applyForce(force, asImpulse: false)
                }
            }
            else{
                let force = SCNVector3(x: Float(dx*3), y: Float(dy/2) , z: Float(-100))
                ballNode.physicsBody?.applyForce(force, asImpulse: false)
            }
                
            
                isShot=true
                tmp=true
            //}
            /*if(tmp){
                let force = SCNVector3(x: Float(dx), y: abs(Float(dx)/2) , z: Float(dx)*(-1))
                ballNode.physicsBody?.applyForce(force, asImpulse: false)
            }*/
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if ballNode.presentation.position.z < -2133{
            if ballNode.presentation.position.y < 95 && ballNode.presentation.position.x > 4054 && ballNode.presentation.position.x < 4300{
                print("Goal!")
                resetGame()
                level = level+1
                nextLevel(level: level)
                
                self.levelLabel.text = String(level)
            }
            else{
                print("No Goal!")
                resetGame()
                chances = chances - 1
                self.chanceLabel.text = String(chances)
            }
           
        }
        else if ballNode.presentation.position.z+50 < ballPosition.z && ballNode.physicsBody?.velocity.z == 0 {
            resetGame()
        }
    }
}

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var contactNode: SCNNode!
        if contact.nodeA.name == "Ball" {
            contactNode = contact.nodeB
        } else {
            if contact.nodeB.name != "Ball"{
                return
            }
            contactNode = contact.nodeA
        }
        
        if lastContactNode != nil && lastContactNode == contactNode {
            return
        }
        lastContactNode = contactNode
        
        
        if contactNode.physicsBody?.categoryBitMask == ColliderType.boxes.rawValue {
            print("Hit box")
            chances = chances - 1
            self.chanceLabel.text = String(chances)
            resetGame()
            //game.playSound(node: scnScene.rootNode, name: "Barrier")
        }
        
        
        
    }
}
