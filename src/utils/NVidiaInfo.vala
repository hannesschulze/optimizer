namespace Optimizer.Utils {
    /**
     * The {@code NVidiaManager} class is responsible for getting information about
     * NVidia GPU info
     *
     * @since 1.0.0
     */
    public class NVidiaInfo {
        public static NVidiaInfo? instance;

        private X.Display dpy;

        public bool IsNvScreen { get; private set; }

        private int _default_screen;

        private int _number_of_gpus = -1;
        public int number_of_gpus { get { return _number_of_gpus; } }

        public int get_gpu_usage ()
        {
            string usage;
            bool ret = XNVCTRL.QueryTargetStringAttribute (dpy, NvTargetType.GPU, 0, 0, NvString.GPU_UTILIZATION, out usage);
            if (!ret)
                return 0;

            int graphics, memory, video, pcie;
            usage.scanf("graphics=%d, memory=%d, video=%d, PCIe=%d",
                out graphics, out memory, out video, out pcie);

            return graphics;
        }

        private NVidiaInfo () {
            dpy = new X.Display(null);

            _default_screen = XNVCTRL.DefaultScreen(dpy);
            IsNvScreen = XNVCTRL.IsNvScreen(dpy, _default_screen);

            bool ret;
            ret = XNVCTRL.QueryTargetCount(dpy, NvTargetType.GPU, out _number_of_gpus);
        }

        public static unowned NVidiaInfo get_instance () {
            if (instance == null) {
                instance = new NVidiaInfo ();
            }

            return instance;
        }
    }


}
