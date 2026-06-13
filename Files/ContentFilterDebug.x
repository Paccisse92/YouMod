#import "Headers.h"

static BOOL didShow = NO;

%hook YTInnerTubeCollectionViewController

- (void)addSectionsFromArray:(NSArray *)array {

    if (didShow) {
        %orig;
        return;
    }

    didShow = YES;

    id foundRenderer = nil;

    for (id section in array) {

        if (![section respondsToSelector:@selector(contentsArray)])
            continue;

        NSArray *contents = [section valueForKey:@"contentsArray"];

        for (id item in contents) {

            if (![item respondsToSelector:@selector(elementRenderer)])
                continue;

            foundRenderer = [item valueForKey:@"elementRenderer"];

            if (foundRenderer)
                break;
        }

        if (foundRenderer)
            break;
    }

    NSString *message = @"No renderer found";

    if (foundRenderer) {

        @try {

            id titleObj = [foundRenderer valueForKey:@"title"];

            message = [NSString stringWithFormat:
                @"TITLE CLASS:\n%@\n\nTITLE VALUE:\n%@",
                NSStringFromClass([titleObj class]),
                titleObj];

        }
        @catch (NSException *exception) {

            message = [NSString stringWithFormat:
                @"EXCEPTION\n\n%@",
                exception.reason];
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIWindow *window =
        [[[UIApplication sharedApplication] windows] firstObject];

        UIViewController *vc =
        window.rootViewController;

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"TITLE DEBUG"
                                            message:message
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
