// Persistence of Vision Ray Tracer Scene Description File

#version 3.5; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm



 
---------------------------------------------------Modeling approach---------------------------------------------- 
In this file I will model a small leaf. The leaf blade will not be modeled by anchor points from an enclosing rectangle, as in the earlier approaches, but by anchor points from more or less rectangular branches. 
(Since it is only a minor leaflet, it actually only has one leaf vein - the "main" leaf vein. I also introduced to minor leaf veins branching from the main one at right angles for modeling purposes. These
leaf veins are shown in red colour here and are not included in the real picture. ) 

From these "leaf veins" positions and normals for the blade elements are calculated and flat spheres are positioned accordingly. Finally they are fused into a blob and this blob is cut by a prism. 

*/

//-----------------------------------Scene settings (Camera, light, background)-------------------------------------------------

global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}

#declare Kameraz = camera {
    location  <1.25, 1.25, -3.75>
    right     x*image_width/image_height
    look_at   <0, 0.9,  0>
}

camera {
    Kameraz
}

light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>*2    // light's color
    translate <100, -5, -20>
}
light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>    // light's color
    translate <30, -5, -100>
}
light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>    // light's color
    translate <0, 35, 00>
}


// ----------------------------------------


//Coordinate system

cylinder { <0, -100, 0>, <0, 100, 0>, 0.01 
  pigment {

    color rgb <0,1,0>     // solid color pigment
  }
}


cylinder { <-100, 0, 0>, <100, 0, 0>, 0.01 
  pigment {

    color rgb <1,0,0>     // solid color pigment
  }
}


cylinder { <0, 0, -100>, <0, 0, 100>, 0.01 
  pigment {

    color rgb <0,0,1>     // solid color pigment
  }
}


//----------------------------------Textures------------------------------- 

#declare Normal_1 = normal {
    bumps 0.6 scale 0.03 turbulence 0.5
} 
#declare Normal_2 = normal {
    crackle 2.3 scale 0.2 turbulence 0.2
} 

#declare VeinTexture = texture { 
    pigment{ 
        color rgb<0, 0.9, 0>
    }
    finish { 
        phong 1.0 reflection 0.00
    }
}; // end of texture 

#declare VeinTextureb = texture { 
    pigment{ 
        color rgb<1, 0, 0>
    }
    finish { 
        phong 1.0 reflection 0.00
    }
}; // end of texture 

#declare  LeafTexture = texture { 
    pigment{ 
        color rgb<0, 0.3, 0>
    }
    normal {
        average
        normal_map {
            [1.0  Normal_1]     // weighting 1.0
            [0.5  Normal_2]     // weighting 0.5
        }
    }
}; // end of texture 


//----------------------Splines----------------------------------------------------------------------       

#declare chance1 = seed (3); 

//Main leaf vein

#declare P1 = <0, 0, 0>; 
#declare P2 = <0., 1.5, 0.> + <0.1*(rand(chance1)-0.5), 0, 0.1*(rand(chance1)-0.5)>; 
#declare P3 = <0., 3, 1.5> + <0.1*(rand(chance1)-0.5), 0, 0.1*(rand(chance1)-0.5)>; 

#declare MainSpline = spline {
    cubic_spline
   
    -2, <0, -3, 0>+ <0.1*(rand(chance1)-0.5), 0, 0.1*(rand(chance1)-0.5)>, // control point
    -1, <0, -1.5, 0>+ <0.1*(rand(chance1)-0.5), 0, 0.1*(rand(chance1)-0.5)>,// control point

    0, P1, 
    1, P2,
    2, P3,

    3, P3 + 2*(P3-P2),
    4, P3 + 4*(P3-P2),
}   

//Minor leaf vein - right side 

#declare P1 = MainSpline(1.0); 
#declare P2 = P1 + <0.55, 0., 0> + 0.4*<rand(chance1)-0.5, rand(chance1)-0.5, rand(chance1)-0.5>; 
#declare P3 = P1 + <1.1, 0, 0> + 0.4*<rand(chance1)-0.5, rand(chance1)-0.5, rand(chance1)-0.5>; 

#declare MinorSplineA = spline {
    cubic_spline
   
    -2, MainSpline (0.2), // control point
    -1, MainSpline (0.6),// control point

    0, P1, 
    1, P2,
    2, P3,

    3, P3 + 1*(P3-P2),
    4, P3 + 2*(P3-P2),
}   

//Minor leaf vein - left side

#declare P1 = MainSpline(1.0); 
#declare P2 = P1 + <-0.55, 0., 0> + 0.4*<rand(chance1)-0.5, rand(chance1)-0.5, rand(chance1)-0.5>; 
#declare P3 = P1 + <-1.1, 0, 0> + 0.4*<rand(chance1)-0.5, rand(chance1)-0.5, rand(chance1)-0.5>; 

#declare MinorSplineB = spline {
    cubic_spline
   
    -2, MainSpline (0.2), // control point
    -1, MainSpline (0.6),// control point

    0, P1, 
    1, P2,
    2, P3,

    3, P3 + 1*(P3-P2),
    4, P3 + 2*(P3-P2),
}   


//--------------------Showing the splines-----------------------------------


//Minor veins are not shown in the real image, since they are at wrong positions. I have only included them for modeling purposes and only show them to make the model more understandable

blob {
    threshold 0.6
    
    //Minor leaf vein
    #declare ticker = 0; 
    #while (ticker < 2)

        sphere { 
            <0,0,0>, (0.05), 1 
            texture { 
                VeinTextureb  
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate MinorSplineA (ticker)  
        }  // end of sphere ----------------------------------- 
    #declare ticker = ticker + 0.007; 
    #end
}

blob {
    threshold 0.6

    //Minor leaf vein
    #declare ticker = 0; 
    #while (ticker < 2)

        sphere { 
            <0,0,0>, (0.05), 1 
            texture {  
                VeinTextureb  
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate MinorSplineB (ticker)  
        }  // end of sphere ----------------------------------- 
    #declare ticker = ticker + 0.007; 
    #end
}




//----------------------------------Objects------------------------------- 

#intersection {

    blob {
        threshold 0.6
        //Main leaf vein

        #declare ticker = 0; 
        #while (ticker < 2)

            sphere { 
                <0,0,0>, (0.12-0.038*ticker)*1.4, 1 
                texture { 
                    VeinTexture  
                } // end of texture
                scale<1,1,1>  rotate<0,0,0>  translate MainSpline (ticker)  
            }  // end of sphere ----------------------------------- 
        #declare ticker = ticker + 0.007; 
        #end


//---------------------------------------Elements of the leaf blades-----------------------------------------

//Both sides of the leaf blade are modeled separately - here comes the right side
        #declare ticker = 1; 
        #while (ticker <28)

            #declare tickerb = 0;
            #while (tickerb < 15) 

                #declare VektorNeben = MinorSplineA (0.1 + 0.2 * tickerb + 0.1) - MinorSplineA (0.1 + 0.2 * tickerb -0.1);          //vector representing the direction of the minor right leaf vein
                #declare VektorHaupt =  MainSpline (0.5 + 0.07*ticker + 0.1) - MainSpline (0.5 + 0.07*ticker - 0.1);                //Vector representing the direction of the major leaf vein

                #declare Normal = vcross(VektorNeben, VektorHaupt);                                                                 //Vector representing the normal of a given point of the leaf blade

                #declare PNeu =  MainSpline (0.5 + 0.07*ticker) + (MinorSplineA ( 0.1 + 0.2 * tickerb ) - (MainSpline (1)  ));      //Position of a given point of the leaf blade


                #if (abs(Normal.x)>abs(Normal.z))                                                                                   //the following procedure places a flat sphere onto the position and rotates 
                                                                                                                                    //it according to the normal
                    #local AngleY = degrees(atan2(Normal.z, Normal.x));  
                    #local N2 = vrotate (Normal, <0, AngleY, 0>);
                    #local AngleZ = degrees(atan2(N2.y, N2.x));
                    sphere { 
                        <0, 0, 0>, 0.25 ,1
                        scale <1, 0.2, 1>
                        rotate <0, 90, 0>
                        rotate <0, 0, 270 +AngleZ>
                        rotate <0, -AngleY, 0>
                        translate PNeu
                        texture { 
                            LeafTexture  
                        } // end of texture
                    }  

                #else

                    #if (abs(Normal.z)>0)

                        #local AngleY = degrees(atan2(Normal.x, Normal.z));
                        #local N2 = vrotate (Normal, <0, -AngleY, 0>); 
                        #local AngleX = -degrees(atan2(N2.y, N2.z));
                        sphere { 
                            <0, 0, 0>, 0.25 ,1
                            scale <1, 0.2, 1>
                            rotate <AngleX+90, 0, 0>
                            rotate <0, AngleY, 0>
                            translate PNeu
                            texture { 
                                LeafTexture  
                            } // end of texture
                        }  
  
                    #else//This covers positions with  

                        sphere { 
                            <0, 0, 0>, 0.25 ,1
                            scale <1, 0.2, 1>
                            translate PNeu
                            texture { 
                                LeafTexture  
                            } // end of texture
                        }  
                    #end 
                #end  

            #declare tickerb = tickerb + 1; 
            #end

        #declare ticker = ticker + 1; 
        #end   

//Both sides of the leaf blade are modeled separately - here comes the left side


        #declare ticker = 1; 
        #while (ticker <28)

            #declare tickerb = 0;
            #while (tickerb < 15) 

                #declare VektorNeben = MinorSplineB (0.1 + 0.2 * tickerb + 0.1) - MinorSplineB (0.1 + 0.2 * tickerb -0.1);           //vector representing the direction of the minor left leaf vein
                #declare VektorHaupt =  MainSpline (0.5 + 0.07*ticker + 0.1) - MainSpline (0.5 + 0.07*ticker - 0.1);                 //Vector representing the direction of the major leaf vein

                #declare Normal = vcross(VektorNeben, VektorHaupt);                                                                  //Vector representing the normal of a given point of the leaf blade

                #declare PNeu =  MainSpline (0.5 + 0.07*ticker) + (MinorSplineB ( 0.1 + 0.2 * tickerb ) - (MainSpline (1)  ));       //Position of a given point of the leaf blade

                #if (abs(Normal.x)>abs(Normal.z)) 
                                                                                                                                     //the following procedure places a flat sphere onto the position and rotates 
                    #local AngleY = degrees(atan2(Normal.z, Normal.x));                                                              //it according to the normal
                    #local N2 = vrotate (Normal, <0, AngleY, 0>);
                    #local AngleZ = degrees(atan2(N2.y, N2.x));
                    sphere {        
                        <0, 0, 0>, 0.25 ,1
                        scale <1, 0.2, 1>
                        rotate <0, 90, 0>
                        rotate <0, 0, 270 +AngleZ>
                        rotate <0, -AngleY, 0>
                        translate PNeu
                        texture { 
                            LeafTexture  
                        } // end of texture
                    }  

                #else

                    #if (abs(Normal.z)>0)

                        #local AngleY = degrees(atan2(Normal.x, Normal.z));
                        #local N2 = vrotate (Normal, <0, -AngleY, 0>); 
                        #local AngleX = -degrees(atan2(N2.y, N2.z));
                        sphere { 
                            <0, 0, 0>, 0.25 ,1
                            scale <1, 0.2, 1>
                            rotate <AngleX+90, 0, 0>
                            rotate <0, AngleY, 0>
                            translate PNeu
                            texture { 
                                LeafTexture  
                            } // end of texture
                        }  
  
                    #else//This covers positions with  

                        sphere {    
                            <0, 0, 0>, 0.25 ,1
                            scale <1, 0.2, 1>
                            translate PNeu
                            texture { 
                                LeafTexture  
                            } // end of texture
                        }  
                    #end 
                #end  

            #declare tickerb = tickerb + 1; 
            #end

        #declare ticker = ticker + 1; 
        #end   

    } 




    #declare P1 = MainSpline (0.5) + <-0.2, 0, 0>;
    #declare P2 = MainSpline (-0.2) + <-0.2, 0, 0>;
    #declare P3 = MainSpline (-0.2) + <0.2, 0, 0>;
    #declare P4 = MainSpline (0.5) + <0.2, 0, 0>;
    #declare P5 = MinorSplineA (2.0) ;
    #declare P6 = MainSpline (1.9);
    #declare P7 = MinorSplineB (2.0) ;


    // linear prism in y-direction: from .. ,to ..,number of points (first = last)          //here comes the prism for cutting the leaf. 
    prism { 
        linear_sweep
        cubic_spline
        -5.00 ,5.00 , 10 
        
        <P1.x, P1.y>, 
        <P2.x, P2.y>, 
        <P3.x, P3.y>, 
        <P4.x, P4.y>, 
        <P5.x, P5.y>, 
        <P6.x, P6.y>, 
        <P7.x, P7.y>, 
        <P1.x, P1.y>,
        <P2.x, P2.y>, 
        <P3.x, P3.y>
        
        texture {
            LeafTexture
        }
        rotate<-90,0,0> 
        translate<0.0,0, 0.5> 
    } // end of prism --------------------------------------------------------
}
 

