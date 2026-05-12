/* See LICENSE file for copyright and license details. */

/* gaps */
static const int gappx    = 5;        /* gap pixel between windows */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
char col_gray1[]       = "#222222";
char col_gray2[]       = "#444444";
char col_gray3[]       = "#bbbbbb";
char col_gray4[]       = "#eeeeee";
char col_cyan[]        = "#005577";
char col_s_sep[]       = "#555555";  /* status: dim separator */
char col_s_icon[]      = "#81a1c1";  /* status: Nord frost blue icons */
char col_s_val[]       = "#eceff4";  /* status: Nord snow white values */
char col_s_warn[]      = "#ebcb8b";  /* status: Nord aurora yellow warning */
char *colors[][3]      = {
	/*                fg           bg          border   */
	[SchemeNorm]  = { col_gray3,  col_gray1,  col_gray2 },
	[SchemeSel]   = { col_gray4,  col_cyan,   col_cyan  },
	[SchemeSep]   = { col_s_sep,  col_gray1,  col_gray1 },
	[SchemeIcon]  = { col_s_icon, col_gray1,  col_gray1 },
	[SchemeVal]   = { col_s_val,  col_gray1,  col_gray1 },
	[SchemeWarn]  = { col_s_warn, col_gray1,  col_gray1 },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
	{ "Brave-browser", NULL,   NULL,       0,            0,           -1 },
	{ "fzfmenu",       NULL,   NULL,       0,            1,           -1 },
	{ "btop",          NULL,   NULL,       0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "rofi", "-show", "drun", "-theme", "/home/sohaib/.config/rofi/dwm-launcher.rasi", NULL };
static const char *termcmd[]       = { "st", NULL };
static const char *screenshotcmd[] = { "dwm-screenshot", NULL };
static const char *screenreccmd[]  = { "dwm-screenrecord", NULL };
static const char *ocrcmd[]        = { "dwm-ocr", NULL };
static const char *browsercmd[] = { "qutebrowser", NULL };
static const char *obsidiancmd[] = { "/bin/sh", "-c", "WAYLAND_DISPLAY= obsidian --ozone-platform=x11", NULL };
static const char *bravecmd[]        = { "/bin/sh", "-c", "WAYLAND_DISPLAY= brave --ozone-platform=x11 --user-data-dir=/home/sohaib/.config/brave-dwm", NULL };
static const char *braveprivatecmd[] = { "/bin/sh", "-c", "WAYLAND_DISPLAY= brave --ozone-platform=x11 --user-data-dir=/home/sohaib/.config/brave-dwm --incognito", NULL };
static const char *whatsappcmd[] = { "dwm-webapp", "https://web.whatsapp.com/", NULL };
static const char *chatgptcmd[]  = { "dwm-webapp", "https://chatgpt.com/", NULL };
static const char *twittercmd[]  = { "dwm-webapp", "https://x.com/", NULL };
static const char *discordcmd[]  = { "dwm-webapp", "https://discord.com/channels/@me", NULL };
static const char *emailcmd[]    = { "dwm-webapp", "https://mail.google.com/", NULL };
static const char *syscmd[]         = { "dwm-sys", NULL };
static const char *notescmd[]       = { "notes", NULL };
static const char *cliphistcmd[]    = { "/bin/sh", "-c", "cliphist list | rofi -dmenu -i -theme ~/.config/rofi/dwm-clip.rasi -p 'Clipboard' | cliphist decode | xclip -selection clipboard -i", NULL };
static const char *imgpickercmd[]   = { "dwm-imgpicker", NULL };
static const char *btopcmd[]        = { "dwm-btop", NULL };
static const char *imgcliphistcmd[] = { "dwm-imgcliphist", NULL };
static const char *chromiumcmd[]    = { "chromium", NULL };
static const char *restartcmd[]     = { "dwm-restart", NULL };
static const char *keyscmd[]        = { "dwm-keys", NULL };
static const char *filemanagercmd[] = { "st", "-e", "yazi", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_w,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_o,      spawn,          {.v = obsidiancmd } },
	{ MODKEY|ShiftMask,             XK_w,      spawn,          {.v = whatsappcmd } },
	{ MODKEY|ShiftMask,             XK_g,      spawn,          {.v = chatgptcmd } },
	{ MODKEY|ShiftMask,             XK_x,      spawn,          {.v = twittercmd } },
	{ MODKEY|ShiftMask,             XK_d,      spawn,          {.v = discordcmd } },
	{ MODKEY|ShiftMask,             XK_e,      spawn,          {.v = emailcmd } },
	{ MODKEY,                       XK_q,      spawn,          {.v = browsercmd } },
	{ MODKEY|ShiftMask,             XK_r,      spawn,          {.v = restartcmd } },
	{ MODKEY|ShiftMask,             XK_b,      spawn,          {.v = bravecmd } },
	{ MODKEY|ShiftMask|Mod1Mask,    XK_b,      spawn,          {.v = braveprivatecmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY|ControlMask,           XK_Delete, quit,           {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      spawn,          {.v = chromiumcmd } },
	{ MODKEY,                       XK_t,      togglefloating, {0} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|Mod1Mask,              XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_p,      setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ 0,                            XK_Print,  spawn,          {.v = screenshotcmd } },
	{ Mod1Mask,                     XK_Print,  spawn,          {.v = screenreccmd } },
	{ MODKEY|ControlMask,           XK_Print,  spawn,          {.v = ocrcmd } },
	{ MODKEY,                       XK_agrave,  view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_agrave,  tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_ampersand,              0)
	TAGKEYS(                        XK_eacute,                 1)
	TAGKEYS(                        XK_quotedbl,               2)
	TAGKEYS(                        XK_apostrophe,             3)
	TAGKEYS(                        XK_parenleft,              4)
	TAGKEYS(                        XK_minus,                  5)
	TAGKEYS(                        XK_egrave,                 6)
	TAGKEYS(                        XK_underscore,             7)
	TAGKEYS(                        XK_ccedilla,               8)
	{ MODKEY|ShiftMask,             XK_s,      spawn,          {.v = syscmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = filemanagercmd } },
	{ MODKEY,                       XK_n,      spawn,          {.v = notescmd } },
	{ MODKEY,                       XK_v,      spawn,          {.v = cliphistcmd } },
	{ MODKEY|ShiftMask,             XK_i,      spawn,          {.v = imgpickercmd } },
	{ MODKEY|ShiftMask,             XK_t,      spawn,          {.v = btopcmd } },
	{ MODKEY|ShiftMask,             XK_v,      spawn,          {.v = imgcliphistcmd } },
	{ MODKEY,                       XK_F1,     spawn,          {.v = keyscmd } },
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

