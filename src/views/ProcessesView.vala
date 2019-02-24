/* ProcessesView.vala
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
using Optimizer.Widgets;

namespace Optimizer.Views {

    /**
     * The {@code ProcessesView} class.
     *
     * @since 1.0.0
     */
    public class ProcessesView : Gtk.Box {
        private Gtk.TreeView    tree_view;
        private Gtk.ListStore   list_model;
        private Gtk.ActionBar   action_bar;
        private Gtk.SearchEntry search_field;
        private Gtk.Button      end_process_button;

        /**
         * Constructs a new {@code ProcessesView} object.
         */
        public ProcessesView () {
            Object (
                orientation: Gtk.Orientation.VERTICAL
            );

            get_style_context ().add_class ("processes_view");

            // Process List
            tree_view = new Gtk.TreeView ();
            pack_start (tree_view, true, true, 0);

            // Action bar with SearchEntry and End-Process-button
            action_bar = new Gtk.ActionBar ();
            pack_end (action_bar, false, true, 0);

            search_field = new Gtk.SearchEntry ();
            action_bar.pack_start (search_field);

            end_process_button = new Gtk.Button.with_label (_("End Process"));
            action_bar.pack_end (end_process_button);

            // Set up the ListStore
            list_model = new Gtk.ListStore.newv ({
                typeof (int),
                typeof (uint64),
                typeof (float),
                typeof (string),
                typeof (float),
                typeof (string)
            });

            var search_filter = new Gtk.TreeModelFilter (list_model, null);
            var sort_model = new Gtk.TreeModelSort.with_model (search_filter);
            tree_view.model = sort_model;

            var column = new Gtk.TreeViewColumn.with_attributes ("PID", new Gtk.CellRendererText (), "text", 0);
            column.resizable = true;
            column.fixed_width = 50;
            column.min_width = 37;
            column.sort_column_id = 0;
            tree_view.append_column (column);

            var cell_renderer = new Gtk.CellRendererText ();
            column = new Gtk.TreeViewColumn.with_attributes ("Resident Memory", cell_renderer, "text", 1);
            column.set_cell_data_func (cell_renderer, (cell_layout, cell, tree_model, iter) => {
                var val = Value (typeof (uint64));
                tree_model.get_value (iter, 1, out val);
                (cell as Gtk.CellRendererText).text = GLib.format_size ((uint64) val, GLib.FormatSizeFlags.IEC_UNITS);
            });
            column.resizable = true;
            column.fixed_width = 90;
            column.min_width = 60;
            column.sort_column_id = 1;
            tree_view.append_column (column);

            cell_renderer = new Gtk.CellRendererText ();
            column = new Gtk.TreeViewColumn.with_attributes ("% Memory", cell_renderer, "text", 2);
            column.set_cell_data_func (cell_renderer, (cell_layout, cell, tree_model, iter) => {
                var val = Value (typeof (float));
                tree_model.get_value (iter, 2, out val);
                (cell as Gtk.CellRendererText).text = "%.1f%%".printf ((float) val);
            });
            column.resizable = true;
            column.fixed_width = 75;
            column.min_width = 60;
            column.sort_column_id = 2;
            tree_view.append_column (column);

            column = new Gtk.TreeViewColumn.with_attributes ("User", new Gtk.CellRendererText (), "text", 3);
            column.resizable = true;
            column.fixed_width = 90;
            column.min_width = 60;
            column.sort_column_id = 3;
            tree_view.append_column (column);

            cell_renderer = new Gtk.CellRendererText ();
            column = new Gtk.TreeViewColumn.with_attributes ("% CPU", cell_renderer, "text", 4);
            column.set_cell_data_func (cell_renderer, (cell_layout, cell, tree_model, iter) => {
                var val = Value (typeof (float));
                tree_model.get_value (iter, 4, out val);
                (cell as Gtk.CellRendererText).text = "%.1f%%".printf ((float) val);
            });
            column.resizable = true;
            column.fixed_width = 65;
            column.min_width = 60;
            column.sort_column_id = 4;
            tree_view.append_column (column);

            column = new Gtk.TreeViewColumn.with_attributes ("Process", new Gtk.CellRendererText (), "text", 5);
            column.min_width = 90;
            column.sort_column_id = 5;
            tree_view.append_column (column);

            // Searching
            search_filter.set_visible_func ((model, iter) => {
                var search_text = search_field.text;

                if (search_text == "") {
                    return true;
                }

                var val = Value (typeof (string));
                model.get_value (iter, 5, out val);

                if (search_text.down () in ((string) val).down ()) {
                    return true;
                } else {
                    return false;
                }
            });
            search_field.changed.connect (() => {
                search_filter.refilter ();
            });
        }
    }
}