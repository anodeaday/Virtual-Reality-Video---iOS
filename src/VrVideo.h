//
//  VrVideo.hpp
//  VrVideo
//
//  Created by Neil van Vuuren on 22/08/2015.
//  kalfie7@gmail.com
//

#ifndef _VrVideo_mm
#define _VrVideo_mm

#include "ofMain.h"
#include "ofxCoreMotion.h"          // iOs Orientation access


#include <stdio.h>


class VrVideo{
    
public:
    void loadVideo(string videoName);
//    void setup();     // Load video. Check Stereo.
    void update(bool useCardboard,bool loop);
    void resetCamera();
    void draw(bool useCardboard);
    void touchDown(int touchX, int touchY);
    void touchMoved(int touchX, int touchY,bool useCardboard);
    void touchUp(int touchX, int touchY);

    
private:
    void setupEnvironment();

    // Video load.
   ofVideoPlayer videoPano;


    //3d Components:

    ofSpherePrimitive monoSphere;
    ofSpherePrimitive stereoSphereLeft;
    ofSpherePrimitive stereoSphereRight;

    ofCamera camera;
    ofFbo leftEyeFBO;
    ofFbo righEyeFBO;


    //Stereo Scene Setup
    ofVec3f centrepoint;
    ofFbo fboMono;
    ofFbo fboCardboard;
    ofFbo fboLeft;
    ofFbo fboRight;


    // Phone Orientation
    ofxCoreMotion coreMotion;
    float spinX;


    // Stereo Logic Operators
    bool isStereo;  // Used to check if video is in a stereoscopic format.
    bool isOU;      // Set if Stereo is Over Under Encoded.
    bool isLR;      // Set if Stereo is Left Right Encoded.



    bool videoisDone;  //NOT USED

    ofVec2f firstTouch;
    int newTouchX;
    int newTouchY;
    int oldTouchX;
    int oldTouchY;
    float cameraRotationX;
    float cameraRotationY;
    ofQuaternion cameraHeading;
    ofQuaternion cameraPitch;
    bool firstRun;
    float oldPitch;
};

#endif /* _Vr_Video_cpp */
