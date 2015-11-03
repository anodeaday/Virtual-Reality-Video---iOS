#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    mainVideo.loadVideo("Bridge_2k.mp4");           //Loads the panoramic video
    useCardboard=false;                             //Start the video in Carboard mode?
    loopVideo=true;                                 //Loop the video?


}

//--------------------------------------------------------------
void ofApp::update(){
    mainVideo.update(useCardboard,loopVideo);
}


//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0,0,0);
    mainVideo.draw(useCardboard);
    

}


//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    mainVideo.touchDown(touch.x, touch.y);                      //Mouse camera with finger if not in cardboard mode)
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    mainVideo.touchMoved(touch.x, touch.y,useCardboard);        //Mouse camera with finger if not in cardboard mode)
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    mainVideo.touchUp(touch.x, touch.y);                        //Mouse camera with finger if not in cardboard mode)
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    useCardboard = !useCardboard;                               //Toggle Cardboard mode
    mainVideo.resetCamera();                                    //Reset camera to phone's orientation

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){


    
}
