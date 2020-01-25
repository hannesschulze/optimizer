/* libradeontop.vapi - radeontop vala bindings
 *
 * Copyright 2020 Hannes Schulze <unknown@domain.org>
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

[CCode (cheader_filename = "radeontop.h")]
namespace Radeontop {

    // -- structs --

    [CCode (cname = "radeontop_bits")]
    public struct Bits {
	    public uint ee;
	    public uint vgt;
	    public uint gui;
	    public uint ta;
	    public uint tc;
	    public uint sx;
	    public uint sh;
	    public uint spi;
	    public uint smx;
	    public uint sc;
	    public uint pa;
	    public uint db;
	    public uint cb;
	    public uint cr;
	    public uint64 vram;
	    public uint64 gtt;
	    public uint sclk;
	    public uint mclk;
    }

    // -- delegates --

    [CCode (cname = "radeontop_getgrbm_func", has_target = false)]
    public delegate int GetGrbmFunc (ref uint32 out);
    [CCode (cname = "radeontop_getvram_func", has_target = false)]
    public delegate int GetVramFunc (ref uint64 out);
    [CCode (cname = "radeontop_getgtt_func", has_target = false)]
    public delegate int GetGttFunc (ref uint64 out);
    [CCode (cname = "radeontop_getsclk_func", has_target = false)]
    public delegate int GetSclkFunc (ref uint32 out);
    [CCode (cname = "radeontop_getmclk_func", has_target = false)]
    public delegate int GetMclkFunc (ref uint32 out);

    [CCode (cname = "radeontop_die_func", has_target = true)]
    public delegate void DieFunc (string why);

    // -- main context --

    [CCode (cname = "radeontop_context", free_function = "radeontop_cleanup", has_type_id = false)]
    [Compact]
    public class Context {
        // public members
        public Bits? bits;
        public uint64 vramsize;
        public uint64 gttsize;
        public uint sclk_max; // kilohertz
        public uint mclk_max; // kilohertz
        public GetGrbmFunc getgrbm;
        public GetVramFunc getvram;
        public GetGttFunc getgtt;
        public GetSclkFunc getsclk;
        public GetMclkFunc getmclk;

        // constructor
        [CCode (cname = "radeontop_context_init")]
        public Context (DieFunc on_die);

        // general functions
        public unowned Bits? results { get; }

        [CCode (cname = "radeontop_version")]
        public static unowned string version ();

        // detect
        [CCode (cname = "radeontop_init_pci")]
        public void init_pci (string? path, ref short bus, ref uint device_id, uchar forcemem);
        [CCode (cname = "radeontop_get_family")]
        public int get_family (uint id);

        // ticks
        [CCode (cname = "radeontop_collect")]
        public void collect (uint ticks, uint dumpinterval);

        // ui
        [CCode (cname = "radeontop_present")]
        public void present (uint ticks, string card, uint color, short bus, uint dumpinterval);

        // dump
        [CCode (cname = "radeontop_dumpdata")]
        public void dumpdata (uint ticks, string file, uint limit, short bus, uint dumpinterval);

        // radeon
        [CCode (cname = "radeontop_init_radeon")]
        public void init_radeon (int fd, int drm_major, int drm_minor);

        // amdgpu
        [CCode (cname = "radeontop_init_amdgpu")]
        public void init_amdgpu (int fd);
        [CCode (cname = "radeontop_cleanup_amdgpu")]
        public static void cleanup_amdgpu();
    }

    [CCode (cname = "radeontop_authenticate_drm")]
    public static void authenticate_drm (int fd);

    namespace Radeon {
        [CCode (cname = "radeontop_radeon_family", cprefix = "", has_type_id = false)]
        public enum Family {
            UNKNOWN_CHIP,
            R600,
            RV610,
            RV630,
            RV670,
            RV620,
            RV635,
            RS780,
            RS880,
            RV770,
            RV730,
            RV710,
            RV740,
            CEDAR,
            REDWOOD,
            JUNIPER,
            CYPRESS,
            HEMLOCK,
            PALM,
            SUMO,
            SUMO2,
            BARTS,
            TURKS,
            CAICOS,
            CAYMAN,
            ARUBA,
            TAHITI,
            PITCAIRN,
            VERDE,
            OLAND,
            HAINAN,
            BONAIRE,
            KABINI,
            MULLINS,
            KAVERI,
            HAWAII,
            TOPAZ,
            TONGA,
            FIJI,
            CARRIZO,
            STONEY,
            POLARIS11,
            POLARIS10,
            POLARIS12,
            VEGAM,
            VEGA10,
            VEGA12,
            VEGA20,
            RAVEN,
            ARCTURUS,
            NAVI10,
            NAVI14,
            RENOIR,
            NAVI12
        }

        [CCode (cname = "radeontop_family_str", array_length = false)]
        const string family_str[];
    }

}
