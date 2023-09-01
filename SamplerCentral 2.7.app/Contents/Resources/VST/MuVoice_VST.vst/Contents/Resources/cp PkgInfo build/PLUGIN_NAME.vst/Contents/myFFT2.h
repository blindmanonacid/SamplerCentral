#if !WIN32
#ifndef __altivec__
#include "altivec.h"
#define __altivec__
#endif
#endif

#if WIN32
#include <xmmintrin.h>
#endif

#ifndef __FFTLIB__
#define __FFTLIB__
class FFTLib
{
private:

	static const int swap256[240];
	static const int swap512[480];
	static const int swap1024[992];
	static const int swap2048[1984];

	float* lookupReal2048;
	float* lookupImag2048;
	float* lookupReal2048SSE;
	float* lookupImag2048SSE;
	float* lookupReal1024;
	float* lookupImag1024;
	float* lookupReal1024SSE;
	float* lookupImag1024SSE;
	float* lookupReal512;
	float* lookupImag512;
	float* lookupReal512SSE;
	float* lookupImag512SSE;
	float* lookupReal256;
	float* lookupImag256;
	float* lookupReal256SSE;
	float* lookupImag256SSE;
	float* tmpInvRe;
	float* tmpInvIm;
	float* div2048f;
	float* div1024f;
	float* div512f;
	float* temprSSEf;
	float* tempiSSEf;
	float* lookupInt; //Int stands for Interleaved

//	__m128 *div2048SSE;
//	__m128 *div1024SSE;
//	__m128 *div512SSE;

//	__m128 *temprSSE2;// = (__m128 *) temprSSEf;
//	__m128 *tempiSSE2;// = (__m128 *) tempiSSEf;

	//Make local variables global
	__m128 *data_rSSE, *data_iSSE, *data_riSSE, *data_rjSSE, *data_iiSSE, *data_ijSSE, *wrSSE, *wiSSE, temprSSE, tempiSSE;
	int nn, n, SSEn, SSEmmax, mmax,m,j,i,istep,SSEstep,swap1,swap2;
	float *lookupReal2, *lookupImag2,wr,wi,tempr, tempi, temp;
	__m128 * div2048;

/*#if WIN32
	__declspec(align(16)) float lookupReal2048[1024];
	__declspec(align(16)) float lookupImag2048[1024];
	__declspec(align(16)) float lookupReal2048SSE[2048];
	__declspec(align(16)) float lookupImag2048SSE[2048];
	__declspec(align(16)) float lookupReal1024[512];
	__declspec(align(16)) float lookupImag1024[512];
	__declspec(align(16)) float lookupReal1024SSE[1024];
	__declspec(align(16)) float lookupImag1024SSE[1024];
	__declspec(align(16)) float lookupReal512[256];
	__declspec(align(16)) float lookupImag512[256];
	__declspec(align(16)) float lookupReal512SSE[512];
	__declspec(align(16)) float lookupImag512SSE[512];
	__declspec(align(16)) float lookupReal256[128];
	__declspec(align(16)) float lookupImag256[128];
	__declspec(align(16)) float lookupReal256SSE[256];
	__declspec(align(16)) float lookupImag256SSE[256];
	__declspec(align(16)) float tmpInvRe[4];
	__declspec(align(16)) float tmpInvIm[4];
	__declspec(align(16)) float div2048f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
	__declspec(align(16)) float div1024f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
	__declspec(align(16)) float div512f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
	__declspec(align(16)) float temprSSEf[4] = {0.0f, 0.0f, 0.0f, 0.0f};
	__declspec(align(16)) float tempiSSEf[4] = {0.0f, 0.0f, 0.0f, 0.0f};
//
//	__declspec(align(16)) float lookupIntFFT2[16]; 
	__declspec(align(16)) float lookupInt[4096]; //Int stands for Interleaved
#else
	float *lookupReal2048 = (float *) valloc(1024*sizeof(float));
	float *lookupImag2048 = (float *) valloc(1024*sizeof(float));
	float *lookupReal2048SSE = (float *) valloc(2048*sizeof(float));
	float *lookupImag2048SSE = (float *) valloc(2048*sizeof(float));
	float *lookupReal1024 = (float *) valloc(512*sizeof(float));
	float *lookupImag1024 = (float *) valloc(512*sizeof(float));
	float *lookupReal1024SSE = (float *) valloc(1024*sizeof(float));
	float *lookupImag1024SSE = (float *) valloc(1024*sizeof(float));
	float *lookupReal512 = (float *) valloc(256*sizeof(float));
	float *lookupImag512 = (float *) valloc(256*sizeof(float));
	float *lookupReal512SSE = (float *) valloc(512*sizeof(float));
	float *lookupImag512SSE = (float *) valloc(512*sizeof(float));
	float *lookupReal256 = (float *) valloc(128*sizeof(float));
	float *lookupImag256 = (float *) valloc(128*sizeof(float));
	float *lookupReal256SSE = (float *) valloc(256*sizeof(float));
	float *lookupImag256SSE = (float *) valloc(256*sizeof(float));
	float *tmpInvRe = (float *) valloc(4*sizeof(float));
	float *tmpInvIm = (float *) valloc(4*sizeof(float));
//float div2048f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
//float div1024f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
//float div512f[4] = {2048.0f, 2048.0f, 2048.0f, 2048.0f};
	float *div2048f = (float *) valloc(4*sizeof(float));
	float *div1024f = (float *) valloc(4*sizeof(float));
	float *div512f = (float *) valloc(4*sizeof(float));
	float *temprSSEf = (float *) valloc(16); //{0.0f, 0.0f, 0.0f, 0.0f};
	float *tempiSSEf = (float *) valloc(16); //{0.0f, 0.0f, 0.0f, 0.0f};
//
//	float *lookupIntFFT2 = (float *) ::malloc(16*sizeof(float));
	float *lookupInt = (float *) ::malloc(4096*sizeof(float));
#endif
*/

public:
	FFTLib ();
	~FFTLib ();

	void fftNR(int dataSize, float* data, const int isign);
	void fftSSE(float* data_r, float* data_i, const int isign, const int N);
	void fft(float* data_r, float* data_i, const int isign, const int N);

	void fft256SSE(float* data_r, float* data_i, const int isign);
//	void fft256IntSSE(float* data, float* temp, const int isign, const int bufferSize);

	void fft512(float* data_r, float* data_i, const int isign);
	void fft512SSE(float* data_r, float* data_i, const int isign);

	void fft1024(float* data_r, float* data_i, const int isign);
	void fft1024SSE(float* data_r, float* data_i, const int isign);

	void fft2048(float* data_r, float* data_i, const int isign);
	void fft2048SSE(float* data_r, float* data_i, const int isign);

	void fft2048RealSSE(float* data_r, float* data_i, const int isign);
	void fft1024RealSSE(float* data_r, float* data_i, const int isign);
	void fft512RealSSE(float* data_r, float* data_i, const int isign);
	void fftRealSSE(float* data_r, float* data_i, const int isign, const int N);
};
#endif
