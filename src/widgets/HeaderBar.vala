/* HeaderBar.vala
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
     * The {@code HeaderBar} class is responsible for displaying top bar. Similar to a horizontal box.
     *
     * @see Gtk.HeaderBar
     * @since 1.0.0
     */
    public class HeaderBar : Gtk.HeaderBar {

        public signal void menu_clicked ();

        public Gtk.MenuButton menu_button { get; private set; }

        /**
         * Constructs a new {@code HeaderBar} object.
         *
         * @see App.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar () {
            menu_button = new Gtk.MenuButton ();
            menu_button.image = new Gtk.Image .from_icon_name ("open-menu-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            menu_button.tooltip_text = _("Settings");
            menu_button.clicked.connect (() => {
                menu_clicked ();
            });

            this.title = "Optimizer";
            this.show_close_button = true;
            this.pack_end (menu_button);
        }
    }
}