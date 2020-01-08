/*
*
*
*/
[CCode (cheader_filename = "NVCtrlLib.h", cprefix = "XNVCTRL", gir_namespace = "XNVCTRL")]
namespace XNVCTRL {
    [CCode (cname = "XNVCTRLQueryExtension")]
    public static bool QueryExtension(X.Display dpy, out int event_basep, out int error_basep);

    [CCode (cname = "XNVCTRLQueryVersion")]
    public static bool QueryVersion (X.Display dpy, out int major, out int minor);

    [CCode (cheader_filename = "X11/Xlib.h", cname = "DefaultScreen")]
    public static int DefaultScreen (X.Display dpy);

    [CCode (cname = "XNVCTRLIsNvScreen")]
    public static bool IsNvScreen (X.Display dpy, int screen);

    [CCode (cname = "XNVCTRLQueryTargetCount")]
    public static bool QueryTargetCount (X.Display dpy, int target_type, out int value);

    [CCode (cname = "XNVCTRLQueryStringAttribute")]
    public static int QueryStringAttribute(X.Display dpy, int screen, uint32 display_mask, uint32 attribute, out string ptr);

    [CCode (cname = "XNVCTRLQueryTargetStringAttribute")]
    public static bool QueryTargetStringAttribute(X.Display dpy, int target_type, int target_id, uint32 display_mask, uint32 attribute, out string ptr);
}

[CCode (cname = "int", cprefix = "NV_CTRL_TARGET_TYPE_", has_type_id = false)]
public enum NvTargetType
{
    X_SCREEN,
    GPU,
    FRAMELOCK
}

[CCode (cname = "int", cprefix = "NV_CTRL_STRING_", has_type_id = false)]
public enum NvString
{
    GPU_UTILIZATION
}
