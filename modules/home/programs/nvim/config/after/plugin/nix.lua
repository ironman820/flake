local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("nix", {
  s(
    "nixmod",
    fmt(
      [[
        {{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }}:
        let
          inherit (lib) mkEnableOption mkIf;

          cfg = config.{};
        in {{
          options.{} = {{
            enable = mkEnableOption "Enable the module";
          }};
          config = mkIf cfg.enable {{
            {}
          }};
        }}
      ]],
      {
        i(1, "module"),
        rep(1),
        i(0),
      }
    )
  ),
  s(
    "nixpkg",
    fmt(
      [[
      {{ lib, inputs, pkgs, stdenv, ... }}:

      stdenv.mkDerivation {{
        name = "{}";
        version = "{}";
        {}
      }}
      ]],
      {
        i(1, "name"),
        i(2, "version"),
        i(0),
      }
    )
  ),
  s(
    "nixoverlay",
    fmt(
      [[
{{ channels, ... }}:
final: prev:
{{
{}
}}
  ]],
      {
        i(0),
      }
    )
  ),
  s(
    "nixvimplug",
    fmt(
      [[
      {{ inputs, pkgs, ... }}:
      let inherit (pkgs.vimUtils) buildVimPlugin;
      in buildVimPlugin {{
        name = "{}";
        src = inputs.{};
      }}
      ]],
      {
        i(1, "name"),
        i(0, "input"),
      }
    )
  ),
})
