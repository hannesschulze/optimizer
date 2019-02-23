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
        private CircularProgressBar cpu_usage;
        private CircularProgressBar ram_usage;
        private CircularProgressBar disk_usage;

        private Gtk.Grid            network_grid;
        private Gtk.ProgressBar     download_speed;
        private Gtk.ProgressBar     upload_speed;

        private SystemInfo          system_info;

        /**
         * Constructs a new {@code DashboardView} object.
         */
        public DashboardView () {
            column_spacing = 24;
            row_spacing = 36;
            valign = Gtk.Align.CENTER;
            column_homogeneous = true;

            cpu_usage = new CircularProgressBar ();
            cpu_usage.description = "CPU";
            cpu_usage.percentage = 0.0;
            cpu_usage.halign = Gtk.Align.END;
            cpu_usage.margin_start = 24;
            attach (cpu_usage, 0, 0, 1, 1);

            ram_usage = new CircularProgressBar ();
            ram_usage.description = "RAM";
            ram_usage.percentage = 0.0;
            attach (ram_usage, 1, 0, 1, 1);

            disk_usage = new CircularProgressBar ();
            disk_usage.description = "DISK";
            disk_usage.percentage = 0.0;
            disk_usage.halign = Gtk.Align.START;
            disk_usage.margin_end = 24;
            attach (disk_usage, 2, 0, 1, 1);

            network_grid = new Gtk.Grid ();
            network_grid.column_homogeneous = true;
            network_grid.column_spacing = 24;
            network_grid.row_spacing = 12;
            network_grid.row_homogeneous = true;
            attach (network_grid, 1, 1, 1, 1);

            var lbl_download_speed = new Gtk.Label ("<b>%s</b>".printf (_("Download:")));
            lbl_download_speed.use_markup = true;
            lbl_download_speed.halign = Gtk.Align.START;
            lbl_download_speed.valign = Gtk.Align.END;
            network_grid.attach (lbl_download_speed, 0, 0, 2, 1);

            download_speed = new Gtk.ProgressBar ();
            download_speed.text = "-";
            download_speed.show_text = true;
            download_speed.fraction = 0.0;
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
            network_grid.attach_next_to
                (upload_speed, lbl_upload_speed, Gtk.PositionType.RIGHT, 5, 1);

            system_info = new SystemInfo ();
            attach (system_info, 1, 2, 1, 1);

            update_resources ();
            GLib.Timeout.add (1000, update_resources);
        }

        private bool update_resources () {
            var resources = Resources.get_instance ();

            // CPU usage
            cpu_usage.percentage = ((double) resources.get_cpu_usage ()) / 100;

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

            // TODO: Update network progress
            upload_speed.text = resources.get_network_up ();

            return true;
        }
    }
}