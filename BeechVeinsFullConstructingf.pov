// Persistence of Vision Ray Tracer Scene Description File

#version 3.6; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm
*/ 
 
/*
---------------------------------------------------Modeling approach---------------------------------------------- 

This file demonstrates my basic approach for creating planar structures directed by two splines. Splines have to run in similar directions. Corresponding positions on the two splines are defined and these positions are 
then connected by row of spheres ultimately being integrated in a common blob. 

In the case of this leaf I am using three different splines. The main leaf vein in the middle and the left and right outer edge of the leave. The left and right leaf blade are created by connecting corresponding 
positions on the main leaf vein on the one hand and on the left our right outer leaf edge. For defining these positions a vector from the leaf base to the leaf tip is defined and positions are distributed evenly
along this vector. 
Projections of these positions, orthogonal to the leaf vector are then created on the main vein and the outer edges.  

*/ 
                
//-----------------------------------Scene settings (Camera, light, background)-------------------------------------------------

global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}



// create a regular point light source
light_source {
    0*x                  // lights position (translated below)
    color rgb <1,1,1>    // lights color
    //shadowless
    translate <20, 60, -20>
} 

// create a regular point light source
light_source {
    0*x                  // lights position (translated below)
    color rgb <1,1,1>    // lights color
    //shadowless
    translate <0, -10, -60>
} 

/*
//Die Hauptachsen

cylinder { 
    <-50, 0, 0>, <50, 0, 0>, 0.03 
    pigment {          // (---surface color---)
        color rgb <1,0,0>    // lights color
    }
}

cylinder { 
    <0, -50, 0>, <0, 50, 0>, 0.03 
    pigment {          // (---surface color---)
        color rgb <0,1,0>    // lights color
    }
}

cylinder { 
    <0, 0, -50>, <0, 0, 50>, 0.03 
    pigment {          // (---surface color---)
        color rgb <0,0,1>    // lights color
    }
}

*/
//The camera

#declare Kamerax = camera {
    location  <25, 3, 10>
    look_at   <0, 0,  10.0>
}


#declare Kameray = camera {
    location  <-10, 25, 0> 
    look_at   <-10, 0,  0>
    rotate <0, 90, 0>
    translate <0, 0, 0>
}

#declare Kameraz = camera {
    location  <-3, 0, 25>
    look_at   <0, 0,  0.0>
}



#declare Hauptkamera = camera {
    location  <-4, 3, 20> 
    look_at   <0, 0,  15>
}


camera {
    Kameray
} 

//----------------------------------------Main variables and textures-----------------------------------------------------------

#declare chance1 = seed (4); 


#declare LateralThickness = 0.1;



#declare BladeTexture = texture { 
    pigment { 
        color rgb <0., 0.6,0> 
    }
    normal {
        agate 0.05
        scale 0.2
        turbulence 0.5
    }
    finish{
        specular 0.2
    }
} // end of texture

#declare VeinTexture = texture { 
    pigment { 
        color rgb <0., 0.5,0>  
    }
    finish  { 
        specular 0.02  
    } 
} // end of texture



//=====================================Definition of the main splines for the leaf=============================================



//-----------------------------------The leaf stalk--------------------------------

                                                                        

#declare Stalk = 

spline { 
    cubic_spline

    -2, <0, 2, -9>, // control point
    -1, <0, 1, -7>,// control point
   
    00, <-0.9, 2, -5>,  
    01, <-0.2, 0.1, -3>,  
    02, <0, 0, 0>,  
   
    03, <0, 0, 1>,  
    04, <0, 0, 2>,  
   
}
   

//---------------------------------The main leaf vein------------------------------------

#declare P0 = <0, 0, 0>; 
#declare PC0b = <0.2, -0.1, 6> + <0, 0.5, 0>; 
#declare PC1 = <0.4, -0.2, 12> + <0, -0.5, 0>; 
#declare PC1b = <0.2, -0.3, 16> + <0, 0.25, 0>; 
#declare PC2 = <0, -0.4, 20>; 

#declare MainVein = spline { 
    cubic_spline

    -2, <0, 2, 0>, // control point
    -1, <0, 1, 0>,// control point
   
    00, P0,  
    01, PC0b,  
    02, PC1,  
    03, PC1b,  
    04, PC2,  
   
    05, <0, 2.5, 22>,  
    06, <0, 2.7, 24>,  
   
}



//--------------------------------------The spline for the right edge------------------------------------------------- 

#declare PC1 = <3.5,- 0.2, 2>; 
#declare PC2 = <5.3,- 0.6, 7>+ <0, 0.9, 0>; 
#declare PC3 = <4.8,- 0.8, 14>; 
#declare PC4 = <0.8, -0.7, 18> + <0, 1, 0>; 
#declare PC5 = <0, -0.4, 20>; 

#declare OutRight = spline {                                                        //Spline for the right border of the leaf
    cubic_spline

    -2, <0, 2, 0>, // control point
    -1, <0, 1, 0>,// control point
   
     00, P0,  
    01, PC1,  
    02, PC2,  
    03, PC3,  
    04, PC4,  
    05, PC5,  
   
    06 <0, 2.5, 22>,  
    07, <0, 2.7, 24>,  
   
}

//--------------------------------------The spline for the left leaf's edge------------------------------------------------

#declare PC1 = <-3.5,- 0.15, 2.5>; 
#declare PC2 = <-5.5,- 0.5, 6>; 
#declare PC3 = <-5.2,- 0.8, 13>+<0, -3, 0>; 
#declare PC4 = <-0.8, -0.6, 18>; 
#declare PC5 = <0, -0.4, 20>; 

#declare OutLeft =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, <0, 2, 0>, // control point
    -1, <0, 1, 0>,// control point
   
    00, P0,  
    01, PC1,  
    02, PC2,  
    03, PC3,  
    04, PC4,  
    05, PC5,  
   
    06 <0, 2.5, 22>,  
    07, <0, 2.7, 24>,  
   
}

//============================================Definition of the lateral splines for the right side ======================================================


//-----------------------------------Right side, 1. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.3); 
#declare PLat3 = OutRight (1.6); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR1 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0), // control point
    -1, MainVein(0.1),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}

//-----------------------------------Right side, 2. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.55); 
#declare PLat3 = OutRight (2); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR2 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0.25), // control point
    -1, MainVein(0.35),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Right side, 3. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.8); 
#declare PLat3 = OutRight (2.3); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR3 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0.5), // control point
    -1, MainVein(0.6),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}


//-----------------------------------Right side, 4. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(1.1); 
#declare PLat3 = OutRight (2.55); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR4 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0.7), // control point
    -1, MainVein(0.9),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}



//-----------------------------------Right side, 5. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(1.4); 
#declare PLat3 = OutRight (2.8); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR5 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(1.0), // control point
    -1, MainVein(1.2),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}



//-----------------------------------Right side, 6. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(1.8); 
#declare PLat3 = OutRight (3.1); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR6 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(1.4), // control point
    -1, MainVein(1.6),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}



//-----------------------------------Right side, 7. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(2.2); 
#declare PLat3 = OutRight (3.35); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR7 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(1.7), // control point
    -1, MainVein(1.9),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}



//-----------------------------------Right side, 8. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(2.6); 
#declare PLat3 = OutRight (3.55); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR8 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(2.2), // control point
    -1, MainVein(2.4),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}


//-----------------------------------Right side, 9. lateral vein---------------------------------------- 


#declare PLat1 = MainVein(2.95); 
#declare PLat3 = OutRight (3.75); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

#declare LatR9 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(2.6), // control point
    -1, MainVein(2.8),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
   
}


//============================================Definition of the lateral splines for the left side ======================================================


//-----------------------------------Left side, 1. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.35); 
#declare PLat3 = OutLeft (1.8); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 

 
#declare LatL1 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0), // control point
    -1, MainVein(0.1),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 2. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.6); 
#declare PLat3 = OutLeft (2.2); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL2 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0), // control point
    -1, MainVein(0.1),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 3. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(0.9); 
#declare PLat3 = OutLeft (2.5); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL3 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0.5), // control point
    -1, MainVein(0.7),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 4. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(1.2); 
#declare PLat3 = OutLeft (2.75); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL4 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(0.8), // control point
    -1, MainVein(1.0),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 5. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(1.5); 
#declare PLat3 = OutLeft (3.05); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL5 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(1.1), // control point
    -1, MainVein(1.3),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 6. lateral vein---------------------------------------- 

           #declare PLat1 = MainVein(1.83); 
#declare PLat3 = OutLeft (3.3); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL6 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(1.5), // control point
    -1, MainVein(1.7),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 7. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(2.15); 
#declare PLat3 = OutLeft (3.45); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL7 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(2.0), // control point
    -1, MainVein(2.1),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}



//-----------------------------------Left side, 8. lateral vein---------------------------------------- 


#declare PLat1 = MainVein(2.5); 
#declare PLat3 = OutLeft (3.6); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL8 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(2.3), // control point
    -1, MainVein(2.5),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}


//-----------------------------------Left side, 9. lateral vein---------------------------------------- 

#declare PLat1 = MainVein(2.85); 
#declare PLat3 = OutLeft (3.8); 
#declare PLat2 = PLat1 + 0.5*(PLat3 - PLat1) + <0, 0.6*(rand(chance1)-0.5), 0>; 
 
#declare LatL9 =  spline {                                        //The spline representing the left border

    cubic_spline

    -2, MainVein(2.6), // control point
    -1, MainVein(2.8),// control point
   
    00, PLat1,  
    01, PLat2,  
    02, PLat3,  
   
    03 PLat3 + 0.1 *(PLat3-PLat2),  
    04, PLat3 + 0.1 *(PLat3-PLat2),  
}




//======================================Visualization of the splines defined ======================================================
#union { 


                                                                        //A blob for visualizing the stalk
blob {
    threshold 0.6 //Showing the spline

    #declare ticker = 0; 
    #while (ticker < 2) 

    sphere {    
        <0,0,0>, 0.15, 1
        texture { 
            pigment { 
                color rgb <60/255,10/255,10/255> 
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate Stalk (ticker)
    }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.01; 
    #end  
}

 

blob {                                                                               //A blob visualizing the main leaf vein
    threshold 0.6 //Showing the spline

    #declare ticker = 0; 
    #while (ticker < 4) 

    sphere {    
        <0,0,0>, 0.15-ticker*ticker*0.011, 1
        texture { 
            pigment { 
                color rgb <0/255,0.4,0/255> 
            }
            finish  { 
                specular 0.2  
            } 
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate MainVein (ticker)
    }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.004; 
    #end  
}

/*
blob {                                                                        //This blob visualizes the right edge
    threshold 0.6 //Showing the spline

    #declare ticker = 0; 
    #while (ticker < 5) 

    sphere {    
        <0,0,0>, 0.1-ticker*0.004, 1
        texture { 
            pigment { 
                color rgb <0/255,0.4,0/255> 
            }
            finish  { 
                specular 0.2  
            } 
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate OutRight (ticker)
    }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.0025; 
    #end  
} 

  
blob {                                                                        //This blob visualizes the left edge
    threshold 0.6 //Showing the spline

    #declare ticker = 0; 
    #while (ticker < 5) 

    sphere {    
        <0,0,0>, 0.1-ticker*0.004, 1
        texture { 
            pigment { 
                color rgb <0/255,0.4,0/255> 
            }
            finish  { 
                specular 0.2  
            } 
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate OutLeft (ticker)
    }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.0025; 
    #end  
} 
*/

//------------------------------------------------------------Visualization of the lateral leaf veins on the right side---------------------------------------


//-----------------------------------Right side, 1. lateral vein---------------------------------------- 

blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR1 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 
             


//-----------------------------------Right side, 2. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR2 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 
             
             
//-----------------------------------Right side, 3. lateral vein---------------------------------------- 




blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR3 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 
             


//-----------------------------------Right side, 4. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR4 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 
             
             

//-----------------------------------Right side, 5. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR5 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 
             
             

//-----------------------------------Right side, 6. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR6 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.04; 
    #end  
} 
             
             

//-----------------------------------Right side, 7. lateral vein---------------------------------------- 


blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR7 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.05; 
    #end  
} 
             
             

//-----------------------------------Right side, 8. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR8 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.06; 
    #end  
} 
             
             

//-----------------------------------Right side, 9. lateral vein---------------------------------------- 


blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness -0.02, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatR9 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.06; 
    #end  
} 
             
             
//--------------------------------------Visualization of the lateral leaf veins on the left side------------------------------------------------------------


//-----------------------------------Left side, 1. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL1 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 



//-----------------------------------Left side, 2. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL2 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.02; 
    #end  
} 


//-----------------------------------Left side, 3. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL3 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.02; 
    #end  
} 



//-----------------------------------Left side, 4. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL4 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.02; 
    #end  
} 



//-----------------------------------Left side, 5. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL5 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.02; 
    #end  
} 


//-----------------------------------Left side, 6. lateral vein---------------------------------------- 



blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL6 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.03; 
    #end  
} 


//-----------------------------------Left side, 7. lateral vein---------------------------------------- 


blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL7 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.04; 
    #end  
} 



//-----------------------------------Left side, 8. lateral vein---------------------------------------- 

blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL8 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.04; 
    #end  
} 


//-----------------------------------Left side, 9. lateral vein---------------------------------------- 


blob {
    threshold 0.6 //Showing the spline
    #declare ticker4 = 0; 
    #while (ticker4 < 2) 
        sphere {    
            <0,0,0>, LateralThickness -0.02, 1//-ticker*0.004, 1
            texture { 
                VeinTexture
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate LatL9 (ticker4)
        }  // end of sphere ----------------------------------- 
    #declare ticker4 =  ticker4 + 0.04; 
    #end  
} 


//====================================================Defining blobs for the leaf blade areas on the right side===========================================

#declare SteepnessY = 0.05;                         //Extent of the waves in y-direction
#declare ElementRadius = 0.05;                      //Radius of sphere used for building up the blades
#declare Step = 0.010;                              //Distance spheres in these blades



//--------------------------------------------------Right blade between the outer edge and the first lateral vein---------------------------------------------



blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = OutRight (ticker*3/4);           //Points from the first lateral vein on the right side
        #declare P2 = LatR1 (ticker);           //and points from the second lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            //#declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}




//--------------------------------------------------Right blade between the first and the second lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = LatR1 (ticker);           //Points from the first lateral vein on the right side
        #declare P2 = LatR2 (ticker);           //and points from the second lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the second and third lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = LatR2 (ticker);           //Points from the second lateral vein on the right side
        #declare P2 = LatR3 (ticker);           //and the third lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}




//--------------------------------------------------Right blade between the third and fourth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR3 (ticker);           //Points from the third lateral vein on the right side
        #declare P2 = LatR4 (ticker);           //and the fourth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the fourth and fifth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR4 (ticker);           //Points from the fourth lateral vein on the right side
        #declare P2 = LatR5 (ticker);           //and the fifth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the fifth and sixth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR5 (ticker);           //Points from the fifth lateral vein on the right side
        #declare P2 = LatR6 (ticker);           //and the sixth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the sixth and seventh lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR6 (ticker);           //Points from the sixth lateral vein on the right side
        #declare P2 = LatR7 (ticker);           //and the seventh lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the seventh and eighth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR7 (ticker);           //Points from the seventh lateral vein on the right side
        #declare P2 = LatR8 (ticker);           //and the eighth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade between the eighth and nineth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatR8 (ticker);           //Points from the eighth lateral vein on the right side
        #declare P2 = LatR9 (ticker);           //and the nineth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Right blade at the leaf tip; betwen the main vein and the outer edge--------------------------------------------




blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <1)
 
        #declare P1 = MainVein (2.95 + 1.05 * ticker);           //Points from the eighth lateral vein on the right side
        #declare P2 = OutRight (3.75 + 1.25 * ticker);           //and the nineth lateral vein on the right side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
           // #declare PNew = PNew + <-0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//====================================================Defining blobs for the leaf blade areas on the left side===========================================



//--------------------------------------------------Left blade between the outer edge and the first lateral vein---------------------------------------------



blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = OutLeft (ticker*3/4);           //Points from the first lateral vein on the left side
        #declare P2 = LatL1 (ticker);           //and points from the second lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}





//--------------------------------------------------Left blade between the first and the second lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = LatL1 (ticker);           //Points from the first lateral vein on the left side
        #declare P2 = LatL2 (ticker);           //and points from the second lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the second and third lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2.0)
 
        #declare P1 = LatL2 (ticker);           //Points from the second lateral vein on the left side
        #declare P2 = LatL3 (ticker);           //and the third lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}




//--------------------------------------------------Left blade between the third and fourth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL3 (ticker);           //Points from the third lateral vein on the left side
        #declare P2 = LatL4 (ticker);           //and the fourth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the fourth and fifth lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL4 (ticker);           //Points from the fourth lateral vein on the left side
        #declare P2 = LatL5 (ticker);           //and the fifth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the fifth and sixth lateral vein---------------------------------------------

blob {
    threshold 0.6 //This blob represents the right leaf blade

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL5 (ticker);           //Points from the fifth lateral vein on the left side
        #declare P2 = LatL6 (ticker);           //and the sixth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the sixth and seventh lateral vein---------------------------------------------

blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL6 (ticker);           //Points from the sixth lateral vein on the left side
        #declare P2 = LatL7 (ticker);           //and the seventh lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the seventh and eighth lateral vein---------------------------------------------

blob {
    threshold 0.6 //This blob represents the right leaf blade

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL7 (ticker);           //Points from the seventh lateral vein on the left side
        #declare P2 = LatL8 (ticker);           //and the eighth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade between the eighth and nineth lateral vein---------------------------------------------

blob {
    threshold 0.6 //This blob represents the right leaf blade

    #declare ticker = 0;
    #while (ticker  <2)
 
        #declare P1 = LatL8 (ticker);           //Points from the eighth lateral vein on the left side
        #declare P2 = LatL9 (ticker);           //and the nineth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew + <0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
            #declare PNew = PNew + <0.5*ticker*ticker*(Zero-factor), 0, 0>;    //And here the outer edge of the leave is somewhat reduced with respect to the slightly protruding lateral veins.     
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}



//--------------------------------------------------Left blade at the leaf tip; betwen the main vein and the outer edge--------------------------------------------




blob {
    threshold 0.6 

    #declare ticker = 0;
    #while (ticker  <1)
 
        #declare P1 = MainVein (2.85 + 1.15 * ticker);           //Points from the eighth lateral vein on the left side
        #declare P2 = OutLeft (3.8 + 1.2 * ticker);           //and the nineth lateral vein on the left side
        #declare PNew = P1;
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(PNew-P1) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+1*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+0.5*Step*(P2-P1)+1*Step*ticker2*(P2-P1); 
            
            #end
            #declare Dist1 = vlength (PNew - P1);              //Now an inverse quadratic function is prepared with a maximum right on half way between P1 and P2 (0.5*(P2-P1) 
            #declare Half = vlength (0.5*(P2-P1));             //Half equals precisely half the distance between P1 and P2, where the output of the quadratic function should be maximum.
            #declare factor = SteepnessY*pow((Dist1-Half), 2); //This is the quadratic function
            #declare Zero = SteepnessY*pow (Half, 2);             //Zero is necessary for setting y-values at P1 and P2 to zero.
            #declare PNew = PNew - 2*<0, Zero-factor, 0>;                         //Here the area between the lateral veins is raised slightly above the level of the lateral veins
             
            sphere { 
                <0,0,0>, ElementRadius, 1
                translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + 0.7*Step; 
    #end 
    texture { 
        BladeTexture
    } // end of texture
}







rotate <0, 0, 360* clock>

}


