#include "ofMain.h"
#include "ofApp.h"

int main(){

//    ofAppiOSWindow * window = new ofAppiOSWindow();
//    window->enableHardwareOrientation();
//    window->enableOrientationAnimation();
  
    ofSetupOpenGL(1024,768,OF_FULLSCREEN);			// <-------- setup the GL context
	ofRunApp(new ofApp());
}
