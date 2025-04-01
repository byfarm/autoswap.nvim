# autoswap.nvim
Define text inputs that will auto-swap whatever you want.

# Usage
Instead of having to search up unicode symbols or having to memorize glyph codes, if you want to write β, type `\beta`. The plugin will automatically detect the word and replace `\beta` with `β`. If you would like capitol beta, `Β`, type `\Beta`.

By default, most of the greek alphabet is included. See the [configuration](#configuration) section on how to define your own swap terms.

# Installation

with [Lazy](https://github.com/folke/lazy.nvim):
```lua
{ 
    "byfarm/nvim-autoswap"
},
```
You _must_ call `setup()` to get the plugin to work. The plugin automatically provides a user command `StartSwap` to setup and load the default configuration.

# Configuration


## Parameters
+ `behavior` = `overwrite` or `default` (`string`). Whether to overwrite or merge with the default config.
+ `greedy` = `true` or `false` (`boolean`). Whether to use greedy matching to replace (`false` by default).
+ `lookup_table` = `table` ( `key` = `value` (`string`) ). The lookup table to make replacements. They keys are what you type into the editor, and the values are what the keys are replaced with.

### Behavior
The configuration supports two modes, `default` and `overwrite`. `default` will merge the provided configuration with the default, and `overwrite` will completely overwrite the default configuration.

#### Default

To extend upon the defaults, you can pass your own delemeter, and your own lookup table into the config.
```lua
{
    "byfarm/nvim-autoswap",
    config = function()
        local config = {
            delemeter = ";",
            lookup_table = {
                ifm = "if __name__ == \"__main__\":\n\tmain()",
            }
        }
        require "autoswap".setup(config)
    end
},
```
Now, typing `;ifm<space>` will expand out to the input string. Note that the delemeter in this case WILL be overwritten.

#### Overwrite

To override the configuration with your own, pass in the `behavior = "overwrite"` key-value pair into the config.
```lua
{
    "byfarm/nvim-autoswap",
    config = function()
        local config = {
            behavior = "overwrite",
            delemeter = "\\",
            lookup_table = {
                beta = "β",
            }
        }
        require "autoswap".setup(config)
    end
},
```
This example will make it so that ONLY beta is in the lookup table. Note that you MUST provide a delemeter if you are in overwrite mode.

### Greedy
By default, the plugin does not enable greedy matching. Greedy matching means that a non-alphanumeric number does _not_ have to be input for the program to search for a match in the lookup table. For example, with the following config
```lua
{
    "byfarm/nvim-autoswap",
    config = function()
        local config = {
            behavior = "overwrite",
            delemeter = ";",
            greedy = true,
            lookup_table = {
                beta = "β",
            }
        }
        require "autoswap".setup(config)
    end
},
```
typing in `;beta` will auto replace with `β`. The default configuration would you require to intput a non-alphanumeric number to get the replacement (`;beta<SPACE>` -> `β `). 

Greedy matching creates the problem of key overlap. If I have two keys: `beta` and `beta2`, `beta2` will never be matched because `beta` will always be matched before `beta2`.
