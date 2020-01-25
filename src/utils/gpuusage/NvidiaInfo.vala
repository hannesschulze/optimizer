/* NvidiaInfo.vala
 *
 * Copyright 2020 Matheus Maldi
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
     * The {@code NvidiaInfo} class is responsible for getting information about
     * NVidia GPUs
     *
     * @since 2.0.0
     */
    public class NvidiaInfo : Object, GPUInfo {

        private X.Display _dpy;
        private bool      _is_nvidia_screen;
        private int       _default_screen;
        private int       _number_of_gpus = -1;

        public bool is_available {
            public get { return _is_nvidia_screen; }
        }
        public string formatted_details {
            owned get {
                return "<b>%s:</b> %d".printf (_("GPU count"), _number_of_gpus);
            }
        }
        public int usage {
            public get {
                string usage;
                bool ret = XNVCTRL.QueryTargetStringAttribute (_dpy, NvTargetType.GPU, 0, 0, NvString.GPU_UTILIZATION, out usage);
                if (!ret)
                    return 0;

                int graphics, memory, video, pcie;
                usage.scanf ("graphics=%d, memory=%d, video=%d, PCIe=%d", out graphics, out memory, out video, out pcie);

                return graphics;
            }
        }

        public NvidiaInfo () {
            _dpy = new X.Display(null);

            _default_screen = XNVCTRL.DefaultScreen(_dpy);
            _is_nvidia_screen = XNVCTRL.IsNvScreen(_dpy, _default_screen);

            XNVCTRL.QueryTargetCount(_dpy, NvTargetType.GPU, out _number_of_gpus);
        }
    }

}
