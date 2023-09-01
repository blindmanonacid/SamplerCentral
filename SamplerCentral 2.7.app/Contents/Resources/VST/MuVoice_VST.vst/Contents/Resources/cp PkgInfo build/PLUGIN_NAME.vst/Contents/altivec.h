/*
 *  altivec.h
 *  MuVoice
 *
 *  Created by Gilles Dandelooy on 4/2/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#if defined( __SSE__ )
#include <xmmintrin.h>
#endif

#if defined( __VEC__ )
#include <vecLib/vecLib.h>

static vector float altinull = (vector float){-0.f,-0.f,-0.f,-0.f};

static float *aref = (float *)valloc(4*sizeof(float));
static float *bref = (float *)valloc(4*sizeof(float));
static float *cref = (float *)valloc(4*sizeof(float));
static float *setpar  = (float *)valloc(4*sizeof(float));

typedef vector float vFloat;

typedef union {
	vector float _intrinsic;
	float elem[4];
} v2Float;

#define __m128 vFloat

#define _mm_add_ps(a, b) vec_add((a), (b))
#define _mm_sub_ps(a, b) vec_sub((a), (b))
#define _mm_mul_ps(a, b) vec_madd((a), (b), altinull)
//#define _mm_div_ps(a, b)  ({ vFloat c; v2Float cref = (v2Float *) c; float* aref = (float *) a; float* bref = (float *) b; cref[0]=aref[0]/bref[0]; cref[1]=aref[1]/bref[1]; cref[2]=aref[2]/bref[2]; cref[3]=aref[3]/bref[3]; return c;})

#define _mm_div_ps(a, b)  ({ vFloat c; vec_st((a), 0, aref); vec_st((b), 0, bref); cref[0]=aref[0]/bref[0]; cref[1]=aref[1]/bref[1]; cref[2]=aref[2]/bref[2]; cref[3]=aref[3]/bref[3]; c = vec_ld(0, cref); c;})
#define _mm_set_ps1(a) ({ setpar[0]=setpar[1]=setpar[2]=setpar[3]=(a); vec_ld(0, setpar); })
//#define _mm_div_ps(a, b) vec_madd((a),(b), altinull)
//#define _mm_set_ps1(a) vec_ld(0, setpar)
#endif

/*static vector float altinull = (vector float){-0.f,-0.f,-0.f,-0.f};
typedef vector float vFloat;
#define __m128 vFloat

#define _mm_add_ps(a, b) vec_add((a), (b))
#define _mm_sub_ps(a, b) vec_sub((a), (b))
#define _mm_mul_ps(a, b) vec_madd((a), (b), altinull)
#define _mm_div_ps(a, b)  ({ float* tmp = (float *) malloc(8*sizeof(float)); vFloat c; vec_st((a), 0, tmp); vec_st((b), 0, tmp+4); tmp[0]/=tmp[4]; tmp[1]/=tmp[5]; tmp[2]/=tmp[6]; tmp[3]/=tmp[7]; c = vec_ld(0, tmp); c;})
#define _mm_set_ps1(a) ({ float* tmp = (float *) malloc(4*sizeof(float)); tmp[0]=tmp[1]=tmp[2]=tmp[3]=(a); vec_ld(0, tmp); })

#endif*/

/*static vector float altinull = (vector float){-0.f,-0.f,-0.f,-0.f};
static float* globals = (float*) malloc(80*sizeof(float));
static int globalsIndex = 0;

typedef vector float vFloat;
#define __m128 vFloat

#define _mm_add_ps(a, b) vec_add((a), (b))
#define _mm_sub_ps(a, b) vec_sub((a), (b))
#define _mm_mul_ps(a, b) vec_madd((a), (b), altinull)
#define _mm_div_ps(a, b)  ({globalsIndex++; if (globalsIndex >= 10) globalsIndex -= 10; float* gTmp = globals+8*globalsIndex; vFloat c; vec_st((a), 0, gTmp); vec_st((b), 0, gTmp+4); gTmp[0]/=gTmp[4]; gTmp[1]/=gTmp[5]; gTmp[2]/=gTmp[6]; gTmp[3]/=gTmp[7]; c = vec_ld(0, gTmp); c;})
#define _mm_set_ps1(a) ({ globalsIndex++; if (globalsIndex >= 10) globalsIndex -= 10; float* gTmp = globals+8*globalsIndex; gTmp[0]=gTmp[1]=gTmp[2]=gTmp[3]=(a); vec_ld(0, gTmp); })

#endif*/
