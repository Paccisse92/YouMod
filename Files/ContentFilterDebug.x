#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (!didShow) {

        for (id obj in array) {

            NSString *desc = [obj description];

            if ([desc containsString:@"video"] ||
                [desc containsString:@"watch"] ||
                [desc containsString:@"channel"] ||
                [desc containsString:@"owner"]) {

                didShow = YES;

                if (desc.length > 1500) {
                    desc = [desc substringToIndex:1500];
                }

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
                    UIViewController *vc = window.rootViewController;

                    UIAlertController *alert =
                    [UIAlertController alertControllerWithTitle:@"VIDEO DEBUG"
                                                        message:desc
                                                 preferredStyle:UIAlertControllerStyleAlert];

                    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];

                    [vc presentViewController:alert animated:YES completion:nil];
                });

                break;
            }
        }
    }

    %orig;
}

%end
