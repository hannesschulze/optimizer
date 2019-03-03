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
            this.headerbar.add_partition ("/");
            this.headerbar.add_partition ("/home");
            this.headerbar.add_partition ("/media/test");
            this.app_view = new AppView ();
            this.headerbar.stack_switcher.stack = this.app_view;

            this.window.add (this.app_view);
            this.window.set_default_size (800, 540);
            this.window.set_size_request (800, 540);
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
    }
}
