/* DiskSpace.vala
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
     * The {@code DiskSpace} class provides tools for managing disk space.
     *
     * @since 1.0.0
     */
    public class DiskSpace {
        public struct FileSpaceInfo {
            public string file_name;
            public string full_path;
            public uint64 file_size;
        }

        public struct FormattedList {
            public string heading;
            public string file_list;
            public uint64 folder_size;
        }

        public static async FormattedList[] get_formatted_file_list (Gee.HashMap<string, string> selected_folders) {
            SourceFunc callback = get_formatted_file_list.callback;
            FormattedList[] output = {};

            ThreadFunc<bool> run = () => {
                FormattedList[] result = {};

                foreach (var folder in selected_folders.entries) {
                    string file_list = "";

                    var list = get_file_list (folder.key, folder.value);
                    uint64 current_size = format_file_list
                        (list.to_array (), out file_list);

                    var item = FormattedList ();
                    item.heading = "%s (%s)".printf(folder.key,
                        GLib.format_size (current_size, FormatSizeFlags.IEC_UNITS));
                    item.file_list = file_list;
                    item.folder_size = current_size;
                    result += item;
                }

                output = result;
                Idle.add ((owned) callback);
                return true;
            };
            new Thread<bool> ("calculating-thread", run);

            yield;
            return output;
        }

        public static uint64 format_file_list (FileSpaceInfo?[] list, out string formatted_list) {
            uint64 total_size = 0;
            formatted_list = "";
            foreach (var item in list) {
                if (item != null) {
                    total_size += item.file_size;
                    formatted_list += item.full_path + ": " + GLib.format_size (item.file_size) + "\n";
                }
            }

            return total_size;
        }

        public static Gee.ArrayList<FileSpaceInfo?> get_file_list (string path, string extension) {
            Gee.ArrayList<FileSpaceInfo?> file_list = new Gee.ArrayList<FileSpaceInfo?> ();

            var file = File.new_for_path (path);

            FileEnumerator enumerator = null;
            try {
                enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            } catch (GLib.Error e) {
                stderr.printf ("WARNING: Couldn't read contents of directory - ignoring it\n");
                return file_list;
            }
            FileInfo file_info;

            try {
                while ((file_info = enumerator.next_file ()) != null) {
                    uint64 file_size;
                    var file_path = Path.build_filename (path, file_info.get_name ());
                    var item = File.new_for_path (file_path);

                    if (item.query_file_type (0) == FileType.DIRECTORY) {
                        if (extension == "") {
                            file_list.add_all (get_file_list (file_path, extension));
                        }
                    } else {
                        if (check_file (file_path, extension, out file_size)) {
                            FileSpaceInfo info = FileSpaceInfo ();
                            info.file_name = file_info.get_name ();
                            info.full_path = file_path;
                            info.file_size = file_size;
                            file_list.add (info);
                        }
                    }
                }
            } catch (GLib.Error e) {
                stderr.printf ("WARNING: Couldn't get next file from the directory - ignoring it\n");
                return file_list;
            }

            return file_list;
        }

        public static bool check_file (string file_name, string extension, out uint64 file_size) {
            file_size = 0;

            if (extension != "") {
                var file_parts = file_name.split (".");
                var file_extension = file_parts [file_parts.length - 1];

                if (file_extension.up () != extension.up ()) {
                    return false;
                }
            }

            var file = File.new_for_path (file_name);

            try {
                var file_info = file.query_info ("standard::size", FileQueryInfoFlags.NONE);

                file_size = file_info.get_size ();
            } catch (Error err) {
                stderr.printf ("Error: %s\n", err.message);
                return false;
            }

            return true;
        }

        public static string[] get_mounts () {
            // We only want to show partitions mounted on every boot, so
            // we will simply parse the /etc/fstab file
            var fstab_file = File.new_for_path ("/etc/fstab");
            if (!fstab_file.query_exists ()) {
                stderr.printf ("/etc/fstab doesn't exist (how did you do that?)\n");
                return { "/" };
            }

            string[] mounts = { };

            try {
                var data_input_stream = new DataInputStream (fstab_file.read ());
                string line;

                // Go through the lines
                while ((line = data_input_stream.read_line (null)) != null) {
                    // Skip comments
                    if (line.@get (0) == '#') {
                        continue;
                    }

                    // Trim spaces and create an array
                    string[] values = { };
                    StringBuilder current_value = new StringBuilder ();
                    foreach (var current_char in line.data) {
                        if (current_char == ' ') {
                            if (current_value.str != "") {
                                values += current_value.str;
                            }
                            current_value = new StringBuilder ();
                        } else {
                            current_value.append_unichar (current_char);
                        }
                    }
                    if (current_value.str != "") {
                        values += current_value.str;
                    }

                    // Check if this is a valid entry
                    if (values.length > 3) {
                        // The path isn't allowed to be none (e.g. swap)
                        if (values[1] == "none") {
                            continue;
                        }

                        // The path has to start with '/'
                        if (values[1].@get (0) != '/') {
                            continue;
                        }

                        // Check if the path exists
                        var mount_file = File.new_for_path (values[1]);
                        if (!mount_file.query_exists ()) {
                            stderr.printf ("%s doesn't exist, ignoring it\n", values[1]);
                            continue;
                        }

                        // Add this path to the array
                        mounts += values[1];
                    }
                }
            } catch (Error err) {
                stderr.printf ("%s\n", err.message);
                return { "/" };
            }

            return mounts;
        }
    }
}
