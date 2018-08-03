#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include "CellLabUI"
#include "CellLabRoutines"

/////////////////////////////////////////////////////////////////////////////////////////////////////
///	Official ScanM Data Preprocessing Scripts - by Tom Baden    	///
/////////////////////////////////////////////////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////////////////////////////////////////////////

function OS_LaunchCellLab()

// 1 // check for Parameter Table
if (waveexists($"OS_Parameters")==0)
	print "Warning: OS_Parameters wave not yet generated - doing that now..."
	OS_ParameterTable()
	DoUpdate
endif
wave OS_Parameters
// 2 //  check for Detrended Data stack
variable Channel = OS_Parameters[%Data_Channel]
// Dont check for detrended stack, as it is not used here. KF
//if (waveexists($"wDataCh"+Num2Str(Channel)+"_detrended")==0)
//	print "Warning: wDataCh"+Num2Str(Channel)+"_detrended wave not yet generated - doing that now..."
//	OS_DetrendStack()
//endif

// flags from "OS_Parameters"
variable Display_RoiMask = OS_Parameters[%Display_Stuff]

// data handling
string input_name = "wDataCh"+Num2Str(Channel)//+"_detrended"
duplicate /o $input_name InputData
variable nX = DimSize(InputData,0)
variable nY = DimSize(InputData,1)
variable nF = DimSize(InputData,2)
//variable Framerate = 1/(nY * LineDuration) // Hz 
//variable Total_time = (nF * nX ) * LineDuration
//print "Recorded ", total_time, "s @", framerate, "Hz"
variable xx,yy

// make average image
make /o/n=(nX,nY) Stack_ave = 0
for (xx=0;xx<nX;xx+=1)
	for (yy=0;yy<nY;yy+=1)
		make /o/n=(nF) currentwave = InputData[xx][yy][p]
		Wavestats/Q Currentwave
		Stack_ave[xx][yy]=V_Avg
	endfor
endfor



// call cell lab
string sourcename = "Stack_ave"
string targetname = "ROIs"
RecognizeCellsUI($sourcename, targetname, "")




// cleanup
killwaves currentwave, InputData

end