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

This file demonstrates my basic approach for creating planar structures. For a start, we create a small patch in the x-z-plain, anchored by four positions determining the corners of this patch (given as a start). 
These four corner positions serve for defining splines in a first step. In a second step these splines are used to determine the y-coordinates and normals of positions in the patch. y-coordinates and normals are cal
culated from y-coordinates and incline of splines at respective x- and z- positions. Finally the flat spheres put at appropriate positions with appropriate normals are fused into a blob.  
*/ 
                
//-----------------------------------Scene settings (Camera, light, background)-------------------------------------------------

global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}

#declare Hauptkamera = camera {
    location  <0.6, 1.1, -1.5> *1.6
    right     x*image_width/image_height
    look_at   <0.6, 0.75,  2.5>
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

//---------------------------------The points and the splines (top-panel)-------------------------------------------------------------


//----------------------------Definition of main points----------------------------------------------------------------

//These  points are spanning a square patch with a certain change in the y-coordinate

#declare P0 = <0, 0, 0> + <-1.4, 1, 0>; 
#declare P1= <1, 0.3, 0> + <-1.4, 1, 0> ; 
#declare P2 = <0, 0.4, 1>  + <-1.4, 1, 0>; 
#declare P3 = <1, 0.6, 1> + <-1.4, 1, 0> ;

//Here the points are given as spheres

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
    scale<1,1,1>  rotate<0,0,0>  translate P0
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P2
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P3
}  // end of sphere ----------------------------------- 



//-------------------------------------Definition of splines--------------------------------------------------------------------

//The splines are used for defining four splines, two along the x-axis and two along the z-axis.

#declare SplineXA = spline {
    cubic_spline
    -2, P0 + <-2, 0, 0>, // control point
    -1, P0 + <-1, 0, 0>,// control point

    0, P0, 
    1, P1, 
   
    2, P1 + <1, 0.2, 0>, // control point
    3 ,  P1 + <2, 0.4, 0>, // control point
}   

#declare SplineXB = spline {
    cubic_spline
    -2, P2 + <-2, 0, 0>, // control point
    -1, P2 + <-1, 0, 0>,// control point

    0, P2, 
    1, P3, 
   
    2, P3 + <1, 0.2, 0>, // control point
    3 ,  P3 + <2, 0.4, 0>, // control point
}   

#declare SplineZA = spline {
    cubic_spline
    -2, P0 + <0, 0, -2>, // control point
    -1, P0 + <0, 0, -1>,// control point

    0, P0, 
    1, P2, 
   
    2, P2 + <0, 0.2, 1>, // control point
    3 ,  P2 + <0, 0.4, 2>, // control point
}   


#declare SplineZB = spline {
    cubic_spline
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    0, P1, 
    1, P3, 
   
    2, P3 + <0, 0.2, 1>, // control point
    3 ,  P3 + <0, 0.4, 2>, // control point
}   

//----------------------------------Visualization of splines-------------------------------------------------------

#declare ticker = 0; 
#while (ticker < 1) 

    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXA (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   


#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXB (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   




#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZA (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end



#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZB (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

//----------------------------Patch made of flat spheres (center panel)---------------------------------------------------

//----------------------------Definition of main points----------------------------------------------------------------

//These  points are spanning a square patch with a certain change in the y-coordinate

#declare P0 = <0, 0, 0> + <0, 1, 0>; 
#declare P1= <1, 0.3, 0> + <0, 1, 0>; 
#declare P2 = <0, 0.4, 1> + <0, 1, 0>; 
#declare P3 = <1, 0.6, 1> + <0, 1, 0>;

//Here the points are given as spheres

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
    scale<1,1,1>  rotate<0,0,0>  translate P0
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P2
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P3
}  // end of sphere ----------------------------------- 



//-------------------------------------Definition of splines--------------------------------------------------------------------

//The splines are used for defining four splines, two along the x-axis and two along the z-axis.

#declare SplineXA = spline {
    cubic_spline
    -2, P0 + <-2, 0, 0>, // control point
    -1, P0 + <-1, 0, 0>,// control point

    0, P0, 
    1, P1, 
   
    2, P1 + <1, 0.2, 0>, // control point
    3 ,  P1 + <2, 0.4, 0>, // control point
}   

#declare SplineXB = spline {
    cubic_spline
    -2, P2 + <-2, 0, 0>, // control point
    -1, P2 + <-1, 0, 0>,// control point

    0, P2, 
    1, P3, 
   
    2, P3 + <1, 0.2, 0>, // control point
    3 ,  P3 + <2, 0.4, 0>, // control point
}   

#declare SplineZA = spline {
    cubic_spline
    -2, P0 + <0, 0, -2>, // control point
    -1, P0 + <0, 0, -1>,// control point

    0, P0, 
    1, P2, 
   
    2, P2 + <0, 0.2, 1>, // control point
    3 ,  P2 + <0, 0.4, 2>, // control point
}   


#declare SplineZB = spline {
    cubic_spline
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    0, P1, 
    1, P3, 
   
    2, P3 + <0, 0.2, 1>, // control point
    3 ,  P3 + <0, 0.4, 2>, // control point
}   

//----------------------------------Visualization of splines-------------------------------------------------------

#declare ticker = 0; 
#while (ticker < 1) 

    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXA (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   


#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXB (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   




#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>, 0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZA (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end



#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZB (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

//-----------------------------------Calculation of the patch-----------------------------------------------

//Flat spheres are distributed regularly along the x- and z-coordinated of the patch. Their y-position is calculated by combining the y-coordinates of fitting to respective x-z-coordinates. 
//Normals are calculated by combining combining values for spline-gradients 

#declare tickerx = 0;                                    //loop over all x-values
#while (tickerx<1)

    #declare tickerz = 0;                                //loop over all z-values
    #while (tickerz < 1)

        //Calculating the y-coordinate

        #declare P1 = SplineZA(tickerz);
        #declare P2 = SplineZB(tickerz);
        #declare Heightz = ((0.5+0.5*sin(0.5*pi + pi*tickerx))*P1.y + (0.5+0.5*sin(1.5*pi + pi*tickerx))*P2.y); 

        #declare P3 = SplineXA(tickerx);
        #declare P4 = SplineXB(tickerx);
        #declare Heightx = ((0.5+0.5*sin(0.5*pi + pi*tickerz))*P3.y + (0.5+0.5*sin(1.5*pi + pi*tickerz))*P4.y); 

        #declare Height = (Heightz + Heightx)/2; 

        //Calculating Normals

        #declare AZ1 = SplineZA(tickerz+0.1) - SplineZA(tickerz-0.1);
        #declare AZ2 = SplineZB(tickerz+0.1) - SplineZB(tickerz-0.1);
        #declare AZ = (0.5+0.5*sin(0.5*pi + pi*tickerx))*AZ1 + (0.5+0.5*sin(1.5*pi + pi*tickerx))*AZ2; 


        #declare AX1 = SplineXA(tickerx+0.1) - SplineXA(tickerx-0.1);
        #declare AX2 = SplineXB(tickerx+0.1) - SplineXB(tickerx-0.1);
        #declare AX = (0.5+0.5*sin(0.5*pi + pi*tickerz))*AX1 + (0.5+0.5*sin(1.5*pi + pi*tickerz))*AX2; 

        #declare Normal = vcross(AX, AZ); 

        #if (abs(Normal.x)>abs(Normal.z)) 

//Positioning and rotating individual elements

            #local AngleY = degrees(atan2(Normal.z, Normal.x));  
            #local N2 = vrotate (Normal, <0, AngleY, 0>);
            #local AngleZ = degrees(atan2(N2.y, N2.x));
            sphere {                                                       //The element for the area patch
                <0, 0, 0>, 0.14
                scale<1,0.02,1> 
                rotate <0, 90, 0>
                rotate <0, 0, 270 +AngleZ>
                rotate <0, -AngleY, 0>
                translate <tickerx, Height, tickerz>
                pigment {
                    color rgb <1,1,1>     // solid color pigment
                }  
            }

            sphere {                                                      //element representing the normal at the given position
                <0, 0, 0>, 0.14
                scale<0.05, 1,0.05> 
                rotate <0, 90, 0>
                rotate <0, 0, 270 +AngleZ>
                rotate <0, -AngleY, 0>
                translate <tickerx, Height, tickerz>
                pigment {
                    color rgb <0, 0.6, 1>     // solid color pigment
                }
                no_shadow               
            }  

        #else

            #if (abs(Normal.z)>0)

                #local AngleY = degrees(atan2(Normal.x, Normal.z));
                #local N2 = vrotate (Normal, <0, -AngleY, 0>); 
                #local AngleX = -degrees(atan2(N2.y, N2.z));
                sphere { 
                    <0, 0, 0>, 0.14                                            //The element for the area patch
                    scale<1,0.02,1>   
                    rotate <AngleX+90, 0, 0>
                    rotate <0, AngleY, 0>
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <1,1,1>     // solid color pigment
                    }
                }
                sphere { 
                    <0, 0, 0>, 0.14                                            //element representing the normal at the given position
                    scale<0.05, 1,0.05> 
                    rotate <AngleX+90, 0, 0>
                    rotate <0, AngleY, 0>
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <0, 0.6, 1>     // solid color pigment
                    }
                    no_shadow                
                }  
  
            #else//This covers positions with  

                sphere {                                                    //The element for the area patch
                    <0, 0, 0>, 0.14
                    scale<1,0.02,1> 
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <1,1,1>     // solid color pigment
                }

                sphere { 
                    <0, 0, 0>, 0.14                                         //element representing the normal at the given position
                    scale<0.05, 1,0.05> 
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <0, 0.6, 1>     // solid color pigment
                    }
                    no_shadow                
                }  
            #end 
        #end  


    #declare tickerz = tickerz + 0.1; 
    #end

#declare tickerx = tickerx + 0.1; 
#end



//----------------------------Patch made of a blob (bottom panel)---------------------------------------------------

//----------------------------Definition of main points----------------------------------------------------------------

//These  points are spanning a square patch with a certain change in the y-coordinate

#declare P0 = <0, 0, 0>; 
#declare P1= <1, 0.3, 0>; 
#declare P2 = <0, 0.4, 1>; 
#declare P3 = <1, 0.6, 1>;

//Here the points are given as spheres

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
    scale<1,1,1>  rotate<0,0,0>  translate P0+ <1.6, 1, 0>
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P1+ <1.6, 1, 0>
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P2+ <1.6, 1, 0>
}  // end of sphere ----------------------------------- 

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
    scale<1,1,1>  rotate<0,0,0>  translate P3+ <1.6, 1, 0>
}  // end of sphere ----------------------------------- 



//-------------------------------------Definition of splines--------------------------------------------------------------------

//The splines are used for defining four splines, two along the x-axis and two along the z-axis.

#declare SplineXA = spline {
    cubic_spline
    -2, P0 + <-2, 0, 0>, // control point
    -1, P0 + <-1, 0, 0>,// control point

    0, P0, 
    1, P1, 
   
    2, P1 + <1, 0.2, 0>, // control point
    3 ,  P1 + <2, 0.4, 0>, // control point
}   

#declare SplineXB = spline {
    cubic_spline
    -2, P2 + <-2, 0, 0>, // control point
    -1, P2 + <-1, 0, 0>,// control point

    0, P2, 
    1, P3, 
   
    2, P3 + <1, 0.2, 0>, // control point
    3 ,  P3 + <2, 0.4, 0>, // control point
}   

#declare SplineZA = spline {
    cubic_spline
    -2, P0 + <0, 0, -2>, // control point
    -1, P0 + <0, 0, -1>,// control point

    0, P0, 
    1, P2, 
   
    2, P2 + <0, 0.2, 1>, // control point
    3 ,  P2 + <0, 0.4, 2>, // control point
}   


#declare SplineZB = spline {
    cubic_spline
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    0, P1, 
    1, P3, 
   
    2, P3 + <0, 0.2, 1>, // control point
    3 ,  P3 + <0, 0.4, 2>, // control point
}   

//----------------------------------Visualization of splines-------------------------------------------------------

#declare ticker = 0; 
#while (ticker < 1) 

    sphere { 
        <0,0,0>, 0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXA (ticker)+ <1.6, 1, 0>
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   


#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineXB (ticker)+ <1.6, 1, 0>
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end
   




#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZA (ticker)+ <1.6, 1, 0>
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end



#declare ticker = 0; 
#while (ticker < 1) 


    sphere { 
        <0,0,0>,  0.005
        texture { 
            pigment{ 
                color rgb<1.00, 0.7, 0.00>
            }
            finish { 
                phong 1.0 reflection 0.00
            }
        } // end of texture
        scale<1,1,1>  rotate<0,0,0>  translate SplineZB (ticker)+ <1.6, 1, 0>
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

//-----------------------------------Calculation of the patch-----------------------------------------------

//Flat spheres are distributed regularly along the x- and z-coordinated of the patch. Their y-position is calculated by combining the y-coordinates of fitting to respective x-z-coordinates. 
//Normals are calculated by combining combining values for spline-gradients 

blob {
threshold 0.6
#declare tickerx = 0;                                    //loop over all x-values
#while (tickerx<1)

    #declare tickerz = 0;                                //loop over all z-values
    #while (tickerz < 1)

        //Calculating the y-coordinate

        #declare P1 = SplineZA(tickerz);
        #declare P2 = SplineZB(tickerz);
        #declare Heightz = ((0.5+0.5*sin(0.5*pi + pi*tickerx))*P1.y + (0.5+0.5*sin(1.5*pi + pi*tickerx))*P2.y); 

        #declare P3 = SplineXA(tickerx);
        #declare P4 = SplineXB(tickerx);
        #declare Heightx = ((0.5+0.5*sin(0.5*pi + pi*tickerz))*P3.y + (0.5+0.5*sin(1.5*pi + pi*tickerz))*P4.y); 

        #declare Height = (Heightz + Heightx)/2; 

        //Calculating Normals

        #declare AZ1 = SplineZA(tickerz+0.1) - SplineZA(tickerz-0.1);
        #declare AZ2 = SplineZB(tickerz+0.1) - SplineZB(tickerz-0.1);
        #declare AZ = (0.5+0.5*sin(0.5*pi + pi*tickerx))*AZ1 + (0.5+0.5*sin(1.5*pi + pi*tickerx))*AZ2; 


        #declare AX1 = SplineXA(tickerx+0.1) - SplineXA(tickerx-0.1);
        #declare AX2 = SplineXB(tickerx+0.1) - SplineXB(tickerx-0.1);
        #declare AX = (0.5+0.5*sin(0.5*pi + pi*tickerz))*AX1 + (0.5+0.5*sin(1.5*pi + pi*tickerz))*AX2; 

        #declare Normal = vcross(AX, AZ); 

        #if (abs(Normal.x)>abs(Normal.z)) 

//Positioning and rotating individual elements  


            #local AngleY = degrees(atan2(Normal.z, Normal.x));  
            #local N2 = vrotate (Normal, <0, AngleY, 0>);
            #local AngleZ = degrees(atan2(N2.y, N2.x));
            sphere {                                                       //The element for the area patch
                <0, 0, 0>, 0.18, 1
                scale<1,0.02,1> 
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
                    <0, 0, 0>, 0.18, 1                                            //The element for the area patch
                    scale<1,0.02,1>   
                    rotate <AngleX+90, 0, 0>
                    rotate <0, AngleY, 0>
                    translate <tickerx, Height, tickerz>
                    pigment {
                        color rgb <1,1,1>     // solid color pigment
                    }
                }
  
            #else//This covers positions with  

                sphere {                                                    //The element for the area patch
                    <0, 0, 0>, 0.18, 1
                    scale<1,0.02,1> 
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
translate + <1.6, 1, 0>
}

