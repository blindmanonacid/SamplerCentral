#if !WIN32
#ifndef __altivec__
#include "altivec.h"
#define __altivec__
#endif
#endif

#ifndef __FILTERS__
#define __FILTERS__
struct Filters {
	float* freqs;
	float* gains;
	int* filterStart;
	int* filterLength;
	int numberOfFilters;
};
#endif

#ifndef __HARMEQS__
#define __HARMEQS__
struct HarmEQs{
	float* harmEQGains; //This array must be 16 byte aligned for SSE compatibility.
	int* harmEQStart; //This must absolutely be a multiple of 4.
	int* harmEQLength; //Must 
	int numberOfEQs;
};
#endif

#ifndef __SM1LIB__
#define __SM1LIB__
class SM1Lib
{
private:
	int lookupW2048Length;
	int	M_W;
	int	M_Y;
	int lookupW2048SSELength;
	int lookupY2048Length;
	float* lookupW2048;
	float* lookupW2048SSE;
	float* 
		lookupY2048;
	float* specWarpBPF;
	float* B; //B[10230]; // 5*2046 // about 12*825 
	float* C; //C[2048];
	float* pitchesIn;
	float* pitchesOut;
	float* pitchesTmp;
	float* pitchesTmp2;
	float* AShift_r;
	float* AShift_i;
	float* AWarp_r;
	float* AWarp_i;
	float* w; // Blackmann-Harris 4*2048, 4*1024, 4*512 = 14336
	float* w2;
	float* tmp;
	float* mr;
	float* mi;
	//global vars for FX
	float* filter;
	float* warpCurves; //10 curves of each 24x2 elements, 24 inputs and 24 outputs.

	float fSMSampleRate;
	long lSMSampleRate;	
	long lSMSampleRateDiv100;
	float* sliderValue;
	int numberOfSliderValues;
	//float sliderIndices[10];
	int* curveIndices;
	int* curveLength;

	//Pointers to filterdefinitions and HarmEQ definitions
	Filters* filters;
	HarmEQs* harmEQs;

	//Check whether the library is initialized
	int initialized;
public:
	SM1Lib ();
	~SM1Lib ();

	int isInitialized();
	void setSMSampleRate(float sampleRate);
	void BPF (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPFComplex (int BPFLength, float* x, float* yr, float* yi, int inputLength, 
				 float* in, float* outr, float* outi);
	void BPF2 (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF2Norm (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF2Uniform (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF2UniformComplex (int BPFLength, float* x, float* yr, float* yi, int inputLength, float* in, float* outr, float* outi);
	void BPF3 (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF4 (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF4Norm (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF4Uniform (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	//void BPF4UniformComplex (int BPFLength, float* x, float* y, int inputLength, float* in, float* out);
	void BPF4UniformComplex (int BPFLength, float* x, float* yr, float* yi, int inputLength, float* in, float* outr, float* outi);
	void blackmannHarris(int N, int M, float* & window);
	void blackmannHarris(float winLength, int& N, int& M, float* & window);
	void ampCalcInTime(float* x_r, float pitch, int M_accent, int N_accent, float* A_rHat, float* A_iHat);
	void ampCalcSimple(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, float* A_rHat, float* A_iHat);
	void ampCalcSimple2(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, float* A_rHat, float* A_iHat) ;
	void ampCalc(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat);
	void ampCalc2(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			  float* A_rHat, float* A_iHat);
	void ampCalcSSE(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat);
	void ampCalcSSE2(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat);
	void ampCalcSSE3(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat);
	void ampCalcSSE4(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat);
	void ampCalcSSE5(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat, int ALength);
	void ampCalcSSE6(float* X_r, float* X_i, float pitch, int M_accent, int N_accent, int D, 
			 float* A_rHat, float* A_iHat, bool debug);
	void dumpAmpCalc(int numberOfPartials);
	void synthesisInTime (int ALength, float* A_r, float* A_i, float pitch, int M_accent, int N_accent, float* x_r, float gain);
	void synthesis (int ALength, float* A_r, float* A_i, float pitch, int M_accent, int N_accent, float* X_r, float* X_i, float gain);
	void synthesis2 (int ALength, float* A_r, float* A_i, float pitch, int M_accent, int N_accent, float* X_r, float* X_i, float gain);
	void synthesisSSE (int ALength, float* A_r, float* A_i, float pitch, int M_accent, int N_accent, float* X_r, float* X_i, int handleReplic, float gain);
	void synthesisSSE2 (int ALength, float* A_r, float* A_i, float pitch, int M_accent, int N_accent, float* X_r, float* X_i, int handleReplic, float gain);
	void synthesisSSE3 (int ALength, float* A_r, float* A_i, float pitch, int N_accent, float* X_r, float* X_i, int handleReplic, float gain);
	void initWarp (void);
	void spectrumWarp (float control, float pitchIn, float pitchOut);
	void spectrumWarpManual (float* warpControls, float pitchIn, float pitchOut);
	void synthVoice (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
				 float pitchIn, float pitchOut, float deltaPhaseOffset, int M_accent, int N_accent, float* sHat_r, float* sHat_i, float gain);
	/*void synthVoiceSSE (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0, //with DeltaN02.
				 float pitchIn, float pitchOut, float deltaN02, int M_accent, int N_accent, 
				 float* sHat_r, float* sHat_i, int handleReplic, float gain);*/
	void synthVoiceSSE (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
				 float pitchIn, float pitchOut, float deltaPhaseOffset, int M_accent, int N_accent, 
				 float* sHat_r, float* sHat_i, int handleReplic, float gain);
	void synthVoiceSSEFX (int formantActive, float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
				 float pitchIn, float pitchOut, float deltaPhaseOffset, int M_accent, int N_accent, 
				 float* sHat_r, float* sHat_i, int handleReplic, float gain, int filter, int harmEQ); //With filter and HarmEQ
	void synthVoiceSSE2 (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
				 float pitchIn, float pitchOut, float deltaPhaseOffset, int M_accent, int N_accent, 
				 float* sHat_r, float* sHat_i, int handleReplic, float gain);
	//void synthVoiceSSE2 (float* formantControlParameters, int ALength, float* A_r, float* A_i, float deltaN0,
	//				 float pitchIn, float pitchOut, float prevPitchIn, float prevPitchOut,
	//				 float deltaPhaseOffset, int M_accent, int N_accent, float* sHat_r, float* sHat_i, int handleReplic, float gain);
	//void synthVoiceSSE3 (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
	//			 float pitchIn, float pitchOut, float prevPitchIn, float prevPitchOut,
	//			 float deltaPhaseOffset, int N_accent, float* sHat_r, float* sHat_i, int handleReplic, float gain);
	//void synthVoiceSSE3 (float formantControlParameter, int ALength, float* A_r, float* A_i, float deltaN0,
	//			 float pitchIn, float pitchOut, float deltaPhaseOffset, int N_accent, 
	//			 float* sHat_r, float* sHat_i, int handleReplic, float gain);
	void setFilters (Filters* pFilters);
	void setHarmEQs (HarmEQs* pHarmEQs);
};
#endif
