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

This file demonstrates my basic approach for creating planar structures. Here we are creating a larger patch in the x-z-plain with a certain variability in the y-coordinate. 
For a start, an x-z-grid is created, anchoring the later patch, with some variability in y-coordinates. Y-coordinates and normals from individual positions in the patch are calculated from a set 
of splines running through the grid positions along the x- and z-axis. For each cell of the grid the closest splines are taken for calculations. 
Finally the flat spheres put at appropriate positions with appropriate normals are fused into a blob. 

*/ 
                
//-----------------------------------Scene settings (Camera, light, background)-------------------------------------------------

global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}


#declare Hauptkamera = camera {
    location  <-1, 4, -3>
    look_at   <7, -2,  7>
}

camera {Hauptkamera}

// create a regular point light source
light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>    // light's color
    translate <-100, 50, -20>
}
light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>    // light's color
    translate <-30, 50, -100>
}

// ----------------------------------------The coordinate system-------------------------------------------------------------------

cylinder { 
    <0, -100, 0>, <0, 100, 0>, 0.005 
    pigment {
        color rgb <0,1,0>     // solid color pigment
    }
}

cylinder { 
    <-100, 0, 0>, <100, 0, 0>, 0.005
    pigment {
        color rgb <1,0,0>     // solid color pigment
    }
}

cylinder { 
    <0, 0, -100>, <0, 0, 100>, 0.005 
    pigment {
        color rgb <0,0,1>     // solid color pigment
    }
}


//----------The envelope for the leaflet--------------------------------------------------------------

// linear prism in y-direction: from .. ,to ..,number of points (first = last)
#declare Envelope = prism { linear_sweep
        cubic_spline
        -0.2 ,1.2 , 8
        <0.0, 0.30>, 
        < 0.50,  0.00>, < 0.20,-0.75>, < -0.20,-0.75>, <-0.50, 0.00>,  <0.0, 0.30>, 
        < 0.50, 0.00>, < 0.30, -0.55>   
        texture {pigment{ color rgb <0,0,1>} 
                 finish { phong 1.0}}
        //rotate<0,90,0> 
       scale 6
        translate<5,-0.5,5.2> 
      } // end of prism --------------------------------------------------------

//---------------------------------The points and the splines (top-panel)-------------------------------------------------------------


//----------------------------Definition of main points----------------------------------------------------------------

//These  points are spanning a 10 x 10 square patch with a certain variation in the y-coordinate. Note: A square patch of 10 x 10 units is defined by 11 x 11 positions. 
#declare XPos = 0;                            //Start on the x-axis
#declare ZPos = 0;                            //Start on the z-axis
#declare chance1 = seed (5); 
#declare Positions = array [11][11];          //Array for storing position


//Here the positions are created an stored in the array.

#declare ticker = 0; 
#while (ticker < 11)

#declare XPos = ticker;
 
#declare ticker2 = 0; 
#while (ticker2 < 11)

#declare ZPos = ticker2;
 
#declare YPos = 0.2 *(rand(chance1)-0.5) + 0.03*ticker2*ticker2; //Variation of y-values between + and - 0.2

#declare P1 = <XPos, YPos, ZPos>; 
#declare Positions [ticker] [ticker2] = P1; //Storing positions


#declare ticker2 = ticker2 + 1;
#end

#declare ticker = ticker + 1; 
#end


//--------------------Visualizing positions------------------------------------------------

#declare ticker = 0; 
#while (ticker < 11)

 
#declare ticker2 = 0; 
#while (ticker2 < 11)

#declare P1 = Positions [ticker][ticker2];
 
sphere { 
    <0,0,0>, 0.03 
    texture { 
        pigment{ 
            color rgb<1.00, 0, 0.00>
        }
        finish { 
            phong 1.0 reflection 0.00
        }
    } // end of texture
    scale<1,1,1>  rotate<0,0,0>  translate P1 
}  // end of sphere ----------------------------------- 
 
#declare ticker2 = ticker2 + 1;
#end

#declare ticker = ticker + 1; 
#end



//-------------------------------------Definition of splines--------------------------------------------------------------------

//10 splines along the x-axis are defined. 

#declare SplineXs = array [11]; //The array for storing the splines in x-direction is created.
#declare SplineZs = array [11]; //The array for storing the splines in y-direction is created.


//The splines in x-direction are defined by the following loop
#for (I, 0, 10)
    #declare SplineXs[I] = spline {
        cubic_spline
        #declare P1 = Positions [0][I]; //Positions of the x-row number I are taken to define the spline, first the initial control points
    
        -2, P1 + <-2, 0, 0>, // control point
        -1, P1 + <-1, 0, 0>,// control point

        #declare ticker = 0;
        #while (ticker < 11)

            #declare P1 = Positions [ticker][I]; //Positions of the x-row number I are taken to define the spline , then all the "inner" positions
            ticker, P1, 

        #declare ticker = ticker + 1; 
        #end
   
        10, P1 + <1, 0, 0>, // And then finally the last two control points
        11,  P1 + <2, 0, 0>, // And then finally the last two control points

    }
#end //This loop is running from I = 0 to I = 10; in total 11 splines are created. 



//The splines in z-direction are defined by the following loop
#for (I, 0, 10)
    #declare SplineZs[I] = spline {
        cubic_spline
        #declare P1 = Positions [I][0]; //Positions of the z-row number I are taken to define the spline, first the initial control points
    
        -2, P1 + <0, 0, -2>, // control point
        -1, P1 + <0, 0, -1>,// control point

        #declare ticker = 0;
        #while (ticker < 11)

            #declare P1 = Positions [I][ticker]; //Positions of the z-row number I are taken to define the spline , then all the "inner" positions
            ticker, P1, 

        #declare ticker = ticker + 1; 
        #end
   
        10, P1 + <0, 0, 1>, // And then finally the last two control points
        11,  P1 + <0, 0, 2>, // And then finally the last two control points

    }
#end //This loop is running from I = 0 to I = 10; in total 11 splines are created. 



//----------------------------------Visualization of splines-------------------------------------------------------


#declare ticker2 = 0; 
#while (ticker2<11)

    #declare ticker = 0; 
    #while (ticker < 10) 

        sphere { 
            <0,0,0>,  0.01
            texture { 
                pigment{ 
                    color rgb<0, 0.7, 1>
                }
                finish { 
                    phong 1.0 reflection 0.00
                }
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate SplineXs [ticker2] (ticker) 
        }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.005; 
    #end

#declare ticker2 = ticker2 + 1; 
#end



#declare ticker2 = 0; 
#while (ticker2<11)

    #declare ticker = 0; 
    #while (ticker < 10) 

        sphere { 
            <0,0,0>,  0.01
            texture { 
                pigment{ 
                    color rgb<1.00, 0.7, 0.00>
                }
                finish { 
                    phong 1.0 reflection 0.00
                }
            } // end of texture
            scale<1,1,1>  rotate<0,0,0>  translate SplineZs [ticker2] (ticker) 
        }  // end of sphere ----------------------------------- 

    #declare ticker =  ticker + 0.005; 
    #end

#declare ticker2 = ticker2 + 1; 
#end




//----------------------------Patch made of flat spheres---------------------------------------------------


//-----------------------------------Calculation of the patch-----------------------------------------------



intersection {
    object {
        Envelope
    }


    //Flat spheres are distributed regularly along the x- and z-coordinated of the patch. Their y-position is calculated by combining the y-coordinates of fitting to respective x-z-coordinates. 
    //Normals are calculated by combining combining values for spline-gradients 
    blob {
        threshold 0.6

        #declare tickerx = 0;                                    //loop over all x-values; since it is running in 0.1-steps, 110 outer loops will take place
        #while (tickerx<10)

            #declare tickerz = 0;                                //loop over all z-values; since it is running in 0.1 steps, 110 inner loops will take place and 12100 positions in total will be defined.
            #while (tickerz < 10) 
    
                #declare P0 = Positions [tickerx][tickerz];      //since this array was initially defined as an 11 x 11 array, y-positions extracted only apply to this rough grid


                //For each position a pair of closeby/adjacent splines in x-direction and a pair of closeby splines in z-direction are defined in order to adjust y-coordinate and orientation (normal).

                //Definition of closeby/adjacent splines in x-direction
            
                #if (P0.z <10) //This condition excludes the last row of points (at P0.z = 10) avoiding any reference to a non-existing SplineXs[11]
                    #declare SplineXStart = SplineXs[floor (P0.z)]; 
                    #declare SplineXEnd = SplineXs[ floor (P0.z) + 1];
                    #declare ResZ = tickerz - floor (P0.z);  
                #else
                #end 

                //Definition of closeby/adjacent splines in z-direction            
                #if (P0.x <10) //This condition excludes the last row of points (at P0.z = 10) avoiding any reference to a non-existing SplineZs[11]
                    #declare SplineZStart = SplineZs[floor (P0.x)]; 
                    #declare SplineZEnd = SplineZs[ floor (P0.x) + 1];
                    #declare ResX = tickerx - floor (P0.x);  
                #else
                #end 
            

                //Calculating the y-coordinate

                //Two points on closeby splines in z-direction fitting to the z-coordinate of the point in question are defined
                #declare P1 = SplineZStart(tickerz);
                #declare P2 = SplineZEnd(tickerz);
            
                //y-coordinates of the two points just defined are combined.
                #declare Heightz = P1.y + ResX*(P2.y-P1.y); 
            
            
                //Two points on closeby splines in z-direction fitting to the z-coordinate of the point in question are defined
                #declare P3 = SplineXStart(tickerx);
                #declare P4 = SplineXEnd(tickerx);
                //y-coordinates of the two points just defined are combined 
                #declare Heightx = P3.y + ResZ*(P4.y-P3.y) ;

                //y-coordinates from the x- and z-directions are combined 
                #declare Height = (Heightz + Heightx)/2; 



                //Calculating Normals: First for the adjacent Splines in z-direction ...

                #declare AZ1 = SplineZStart(tickerz+0.1) - SplineZStart(tickerz-0.1);
                #declare AZ2 = SplineZEnd(tickerz+0.1) - SplineZEnd(tickerz-0.1);
            
                //Combinations alternatively using sinus or linear
                //#declare AZ = sin(0.5*pi *(1-ResX))*AZ1 + sin(0.5*pi*ResX)*AZ2; 
                #declare AZ = (1-ResX)*AZ1 + ResX*AZ2;

                //... then for the adjacent splines in x-direction
                #declare AX1 = SplineXStart(tickerx+0.1) - SplineXStart(tickerx-0.1);
                #declare AX2 = SplineXEnd(tickerx+0.1) - SplineXEnd(tickerx-0.1); 
            
                //Combinations alternatively using sinus or linear
                //#declare AX = sin(0.5*pi*(1-ResZ))*AX1 + sin(0.5*pi*ResZ)*AX2; 
                #declare AX =  (1-ResZ)*AX1 + ResZ*AX2;
            
                //Normals are defined by the cross-product of vectors along x- and y-axes            
                #declare Normal = vcross(AX, AZ); 
            
            
                //Positioning and rotating elements according to the values just calculated
            
                #if (abs(Normal.x)>abs(Normal.z)) 


                    #local AngleY = degrees(atan2(Normal.z, Normal.x));  
                    #local N2 = vrotate (Normal, <0, AngleY, 0>);
                    #local AngleZ = degrees(atan2(N2.y, N2.x));
                    sphere {                                                       
                        <0, 0, 0>, 0.17, 1
                        scale<1,0.1,1> 
                        rotate <0, 90, 0>
                    rotate <0, 0, 270 +AngleZ>
                    rotate <0, -AngleY, 0>
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <1,1,1>     // solid color pigment
                    }  
                }


                #else

                    #if (abs(Normal.z)>0)

                        #local AngleY = degrees(atan2(Normal.x, Normal.z));
                        #local N2 = vrotate (Normal, <0, -AngleY, 0>); 
                        #local AngleX = -degrees(atan2(N2.y, N2.z));
                        sphere { 
                            <0, 0, 0>, 0.17 , 1                                           
                            scale<1,0.1,1>   
                            rotate <AngleX+90, 0, 0>
                            rotate <0, AngleY, 0>
                            translate <tickerx, Height, tickerz> 
                            pigment {
                                color rgb <1,1,1>     // solid color pigment
                            }
                        }
  
                    #else//This covers positions with  

                        sphere {                                                    
                            <0, 0, 0>, 0.17, 1
                            scale<1,0.1,1> 
                            translate <tickerx, Height, tickerz> 
                            pigment {
                                color rgb <1,1,1>     // solid color pigment
                        }

                    #end 
                #end  
         
        

            #declare tickerz = tickerz + 0.1; 
            #end

        #declare tickerx = tickerx + 0.1; 
        #end
    }

}
