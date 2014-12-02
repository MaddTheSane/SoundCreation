
#ifndef __SC_COMMON_H_
#define __SC_COMMON_H_

#include <CoreFoundation/CoreFoundation.h>
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif

#include <stdlib.h>
#include <sys/cdefs.h>

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - General
#ifdef __OBJC__
NSString* currentVersion(void);
NSString* timeStamp(void);
#endif

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
#ifdef __OBJC__
void _dbgLog(const char* pszFile, int line, NSString* fmt, ...);
#else
void _dbgLogCPP(const char* pszFile, int line, const char *fmt, ...);
#endif
#define dbgAssert(arg) assert(arg)
#else
#define dbgLog(args...)	{}
#define dbgAssert(arg) {}
#endif

#ifdef __cplusplus
}
#endif

#endif
