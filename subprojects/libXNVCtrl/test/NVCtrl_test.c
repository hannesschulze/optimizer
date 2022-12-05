#include <X11/Xlib.h>
#include <stdio.h>

#include "NVCtrlLib.h"

int
main(void)
{
    Display *dpy;
    Bool ret;
    int major, minor;

    dpy = XOpenDisplay(NULL);
    if (!dpy)
    {
        fprintf(stderr, "Cannot open display '%s'.\n", XDisplayName(NULL));
        return 1;
    }

    ret = XNVCTRLQueryVersion(dpy, &major, &minor);
    if (ret != True)
    {
        fprintf(stderr, "The NV-CONTROL X extension does not exist on '%s'.\n",
                XDisplayName(NULL));
        return 1;
    }

    printf("NV-CONTROL X extension present\n");
    printf("  version        : %d.%d\n", major, minor);

    return 0;
}
