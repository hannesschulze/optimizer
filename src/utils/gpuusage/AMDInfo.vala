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

        //private Radeontop.Context _context;
        private bool              _has_died;
        private string            _family;

        public bool is_available {
            public get { return !_has_died; }
        }

        public string formatted_details {
            owned get {
                return "<b>%s:</b> %s".printf (_("GPU information"), _family);
            }
        }
        public int get_memory_usage (out string used_memory_text, out string total_memory_text) {
            used_memory_text = total_memory_text = "n/a";

            /*string usage;
            bool ret = XNVCTRL.QueryTargetStringAttribute (_dpy, NvTargetType.GPU, 0, 0, NvString.GPU_UTILIZATION, out usage);
            if (!ret)
                return 0;

            int graphics, memory, video, pcie;
            usage.scanf ("graphics=%d, memory=%d, video=%d, PCIe=%d", out graphics, out memory, out video, out pcie);

            total_memory_text = GLib.format_size (memory, FormatSizeFlags.IEC_UNITS);
            used_memory_text = GLib.format_size (memory, FormatSizeFlags.IEC_UNITS);*/

            return 100;
        }

        public AMDInfo () {
            _has_died = false;
            _family = "n/a";
        }
    }

}
