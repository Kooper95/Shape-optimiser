SetFactory("OpenCASCADE");




//in: Power, Rin and bs0,bs1



R = Sqrt(Power/2000) * Rin;

gridsize=0.6 * (R/0.23)^(1/2);



wwidth=0.2;
inlet=2;
LenDif= Sqrt(Power/2000) * 130;
gamma=1.3271193649;
pa = 10000;
pc= 4 * 101325; 
epsilon = ((gamma-1)/2)^(1/2) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1))) * (pa/pc)^(-1/gamma) * (1-(pa/pc)^((gamma-1)/gamma))^(-1/2);
Rf=R*Sqrt(epsilon);
Len=3 * R * (Sqrt(epsilon)-1)/Tan(15*Pi/180);
thi = Atan((Rf-R)/Len);


bs0 = b0 * R;
bs1 = b1 * R;


Printf("AreaMinX %g; AreaMaxY %g;", Pi * ((-0.5 * R + 3* R * (1 - Cos(Pi/4)) + 1.5* R)/1000)^2 , Pi * ((Rf + wwidth + inlet)^2 - (Rf + wwidth)^2)/1000000) >> "0/dataTable";



//Printf("%g", Len) >> "read";
rsmall=1.5;


Point(1) = {0,                                              Rf,             0, gridsize/8   }; 
Point(3) = {Sin(thi) * rsmall * R - Len,                     (1+rsmall) * R - Cos(thi) * rsmall * R,             0, gridsize/8   }; 



//Point(4) = {- Len,                     1.382 * R,             0, gridsize/8   }; 
//Point(5) = {- Len,                     R,             0, gridsize/8   }; 

Point(6) = {- Len,                     2.5 * R,             0, gridsize/8   }; 
Point(7) = {- Len-1.5* R *Sin(Pi/4),                     2.5 * R -1.5 * Cos(Pi/4) * R,             0, gridsize/6   }; 

Point(8) = {- Len-3* R *Sin(Pi/4),                     -0.5 * R + 3* R * (1 - Cos(Pi/4)),             0, gridsize/6   }; 

Point(9) = {- Len-3* R *Sin(Pi/4),                     -0.5 * R + 3* R * (1 - Cos(Pi/4)) + 1.5* R,             0, gridsize/6   }; 


Point(10) = {- Len-3* R *Sin(Pi/4)-2,                     -0.5 * R + 3* R * (1 - Cos(Pi/4)) + 1.5* R,             0, (-0.5 * R + 3* R * (1 - Cos(Pi/4)) + 1.5* R)/3   }; 
Point(11) = {- Len-3* R *Sin(Pi/4)-2,                     0,             0, (-0.5 * R + 3* R * (1 - Cos(Pi/4)) + 1.5* R)/3   }; 



Point(12) = {- Len-3* R *Sin(Pi/4),                     0,             0, gridsize/6   }; 
Point(13) = {- Len +2*LenDif/3,                     0,             0, gridsize/5   }; 
Point(14) = { LenDif,                     0,             0, gridsize/4    }; 



// Tanh function in here from b1 to b0


res = 80;

For i In {0: res-1}
    Point(i + 15) = { LenDif - i * (LenDif-LenDif/7) / res,        (bs1 - bs0) * Tanh(Pi * (LenDif - i * (LenDif-LenDif/7) / res) / (LenDif-LenDif/7) - Pi) + bs1,         0, gridsize/3  - i*gridsize/(6*res)  };
EndFor




Point(res+ 15) = { LenDif/7-0,                     (bs1 - bs0) * Tanh(Pi *  (LenDif/7) / (LenDif-LenDif/7) - Pi) + bs1,             0, gridsize/8   }; 
Point(res+ 16) = { LenDif/7-2,                   (bs1 - bs0) * Tanh(Pi *  (LenDif/7) / (LenDif-LenDif/7) - Pi) + bs1,             0, gridsize   }; 
Point(res+ 17) = { LenDif/7-4,                   (bs1 - bs0) * Tanh(Pi *  (LenDif/7) / (LenDif-LenDif/7) - Pi) + bs1,             0, gridsize   }; 

Point(res+ 18) = { 4,                     Rf + wwidth + inlet,             0, gridsize   }; 
Point(res+ 19) = { 2,                     Rf + wwidth + inlet,             0, gridsize   }; 
Point(res+ 20) = { 0,                     Rf + wwidth + inlet,             0, gridsize/6   }; 




Point(res+ 21) = { -Len/4,                     Rf + wwidth + inlet,             0, inlet/4    }; 

Point(res+ 22) = { -Len/4,                     Rf + wwidth,             0, inlet/4   }; 
Point(res+ 23) = { -wwidth * 2,                     Rf + wwidth,             0, gridsize/6   };
//Point(res+ 24) = {wwidth,                     Rf + wwidth/2,             0, gridsize/3   };




Line(1) = {1 , 3};

Circle(2)    = {3,6,7};
Circle(3)    = {7:9};
Line(4)      = {9,10};
Line(5)      = {10,11};

Line(6)      = {11,12};
Line(7)      = {12,13};
Line(8)      = {13,14};
Line(9)      = {14, 15};


For i In {0: res-1}
    Line(10 + i)      = {15 + i, 16 + i};
EndFor

BSpline(10 + res) = {res+ 15 : res+ 20};

Line(11 + res) = {res+ 20 : res+ 21};
Line(12 + res) = {res+ 21 : res+ 22};
Line(13 + res) = {res+ 22 : res+ 23};
Line(14 + res) = {res+ 23 , 1};





Line Loop(15 + res)     = {1:14 + res};

//Compound Curve{1,2};



Plane Surface(16 + res) = { 15 + res  };


//Mesh.Algorithm = 6;

Recombine Surface {16 + res};
Mesh.RecombinationAlgorithm = 3;


Mesh.Smoothing = 10;

surfaceVector[] = Extrude {0,0,3} {
    Surface{16 + res};
    Layers{1};
    Recombine;
};




Physical Surface("maxZ")    = surfaceVector[0];
Physical Volume("internal") = surfaceVector[1];
Physical Surface("minX")    = surfaceVector[6];
Physical Surface("maxY")    = surfaceVector[13 + res];
Physical Surface("maxX")    = surfaceVector[10];
Physical Surface("minY")    = {surfaceVector[7] , surfaceVector[8],surfaceVector[9]};
Physical Surface("minZ")    = {16 + res};

Physical Surface("theWalls")= {surfaceVector[2],surfaceVector[3], surfaceVector[4] ,surfaceVector[5], surfaceVector[14 + res], surfaceVector[15 + res] , surfaceVector[11 ] : surfaceVector[12 + res]};
