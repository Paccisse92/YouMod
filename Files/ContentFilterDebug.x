#import "Headers.h"

static BOOL didRun = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didRun && array.count > 0) {

        didRun = YES;

        id firstSection = [array firstObject];

        NSString *text = [firstSection description];

        if (!text)
            text = @"NULL";

        NSString *path = @"/var/mobile/Documents/filter_debug.txt";

        [text writeToFile:path
              atomically:YES
                encoding:NSUTF8StringEncoding
                   error:nil];
    }

    %orig;
}

%end
