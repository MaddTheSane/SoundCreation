#import "Common.h"

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

#pragma mark - Music
double changeFrequencyByWholeStep(double frequency, BOOL stepUp) {
    if (stepUp)
        return (frequency * pow(kFrequency_Ratio, 2));
    else
        return (frequency / pow(kFrequency_Ratio, 2));
}

double changeFrequencyByHalfStep(double frequency, BOOL stepUp) {
    if (stepUp)
        return (frequency * kFrequency_Ratio);
    else
        return (frequency / kFrequency_Ratio);
}

double changeFrequencyBySteps(double frequency, int steps, BOOL stepUp) {
    if (stepUp)
        return (frequency * pow(kFrequency_Ratio, steps));
    else
        return (frequency / pow(kFrequency_Ratio, steps));
}

#pragma mark - Logging
#if DEBUG

void _dbgLog(const char* pszFile, int line, NSString* fmt, ...) {
    char threadname[32] = "main";
    if (!pthread_main_np()) {
        mach_port_t tid = pthread_mach_thread_np(pthread_self());
        sprintf(threadname, "%d", tid);
    }
    
    va_list ap;
    va_start(ap, fmt);
    NSString* log = [[NSString alloc] initWithFormat:fmt arguments:ap];
    va_end(ap);
    
    const char* end = strrchr(pszFile, '/');
    fprintf(stderr, "[dbgLog %s-%s:%d] %s\n", threadname, end ? end+1 : pszFile, line, [log UTF8String]);
}

#endif

