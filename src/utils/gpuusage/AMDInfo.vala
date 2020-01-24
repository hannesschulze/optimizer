/* AMDInfo.vala
 *
 * Copyright 2020 Hannes Schulze
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
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Optimizer.Utils.GPUUsage {

    /**
     * The {@code AMDInfo} class is responsible for getting information about
     * AMD GPUs
     *
     * @since 2.0.0
     */
    public class AMDInfo : Object, GPUInfo {

        private Radeontop.Context? _context;
        private bool               _has_died;
        private string             _family;
        private short              _radeontop_bus;
        private uchar              _radeontop_forcemem;
        private uint               _radeontop_device_id;

        public bool is_available {
            public get { return !_has_died; }
        }

        public string formatted_details {
            owned get {
                string info = "%s bus %02x, %u samples/sec".printf
			        (_family, _radeontop_bus, 120);
                return "<b>%s:</b> %s".printf (_("GPU information"), info);
            }
        }
        public int get_memory_usage (out string used_memory_text, out string total_memory_text) {
            used_memory_text = total_memory_text = "n/a";

            unowned Radeontop.Bits? results = _context.results;

            if (results == null)
                return 0;

            float total_memory = (float) (_context.vramsize / 1024 / 1024);
            float used_memory = (float) (results.vram / 1024 / 1024);

            total_memory_text = GLib.format_size (_context.vramsize, FormatSizeFlags.IEC_UNITS);
            used_memory_text = GLib.format_size (results.vram, FormatSizeFlags.IEC_UNITS);

            return (int) (Math.round ((used_memory / total_memory) * 100));
        }

        public AMDInfo () {
            Posix.seteuid (Posix.getuid ());

            _has_died = false;
            _family = "n/a";

            _radeontop_bus = -1;
            _radeontop_forcemem = 0;
            _radeontop_device_id = 0;

            // Try initializing radeontop
            _context = new Radeontop.Context ((why) => {
                _has_died = true;
                print ("Radeontop died: %s\n", why);
            });

            Posix.seteuid (0);
            _context.init_pci (null, ref _radeontop_bus, ref _radeontop_device_id, _radeontop_forcemem);
            Posix.seteuid (Posix.getuid ());
            if (_has_died) return;

            // Get device family
            int family = _context.get_family (_radeontop_device_id);
            if (family == 0) {
                _has_died = true;
                return;
            }
            _family = Radeontop.Radeon.family_str[family];
            if (_has_died) return;

            // Start collecting data
            _context.collect (120, 1);
        }
    }

}
