VERSION = "1.0.0"

local translations={}
{% require-file "main.lua" %}
{% require-dir "functions" %}
{% require-dir "tables" %}
{% require-dir "translations" %}
{% require-dir "systems" %}
{% require-dir "menus" %}
{% require-dir "events" %}
{% require-file "end.lua" %}