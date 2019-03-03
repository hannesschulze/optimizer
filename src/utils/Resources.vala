/* Resources.vala
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

namespace Optimizer.Utils {

    /**
     * The {@code Resources} class is responsible for getting information about
     * system resources
     *
     * @since 1.0.0
     */
    public class Resources {

        /**
         * This static property represents the {@code Resources} type.
         */
        private static Resources? instance;

        private uint64 last_network_down;
        private uint64 last_network_up;

        private uint64 max_network_down;
        private uint64 max_network_up;

        private float last_used_cpu;
        private float last_total_cpu;

        public string mount_path { get; set; }

        public int get_memory_usage (out string used_memory_text,
                                     out string total_memory_text) {
            float total_memory;
            float used_memory;

            GTop.Memory memory;
    		GTop.get_mem (out memory);

    		total_memory = (float) (memory.total / 1024 / 1024) / 1000;
            used_memory = (float) (memory.user / 1024 / 1024) / 1000;

            total_memory_text = GLib.format_size (memory.total, FormatSizeFlags.IEC_UNITS);
            used_memory_text = GLib.format_size (memory.user, FormatSizeFlags.IEC_UNITS);

            return (int) (Math.round ((used_memory / total_memory) * 100));
        }

        public int get_cpu_usage () {
			GTop.Cpu cpu;
            GTop.get_cpu (out cpu);

			var used = (float) (cpu.user + cpu.sys + cpu.nice + cpu.irq + cpu.softirq);
			var idle = (float) (cpu.idle + cpu.iowait);
            var total = used + idle;

            var diff_used = used - last_used_cpu;
            var diff_total = total - last_total_cpu;

            var load = diff_used.abs () / diff_total.abs ();

            last_used_cpu = used;
            last_total_cpu = total;

            return (int) (Math.round (load * 100));
        }

        public int get_fs_usage (out string used_disk_space,
                                 out string total_disk_space) {
            var root_mount = GLib.File.new_for_path (mount_path);
            try {
                var info = root_mount.query_filesystem_info (GLib.FileAttribute.FILESYSTEM_SIZE, null);
                uint64 total_attr = info.get_attribute_uint64 (GLib.FileAttribute.FILESYSTEM_SIZE);
                float total = (float) (total_attr / 1024 / 1024) / 1000;
                total_disk_space = GLib.format_size (total_attr, FormatSizeFlags.IEC_UNITS);

                info = root_mount.query_filesystem_info (GLib.FileAttribute.FILESYSTEM_USED, null);
                uint64 used_attr = info.get_attribute_uint64 (GLib.FileAttribute.FILESYSTEM_USED);
                float used = (float) (used_attr / 1024 / 1024) / 1000;
                used_disk_space = GLib.format_size (used_attr, FormatSizeFlags.IEC_UNITS);

                return (int) (Math.round ((used / total) * 100));
            } catch (Error e) {
                total_disk_space = "n/a";
                used_disk_space = "n/a";
                warning (e.message);
                return 0;
            }
        }

        public int get_network_down (out string network_down_text) {
            uint64 network_down = 0;
            try {
                Dir dir = Dir.open ("/sys/class/net", 0);
                string? element = null;

                while ((element = dir.read_name ()) != null) {
                    string path = Path.build_filename ("/sys/class/net", element);
                    if (FileUtils.test (path, FileTest.IS_DIR)) {
                        GTop.NetLoad netload;
                        GTop.get_netload (out netload, element);
                        network_down += netload.bytes_in;
                    }
                }
            } catch (FileError err) {
                stderr.printf (err.message);
            }

            if (last_network_down != 0) {
                network_down_text = GLib.format_size (network_down - last_network_down, FormatSizeFlags.IEC_UNITS) + "/s";

                if (network_down - last_network_down > max_network_down) {
                    max_network_down = network_down - last_network_down;
                }

                float max_size = (float) (max_network_down / 1024);
                float current_size = (float) ((network_down - last_network_down) / 1024);
                int fraction = (int) (Math.round ((current_size / max_size) * 100));

                last_network_down = network_down;

                return fraction;
            } else {
                last_network_down = network_down;
                network_down_text = "n/a";
                return 0;
            }
        }

        public int get_network_up (out string network_up_text) {
            uint64 network_up = 0;
            try {
                Dir dir = Dir.open ("/sys/class/net", 0);
                string? element = null;

                while ((element = dir.read_name ()) != null) {
                    string path = Path.build_filename ("/sys/class/net", element);
                    if (FileUtils.test (path, FileTest.IS_DIR)) {
                        GTop.NetLoad netload;
                        GTop.get_netload (out netload, element);
                        network_up += netload.bytes_out;
                    }
                }
            } catch (FileError err) {
                stderr.printf (err.message);
            }

            if (last_network_up != 0) {
                network_up_text = GLib.format_size (network_up - last_network_up, FormatSizeFlags.IEC_UNITS) + "/s";

                if (network_up - last_network_up > max_network_up) {
                    max_network_up = network_up - last_network_up;
                }

                float max_size = (float) (max_network_up / 1024);
                float current_size = (float) ((network_up - last_network_up) / 1024);
                int fraction = (int) (Math.round ((current_size / max_size) * 100));

                last_network_up = network_up;

                return fraction;
            } else {
                last_network_up = network_up;
                network_up_text = "n/a";
                return 0;
            }
        }

        /**
         * Constructs a new {@code Resources} object
         */
        private Resources () {
            last_network_down = 0;
            last_network_up = 0;
            last_used_cpu = 0;
            last_total_cpu = 0;
            max_network_down = 0;
            max_network_up = 0;
            mount_path = Configs.Settings.get_instance ().monitored_partition;
        }

        /**
         * Returns a single instance of this class.
         *
         * @return {@code Resources}
         */
        public static unowned Resources get_instance () {
            if (instance == null) {
                instance = new Resources ();
            }

            return instance;
        }
    }
}
