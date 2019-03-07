/* AppController.vala
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

using Optimizer.Widgets;
using Optimizer.Views;

namespace Optimizer.Controllers {

    /**
     * The {@code AppController} class.
     *
     * @since 1.0.0
     */
    public class AppController {

        private Gtk.Application            application;
        private AppView                    app_view;
        private HeaderBar                  headerbar;
        private Gtk.ApplicationWindow      window { get; private set; default = null; }

        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            this.application = application;
            this.window = new Window (this.application);
            this.headerbar = new HeaderBar (application);
            string[] mounts = get_mounts ();
            foreach (var mount in mounts) {
                this.headerbar.add_partition (mount);
            }
            this.app_view = new AppView ();
            this.headerbar.stack_switcher.stack = this.app_view;

            this.window.add (this.app_view);
            this.window.set_default_size (900, 540);
            this.window.set_size_request (900, 540);
            this.window.set_titlebar (this.headerbar);
            this.application.add_window (window);

            // Flip the sort indicator's direction
            Gtk.Settings.get_default ().set ("gtk-alternative_sort_arrows", true);
        }

        public void activate () {
            window.show_all ();
            app_view.activate ();
        }

        public void quit () {
            window.destroy ();
        }

        private string[] get_mounts () {
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
