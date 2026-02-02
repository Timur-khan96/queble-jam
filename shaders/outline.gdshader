shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float base_alpha = 1.0;
uniform float line_thickness : hint_range(0.0, 10.0) = 2.0;
uniform float sprite_fade : hint_range(0.0, 1.0) = 0.5;

const vec2 OFFSETS[8] = {
    vec2(-1, -1), vec2(-1, 0), vec2(-1, 1),
    vec2(0, -1),               vec2(0, 1),
    vec2(1, -1),  vec2(1, 0),  vec2(1, 1)
};

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    // Detect inner outline using original alpha
    float inner_outline = 1.0;
    vec2 offset = TEXTURE_PIXEL_SIZE * line_thickness;

    for (int i = 0; i < 8; i++) {
        inner_outline *= texture(TEXTURE, UV + offset * OFFSETS[i]).a;
    }
    inner_outline = 1.0 - inner_outline; // 1.0 where outline should be

    // Fade only the sprite interior
    vec4 faded_base = base;
    faded_base.a *= sprite_fade;

    // Outline should remain full alpha → use base alpha (unfaded)
    vec4 outline_pixel = vec4(line_color.rgb, base.a);

    // Blend: outline where inner_outline = 1
    vec4 final_color = mix(faded_base, outline_pixel, inner_outline * base.a);

    COLOR = vec4(final_color.rgb, final_color.a * base_alpha);
}
