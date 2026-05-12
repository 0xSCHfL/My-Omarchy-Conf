const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0f0c01", /* black   */
  [1] = "#6A5C1C", /* red     */
  [2] = "#5D5B37", /* green   */
  [3] = "#7A7F7D", /* yellow  */
  [4] = "#8C6911", /* blue    */
  [5] = "#8D641D", /* magenta */
  [6] = "#8A7652", /* cyan    */
  [7] = "#c8bea0", /* white   */

  /* 8 bright colors */
  [8]  = "#8c8570",  /* black   */
  [9]  = "#6A5C1C",  /* red     */
  [10] = "#5D5B37", /* green   */
  [11] = "#7A7F7D", /* yellow  */
  [12] = "#8C6911", /* blue    */
  [13] = "#8D641D", /* magenta */
  [14] = "#8A7652", /* cyan    */
  [15] = "#c8bea0", /* white   */

  /* special colors */
  [256] = "#0f0c01", /* background */
  [257] = "#c8bea0", /* foreground */
  [258] = "#c8bea0",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
