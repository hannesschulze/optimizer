/* Process.vala
 *
 * Copyright 2019 Hannes Schulze
 *
 * Simplified version of Process.vala by stsdc published under
 * the GPL-3.0 license:
 * https://github.com/stsdc/monitor/blob/master/src/Managers/Process.vala
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
     * The {@code Process} class represents one process
     *
     * @since 1.0.0
     */
    public class Process {
        // Whether or not the PID leads to something
        public bool exists { get; private set; }

        // Process ID
        public int pid { get; private set; }

        // Process Group ID; 0 if a kernal process/thread
        public int pgrp { get; private set; }

        // Full command from cmdline file
        public string command { get; private set; }

        // The owner of this process
        public string user { get; private set; }

        /**
         * CPU usage of this process from the last time that it was updated, measured in percent
         *
         * Will be 0 on first update.
         */
        public double cpu_usage { get; private set; }

        private uint64 cpu_last_used;

        // Memory usage of the process

        public uint64 mem_usage { get; private set; }

        private uint64 last_total;


        // Construct a new process
        public Process (int _pid) {
            pid = _pid;
            last_total = 0;

            exists = read_stat (0, 1) && read_cmdline ();
        }

        // Updates the process to get latest information
        // Returns if the update was successful
        public bool update (uint64 cpu_total, uint64 cpu_last_total) {
            exists = read_stat (cpu_total, cpu_last_total);

            return exists;
        }

        // Kills the process
        // Returns if kill was successful
        public bool kill () {
            if (Posix.kill (pid, Posix.Signal.INT) == 0) {
                return true;
            }
            return false;
        }

        // Reads the /proc/%pid%/stat file and updates the process with the information therein.
        private bool read_stat (uint64 cpu_total, uint64 cpu_last_total) {
            /* grab the stat file from /proc/%pid%/stat */
            var stat_file = File.new_for_path ("/proc/%d/stat".printf (pid));

            /* make sure that it exists, not an error if it doesn't */
            if (!stat_file.query_exists ()) {
                return false;
            }

            try {
                // read the single line from the file
                var dis = new DataInputStream (stat_file.read ());
                string? stat_contents = dis.read_line ();

                if (stat_contents == null) {
                    stderr.printf ("Error reading stat file '%s': couldn't read_line ()\n", stat_file.get_path ());
                    return false;
                }

                // Get process UID
                GTop.ProcUid uid;
                GTop.get_proc_uid (out uid, pid);
                pgrp = uid.pgrp; // process group id

                // Get CPU usage by process
                GTop.ProcTime proc_time;
                GTop.get_proc_time (out proc_time, pid);
                cpu_usage = ((double)(proc_time.rtime - cpu_last_used)) / (cpu_total - cpu_last_total);
                cpu_last_used = proc_time.rtime;

                // Get memory usage by process
                GTop.ProcMem proc_mem;
                GTop.get_proc_mem (out proc_mem, pid);
                mem_usage = proc_mem.resident - proc_mem.share;

                Wnck.ResourceUsage resu = Wnck.ResourceUsage.pid_read (Gdk.Display.get_default(), pid);
                mem_usage += resu.total_bytes_estimate;

                // TODO: Show processes from other owners
                user = Posix.getlogin ();
            } catch (Error e) {
                warning ("Can't read process stat: '%s'", e.message);
                return false;
            }

            return true;
        }

        /**
         * Reads the /proc/%pid%/cmdline file and updates from the information contained therein.
         */
        private bool read_cmdline () {
            // grab the cmdline file from /proc/%pid%/cmdline
            var cmdline_file = File.new_for_path ("/proc/%d/cmdline".printf (pid));

            // make sure that it exists
            if (!cmdline_file.query_exists ()) {
                warning ("File '%s' doesn't exist.\n", cmdline_file.get_path ());
                return false;
            }
            try {
                // read the single line from the file
                var dis = new DataInputStream (cmdline_file.read ());
                uint8[] cmdline_contents_array = new uint8[4097]; // 4096 is max size with a null terminator
                var size = dis.read (cmdline_contents_array);

                if (size <= 0) {
                    // was empty, not an error
                    return true;
                }

                // cmdline is a single line file with each arg seperated by a null character ('\0')
                // convert all \0 and \n to spaces
                for (int pos = 0; pos < size; pos++) {
                    if (cmdline_contents_array[pos] == '\0' || cmdline_contents_array[pos] == '\n') {
                        cmdline_contents_array[pos] = ' ';
                    }
                }
                cmdline_contents_array[size] = '\0';
                string cmdline_contents = (string) cmdline_contents_array;

                //TODO: need to make sure that this works
                GTop.ProcState proc_state;
                GTop.get_proc_state (out proc_state, pid);

                command = cmdline_contents;
            }
            catch (Error e) {
                stderr.printf ("Error reading cmdline file '%s': %s\n", cmdline_file.get_path (), e.message);
                return false;
            }

            return true;
        }
    }
}
