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
    location  <25, 15, 10>
    look_at   <0, 0,  10.0>
}


#declare Kameray = camera {
    location  <0, 23, 0> 
    look_at   <0, 0,  0>
    rotate <0, 90, 0>
    translate <0, 0, 7>
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


//-----------------------------------The leaf stalk--------------------------------

                                                                         //For purposes of animation, the whole leaf is put into a union

#declare Stiel = 

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
#declare PC1 = <0.4, -0.2, 12> + <0, -1, 0>; 
#declare PC2 = <0, -0.4, 20>; 

#declare MainVein = spline { 
    cubic_spline

    -2, <0, 2, 0>, // control point
    -1, <0, 1, 0>,// control point
   
    00, P0,  
    01, PC1,  
    02, PC2,  
   
    03, <0, 2.5, 22>,  
    04, <0, 2.7, 24>,  
   
}

#declare SizeMainVein = 2;   

#declare BladeTexture = texture { 
    pigment { 
        color rgb <0.3,1,0.3> 
    }
    normal {
        bumps 0.4
        scale 0.1
        turbulence 0.5
    }
} // end of texture


//---------------------------------------------------------------------Right leaf blade-------------------------------------------------------



//As points of reference we will take positions distributed evenly along a main axis. Here are the parameters for this points.
#declare MainAxis = MainVein (2) - MainVein (0); 
#declare P0 = MainVein(0); 
#declare Step = 0.0035;

//Here are the arrays for storing the points defined along the splines. 
#declare MainPositions = array [1/Step +1]; //The array MainPositions contains positions from MainVein in a radial distance of 0.005 from its starting point (MainVein (0))
#declare OutRPositions = array [1/Step +1]; //The array MainPositions contains positions from MainVein in a radial distance of 0.005 from its starting point (MainVein (0))
#declare OutLPositions = array [1/Step +1]; //The array MainPositions contains positions from MainVein in a radial distance of 0.005 from its starting point (MainVein (0))
    

//The following nested loops will find positions on the MainVein orthogonal to the positions on the main axis.     
#declare ticker = 1; 
#while ((ticker * Step) <1)

    #declare PStep = ticker*Step*MainAxis;                                      //This defines the points along the main axis. For each of these points we have now to find an orthogonal projection 

    #declare PSplineOld = MainVein (0.7*SizeMainVein*ticker*Step);              //For starting our second loop we are defining a position on MainVein somewhat "behind" the expected orthogonal position. 
    #declare SkalarProdOld = vdot ((PStep-P0),(PSplineOld-PStep));              //skalar product between the vector of the main axis and the vector from the position on the main axis to the current position on MainVein. Should become zero for orthogonal projection.
    #declare PSplineNew = MainVein (0.8*SizeMainVein*ticker*Step);              //This would be a point further along MainVein, with a smaller absolute value of the respective skalar product. 
    #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep));              //The respective skalar product for this latter point. 
    #declare counter = 1; 

    #while (abs(SkalarProdNew) < abs(SkalarProdOld))                            //Inner loop looking for a position where the skalar product reaches a minimum (orthogonal position)
    
        #declare SkalarProdOld = SkalarProdNew; 
        #declare PSplineOld = PSplineNew;  
        #declare PSplineNew = MainVein ( 0.8*SizeMainVein*ticker*Step + 0.1*counter*Step);   //With each inner loop position further along the spline are analyzed.
        #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep)); 
        #declare counter = counter + 1; 
    
    #end 
    
    #declare MainPositions [ticker] = PSplineOld;                               //positions with the smallest skalar product, i.e. with an angle closest to 90 degrees are stored in an array.

#declare ticker = ticker + 1; 
#end



//Next the spline for the right edge is defined. 

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

#declare SizeOutRight = 5; 



//The following nested loops will find positions on the right edge orthogonal to the positions on the main axis.     

#declare ticker = 1; 
#while ((ticker * Step) <1)

    #declare PStep = ticker*Step*MainAxis;

    #declare PSplineOld = OutRight (0.7*SizeOutRight*ticker*Step); 
    #declare SkalarProdOld = vdot ((PStep-P0),(PSplineOld-PStep));  
    #declare PSplineNew = OutRight (0.8*SizeOutRight*ticker*Step); 
    #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep)); 
    #declare counter = 1;  
    
    #while (abs(SkalarProdNew) < abs(SkalarProdOld))
    
        #declare SkalarProdOld = SkalarProdNew; 
        #declare PSplineOld = PSplineNew;  
        #declare PSplineNew = OutRight ( 0.8* SizeOutRight*ticker*Step + 0.1*counter*Step);
        #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep)); 
        #declare counter = counter + 1; 
        
    #end
    #declare OutRPositions [ticker] = PSplineOld; 

#declare ticker = ticker + 1; 
#end


//Since corresponding positions on the right leaf edge and tne main vein are defined now, the right leaf blade is now formed by connecting these corresponding positions. 

#declare RightBlade = blob {
    threshold 0.6 //This blob represents the right leaf blade

    #declare ticker = 1;
    #while ((ticker * Step) <1)
 
        #declare P1 = MainPositions [ticker];           //Points from the main vein
        #declare P2 = OutRPositions [ticker];           //and corresponding points from the right border
        #declare PNew = P1; 
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(P1-PNew) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface somewhat smoother
            
                #declare PNew = P1+4*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+2*Step*(P2-P1)+4*Step*ticker2*(P2-P1); 
            
            #end

            sphere { 
                <0,0,0>, 0.1, 1
                
                scale<1,1,1>  rotate<0,0,0>  translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + 1; 
    #end 
texture { 
                    BladeTexture
                } // end of texture
                }



//Below the spline for the left leaf's edge is defined

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

#declare SizeOutLeft = 5; 
                                                                         //This blob visualizes the left edge of the leaf

//The following nested loops will find positions on the left edge orthogonal to the positions on the main axis.     

#declare ticker = 1; 
#while ((ticker * Step) <1)

    #declare PStep = ticker*Step*MainAxis;

    #declare PSplineOld = OutLeft (0.7*SizeOutLeft*ticker*Step); 
    #declare SkalarProdOld = vdot ((PStep-P0),(PSplineOld-PStep));  
    #declare PSplineNew = OutLeft (0.8*SizeOutLeft*ticker*Step); 
    #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep)); 
    #declare counter = 1;  
    
    
    
    #while (abs(SkalarProdNew) < abs(SkalarProdOld))
    
        #declare SkalarProdOld = SkalarProdNew; 
        #declare PSplineOld = PSplineNew;  
        #declare PSplineNew = OutLeft ( 0.8* SizeOutLeft*ticker*Step + 0.1*counter*Step);
        #declare SkalarProdNew = vdot ((PStep-P0),(PSplineNew-PStep)); 
        #declare counter = counter + 1; 
        
    #end


    #declare OutLPositions [ticker] = PSplineOld; 

#declare ticker = ticker + 1; 
#end



//Since corresponding positions on the left leaf edge and tne main vein are defined now, the left leaf blade is now formed by connecting these corresponding positions. 

#declare LeftBlade = blob {
    threshold 0.6 //This blob represents the right leaf blade

    #declare ticker = 1;
    #while ((ticker * Step) <1)
 
        #declare P1 = MainPositions [ticker];           //Points from the main vein
        #declare P2 = OutLPositions [ticker];           //and corresponding points from the right border
        #declare PNew = P1; 
                                                //This loop is producing spheres running from the point from the main vein to the corresponding point on the right border. 
        #declare ticker2 = 0; 
        #while (vlength(P1-PNew) < vlength(P2-P1))

            #if (mod(ticker, 2) > 0)                            //This if-clause shifts every second row by half an element, making the surface considerably smoother
            
                #declare PNew = P1+4*Step*ticker2*(P2-P1); 
            
            #else 
            
                #declare PNew = P1+2*Step*(P2-P1)+4*Step*ticker2*(P2-P1); 
            
            #end

            sphere { 
                <0,0,0>, 0.1, 1
                scale<1,1,1>  rotate<0,0,0>  translate PNew
            }  // end of sphere ----------------------------------- 

        #declare ticker2 = ticker2 + 1; 
        #end

    #declare ticker = ticker + 1; 
    #end 
                texture { 
                    BladeTexture
                } // end of texture
}




#union { 


                                                                        //A blob for visualizing the spline just defined.
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
        scale<1,1,1>  rotate<0,0,0>  translate Stiel (ticker)
    }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.01; 
    #end  
}

 

blob {                                                                               //A blob visualizing the main leaf vein
    threshold 0.6 //Showing the spline

    #declare ticker = 0; 
    #while (ticker < 1.7) 

    sphere {    
        <0,0,0>, 0.15-ticker*ticker*0.02, 1
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


blob {
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

#object {RightBlade}

 
#object {LeftBlade}


//------------------------------------------------------------Now we start with the lateral leaf veins---------------------------------------

#declare P1 = MainVein(0.2) + <0, 2, 0>; 
#declare P2 = MainVein(0.2) + <0, 2, 0> + <3.7, 0, 2.5>;  
#declare Step = 0.01; 
#declare ticker = 0;
#declare Adjust = <0, -0.06, 0>;  
#declare LateralThickness = 0.11;
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust 
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 




#declare P1 = MainVein (0.35) + <0, 2, 0>; 
#declare P2 = MainVein (0.35) + <0, 2, 0> + <4.2, 0, 3.0>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 





#declare P1 = MainVein (0.5) + <0, 2, 0>; 
#declare P2 = MainVein (0.5) + <0, 2, 0>+ <4.4, 0, 3.3>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 



#declare P1 = MainVein (0.65) + <0, 2, 0>; 
#declare P2 = MainVein (0.65) + <0, 2, 0>+ <4.2, 0, 3.0>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3   + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 




#declare P1 = MainVein (0.8) + <0, 2, 0>; 
#declare P2 = MainVein (0.8) + <0, 2, 0> + <4.0, 0, 2.7>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 




#declare P1 = MainVein (0.95) + <0, 2, 0>; 
#declare P2 = MainVein (0.95) + <0, 2, 0> + <3.2, 0, 2.7>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 



#declare P1 = MainVein (1.1) + <0, 2, 0>; 
#declare P2 = MainVein (1.1) + <0, 2, 0> + <2.4, 0, 2.1>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 



#declare P1 = MainVein (1.25) + <0, 2, 0>; 
#declare P2 = MainVein (1.25) + <0, 2, 0>+ <1.6, 0, 1.5>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3   + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 



#declare P1 = MainVein (1.4) + <0, 2, 0>; 
#declare P2 = MainVein (1.4) + <0, 2, 0>+ <0.8, 0, 1.0>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (RightBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3   + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 


//-------------------------------------------------------------------------------------------------------



#declare P1 = MainVein (0.17) + <0, 2, 0>; 
#declare P2 = MainVein (0.17) + <0, 2, 0>+ <-3.7, 0, 2.5>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 





#declare P1 = MainVein (0.32) + <0, 2, 0>; 
#declare P2 = MainVein (0.32) + <0, 2, 0> + <-4.7, 0, 3.5> ;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 



#declare P1 = MainVein (0.46) + <0, 2, 0>; 
#declare P2 = MainVein (0.46) + <0, 2, 0>+ <-4.9, 0, 3.8>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3   + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 





#declare P1 = MainVein (0.61) + <0, 2, 0>; 
#declare P2 = MainVein (0.61) + <0, 2, 0> + <-4.7, 0, 3.5>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 





#declare P1 = MainVein (0.75) + <0, 2, 0>; 
#declare P2 = MainVein (0.75) + <0, 2, 0>+ <-4.2, 0, 3.1>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 




#declare P1 =  MainVein (0.90) + <0, 2, 0> ; 
#declare P2 = MainVein (0.90) + <0, 2, 0> + <-3.2, 0, 2.7>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3 + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 





#declare P1 = MainVein (1.04) + <0, 2, 0>; 
#declare P2 = MainVein (1.04) + <0, 2, 0>+ <-2.6, 0, 2.3>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 






#declare P1 = MainVein (1.19) + <0, 2, 0>; 
#declare P2 = MainVein (1.19) + <0, 2, 0> + <-1.8, 0, 1.7>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3  + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 




#declare P1 = MainVein (1.34) + <0, 2, 0>; 
#declare P2 = MainVein (1.34) + <0, 2, 0> + <-1.1, 0, 1.3>;  
#declare Step = 0.01; 
#declare ticker = 0; 
 
blob {
    threshold 0.6 
 
    #while (ticker <1)
 
        #declare P3 = P1 + ticker*(P2-P1);
 
        #while (inside (LeftBlade, P3)=0)
        
            #declare P3 = P3 + <0, -0.01, 0>;
    
        #end 
 
        sphere {    
            <0,0,0>, LateralThickness,1
            texture { 
                pigment { 
                    color rgb <0/255,0.4,0/255> 
                }
                finish  { 
                    specular 0.2  
                } 
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate P3   + Adjust
        
              
        }  // end of sphere ----------------------------------- 

    #declare ticker = ticker + Step; 
    #end
} 

//rotate <0, 0, 180>
rotate <0, 0, -360*clock>

}