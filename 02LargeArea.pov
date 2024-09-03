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
    location  <-2.6, 3, -2.4>
    look_at   <5, -2,  5>
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

//---------------------------------The points and the splines (top-panel)-------------------------------------------------------------


//----------------------------Definition of main points----------------------------------------------------------------

//These  points are spanning a square patch with a certain change in the y-coordinate
#declare XPos = 0; 
#declare ZPos = 0;
#declare chance1 = seed (5); 
#declare Positions = array [11][11];

#declare ticker = 0; 
#while (ticker < 11)

//#declare ZPos = 0; 
#declare XPos = ticker;
 
#declare ticker2 = 0; 
#while (ticker2 < 11)

#declare ZPos = ticker2;
 
#declare YPos = 0.4 *(rand(chance1)-0.5); 

#declare P1 = <XPos, YPos, ZPos>; 
#declare Positions [ticker] [ticker2] = P1;


#declare ticker2 = ticker2 + 1;
#end

#declare ticker = ticker + 1; 
#end




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


#declare SplineXA = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][0]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][0];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}


#declare SplineXB = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][1]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][1];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXC = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][2]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][2];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXD = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][3]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][3];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXE = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][4]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][4];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXF = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][5]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][5];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXG = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][6]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][6];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXH = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][7]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][7];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXI = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][8]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][8];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXJ = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][9]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][9];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}

#declare SplineXK = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][10]; 
    
    -2, P1 + <-2, 0, 0>, // control point
    -1, P1 + <-1, 0, 0>,// control point

#declare ticker = 0;
#while (ticker < 10)

#declare P1 = Positions [ticker][10];
 
    ticker, P1, 

#declare ticker = ticker + 1; 
#end
   
    10, P1 + <1, 0, 0>, // control point
    11,  P1 + <2, 0, 0>, // control point
}


//10 splines along the z-axis are defined. 


#declare SplineZA = spline {
    cubic_spline 
    
    #declare P1 = Positions [0][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [0][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZB = spline {
    cubic_spline 
    
    #declare P1 = Positions [1][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [1][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZC = spline {
    cubic_spline 
    
    #declare P1 = Positions [2][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [2][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZD = spline {
    cubic_spline 
    
    #declare P1 = Positions [3][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [3][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZE = spline {
    cubic_spline 
    
    #declare P1 = Positions [4][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [4][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZF = spline {
    cubic_spline 
    
    #declare P1 = Positions [5][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [5][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZG = spline {
    cubic_spline 
    
    #declare P1 = Positions [6][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [6][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZH = spline {
    cubic_spline 
    
    #declare P1 = Positions [7][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [7][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZI = spline {
    cubic_spline 
    
    #declare P1 = Positions [8][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [8][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZJ = spline {
    cubic_spline 
    
    #declare P1 = Positions [9][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [9][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}


#declare SplineZK = spline {
    cubic_spline 
    
    #declare P1 = Positions [10][0]; 
    
    -2, P1 + <0, 0, -2>, // control point
    -1, P1 + <0, 0, -1>,// control point

    #declare ticker = 0;
    #while (ticker < 10)

        #declare P1 = Positions [10][ticker];
        ticker, P1, 

    #declare ticker = ticker + 1; 
    #end
   
    10, P1 + <0, 0, 1>, // control point
    11,  P1 + <0, 0, 2>, // control point
}







 

//----------------------------------Visualization of splines-------------------------------------------------------


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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXA (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end



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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXB (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end


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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXC (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXD (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXE (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXF (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXG (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXH (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXI (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXJ (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end


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
        scale<1,1,1>  rotate<0,0,0>  translate SplineXK (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end




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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZA (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZB (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZC (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZD (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZE (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZF (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZG (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZH (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZI (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end

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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZJ (ticker)
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end


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
        scale<1,1,1>  rotate<0,0,0>  translate SplineZK (ticker) 
    }  // end of sphere ----------------------------------- 

#declare ticker =  ticker + 0.005; 
#end



//----------------------------Patch made of flat spheres---------------------------------------------------


//-----------------------------------Calculation of the patch-----------------------------------------------

//Flat spheres are distributed regularly along the x- and z-coordinated of the patch. Their y-position is calculated by combining the y-coordinates of fitting to respective x-z-coordinates. 
//Normals are calculated by combining combining values for spline-gradients 
blob {
    threshold 0.6

    #declare tickerx = 0;                                    //loop over all x-values
    #while (tickerx<10)

        #declare tickerz = 0;                                //loop over all z-values
        #while (tickerz < 10) 
    
            #declare P0 = Positions [tickerx][tickerz];
    
            #if (P0.z < 1)

                #declare SplineXStart = SplineXA; 
                #declare SplineXEnd = SplineXB;
                #declare ResZ = tickerz;  

            #else

                #if (P0.z < 2)

                    #declare SplineXStart = SplineXB; 
                    #declare SplineXEnd = SplineXC; 
                    #declare ResZ = tickerz-1;  
                
                #else

                    #if (P0.z < 3)

                        #declare SplineXStart = SplineXC; 
                        #declare SplineXEnd = SplineXD; 
                        #declare ResZ = tickerz-2;  

                    #else

                        #if (P0.z < 4)

                            #declare SplineXStart = SplineXD; 
                            #declare SplineXEnd = SplineXE; 
                            #declare ResZ = tickerz-3;  

                        #else

                            #if (P0.z < 5 )

                                #declare SplineXStart = SplineXE; 
                                #declare SplineXEnd = SplineXF; 
                                #declare ResZ = tickerz-4;  

                            #else

                                #if (P0.z < 6)

                                    #declare SplineXStart = SplineXF; 
                                    #declare SplineXEnd = SplineXG; 
                                    #declare ResZ = tickerz-5;  

                                #else

                                    #if (P0.z < 7)

                                        #declare SplineXStart = SplineXG; 
                                        #declare SplineXEnd = SplineXH; 
                                        #declare ResZ = tickerz-6;  

                                    #else

                                        #if (P0.z< 8)

                                            #declare SplineXStart = SplineXH; 
                                            #declare SplineXEnd = SplineXI; 
                                            #declare ResZ = tickerz-7;  

                                        #else

                                            #if (P0.z < 9)

                                                #declare SplineXStart = SplineXI; 
                                                #declare SplineXEnd = SplineXJ; 
                                                #declare ResZ = tickerz-8;  

                                            #else 
                                                #declare SplineXStart = SplineXJ; 
                                                #declare SplineXEnd = SplineXK; 
                                                #declare ResZ = tickerz-9;  
                                    
                                            #end
                                        #end
                                    #end
                                #end
                            #end
                        #end
                    #end
                #end
            #end


    
            #if (P0.x < 1)

                #declare SplineZStart = SplineZA; 
                #declare SplineZEnd = SplineZB; 
                #declare ResX = tickerx;  

            #else

                #if (P0.x< 2)

                    #declare SplineZStart = SplineZB; 
                    #declare SplineZEnd = SplineZC; 
                    #declare ResX = tickerx-1;  

                #else

                    #if (P0.x< 3)

                        #declare SplineZStart = SplineZC; 
                        #declare SplineZEnd = SplineZD; 
                        #declare ResX = tickerx-2;  

                    #else

                        #if (P0.x < 4)

                            #declare SplineZStart = SplineZD; 
                            #declare SplineZEnd = SplineZE; 
                            #declare ResX = tickerx-3;  

                        #else

                            #if (P0.x < 5 )

                                #declare SplineZStart = SplineZE; 
                                #declare SplineZEnd = SplineZF; 
                                #declare ResX = tickerx-4;  

                            #else

                                #if (P0.x < 6)

                                    #declare SplineZStart = SplineZF; 
                                    #declare SplineZEnd = SplineZG; 
                                    #declare ResX = tickerx-5;  

                                #else

                                    #if (P0.x < 7)

                                        #declare SplineZStart = SplineZG; 
                                        #declare SplineZEnd = SplineZH; 
                                        #declare ResX = tickerx-6;  

                                    #else

                                        #if (P0.x < 8)

                                            #declare SplineZStart = SplineZH; 
                                            #declare SplineZEnd = SplineZI; 
                                            #declare ResX = tickerx-7;  
                                
                                        #else

                                            #if (P0.x < 9)

                                                #declare SplineZStart = SplineZI; 
                                                #declare SplineZEnd = SplineZJ; 
                                                #declare ResX = tickerx-8;  
                                   
                                            #else 
                                                #declare SplineZStart = SplineZJ; 
                                                #declare SplineZEnd = SplineZK; 
                                                #declare ResX = tickerx-9; 
                                         
                                            #end
                                        #end
                                    #end
                                #end
                            #end
                        #end
                    #end
                #end
            #end

    

            //Calculating the y-coordinate

            #declare P1 = SplineZStart(tickerz);
            #declare P2 = SplineZEnd(tickerz);
            #declare Heightz = sin(0.5*pi *(1-ResX))*P1.y + sin(0.5*pi*ResX)*P2.y; 

            #declare P3 = SplineXStart(tickerx);
            #declare P4 = SplineXEnd(tickerx);
            #declare Heightx = sin(0.5*pi*(1-ResZ))*P3.y + sin(0.5*pi*ResZ)*P4.y; 

            #declare Height = (Heightz + Heightx)/2; 



            //Calculating Normals

            #declare AZ1 = SplineZStart(tickerz+0.1) - SplineZStart(tickerz-0.1);
            #declare AZ2 = SplineZEnd(tickerz+0.1) - SplineZEnd(tickerz-0.1);
            #declare AZ = sin(0.5*pi *(1-ResX))*AZ1 + sin(0.5*pi*ResX)*AZ2; 


            #declare AX1 = SplineXStart(tickerx+0.1) - SplineXStart(tickerx-0.1);
            #declare AX2 = SplineXEnd(tickerx+0.1) - SplineXEnd(tickerx-0.1);
            #declare AX = sin(0.5*pi*(1-ResZ))*AX1 + sin(0.5*pi*ResZ)*AX2; 

            #declare Normal = vcross(AX, AZ); 

            #if (abs(Normal.x)>abs(Normal.z)) 

    //Positioning and rotating individual elements

                #local AngleY = degrees(atan2(Normal.z, Normal.x));  
                #local N2 = vrotate (Normal, <0, AngleY, 0>);
                #local AngleZ = degrees(atan2(N2.y, N2.x));
                sphere {                                                       //The element for the area patch
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
                        <0, 0, 0>, 0.17 , 1                                           //The element for the area patch
                        scale<1,0.1,1>   
                        rotate <AngleX+90, 0, 0>
                        rotate <0, AngleY, 0>
                        translate <tickerx, Height, tickerz> 
                        pigment {
                            color rgb <1,1,1>     // solid color pigment
                        }
                    }
  
                #else//This covers positions with  

                    sphere {                                                    //The element for the area patch
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

