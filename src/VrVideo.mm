//
//  VrVideo.cpp
//  VrVideo
//
//  Created by Neil van Vuuren on 22/08/2015.
//  kalfie7@gmail.com
//

#include "VrVideo.h"

    
//_________________________________________________________________Load the video by string and set up video environment
void VrVideo::loadVideo(string videoName){
    videoPano.loadMovie(videoName);
    ofSetOrientation(OF_ORIENTATION_90_LEFT);   
    videoPano.play();
    firstRun=true;
    
    isLR=false;
    isOU=false;
    isStereo=false;


    }

void VrVideo::resetCamera(){
    cameraRotationX=0;
    cameraRotationY=0;
    ofVec3f Znormal(0, 0, 1);
    ofVec3f HeadingNormal(1,0,0);
    ofVec3f HeadingReversed(-1,0,0);
    
    cameraHeading = ofQuaternion(cameraRotationX,Znormal);
    cameraPitch = ofQuaternion(cameraRotationY,HeadingNormal);
}


//_________________________________________________________________Load the FBO and render the scenes.



void VrVideo::update(bool useCardboard, bool loop){
    
     videoPano.update();
    if (loop){
        if (!(videoPano.isPlaying())){
            videoPano.play();
        }
    }

    
    

    
    
   
        ofTranslate(ofGetWidth()/2, ofGetHeight()/2, 0);
    

        coreMotion.update();

        ofQuaternion quat = coreMotion.getQuaternion();                         //Gyroscope Set attitude of Camera!

        ofQuaternion landscapeFix(-quat.y(), quat.x(), quat.z(), quat.w());     // Correct rotation
        if (!useCardboard){
        ofQuaternion cameraTotal;
        cameraTotal = cameraPitch  * landscapeFix * cameraHeading ;
        camera.setOrientation(cameraTotal);
        }
        else{
            camera.setOrientation(landscapeFix);
        }
    
    
    
    if(firstRun)
    {
        videoPano.setVolume((1.0f));
        setupEnvironment();
        firstRun=false;
        oldPitch = camera.getPitch();
    }
    


    

    

    videoPano.getTextureReference().bind();         //LOAD VIDEO as texture
     
            if (!isStereo){
                                                    //Draw a mono video and cardboard view
                if (!useCardboard){fboMono.begin();}
                if (useCardboard){fboCardboard.begin();}
                camera.begin();
                monoSphere.draw();
                if (useCardboard){fboCardboard.end();}
                if (!useCardboard){fboMono.end();}
                camera.end();
            }
            
            if (isStereo){
                
                if (!useCardboard){fboMono.begin();}  //if no cardbaord draw MONO FBO
                if (useCardboard){fboLeft.begin();}   //if Cardboard draw stereo left
                camera.begin();
                stereoSphereLeft.draw();
                if(useCardboard){fboLeft.end();}
                if(!useCardboard){fboMono.end();}
                camera.end();
                
                if (useCardboard){                      //if Cardboard draw stereo right
                    fboRight.begin();
                    camera.begin();
                    stereoSphereRight.draw();
                    fboRight.end();
                    camera.end();
                }
                
            }
        
        
    videoPano.getTextureReference().unbind();

     //Stereo Sanity Check
    // Sometimes the video loads as mono even though it's stereo. Don't know why, this hack fixes it though.

      if ((videoPano.getWidth()/videoPano.getHeight()==1)){
            if(!isStereo){
            cout <<"VIDEO IS STEREO BUT SCENE IS MONO!!!!!! WHAT THE HELL MAN?!" << endl;
            setupEnvironment();
            }
        }

    
    


    }
    
//_________________________________________________________________DRAW 360 Video



void VrVideo::draw(bool useCardboard){

    if (!useCardboard) {
        fboMono.draw(0,0);
        }
        else if (useCardboard) {
            if (isStereo){
                fboLeft.draw(0,0,ofGetScreenHeight()*0.5,ofGetScreenWidth());
                fboRight.draw(ofGetScreenHeight()*0.5,0);

            }
            else{
                fboCardboard.draw(0,0);
                fboCardboard.draw(ofGetScreenHeight()*0.5,0);
            }
            
        }



    }




    
    
//_________________________________________________________________Rotate camera by Hand

void VrVideo::touchDown(int touchX, int touchY){

    oldTouchX = touchX;
    oldTouchY = touchY;

}


void VrVideo::touchMoved(int touchX, int touchY,bool useCardboard){

    if (!useCardboard){
  
        
        newTouchX = touchX;
        newTouchY = touchY;
        
        if (newTouchX != oldTouchX){
            cameraRotationX+=(newTouchX-oldTouchX)*0.5;
        }
        if (newTouchY != oldTouchY){
            cameraRotationY-=(newTouchY-oldTouchY)*0.5;
        }
     
        oldTouchX = touchX;
        oldTouchY = touchY;

        ofVec3f Znormal(0, 0, 1);
        ofVec3f HeadingNormal(1,0,0);
        ofVec3f HeadingReversed(-1,0,0);
        
        cameraHeading = ofQuaternion(cameraRotationX,Znormal);
        cameraPitch = ofQuaternion(cameraRotationY,HeadingNormal);

        if (abs((camera.getPitch())-(oldPitch)) > 170){
            cout<<"flipped?"<<endl;
        }

        
        cout << camera.getPitch()<<endl;
        oldPitch = camera.getPitch();
        



    }
    }

    
//_________________________________________________________________Finish hand rotation of camera



void VrVideo::touchUp(int touchX, int touchY){
        
    }

    



void VrVideo::setupEnvironment(){
    
    
        float vidwidth = videoPano.getWidth();
        float vidheight = videoPano.getHeight();
        cout << "Loaded? " <<    videoPano.isLoaded() <<endl;
        cout <<vidwidth<< " x " << vidheight << " pixels " << endl;
        if (vidwidth/vidheight==1){
            isStereo=true;
            isOU=true;
            isLR=false;
            cout << "VIDEO: IS STEREO Over / Under"<<endl;
        }
    
        else if (vidwidth/vidheight==4){
            isStereo=true;
            isLR=true;
            isOU=false;
            cout << "VIDEO: IS STEREO Left Right"<<endl;
        }
    
        else {
            isStereo=false;
            isOU=false;
            isLR=false;
            cout << "VIDEO: IS MONO"<<endl;
        }




    
        // Allocate and CLEAR all the Buffers
    
        fboMono.allocate(ofGetScreenHeight(), ofGetScreenWidth(),GL_RGB);
    
        

    
        cout << "Allocated Mono FBO"<< endl;

        if (isStereo) {
        fboLeft.allocate((ofGetScreenHeight()*0.5),(ofGetScreenWidth()),GL_RGB);
        fboRight.allocate((ofGetScreenHeight()*0.5),(ofGetScreenWidth()),GL_RGB);
          
            fboLeft.begin();
            ofClear(0,0,0,0);
            fboLeft.end();
            
            fboRight.begin();
            ofClear(0,0,0,0);
            fboRight.end();
            
            cout << "Allocated Stereo FBOs"<< endl;
        }
        
        if (!isStereo){
            fboCardboard.allocate((ofGetScreenHeight()*0.5),(ofGetScreenWidth()),GL_RGB);
            
            fboCardboard.begin();
            ofClear(0,0,0,0);
            fboCardboard.end();
            cout << "Allocated Cardboard FBO"<< endl;
        }
   
        //NEW GYRO CAMERA

        camera.setupPerspective();
        camera.setFov(75);
        camera.setVFlip(false);
        camera.setPosition(0, 0, 0);

    
    
    
    
        cout << "set up camera"<< endl;

        // Create sphere for video mapping:
        
        if (isStereo){
            
            stereoSphereLeft.setRadius(500);
            stereoSphereLeft.setPosition(0,0,0);
            stereoSphereLeft.setOrientation(ofVec3f(270,0,0)); // FIX SPHERE ORIENTATION
            stereoSphereLeft.setResolution(100);
            
            stereoSphereRight.setRadius(500);
            stereoSphereRight.setPosition(0,0,0);
            stereoSphereRight.setOrientation(ofVec3f(270,0,0)); // FIX SPHERE ORIENTATION
            stereoSphereRight.setResolution(100);
            
            if (isOU){
                stereoSphereRight.mapTexCoords(0,0,1,0.5);       //Left Bottom??
                stereoSphereLeft.mapTexCoords(0,0.5,1,1);
                cout << "Mapped UV for OU"<< endl;
            }
            else if (isLR){
                stereoSphereLeft.mapTexCoords(0,0,0.5,1);       //Left - Left half
                stereoSphereRight.mapTexCoords(0.5,0,1,1);      //Right - Right half
                cout << "Mapped UV for LR"<< endl;
            }

        }
        else{
            monoSphere.setRadius(500);
            monoSphere.setPosition(0,0,0);
            monoSphere.setOrientation(ofVec3f(270,0,0)); // FIX SPHERE ORIENTATION
            monoSphere.setResolution(100);
        }
        
        /* combinations for viewing:
    
         Mono Video 360:
            Camera + fboMono + monoSphere
         
         Mono Video Cardboard:
            Camera + fboCardboard + monoSphere

         
         Stereo Video 360:
            Camera + fboMono + stereoSphereLeft
         
         Stereo Video Cardboard:
            Camera + fboLeft + fbo Right + sterepSphereLeft + stereoSphereRight
         
         */
        
        
    
    
     /*
     
     Setup Core Motion for Attiude readout.
     There are two options for using the phone's attitude - either magnetic north or arbitrary
     Magnetic north could be useful for Augmented reality or location based projects
     Arbitrary is useful for general video - ensuring the forward view will reset for each opening of the app.
    
     */
    
    //coreMotion.setupAttitude(CMAttitudeReferenceFrameXMagneticNorthZVertical);  // Always north
    
    coreMotion.setupAttitude(CMAttitudeReferenceFrameXArbitraryZVertical);  //Forward is app facing direction.
    

    //these accumlate all change
    cameraRotationX=0.0f;
    cameraRotationY=0.0f;
    
}
    
    
    

    
    
    

    

    
        

