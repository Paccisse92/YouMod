#import "Headers.h"

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (array.count > 0) {

        id firstSection = [array firstObject];

        NSLog(@"=====================");
        NSLog(@"FILTER DEBUG");
        NSLog(@"%@", [firstSection description]);
        NSLog(@"=====================");
    }

    %orig;
}

%end
