/* CircularProgressBar.vala
 *
 * Copyright 2019 Hannes Schulze
 * Based on vala-circular-progressbar by phastmike
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
     * The {@code CircularProgressBar} class provides a widget displaying a circular progress bar.
     *
     * @since 1.0.0
     */
    public class CircularProgressBar : Gtk.Bin {
        private const int MIN_DIAMETER = 80;
        private double m_percentage = 0.0;

        [Description(nick = "Percentage/Value", blurb = "The percentage value [0.0 ... 1.0]")]
        public double percentage {
            get {
                return m_percentage;
            }
            set {
                if (value > 1.0) {
                    m_percentage = 1.0;
                } else if (value < 0.0) {
                    m_percentage = 0.0;
                } else {
                    m_percentage = value;
                }
            }
        }

        [Description(nick = "Description", blurb = "Title of the progress bar")]
        public string description { get; set; }

        /**
         * Constructs a new {@code CircularProgressBar} object.
         */
        public CircularProgressBar () {
            notify.connect (() => {
                queue_draw ();
            });
        }

        private int calculate_radius () {
            return (int) double.min (get_allocated_width () / 2,
                                     get_allocated_height () / 2) - 1;
        }

        private int calculate_diameter () {
            return 2 * calculate_radius ();
        }

        public override Gtk.SizeRequestMode get_request_mode () {
            return Gtk.SizeRequestMode.CONSTANT_SIZE;
        }

        public override void get_preferred_width (out int min_w, out int natural_w) {
            var diameter = calculate_diameter ();
            min_w = MIN_DIAMETER;
            if (diameter > MIN_DIAMETER) {
                natural_w = diameter;
            } else {
                natural_w = MIN_DIAMETER;
            }
        }

        public override void get_preferred_height (out int min_h, out int natural_h) {
            var diameter = calculate_diameter ();
            min_h = MIN_DIAMETER;
            if (diameter > MIN_DIAMETER) {
                natural_h = diameter;
            } else {
                natural_h = MIN_DIAMETER;
            }
        }

        public override bool draw (Cairo.Context cr) {
            int width, height;
            Pango.Layout layout;
            Pango.FontDescription font_description;

            cr.save ();

            var center_x = (get_allocated_width () - 2) / 2;
            var center_y = (get_allocated_height () - 2) / 2;
            var radius = calculate_radius () - 1;

            // Radius fill
            draw_stroke (cr, radius, 4, 0, center_x, center_y + 1, 1.0, "#ffffff");
            draw_stroke (cr, radius, 7, 0, center_x, center_y, 1.0, "#b7b7b7");
            draw_stroke (cr, radius, 5, 1, center_x, center_y, 1.0, "#ffffff");
            draw_stroke (cr, radius, 3, 2, center_x, center_y, 1.0, "#efefef");
            draw_stroke (cr, radius, 2, 3, center_x, center_y, 1.0, "#e9e9e9");
            draw_stroke (cr, radius, 1, 4, center_x, center_y, 1.0, "#e2e2e2");

            // Progress fill
            double progress = (double) percentage;
            if (progress > 0.0) {
                draw_stroke (cr, radius, 7, 0, center_x, center_y, progress, "#2c92e3");
                draw_stroke (cr, radius, 5, 1, center_x, center_y, progress, "#b3ddfe");
                draw_stroke (cr, radius, 3, 2, center_x, center_y, progress, "#7bc3fd");
                draw_stroke (cr, radius, 2, 3, center_x, center_y, progress, "#6dbcfb");
                draw_stroke (cr, radius, 1, 4, center_x, center_y, progress, "#5db4f9");
            }

            // Textual information
            var context = get_style_context ();
            context.save ();
            context.add_class (Gtk.STYLE_CLASS_TROUGH);
            Gdk.RGBA color = context.get_color (context.get_state ());
            Gdk.cairo_set_source_rgba (cr, color);

            // Title
            layout = Pango.cairo_create_layout (cr);
            layout.set_text (description.printf ((int) (percentage * 100.0)), -1);
            font_description = Pango.FontDescription.from_string ("Open Sans 26");
            font_description.set_weight (Pango.Weight.ULTRALIGHT);
            layout.set_font_description (font_description);
            Pango.cairo_update_layout (cr, layout);
            layout.get_size (out width, out height);
            cr.move_to (center_x - ((width / Pango.SCALE) / 2), center_y - 32);
            Pango.cairo_show_layout (cr, layout);

            // Percentage
            layout.set_text (_("%d PERCENT").printf ((int) (percentage * 100.0)), -1);
            font_description = Pango.FontDescription.from_string ("Open Sans 9");
            font_description.set_weight (Pango.Weight.NORMAL);
            layout.set_font_description (font_description);
            Pango.cairo_update_layout (cr, layout);
            layout.get_size (out width, out height);
            cr.move_to (center_x - ((width / Pango.SCALE) / 2), center_y + 18);
            Pango.cairo_show_layout (cr, layout);

            context.restore ();
            cr.restore ();

            return base.draw (cr);
        }

        private void draw_stroke (Cairo.Context cr,
                                  int radius, int line_width, int position,
                                  double center_x, double center_y,
                                  double progress, string color_code) {
            cr.set_line_width (line_width);
            int delta = radius - position - line_width / 2;
            cr.arc (center_x,
                    center_y,
                    delta,
                    1.5 * Math.PI,
                    (1.5 + progress * 2) * Math.PI);
            Gdk.RGBA color = Gdk.RGBA ();
            color.parse (color_code);
            Gdk.cairo_set_source_rgba (cr, color);
            cr.stroke ();
        }
    }
}