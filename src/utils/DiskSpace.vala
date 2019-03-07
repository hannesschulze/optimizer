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

        //public static string[] get_formatted_file_list (string path) {
//
        //}

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

        public static void print_file_list (FileSpaceInfo?[] list) {
            uint64 total_size = 0;
            foreach (var item in list) {
                if (item != null) {
                    print ("%s: %s\n", item.full_path, GLib.format_size (item.file_size));
                    total_size += item.file_size;
                }
            }

            print ("Total file size: %s\n", GLib.format_size (total_size));
        }

        public static Gee.ArrayList<FileSpaceInfo?> get_file_list (string path, string extension) {
            Gee.ArrayList<FileSpaceInfo?> file_list = new Gee.ArrayList<FileSpaceInfo?> ();

            var file = File.new_for_path (path);

            FileEnumerator enumerator = null;
            try {
                enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            } catch (IOError e) {
                stderr.printf ("Couldn't read contents of directory - ignoring it\n");
                return file_list;
            }
            FileInfo file_info;

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
    }
}
