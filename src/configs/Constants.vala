/* Constants.vala
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
     * The {@code Constants} class is responsible for defining all
     * the constants used in the application.
     *
     * @since 1.0.0
     */
    public class Constants {

        public abstract const string ID = "com.github.hannesschulze.optimizer";
        public abstract const string VERSION = "1.0.0";
        public abstract const string PROGRAME_NAME = "Optimizer";
        public abstract const string APP_YEARS = "2019";
        public abstract const string APP_ICON = "com.github.hannesschulze.optimizer";
        public abstract const string ABOUT_COMMENTS = _("Find out what's eating up your system resources and delete unnecessary files from your disk.");
        public abstract const string TRANSLATOR_CREDITS = _("Translators");
        public abstract const string MAIN_URL = "https://github.com/hannesschulze/optimizer";
        public abstract const string BUG_URL = "https://github.com/hannesschulze/optimizer/issues";
        public abstract const string HELP_URL = "https://github.com/hannesschulze/optimizer/wiki";
        public abstract const string TRANSLATE_URL = "https://github.com/hannesschulze/optimizer";
        public abstract const string TEXT_FOR_ABOUT_DIALOG_WEBSITE = _("Website");
        public abstract const string TEXT_FOR_ABOUT_DIALOG_WEBSITE_URL = "https://github.com/hannesschulze/optimizer";
        public abstract const string URL_CSS = "/com/github/hannesschulze/optimizer/css/style.css";
        public abstract const string [] ABOUT_AUTHORS = { "Hannes Schulze <haschu0103@gmail.com>" };
        public abstract const Gtk.License ABOUT_LICENSE_TYPE = Gtk.License.GPL_3_0;
    }
}
