
using Optimizer.Configs;
using Optimizer.Widgets;
using Optimizer.Utils;

namespace Optimizer.Views {

    /**
     * The {@code NVidiaView} class.
     *
     * @since 1.0.0
     */
    public class NVidiaView : Gtk.Grid {

        NVidiaInfo nvidia_info;

        public NVidiaView () {
            nvidia_info = NVidiaInfo.get_instance ();

            column_spacing = 48;
            row_spacing = 36;
            margin_top = 24;
            margin_bottom = 24;
            valign = Gtk.Align.CENTER;
            column_homogeneous = true;

            var label = new Gtk.Label("");
            label.use_markup = true;
            label.justify = Gtk.Justification.CENTER;
            label.label += "NV-CONTROL X extension present\n";
            label.label += "<b>Number of GPUs:</b> %d\n".printf(nvidia_info.number_of_gpus);

            attach (label, 0, 2, 3, 1);
        }
    }
}
