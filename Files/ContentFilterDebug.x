#import "Headers.h"

static BOOL didShowDebug = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShowDebug && array.count > 0) {

        didShowDebug = YES;

        NSString *desc = [[array firstObject] description];

        if (desc.length > 1000) {
            desc = [desc substringToIndex:1000];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            UIViewController *rootVC =
            [UIApplication sharedApplication].keyWindow.rootViewController;

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"FILTER DEBUG"
                                                message:desc
                                         preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];

            [rootVC presentViewController:alert
                                 animated:YES
                               completion:nil];
        });
    }

    %orig;
}

%end
