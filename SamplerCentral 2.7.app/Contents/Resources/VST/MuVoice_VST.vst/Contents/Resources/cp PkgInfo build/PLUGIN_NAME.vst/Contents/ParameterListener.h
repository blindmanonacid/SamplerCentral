//-----------------------------------------------------------------------------
#ifndef __ParameterListener__
#define __ParameterListener__

class CParameterListener
{
public:
	virtual void parameterChanged (int objectId, int parameterId, void *data, double pSamplePos) = 0;
};

#endif