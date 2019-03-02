/* AppView.vala
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

namespace Optimizer.Views {

    /**
     * The {@code AppView} class.
     *
     * @since 1.0.0
     */
    public class AppView : Gtk.Stack {
        private DashboardView     dashboard_view;
        private SystemCleanerView system_cleaner_view;
        private ProcessesView     processes_view;

        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {
            transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            transition_duration = 500;

            dashboard_view = new DashboardView ();
            add_titled (dashboard_view, "dashboard", _("Dashboard"));

            system_cleaner_view = new SystemCleanerView ();
            add_titled (system_cleaner_view, "system-cleaner", _("Cleaner"));

            processes_view = new ProcessesView ();
            add_titled (processes_view, "processes", _("Processes"));
        }
    }
}