#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (didShow) {
        %orig;
        return;
    }

    didShow = YES;

    NSMutableString *msg = [NSMutableString string];

    int sectionCount = 0;

    for (id section in array) {

        sectionCount++;

        [msg appendFormat:
         @"SECTION %d\n%@\n\n",
         sectionCount,
         NSStringFromClass([section class])];

        @try {

            NSArray *contents =
            [section valueForKey:@"contentsArray"];

            [msg appendFormat:
             @"contents=%lu\n\n",
             (unsigned long)contents.count];

            int i = 0;

            for (id item in contents) {

                [msg appendFormat:
                 @"item %d -> %@\n",
                 i,
                 NSStringFromClass([item class])];

                i++;

                if (i >= 5)
                    break;
            }

        } @catch (...) {

            [msg appendString:@"NO CONTENTS\n\n"];
        }

        if (sectionCount >= 5)
            break;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIWindow *window =
        [[[UIApplication sharedApplication] windows] firstObject];

        UIViewController *vc =
        window.rootViewController;

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"SECTION DEBUG"
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
         [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                handler:nil]];

        [vc presentViewController:alert
                         animated:YES
                       completion:nil];
    });

    %orig;
}

%end
