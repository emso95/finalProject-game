import UIKit
import SceneKit


class GameViewController: UIViewController {
    var isShot=false;
    var tmp=false;
    var startLocation = CGPoint()
    var ballPosition: SCNVector3!
    var scnView: SCNView!
    var scnScene: SCNScene!
    var panGesture = UIPanGestureRecognizer()
    var game = GameHelper.sharedInstance
    var verticalCameraNode: SCNNode!
    var ballNode: SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    func setupScene() {
        scnView = self.view as! SCNView
        scnView.delegate = self
        
        scnScene = SCNScene(named: "freekickerArt.scnassets/Scene/model.scn")
        scnView.scene = scnScene
        scnView.showsStatistics = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.shootBall(_:)))
        scnView.addGestureRecognizer(panGesture)
    }
    
    func setupNodes() {
        
        verticalCameraNode = scnScene.rootNode.childNode(withName: "cameraa", recursively: true)!
        
        scnScene.rootNode.addChildNode(game.hudNode)
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively:
            true)!
        ballPosition =  ballNode.position
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
            print(dx)
            if dy > 200 && tmp == false{
                
                let force = SCNVector3(x: Float(dx), y: Float(250/3) , z: Float(-1*(150)))
                
                //let position = SCNVector3(x: 0, y: 0, z: 0)
                ballNode.physicsBody?.applyForce(force, asImpulse: true)
                isShot=true
                tmp=true
            }
            if(tmp){
                let force = SCNVector3(x: Float(dx), y: abs(Float(dx)/2) , z: Float(dx)*(-1))
                ballNode.physicsBody?.applyForce(force, asImpulse: false)
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
        if ballNode.presentation.position.z < -2133{
            if ballNode.presentation.position.y < 95 && ballNode.presentation.position.x > 4054 && ballNode.presentation.position.x < 4300{
                print("Goal!")
            }
            else{
                print("No Goal!")
            }
           resetGame()
        }
        else if ballNode.presentation.position.z+50 < ballPosition.z && ballNode.physicsBody?.velocity.z == 0 {
            resetGame()
        }
    }
}
