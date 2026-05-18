config.load_autoconfig(False)

# Dark mode
config.set("colors.webpage.darkmode.enabled", True)

# Start page
c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.default_page = "https://start.duckduckgo.com"

# Search engine
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "yt": "https://youtube.com/search?search_query={}",
}

# Font
c.fonts.default_family = "Iosevka"
c.fonts.default_size = "11pt"

# Let qutebrowser's built-in quirks handle Google login (sends Firefox UA to accounts.google.com)
c.content.site_specific_quirks.enabled = True

# Editor
c.editor.command = ["kitty", "-e", "nvim", "{}"]

# Tabs
c.tabs.position = "top"
c.tabs.show = "multiple"

# Vim-like keybindings
config.bind("d", "scroll-page 0 0.5")
config.bind("u", "scroll-page 0 -0.5")
config.bind("D", "tab-close")
config.bind("<Ctrl-l>", "set-cmd-text -s :open")
