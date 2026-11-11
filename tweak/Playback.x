// Experiment for playback stopping after a minute or two on a re-signed app: make the
// client pick formats itself instead of using server-driven ABR. Same hook as the
// "Disable server ABR" option in PoomSmart's YTUHD.
#import <Foundation/Foundation.h>

%hook YTHotConfig

- (BOOL)iosPlayerClientSharedConfigDisableServerDrivenAbr { return YES; }

%end
