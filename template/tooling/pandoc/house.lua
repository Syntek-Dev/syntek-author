--[[
house.lua — the house Pandoc filter: semantic Markdown in, the right construct out.

The author marks meaning in Markdown, never layout. This filter decides what each mark becomes
for the output Pandoc is writing, so one Markdown source serves every format:

  Markdown                                LaTeX for the house book class    elsewhere
  ::: epigraph … :::                      \begin{epigraph} … \end{epigraph}   an indented italic block
  last epigraph paragraph opening '—'     \epigraphsource{— …}              set right, upright
  ::: scene-break :::  or a lone * * *    \scenebreak                       a centred * * *
  [word]{.conlang lang=<slug>}            \conlang[<slug>]{word}            italic
  [word]{.conlang-native lang=<slug>}     \conlangnative[<slug>][word]{…}   italic (romanised)
  [text]{.smallcaps}                      \smallcaps{text}                  small capitals
  [text]{lang=grc} · [text]{lang=hbo}     \greek{text} · \hebrew{text}      unchanged
  <!-- section: slug -->                  % section: slug                   dropped
  <!-- AUTHOR TO CONFIRM: … --> (VERIFY)  \dnote{AUTHOR TO CONFIRM: …}      dropped

Modes, set by the Makefile as metadata (-M key=true), never by the author:
  house-class      `make tex`: write the house class's macros. Without it, LaTeX output uses
                   only what Pandoc's own template defines, so `make pdf` still builds.
  house-book       book builds: every horizontal rule is a scene break. Off for business
                   documents, where a rule is a rule.
  house-refs-only  `make print`: keep only the reference list that citeproc made.

Plain-text output (`-t plain`) is what the fidelity check reads: it keeps every word the reader
meets, in order, and the structure it checks with them: an epigraph stays a Div, and a scene
break stays a horizontal rule. A native-script word becomes the same Private Use Area text the
LaTeX carries, so both sides of the check see identical characters.

A native-script span asks the language's script tool for its Private Use Area text:
  python3 tooling/script.py transliterate <slug> --pua -- <word>
(the `--` keeps a word that opens with a hyphen, such as an affix, from reading as an option).
The text may hold spaces and ASCII punctuation (an affix's hyphen) beside the glyphs, and must
hold at least one glyph; punctuation the romanised word shares at either end is set outside the
script font, which has glyphs only for the script. If that fails (the script tool fails, or a
letter has no glyph), the word falls back to romanised italic with a warning naming the cause,
in every output alike, so the check still compares like with like.

Standard Pandoc 3 Lua; no modules beyond Pandoc's own.
]]

local stringify = pandoc.utils.stringify

local HOUSE_CLASS = false
local HOUSE_BOOK = false
local REFS_ONLY = false

local function warn(msg)
  io.stderr:write('house.lua: warning: ' .. msg .. '\n')
end

local function truthy(value)
  if value == nil then return false end
  if type(value) == 'boolean' then return value end
  local s = stringify(value):lower()
  return s == 'true' or s == 'yes' or s == '1'
end

local function is_latex() return FORMAT:match('latex') ~= nil or FORMAT == 'beamer' end
local function is_plain() return FORMAT == 'plain' end
local function is_docx() return FORMAT == 'docx' or FORMAT == 'odt' end
local function is_html() return FORMAT:match('html') ~= nil or FORMAT:match('epub') ~= nil end
local function house_latex() return HOUSE_CLASS and is_latex() end

local function raw(s) return pandoc.RawInline('latex', s) end
local function rawblock(s) return pandoc.RawBlock('latex', s) end

-- Escape text placed inside a LaTeX argument by this filter (not text Pandoc writes itself).
local function tex_escape(s)
  return (s:gsub('[\\{}%%#&_%$%^~]', function(c)
    if c == '\\' then return '\\textbackslash{}' end
    if c == '^' then return '\\textasciicircum{}' end
    if c == '~' then return '\\textasciitilde{}' end
    return '\\' .. c
  end))
end

-- ── Native script: ask the script tool once per word ─────────────────────────

local native_cache = {}

local function in_pua(cp)
  return (cp >= 0xE000 and cp <= 0xF8FF) or (cp >= 0xF0000 and cp <= 0xFFFFD)
      or (cp >= 0x100000 and cp <= 0x10FFFD)
end

-- Beside its glyphs, native text may hold spaces and ASCII punctuation (an affix's hyphen).
local function passes_through(cp)
  return cp == 0x20 or (cp >= 0x21 and cp <= 0x2F) or (cp >= 0x3A and cp <= 0x40)
      or (cp >= 0x5B and cp <= 0x60) or (cp >= 0x7B and cp <= 0x7E)
end

-- Why s is not native-script text, or nil when it is.
local function not_native(s)
  local glyphs, stray = 0, pandoc.List()
  for _, cp in utf8.codes(s) do
    if in_pua(cp) then glyphs = glyphs + 1
    elseif not passes_through(cp) then stray:insert(utf8.char(cp)) end
  end
  if #stray > 0 then return 'it contains characters that are not glyphs: ' .. table.concat(stray, ' ') end
  if glyphs == 0 then return 'it holds no glyph' end
  return nil
end

local function to_native(lang, word)
  local key = lang .. '\0' .. word
  if native_cache[key] ~= nil then return native_cache[key] or nil end
  local ok, out = pcall(pandoc.pipe, 'python3',
    { 'tooling/script.py', 'transliterate', lang, '--pua', '--', word }, '')
  local native, why = nil, nil
  if not ok then
    why = 'the script tool failed; its own error is above'
  elseif type(out) == 'string' then
    native = out:match('native:%s*([^\r\n]+)') or out:match('^%s*(.-)%s*$')
    why = not_native(native)
    if why then native = nil end
  end
  if not native then
    warn("no native-script text for '" .. word .. "' in " .. lang .. ' (' ..
         (why or 'the script tool printed nothing') .. '); using romanised italic')
  end
  native_cache[key] = native or false
  return native
end

-- Punctuation the romanised word and its native text share at one end, such as an affix's
-- hyphen, is set outside the script font.
local function shared_edges(word, native)
  local lead, tail = native:match('^%p*'), native:match('%p*$')
  if lead == '' or word:sub(1, #lead) ~= lead then lead = '' end
  if tail == '' or #tail >= #native - #lead or word:sub(-#tail) ~= tail then tail = '' end
  return lead, word:sub(#lead + 1, #word - #tail), native:sub(#lead + 1, #native - #tail), tail
end

-- ── Inline marks ─────────────────────────────────────────────────────────────

local function conlang(el, lang)
  if house_latex() then
    local open = lang and ('\\conlang[' .. lang .. ']{') or '\\conlang{'
    local out = pandoc.List({ raw(open) })
    out:extend(el.content)
    out:insert(raw('}'))
    return out
  elseif is_latex() or is_docx() then
    return pandoc.Emph(el.content)
  elseif is_html() then
    return pandoc.Span({ pandoc.Emph(el.content) },
      pandoc.Attr('', { 'conlang' }, { ['data-lang'] = lang or '' }))
  elseif is_plain() then
    return el.content
  end
  return nil
end

local function conlang_native(el, lang)
  local word = stringify(el.content)
  if not lang then
    warn("a conlang-native span has no lang= attribute ('" .. word .. "'); using romanised italic")
    return conlang(el, nil)
  end
  if house_latex() or is_plain() then
    local native = to_native(lang, word)
    if not native then return conlang(el, lang) end
    if is_plain() then return pandoc.Str(native) end
    local lead, roman, glyphs, tail = shared_edges(word, native)
    return raw(tex_escape(lead) .. '\\conlangnative[' .. lang .. '][' .. tex_escape(roman) .. ']{'
      .. tex_escape(glyphs) .. '}' .. tex_escape(tail))
  end
  if is_html() then
    return pandoc.Span({ pandoc.Emph(el.content) },
      pandoc.Attr('', { 'conlang-native' }, { ['data-lang'] = lang }))
  end
  if is_latex() or is_docx() then return pandoc.Emph(el.content) end
  return nil
end

local function Span(el)
  local lang = el.attributes['lang']
  if el.classes:includes('conlang') then return conlang(el, lang) end
  if el.classes:includes('conlang-native') then return conlang_native(el, lang) end
  if lang and house_latex() then
    local macro = nil
    if lang:match('^grc') or lang:match('^el') then macro = '\\greek{' end
    if lang:match('^hbo') or lang:match('^he') then macro = '\\hebrew{' end
    if macro then
      local out = pandoc.List({ raw(macro) })
      out:extend(el.content)
      out:insert(raw('}'))
      return out
    end
  end
  return nil
end

local function SmallCaps(el)
  if house_latex() then
    local out = pandoc.List({ raw('\\smallcaps{') })
    out:extend(el.content)
    out:insert(raw('}'))
    return out
  end
  if is_plain() then return el.content end
  return nil
end

-- ── Blocks ───────────────────────────────────────────────────────────────────

local function stars()
  return pandoc.Para({ pandoc.Str('*'), pandoc.Space(), pandoc.Str('*'), pandoc.Space(), pandoc.Str('*') })
end

local function scene_break()
  if house_latex() then return rawblock('\\scenebreak') end
  if is_latex() then return rawblock('\\begin{center}*\\quad*\\quad*\\end{center}') end
  if is_docx() then return pandoc.Div({ stars() }, pandoc.Attr('', {}, { ['custom-style'] = 'Scene Break' })) end
  if is_html() then return pandoc.Div({ stars() }, pandoc.Attr('', { 'scene-break' })) end
  if is_plain() then return pandoc.HorizontalRule() end -- the fidelity check reads it as a break
  return pandoc.HorizontalRule()
end

-- The attribution is the epigraph's last paragraph when it opens with a dash.
local function split_epigraph(blocks)
  local last = blocks[#blocks]
  if last and (last.t == 'Para' or last.t == 'Plain') and last.content[1]
     and last.content[1].t == 'Str' then
    local first = last.content[1].text
    if first:sub(1, 3) == '—' or first:sub(1, 3) == '―' then
      local quote = pandoc.List()
      for i = 1, #blocks - 1 do quote:insert(blocks[i]) end
      return quote, last.content
    end
  end
  return blocks, nil
end

local function epigraph(el)
  local quote, source = split_epigraph(el.content)
  if house_latex() then
    local out = pandoc.List({ rawblock('\\begin{epigraph}') })
    out:extend(quote)
    if source then
      local para = pandoc.List({ raw('\\epigraphsource{') })
      para:extend(source)
      para:insert(raw('}'))
      out:insert(pandoc.Para(para))
    end
    out:insert(rawblock('\\end{epigraph}'))
    return out
  elseif is_latex() then
    local out = pandoc.List({ rawblock('\\begin{flushright}\\begin{minipage}{0.65\\linewidth}\\itshape') })
    out:extend(quote)
    if source then
      local para = pandoc.List({ raw('{\\raggedleft\\upshape ') })
      para:extend(source)
      para:insert(raw('\\par}'))
      out:insert(pandoc.Para(para))
    end
    out:insert(rawblock('\\end{minipage}\\end{flushright}'))
    return out
  elseif is_docx() then
    local out = pandoc.List({ pandoc.Div(quote, pandoc.Attr('', {}, { ['custom-style'] = 'Epigraph' })) })
    if source then
      out:insert(pandoc.Div({ pandoc.Para(source) },
        pandoc.Attr('', {}, { ['custom-style'] = 'Epigraph Source' })))
    end
    return out
  elseif is_html() then
    local inner = pandoc.List(quote)
    if source then inner:insert(pandoc.Div({ pandoc.Para(source) }, pandoc.Attr('', { 'epigraph-source' }))) end
    return pandoc.Div(inner, pandoc.Attr(el.identifier, { 'epigraph' }))
  end
  return nil -- plain output keeps the Div, which the fidelity check reads as the epigraph's bounds
end

local function Div(el)
  if el.classes:includes('epigraph') then return epigraph(el) end
  if el.classes:includes('scene-break') then return scene_break() end
  return nil
end

local function HorizontalRule()
  if HOUSE_CLASS or HOUSE_BOOK or is_plain() then return scene_break() end
  return nil
end

-- ── Comments: markers and flags survive into the house LaTeX; nothing else prints ──

local function comment_text(s)
  return s:match('^%s*<!%-%-(.-)%-%->%s*$')
end

local function flag_of(text)
  local body = text:match('^%s*(.-)%s*$')
  if body:match('^AUTHOR TO CONFIRM:') or body:match('^VERIFY:') then
    return '\\dnote{' .. tex_escape(body:gsub('%s+', ' ')) .. '}'
  end
  return nil
end

local function RawBlock(el)
  if not (house_latex() and el.format == 'html') then return nil end
  local text = comment_text(el.text)
  if not text then return nil end
  local slug = text:match('^%s*section:%s*(%S+)%s*$')
  if slug then return rawblock('% section: ' .. slug) end
  local flag = flag_of(text)
  if flag then return rawblock(flag) end
  local lines = pandoc.List()
  for line in (text:match('^%s*(.-)%s*$') .. '\n'):gmatch('(.-)\n') do
    lines:insert('% ' .. line:gsub('^%s+', ''))
  end
  return rawblock(table.concat(lines, '\n'))
end

local function RawInline(el)
  if not (house_latex() and el.format == 'html') then return nil end
  local text = comment_text(el.text)
  if not text then return nil end
  local flag = flag_of(text)
  if flag then return raw(flag) end
  return {}
end

-- ── The reference list alone, for the back of the printed book ──────────────

local function refs_only(doc)
  if not REFS_ONLY then return nil end
  local refs = nil
  doc.blocks:walk({ Div = function(d) if d.identifier == 'refs' then refs = d end end })
  if not refs then warn('no reference list: nothing in the manuscript is cited') end
  return pandoc.Pandoc(refs and { refs } or {}, doc.meta)
end

local function Meta(meta)
  HOUSE_CLASS = truthy(meta['house-class'])
  HOUSE_BOOK = truthy(meta['house-book'])
  REFS_ONLY = truthy(meta['house-refs-only'])
  return nil
end

return {
  { Meta = Meta },
  {
    Span = Span,
    SmallCaps = SmallCaps,
    RawInline = RawInline,
    Div = Div,
    HorizontalRule = HorizontalRule,
    RawBlock = RawBlock,
  },
  { Pandoc = refs_only },
}
