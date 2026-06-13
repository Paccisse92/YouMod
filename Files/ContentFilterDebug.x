#import <objc/runtime.h>
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
    int rendererIndex = 0;

    for (id section in array) {

        if (![section respondsToSelector:@selector(contentsArray)])
            continue;

        NSArray *contents = [section valueForKey:@"contentsArray"];

        for (id item in contents) {

            if (![item respondsToSelector:@selector(elementRenderer)])
                continue;

            rendererIndex++;

            // Cambia questo numero se serve
            if (rendererIndex == 15) {

                foundRenderer = [item valueForKey:@"elementRenderer"];

                break;
            }
        }

        if (foundRenderer)
            break;
    }

    NSString *message = @"No renderer found";

    if (foundRenderer) {

        NSMutableString *msg = [NSMutableString string];

        [msg appendFormat:@"RENDERER #%d\n\n", rendererIndex];

        [msg appendFormat:@"CLASS:\n%@\n\n",
         NSStringFromClass([foundRenderer class])];

        unsigned int count = 0;

        objc_property_t *properties =
        class_copyPropertyList([foundRenderer class], &count);

        [msg appendFormat:@"PROPERTIES (%u):\n\n", count];

        for (unsigned int i = 0; i < count; i++) {

            const char *name =
            property_getName(properties[i]);

            [msg appendFormat:@"%s\n", name];
        }

        free(properties);

        message = msg;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIWindow *window =
        [[[UIApplication sharedApplication] windows] firstObject];

        UIViewController *vc =
        window.rootViewController;

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"RENDERER DEBUG"
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
