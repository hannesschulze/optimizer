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
        private const double LINE_WIDTH = 7.0;
        private double m_percentage = 0.0;
        private bool m_is_in_focus = true;

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

        [Description(nick = "Custom progress text", blurb = "Custom progress text other than %d PERCENT")]
        public string custom_progress_text { get; set; default = ""; }

        /**
         * Constructs a new {@code CircularProgressBar} object.
         */
        public CircularProgressBar () {
            set_size_request (200, 200);
            notify.connect (() => {
                queue_draw ();
            });

            realize.connect (() => {
                var toplevel_widget = get_toplevel ();
                if (toplevel_widget is Gtk.Window) {
                    ((Gtk.Window) toplevel_widget).focus_in_event.connect (() => {
                        m_is_in_focus = true;
                        queue_draw ();
                        return false;
                    });
                    ((Gtk.Window) toplevel_widget).focus_out_event.connect (() => {
                        m_is_in_focus = false;
                        queue_draw ();
                        return false;
                    });
                }
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
            var radius = (double) (calculate_radius () - 1);

            // Radius fill
            var settings = Gtk.Settings.get_default();
		    var theme = Environment.get_variable("GTK_THEME");
            var dark = settings.gtk_application_prefer_dark_theme || 
                       (theme != null && theme.has_suffix(":dark"));

            if (dark) {
                if (Constants.USE_FALLBACK_PROGRESS_BAR_THEME) {
                    if (m_is_in_focus) {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.15, 0.15, 0.15);
                    } else {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.07, 0.07, 0.07);
                    }
                } else {
                    if (m_is_in_focus) {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.18, 0.18, 0.18);
                        draw_gradient_stroke (cr, radius, 1.0, 1.0, center_x, center_y, 0.28, 0.28, 0.28,
                                              0.25, 0.25, 0.25);
                    } else {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.21, 0.21, 0.21);
                        draw_gradient_stroke (cr, radius, 1.0, 1.0, center_x, center_y, 0.3, 0.3, 0.3,
                                              0.29, 0.29, 0.29);
                    }
                }
            } else {
                if (Constants.USE_FALLBACK_PROGRESS_BAR_THEME) {
                    if (m_is_in_focus) {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.85, 0.85, 0.85);
                    } else {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.93, 0.93, 0.93);
                    }
                } else {
                    if (m_is_in_focus) {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.79, 0.79, 0.79);
                        draw_gradient_stroke (cr, radius, 1.0, 1.0, center_x, center_y, 0.98, 0.98, 0.98,
                                              1.0, 1.0, 1.0);
                    } else {
                        draw_solid_stroke (cr, radius, 0.0, 1.0, center_x, center_y, 0.78, 0.78, 0.78);
                        draw_gradient_stroke (cr, radius, 1.0, 1.0, center_x, center_y, 0.98, 0.98, 0.98,
                                              0.99, 0.99, 0.99);
                    }
                }
            }

            // Progress fill
            double progress = (double) percentage;
            if (dark) {
                if (progress > 0.0) {
                    if (Constants.USE_FALLBACK_PROGRESS_BAR_THEME) {
                        if (m_is_in_focus) {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.95, 0.45, 0.16);
                        } else {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.35, 0.35, 0.35);
                        }
                    } else {
                        if (m_is_in_focus) {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.66, 0.32, 0.11);
                            draw_gradient_stroke (cr, radius, 1.0, progress, center_x, center_y, 0.95, 0.47, 0.20,
                                                  0.95, 0.45, 0.16);
                        } else {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.11, 0.11, 0.11);
                            draw_solid_stroke (cr, radius, 1.0, progress, center_x, center_y, 0.15, 0.15, 0.15);
                        }
                    }
                }
            } else {
                if (progress > 0.0) {
                    if (Constants.USE_FALLBACK_PROGRESS_BAR_THEME) {
                        if (m_is_in_focus) {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.95, 0.45, 0.16);
                        } else {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.65, 0.65, 0.65);
                        }
                    } else {
                        if (m_is_in_focus) {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.76, 0.36, 0.13);
                            draw_gradient_stroke (cr, radius, 1.0, progress, center_x, center_y, 0.96, 0.56, 0.33,
                                                  0.95, 0.45, 0.16);
                        } else {
                            draw_solid_stroke (cr, radius, 0.0, progress, center_x, center_y, 0.70, 0.70, 0.70);
                            draw_solid_stroke (cr, radius, 1.0, progress, center_x, center_y, 0.87, 0.87, 0.87);
                        }
                    }
                }
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
            if (custom_progress_text != "") {
                layout.set_text (custom_progress_text, -1);
            } else {
                layout.set_text (_("%d Percent").printf ((int) (percentage * 100.0)).up (), -1);
            }
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

        private void mask_arc (Cairo.Context cr, double radius, double shrink,
                               double progress, double center_x, double center_y) {
            cr.set_line_width (LINE_WIDTH - shrink * 2.0);
            var actual_radius = radius - LINE_WIDTH * 0.5;
            cr.arc (center_x, center_y, actual_radius, 1.5 * Math.PI,
                    (1.5 + progress * 2.0) * Math.PI);
        }

        private void draw_solid_stroke (Cairo.Context cr, double radius, double shrink,
                                        double progress, double center_x, double center_y,
                                        double color_r, double color_g, double color_b) {
            mask_arc (cr, radius, shrink, progress, center_x, center_y);
            cr.set_source_rgb (color_r, color_g, color_b);
            cr.stroke ();
        }

        private void draw_gradient_stroke (Cairo.Context cr, double radius, double shrink,
                                           double progress, double center_x, double center_y,
                                           double outer_r, double outer_g, double outer_b,
                                           double inner_r, double inner_g, double inner_b) {
            mask_arc (cr, radius, shrink, progress, center_x, center_y);
            var outer_radius = radius - shrink;
            var inner_radius = outer_radius - LINE_WIDTH;
            var pattern = new Cairo.Pattern.radial (center_x, center_y, outer_radius,
                                                    center_x, center_y, inner_radius);
            pattern.add_color_stop_rgb (0.0, outer_r, outer_g, outer_b);
            pattern.add_color_stop_rgb (1.0, inner_r, inner_g, inner_b);
            cr.set_source (pattern);
            cr.stroke ();
        }
    }
}
