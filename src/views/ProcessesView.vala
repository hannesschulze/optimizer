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
    public class ProcessesView : Gtk.Label {
        /**
         * Constructs a new {@code ProcessesView} object.
         */
        public ProcessesView () {
            Object (
                label: "Hello world!"
            );
        }
    }
} 