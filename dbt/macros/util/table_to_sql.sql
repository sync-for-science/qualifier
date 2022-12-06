{%- macro table_to_sql() -%}
    {%- set re = modules.re -%}
    {%- set tbl = re.sub("(^[|\-\s:]+$)|(^\s*\|\s*)|(\s*\|\s*$)", "", caller(), flags=re.MULTILINE) -%}
    {%- set rows = re.split("\n", tbl) |  map('trim') | reject('==', '') | list -%}
    {%- set fields = re.split("\s*(?<!\\\)\|\s*", rows[0]) -%}
    {%- set ns = namespace(query_select=[], query=[]) -%}

    {%- for row in rows[1:] -%}
        {%- set cells = re.split("\s*(?<!\\\)\|\s*", row) -%}
        {%- for cell in cells -%}
            {%- set field = fields[loop.index0].split("::") -%}
            {%- if field[1] -%}
                {%- set ns.query_select = ns.query_select + [cell + "::" + field[1] + " AS " + field[0]] -%}
            {%- else -%}
                {%- set ns.query_select = ns.query_select + [cell + " AS " + field[0]] -%}
            {%- endif -%}  
        {%- endfor -%}
        {%- set ns.query = ns.query + ["SELECT " + ", ".join(ns.query_select)] -%}
        {%- set ns.query_select = [] -%}
    {%- endfor -%}
    
{{ "\nUNION ALL\n".join(ns.query) }}

{%- endmacro -%}