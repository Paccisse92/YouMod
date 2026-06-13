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

    int idx = 0;

    for (id section in array) {

        [msg appendFormat:
         @"%d -> %@\n",
         idx,
         NSStringFromClass([section class])];

        idx++;

        if (idx >= 30)
            break;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIWindow *window =
        [[[UIApplication sharedApplication] windows] firstObject];

        UIViewController *vc =
        window.rootViewController;

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"SECTION TYPES"
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
