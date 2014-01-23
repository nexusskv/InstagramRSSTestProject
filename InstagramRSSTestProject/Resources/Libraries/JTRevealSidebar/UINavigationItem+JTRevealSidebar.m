/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UINavigationItem+JTRevealSidebar.h"
#import <objc/runtime.h>

@implementation UINavigationItem (JTRevealSidebar)

static char *revealSidebarDelegateKey;

- (void)setRevealSidebarDelegate:(id<JTRevealSidebarDelegate>)revealSidebarDelegate {
    objc_setAssociatedObject(self, &revealSidebarDelegateKey, revealSidebarDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id <JTRevealSidebarDelegate>)revealSidebarDelegate {
    return (id <JTRevealSidebarDelegate>)objc_getAssociatedObject(self, &revealSidebarDelegateKey);
}

@end
