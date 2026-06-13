#import "Headers.h"

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    NSLog(@"========== FILTER DEBUG ==========");

    for (id section in array) {
        NSLog(@"SECTION: %@", [section description]);
    }

    %orig;
}

%end