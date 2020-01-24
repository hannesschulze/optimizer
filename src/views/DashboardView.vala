/* DashboardView.vala
 *
 * Copyright 2019 Hannes Schulze
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Optimizer.Configs;
using Optimizer.Widgets;
using Optimizer.Utils;

namespace Optimizer.Views {

    /**
     * The {@code DashboardView} class.
     *
     * @since 1.0.0
     */
    public class DashboardView : Gtk.Grid {
        private CircularProgressBar  cpu_usage;
        private CircularProgressBar? gpu_usage;
        private CircularProgressBar  ram_usage;
        private CircularProgressBar  disk_usage;

        private Gtk.Grid             network_grid;
        private Gtk.ProgressBar      download_speed;
        private Gtk.ProgressBar      upload_speed;

        private SystemInfo           system_info;

        /**
         * Constructs a new {@code DashboardView} object.
         */
        public DashboardView () {
            column_spacing = 48;
            row_spacing = 36;
            margin_top = 24;
            margin_bottom = 24;
            valign = Gtk.Align.CENTER;
            column_homogeneous = true;

            var components_grid = new Gtk.Grid ();
            components_grid.column_spacing = 24;
            components_grid.row_spacing = 12;
            components_grid.row_homogeneous = true;
            components_grid.halign = Gtk.Align.CENTER;
            attach (components_grid, 0, 0, 3, 1);

            int component_grid_count = 0;
            cpu_usage = new CircularProgressBar ();
            cpu_usage.description = _("CPU").up ();
            cpu_usage.percentage = 0.0;
            cpu_usage.halign = Gtk.Align.END;
            cpu_usage.margin_start = 24;
            components_grid.attach (cpu_usage, component_grid_count++, 0, 1, 1);

            if (Resources.get_instance ().gpu != null) {
                gpu_usage = new CircularProgressBar ();
                gpu_usage.description = _("GPU").up ();
                gpu_usage.percentage = 0.0;
                components_grid.attach (gpu_usage, component_grid_count++, 0, 1, 1);
            }

            ram_usage = new CircularProgressBar ();
            ram_usage.description = _("RAM").up ();
            ram_usage.percentage = 0.0;
            components_grid.attach (ram_usage, component_grid_count++, 0, 1, 1);

            disk_usage = new CircularProgressBar ();
            disk_usage.description = _("Disk").up ();
            disk_usage.percentage = 0.0;
            disk_usage.halign = Gtk.Align.START;
            disk_usage.margin_end = 24;
            components_grid.attach (disk_usage, component_grid_count++, 0, 1, 1);

            network_grid = new Gtk.Grid ();
            network_grid.column_spacing = 24;
            network_grid.row_spacing = 12;
            network_grid.row_homogeneous = true;
            network_grid.halign = Gtk.Align.CENTER;
            attach (network_grid, 0, 1, 3, 1);

            var lbl_download_speed = new Gtk.Label ("<b>%s</b>".printf (_("Download:")));
            lbl_download_speed.use_markup = true;
            lbl_download_speed.halign = Gtk.Align.START;
            lbl_download_speed.valign = Gtk.Align.END;
            network_grid.attach (lbl_download_speed, 0, 0, 2, 1);

            download_speed = new Gtk.ProgressBar ();
            download_speed.text = "-";
            download_speed.show_text = true;
            download_speed.fraction = 0.0;
            download_speed.width_request = 200;
            network_grid.attach_next_to
                (download_speed, lbl_download_speed, Gtk.PositionType.RIGHT, 5, 1);

            var lbl_upload_speed = new Gtk.Label ("<b>%s</b>".printf (_("Upload:")));
            lbl_upload_speed.use_markup = true;
            lbl_upload_speed.halign = Gtk.Align.START;
            lbl_upload_speed.valign = Gtk.Align.END;
            network_grid.attach (lbl_upload_speed, 0, 1, 2, 1);

            upload_speed = new Gtk.ProgressBar ();
            upload_speed.text = "-";
            upload_speed.show_text = true;
            upload_speed.fraction = 0.0;
            upload_speed.width_request = 200;
            network_grid.attach_next_to
                (upload_speed, lbl_upload_speed, Gtk.PositionType.RIGHT, 5, 1);

            system_info = new SystemInfo ();
            attach (system_info, 0, 2, 3, 1);

            update_resources ();
            GLib.Timeout.add (1000, update_resources);
        }

        private bool update_resources () {
            var resources = Resources.get_instance ();

            // CPU usage
            cpu_usage.percentage = ((double) resources.get_cpu_usage ()) / 100;

            // GPU usage
            if (Resources.get_instance ().gpu != null) {
                string total_memory = "";
                string used_memory = "";
                double memory_usage = (double) resources.gpu.get_memory_usage
                    (out used_memory, out total_memory);
                gpu_usage.percentage = memory_usage / 100;
                gpu_usage.custom_progress_text = "%s / %s".printf (used_memory, total_memory);
            }

            // Memory usage
            string total_memory = "";
            string used_memory = "";
            double memory_usage = (double) resources.get_memory_usage
                (out used_memory, out total_memory);
            ram_usage.percentage = memory_usage / 100;
            ram_usage.custom_progress_text = "%s / %s".printf (used_memory, total_memory);

            // Disk usage
            string total_disk = "";
            string used_disk = "";
            double fs_usage = (double) resources.get_fs_usage
                (out used_disk, out total_disk);
            disk_usage.percentage = fs_usage / 100;
            disk_usage.custom_progress_text = "%s / %s".printf (used_disk, total_disk);

            // Download speed
            string download_speed_text = "";
            double download_speed_progress = (double) resources.get_network_down
                (out download_speed_text);
            download_speed.fraction = download_speed_progress / 100;
            download_speed.text = download_speed_text;

            // Upload speed
            string upload_speed_text = "";
            double upload_speed_progress = (double) resources.get_network_up
                (out upload_speed_text);
            upload_speed.fraction = upload_speed_progress / 100;
            upload_speed.text = upload_speed_text;

            return true;
        }
    }
}
