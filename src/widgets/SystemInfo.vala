/* SystemInfo.vala
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

namespace Optimizer.Widgets {

    /**
     * The {@code SystemInfo} class is listing system information
     *
     * @since 1.0.0
     */
    public class SystemInfo : Gtk.Label {
        /**
         * Constructs a new {@code Label} object.
         */
        public SystemInfo () {
            Object (
                label: ""
            );

            this.use_markup = true;
            this.justify = Gtk.Justification.CENTER;

            // Hostname
            this.label += "<b>%s</b> %s\n".printf
                (_("Hostname:"), Environment.get_host_name ());

            // Distro
            var file = File.new_for_path ("/etc/os-release");
            try {
                var osrel = new Gee.HashMap<string, string> ();
                var dis = new DataInputStream (file.read ());
                string line;
                // Read lines until end of file (null) is reached
                while ((line = dis.read_line (null)) != null) {
                    var osrel_component = line.split ("=", 2);
                    if (osrel_component.length == 2) {
                        osrel[osrel_component[0]] = osrel_component[1].replace ("\"", "");
                    }
                }

                var os = osrel["PRETTY_NAME"];
                this.label += "<b>%s</b> %s\n".printf
                    (_("Distribution:"), os);
            } catch (Error e) {
                warning ("Couldn't read os-release file");
            }

            // Architecture
            var arch = "";
            var uts_name = Posix.utsname ();
            switch (uts_name.machine) {
                case "x86_64":
                    arch = "64-bit";
                    break;
                case "arm":
                    arch = "ARM";
                    break;
                default:
                    arch = "32-bit";
                    break;
            }
            this.label += "<b>%s</b> %s\n".printf
                (_("Architecture:"), arch);

            // Kernel
            var kernel = "%s %s".printf (uts_name.sysname, uts_name.release);
            this.label += "<b>%s</b> %s\n".printf
                (_("Kernel:"), kernel);

            // Processor
            this.label += "<b>%s</b> %s\n".printf
                (_("CPU Model:"), get_cpu ());

            // Cores
            this.label += "<b>%s</b> %s".printf
                (_("CPU Cores:"), get_cores ());

            if (Utils.Resources.get_instance ().gpu != null)
                this.label += "\n" + Utils.Resources.get_instance ().gpu.formatted_details;
        }

        private string get_cpu () {
            var cpu_file = File.new_for_path ("/proc/cpuinfo");
            string processor = null;
            try {
                var dis = new DataInputStream (cpu_file.read ());
                string line;
                while ((line = dis.read_line ()) != null) {
                    if (line.has_prefix ("model name")) {
                        if (processor == null) {
                            var parts = line.split (":", 2);
                            if (parts.length > 1) {
                                processor = parts[1].strip ();
                            }
                        }
                    }
                }
            } catch (Error e) {
                warning (e.message);
            }

            if (processor == null) {
                processor = _("Unknown");
            } else {
                if ("(R)" in processor) {
                    processor = processor.replace ("(R)", "®");
                }

                if ("(TM)" in processor) {
                    processor = processor.replace ("(TM)", "™");
                }
            }

            return processor;
        }

        private string get_cores () {
            var cpu_file = File.new_for_path ("/proc/cpuinfo");
            string cpu_cores = _("Single-Core");
            uint cores = 0U;
            bool cores_found = false;
            try {
                var dis = new DataInputStream (cpu_file.read ());
                string line;
                while ((line = dis.read_line ()) != null) {
                    if (line.has_prefix ("cpu cores")) {
                        var core_count = line.split (":", 2);
                        if (core_count.length > 1) {
                            cores = int.parse (core_count[1]);
                            if (cores != 0) {
                                cores_found = true;
                            }
                        }
                    }

                    if (line.has_prefix ("model name")) {
                        if (!cores_found) {
                            cores++;
                        }
                    }
                }
            } catch (Error e) {
                warning (e.message);
            }

            if (cores > 1) {
                if (cores == 2) {
                    cpu_cores = _("Dual-Core");
                } else if (cores == 4) {
                    cpu_cores = _("Quad-Core");
                } else {
                    cpu_cores = cores.to_string () + " " + _("Cores");
                }
            }

            return cpu_cores;
        }
    }
}
