//logo_points = [[594, 163], [540, 159], [531, 149], [513, 137], [486, 126], [475, 125], [430, 112], [390, 103], [354, 103], [318, 86], [299, 78], [275, 75], [215, 84], [171, 104], [108, 149], [80, 206], [75, 258], [74, 276], [66, 294], [29, 329], [9, 364], [1, 402], [5, 440], [20, 471], [44, 503], [77, 522], [104, 523], [120, 519], [124, 506], [118, 497], [109, 497], [107, 509], [85, 506], [65, 492], [42, 466], [30, 434], [25, 413], [28, 377], [52, 343], [97, 308], [117, 301], [137, 316], [146, 332], [131, 352], [138, 356], [158, 342], [168, 356], [177, 347], [188, 342], [198, 353], [205, 346], [192, 330], [196, 310], [228, 300], [265, 297], [283, 300], [285, 328], [271, 336], [265, 345], [271, 354], [292, 343], [297, 354], [319, 340], [329, 349], [344, 349], [349, 341], [336, 327], [329, 312], [345, 320], [358, 339], [360, 350], [370, 352], [372, 340], [374, 338], [380, 350], [385, 348], [386, 340], [397, 345], [403, 335], [391, 325], [370, 311], [377, 305], [395, 300], [410, 285], [432, 278], [463, 313], [477, 324], [502, 335], [516, 331], [518, 309], [517, 276], [521, 239], [532, 214], [549, 194], [580, 182], [591, 173]]; // unscaled/unnormalized
LOGO_POINTS = [[296.5, 136.0], [242.5, 140.0], [233.5, 150.0], [215.5, 162.0], [188.5, 173.0], [177.5, 174.0], [132.5, 187.0], [92.5, 196.0], [56.5, 196.0], [20.5, 213.0], [1.5, 221.0], [-22.5, 224.0], [-82.5, 215.0], [-126.5, 195.0], [-189.5, 150.0], [-217.5, 93.0], [-222.5, 41.0], [-223.5, 23.0], [-231.5, 5.0], [-268.5, -30.0], [-288.5, -65.0], [-296.5, -103.0], [-292.5, -141.0], [-277.5, -172.0], [-253.5, -204.0], [-220.5, -223.0], [-193.5, -224.0], [-177.5, -220.0], [-173.5, -207.0], [-179.5, -198.0], [-188.5, -198.0], [-190.5, -210.0], [-212.5, -207.0], [-232.5, -193.0], [-255.5, -167.0], [-267.5, -135.0], [-272.5, -114.0], [-269.5, -78.0], [-245.5, -44.0], [-200.5, -9.0], [-180.5, -2.0], [-160.5, -17.0], [-151.5, -33.0], [-166.5, -53.0], [-159.5, -57.0], [-139.5, -43.0], [-129.5, -57.0], [-120.5, -48.0], [-109.5, -43.0], [-99.5, -54.0], [-92.5, -47.0], [-105.5, -31.0], [-101.5, -11.0], [-69.5, -1.0], [-32.5, 2.0], [-14.5, -1.0], [-12.5, -29.0], [-26.5, -37.0], [-32.5, -46.0], [-26.5, -55.0], [-5.5, -44.0], [-0.5, -55.0], [21.5, -41.0], [31.5, -50.0], [46.5, -50.0], [51.5, -42.0], [38.5, -28.0], [31.5, -13.0], [47.5, -21.0], [60.5, -40.0], [62.5, -51.0], [72.5, -53.0], [74.5, -41.0], [76.5, -39.0], [82.5, -51.0], [87.5, -49.0], [88.5, -41.0], [99.5, -46.0], [105.5, -36.0], [93.5, -26.0], [72.5, -12.0], [79.5, -6.0], [97.5, -1.0], [112.5, 14.0], [134.5, 21.0], [165.5, -14.0], [179.5, -25.0], [204.5, -36.0], [218.5, -32.0], [220.5, -10.0], [219.5, 23.0], [223.5, 60.0], [234.5, 85.0], [251.5, 105.0], [282.5, 117.0], [293.5, 126.0]]; // scaled/normalized

EYE_POINTS = [ // Still need to design this - these are just to figure out rough location.
//[150,150],[150,140],[140,140],[140,150]
];

module possum() {
    difference() {
        union() {
            polygon(LOGO_POINTS);
        };
        union() {
            polygon(EYE_POINTS);
        };
    };
};

//possum();
