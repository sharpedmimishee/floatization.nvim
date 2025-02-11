# floatization.nvim
Recommend that Neovim should use float window.
features: 
- pressed keys logger
- use float window (have many bugs)
config:
```lua
require("floatization").setup({
  key = true --Enable pressed keys logger
  disappear = 10 --Number of keys dispalyed at once
})
```
