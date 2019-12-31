/* Main.vala
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

public class Main {
    private static bool testing = false;
    private static bool version = false;

    private const OptionEntry[] options = {
        { "version", 0, 0, OptionArg.NONE, ref version, "Display Version Number", null },
        { "run-tests", 0, 0, OptionArg.NONE, ref testing, "Run testing", null},
        { null }
    };

    public static void entry_point() {
        X.Display dpy = new X.Display(null);
        int event_basep, error_basep;
        bool ret = false;
        ret = XNVCTRL.QueryExtension(dpy, out event_basep, out error_basep);
        if (!ret)
        {
            stderr.printf ("The NV-CONTROL X extension does not exist on '%s'.\n", dpy.display_string());
        }
    }

    /**
     * Main method. Responsible for starting the {@code Application} class.
     *
     * @see Optimizer.Application
     * @return {@code int}
     * @since 1.0.0
     */
    public static int main (string [] args) {
        var options_context = new OptionContext (Optimizer.Configs.Constants.PROGRAME_NAME +" "+ _("Options"));
        options_context.set_help_enabled (true);
        options_context.add_main_entries (options, null);

        try {
            options_context.parse (ref args);
        }
        catch (Error error) {}

        if (version) {
            stdout.printf (Optimizer.Configs.Constants.PROGRAME_NAME +" "+ Optimizer.Configs.Constants.VERSION + "\r\n");
            return 0;
        }

        else {
            var app = new Optimizer.Application ();
            app.run (args);
        }

        return 0;
    }
}
