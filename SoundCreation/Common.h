
#pragma mark - General
NSString* currentVersion(void);
NSString* timeStamp(void);

#pragma mark - Math

// 2*Pi; handy for trig math
#define M_PI_X_2 3.14159265358979323846264338327950288 * 2
double degreesToRadians(double);
double radiansToDegrees(double);

#pragma mark - Music

/*
 * Frequency ratio between notes tuned in 'equal temperament'
 * the ratio to the 12th power is equal to 2, which when
 * multiplied by a frequency gives a sound one octave higher
 */
#define kFrequency_Ratio 1.05946

/*
 * Returns the frequency of the note that is a whole step higher
 * or lower than the frequency you give
 * NOTE: Set the 2nd parameter to YES to step up, NO to step down
 */
double changeFrequencyByWholeStep(double, BOOL);

/*
 * Same as above but for half step
 */
double changeFrequencyByHalfStep(double, BOOL);

/*
 * Same as above too except you set how many steps to take
 * The 2nd parameter sets how many half steps to take
 * NOTE: Since everything to the 0 power is one, passing in
 * 0 for the second parameter will return the frequency you gave
 */
double changeFrequencyBySteps(double, int, BOOL);

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