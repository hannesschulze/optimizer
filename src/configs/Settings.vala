/* Settings.vala
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

namespace Optimizer.Configs {

    /**
     * The {@code Settings} class is responsible for defining all
     * the texts that are displayed in the application and must be translated.
     *
     * @see Granite.Services.Settings
     * @since 1.0.0
     */
    public class Settings : Granite.Services.Settings {

        /**
         * This static property represents the {@code Settings} type.
         */
        private static Settings? instance;

        /**
         * This property will represent the location x of the screen.
         * Variable of type {@code int} as declared.
         */
        public int window_x { get; set; }

        /**
         * This property will represent the location y of the screen.
         * Variable of type {@code int} as declared.
         */
        public int window_y { get; set; }

        /**
         * This property will represent the mount path of the partition that is
         * monitored in the dashboard view.
         * Variable of type {@code string} as declared.
         */
        public string monitored_partition { get; set; }

        /**
         * This property is set to true when the user selected a dark theme using
         * the ModeSwitch.
         * Variable of type {@code bool} as declared.
         */
        public bool dark_theme { get; set; }

        /**
         * Constructs a new {@code Settings} object
         * and sets the default exit folder.
         */
        private Settings () {
            base (Constants.ID);
        }

        /**
         * Returns a single instance of this class.
         *
         * @return {@code Settings}
         */
        public static unowned Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }
    }
}
