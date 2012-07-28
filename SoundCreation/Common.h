
#pragma mark - General
NSString* currentVersion(void);
NSString* timeStamp(void);

#pragma mark - Math

// 2*Pi; handy for trig math
#define M_PI_X_2 3.14159265358979323846264338327950288 * 2
double degreesToRadians(double);
double radiansToDegrees(double);

#pragma mark - Logging
// Does some craziness I don't understand
#if DEBUG
#include "pthread.h"
#define dbgLog(args...) _dbgLog(__FILE__, __LINE__, args)
void _dbgLog(const char* pszFile, int line, NSString* fmt, ...);
#define dbgAssert(arg) assert(arg)
#else
#define dbgLog(args...)	{}
#define dbgAssert(arg) {}
#endif