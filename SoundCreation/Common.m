#import <Foundation/Foundation.h>
#include "Common.h"

#pragma mark - General
NSString* currentVersion(void) {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString* timeStamp(void) {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    return [formatter stringFromDate:now];
}

#pragma mark - Math
double degreesToRadians (double angle) {
    return angle * (M_PI/180);
}

double radiansToDegrees(double radians) {
    return radians * (180/M_PI);
}

#pragma mark - Logging
#if DEBUG

static void _dbgLogV(const char* pszFile, int line, NSString* fmt, va_list ap) {
	char threadname[32] = "main";
	if (!pthread_main_np()) {
		mach_port_t tid = pthread_mach_thread_np(pthread_self());
		sprintf(threadname, "%d", tid);
	}
	
	NSString* log = [[NSString alloc] initWithFormat:fmt arguments:ap];
	
	const char* end = strrchr(pszFile, '/');
	fprintf(stderr, "[dbgLog %s-%s:%d] %s\n", threadname, end ? end+1 : pszFile, line, [log UTF8String]);
}

void _dbgLog(const char* pszFile, int line, NSString* fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
	_dbgLogV(pszFile, line, fmt, ap);
    va_end(ap);
}

void _dbgLogCPP(const char* pszFile, int line, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_dbgLogV(pszFile, line, @(fmt), ap);
	va_end(ap);
}

#endif

