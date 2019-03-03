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

        public Gtk.StackSwitcher stack_switcher { get; set; }
        public Gtk.MenuButton    menu_button { get; set; }
        public Gtk.Popover       menu { get; set; }
        public GLib.Menu         partition_menu;

        /**
         * Constructs a new {@code HeaderBar} object.
         *
         * @see App.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar (Gtk.Application app) {
            SimpleAction partition_action = new SimpleAction.stateful ("partition-action",
                new GLib.VariantType ("s"),
                new Variant.string ("/"));
            partition_action.activate.connect ((parameter) => {
                partition_action.set_state (parameter);
            });
            app.add_action (partition_action);

            stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.homogeneous = true;

            this.show_close_button = true;
            this.custom_title = stack_switcher;

            menu_button = new Gtk.MenuButton ();
            menu_button.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);

            var main_menu = new GLib.Menu ();
            partition_menu = new GLib.Menu ();
            main_menu.append_submenu (_("Monitored partition"), partition_menu);
            main_menu.append (_("Quit"), "app.quit");

            menu = new Gtk.Popover.from_model (null, main_menu);
            menu_button.popover = menu;
            pack_end (menu_button);
        }

        public void add_partition (string partition_path) {
            var menu_item = new GLib.MenuItem (partition_path, "app.partition-action");
            menu_item.set_attribute_value ("target", new Variant.string (partition_path));
            partition_menu.append_item (menu_item);
        }
    }
}
