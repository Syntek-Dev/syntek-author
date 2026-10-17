#!/usr/bin/env python3
"""family-update.py: say what an update did not deliver, and keep the shared files current.

Why. Copier delivers a template's change only to the files it owns. A file the owner changed,
a seed, a seed-once example, a copy-only path and a file the owner deleted keep their old
text, with no word from Copier. This script ends every update with a report of each such
file, and one offline git command to compare it and one to take the template's version.
It also refreshes the shared working-practice files (each template's
migrations/family-refresh.json lists them): copy-only files that every template of the
family ships byte for byte, which no update would otherwise reach.

Records, per clone, inside .git (never pushed by default, never in the work tree or index):
  refs/<template>/template  a commit whose tree is this project's full render of the version
                            now recorded (copy semantics: seeds, copy-only paths, examples).
                            Its parent is the previous render, so the chain holds every
                            version this project has been rendered at. Its message is the
                            full report, then 'commit: <sha>' and 'answers: <blob>'.
  refs/<template>/yours     the owner's HEAD when the update ran (the pre-update state).
The template's name comes from the answers file: .copier-answers.<template>.yml.

Subcommands (run from the project root; Copier runs both through _copier_python):
  update   --src S --to SHA --answers F   the last after-stage migration of every update:
           refresh, report, record.
  baseline --src S --to SHA --answers F   the last task of a copy: record the render, and
           refresh shared files that equal an earlier recorded render.
  --self-test                             prove the classes, the refresh and the commands
                                          in temporary folders (exits 1 on a failure).
  --help                                  this text.

The refresh replaces a listed file only when it is a regular file the update left untouched
(the work tree equals HEAD), whose bytes equal a render this project recorded, and which
differs from the new render. A listed file that is absent and that the owner never had (no
commit of HEAD's history and no recorded render of any template here held it) is added, so
one the owner deleted stays deleted and one a skipped refresh never wrote arrives with the next
full run. A hook written or refreshed under .claude/hooks/ is left mode 755. A file that cannot
be written is reported and the run goes on to the report and the record.

Settings. Each entry the template's family-refresh.json lists (hooks, permissions deny and
ask, and top-level values such as autoCompactEnabled) that the new render's
.claude/settings.json also holds is offered to the project's settings.json once, by baseline
(a copy, also over an existing settings.json) or by update: present, it is only recorded;
absent, it is added; a rule the owner allows is reported, never added; a top-level key the
owner set to another value is kept and reported, never changed; a hook entry whose script is
not in .claude/hooks/ is reported and offered again; a settings.json that is a link, or lies
beyond one, is never written, and a link to a file inside the project is read, so only the
entries it lacks are named for adding by hand. An ask counts as allowed where an allow rule
is the same rule or, for mcp__S__T, is mcp__S, mcp__S__* or a tool-name glob after mcp__S__
that matches T: Claude Code takes the first of deny, ask and allow that matches, however
specific, so the ask would override the owner's allow. A deny counts as allowed only by the
same rule. The render record lists every entry offered
('settings: ' lines), so an entry the owner removed after it was offered stays removed. Where no record lists them (a project
older than the record, a fresh clone, a copy without tasks), an entry counts as offered when
any committed version of settings.json held it. Entries are inserted as text into the
owner's file, in its own indentation and line endings; the file is written only when
something is added; a file that is not plain JSON is reported and left alone; if the result
would not parse to exactly the planned settings, the file is rewritten as JSON in its own key
order and indentation, and the report line says so. Never removed, reordered or weakened.

MCP servers. Each server the data file's "mcp" lists is offered once to each listed file,
with the value the new render's file holds at that file's key path, by baseline and by
update. A file the new render lacks (its client is not recorded) or the project lacks is
never created or written; one the project holds although the answers do not name its client
gets one line. A file in conflict, a link, a path beyond a link and a file that is not
regular are never written: what can be read is read, so only the servers it lacks are named
for adding by hand, and they are offered again. A git-ignored file is never read: one line
names the servers to add by hand, and the offer is recorded. A file that does not parse is
reported, and its servers are offered again. A server already there by name is only
recorded; where its value differs, one line says so, once, naming the sibling template whose
recorded render holds that value. A missing server is added unless the record lists it as
offered or any commit of HEAD's history held it there (the owner removed it). JSON is
inserted into the owner's text as settings are, and must parse to the plan; TOML gets the new
render's [mcp_servers.<server>] tables appended (its env and tools tables included) and is
written only if the result parses to the owner's file plus exactly those servers, with no
rewrite fallback. Where the file's bytes equal a recorded render and the new render's file
parses to it plus exactly the servers offered, the new render's bytes are written instead.
opencode.json and .gemini/settings.json gain a server only once they hold, in the form the
permissions script writes there, every ask rule for its tools that the new render's or the
project's .claude/settings.json holds, so an allow written there before the server existed
never covers its tools; otherwise nothing is added or recorded there, and one line gives the
permissions script's --write command (as it does where this run added an mcp__ rule to
settings.json and a client file it writes exists).

The record lists every server offered ('mcp: <path> <server> <sha256 of the value offered,
as canonical JSON>' lines, after 'mcp-offered: <count>'; no such count means no record of MCP
offers) and every blob this script wrote to settings.json or an MCP file ('written-blob:
<path> <blob>' lines, carried from record to record, the last 50 kept; ' edited' at the end
where the file held the owner's edit before the write and does not parse equal to the new
render's after it; an older record's 'settings-blob: ' lines are read as settings.json's). A later update counts a file only the script changed as
written once, never as the owner's edit; a file the script changed in this run is classified
by its blob from before the change; and a JSON or TOML file it wrote that parses equal to the
new render's, list order apart, counts as delivered.
Nothing else of the owner's is ever written: not the work tree, the index or a branch. It
never commits and needs no network. The record holds no path of this machine (the rendered
answers file, which names the template's source, is left out of it).

The data file, migrations/family-refresh.json, is per template (each lists its own files),
but its format is shared by every template of the family:
  {"format": 1, "template": "<name in .copier-answers.<name>.yml>",
   "refresh": ["<project path>", ...],
   "settings": {"<top-level key>": <true, false, a number or a string>, ...,
                "hooks": {"<event>": [<entry exactly as settings.json holds it>, ...]},
                "permissions": {"deny": ["<rule>", ...], "ask": ["<rule>", ...]}},
   "mcp": {"servers": ["<name, [A-Za-z0-9_-]+>", ...],
           "files": {"<project path, no ..>": ["<key>", ...], ...}}}
A hook entry counts as present when an entry of the same event and matcher already runs every
hook script it names; a rule, when the same list already holds it; a top-level key, when the
owner's file holds the key at all (any value: one other than the template's is reported, once).
A record that lists no top-level value (written by an older script) leaves it to the committed
history, as where there is no record.
Every key of "settings" but hooks and permissions is a top-level value (an object, a list or
null there is ignored); a script older than this format reads only hooks and permissions, so it
ignores the top-level values and offers nothing for them.
"mcp" sits beside "settings", never inside it, and is optional. Its "files" maps each path to
the key path that holds the servers there; a path ending .toml is TOML, every other is JSON.
The values are read from the new render, never from the data file. A malformed "mcp" gives one
line and no MCP offer, and the rest of the run goes on. A script older than "mcp" ignores it.

SYNTEK_UPDATE_REPORT=off skips every render and prints only conflicts and deletions; it also
skips the refresh, the settings entries and the MCP servers, which the next update without it
then delivers (as it does after a render that failed). A .rej file counts as a conflict only
beside a template path and only where it is new or changed since HEAD.
The project must be its own git repository (not a folder inside one); otherwise nothing is
recorded, refreshed or added, and one line says so. A record is a commit whose message ends
with its 'commit: ' and 'answers: ' lines; any other commit at refs/<name>/template, and any
ref in a namespace of Git's own (refs/heads/template, say), is never read as one.
SYNTEK_UPDATE_COPIER names the command that renders (default: copier on PATH, then this
Python's copier module).

Python 3.11 or later, standard library and git only. Exit status: always 0, except a failing
--self-test. A non-zero exit would abort the update.
"""

import copy
import fnmatch
import hashlib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile

MAX_LIST = 25
GITCFG = ['-c', 'gc.auto=0', '-c', 'maintenance.auto=false', '-c', 'commit.gpgsign=false',
          '-c', 'core.quotepath=false']
IDENT = {'GIT_AUTHOR_NAME': 'family-update', 'GIT_AUTHOR_EMAIL': 'family-update@invalid',
         'GIT_COMMITTER_NAME': 'family-update', 'GIT_COMMITTER_EMAIL': 'family-update@invalid'}
SAFE = re.compile(r'[A-Za-z0-9._/@+-]+')
HOOK_SCRIPT = re.compile(r'\.claude/hooks/([A-Za-z0-9._-]+)')
SETTINGS = '.claude/settings.json'
REFRESH_DATA = 'migrations/family-refresh.json'
# Who relies on a top-level value, for the line that reports an owner's other value.
SETTING_USERS = {'autoCompactEnabled': 'the handoff hooks'}
# An MCP rule of .claude/settings.json, as the permissions script reads one: mcp__<server>__<tool>.
MCP_RULE = re.compile(r'mcp__([A-Za-z0-9_-]+?)__([A-Za-z0-9_-]+)')
MCP_NAME = re.compile(r'[A-Za-z0-9_-]+')
MCP_PATH = re.compile(r'[A-Za-z0-9._@+-]+(?:/[A-Za-z0-9._@+-]+)*')   # and no . or .. part
# The client files whose own permission rules the permissions script writes; a server reaches
# the first two only once they hold its ask rules (an earlier broad allow there would cover it).
PERMISSION_FILES = ('opencode.json', '.codex/config.toml', '.gemini/settings.json')
ASK_FORMS = ('opencode.json', '.gemini/settings.json')
RENDER = None   # replaced by the self-test


def off():
    return os.environ.get('SYNTEK_UPDATE_REPORT', '').strip().lower() == 'off'


def say(line):
    print('  family-update: ' + line, flush=True)


def git(*args, env=None, inp=None, check=True, binary=False, cwd=None):
    e = dict(os.environ)
    e.update(env or {})
    r = subprocess.run(['git', *GITCFG, *args], input=inp, capture_output=True, env=e,
                       text=not binary, cwd=cwd)
    if check and r.returncode != 0:
        err = r.stderr if not binary else r.stderr.decode('utf-8', 'replace')
        raise RuntimeError('git ' + ' '.join(args[:2]) + ': ' + err.strip())
    return r.stdout


def verify(rev, cwd=None):
    return git('rev-parse', '-q', '--verify', rev + '^{commit}', check=False, cwd=cwd).strip()


def q(p):
    return p if SAFE.fullmatch(p) else '"' + p.replace('\\', '\\\\').replace('"', '\\"') + '"'


# ── Rendering ────────────────────────────────────────────────────────────────

def copier_cmd():
    named = os.environ.get('SYNTEK_UPDATE_COPIER', '').strip()
    if named:
        return shlex.split(named)
    if shutil.which('copier'):
        return ['copier']
    return [sys.executable, '-m', 'copier']


def copier_render(src, ref, data, out):
    """copier copy at ref into out, copy semantics, no tasks. Returns '' or the reason."""
    env = dict(os.environ)
    n = int(env.get('GIT_CONFIG_COUNT', '0') or 0)
    env.update({'GIT_CONFIG_KEY_%d' % n: 'gc.auto', 'GIT_CONFIG_VALUE_%d' % n: '0',
                'GIT_CONFIG_KEY_%d' % (n + 1): 'maintenance.auto',
                'GIT_CONFIG_VALUE_%d' % (n + 1): 'false', 'GIT_CONFIG_COUNT': str(n + 2)})
    cmd = copier_cmd() + ['copy', '--trust', '--defaults', '--quiet', '--skip-tasks',
                          '--vcs-ref', ref, '--data-file', data, src, out]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, stdin=subprocess.DEVNULL, env=env)
    except OSError as err:
        return 'copier could not be run (%s)' % err.strerror
    if r.returncode != 0:
        lines = [l for l in (r.stderr or r.stdout).strip().splitlines() if l.strip()]
        return 'copier could not render %s (%s)' % (ref[:12], lines[-1].strip() if lines else 'exit %d' % r.returncode)
    return ''


def data_file(text, path):
    """The answers as a data file: Copier's own keys dropped, a missing client list empty."""
    lines = [l for l in text.splitlines() if not re.match(r'_[A-Za-z0-9_]*:', l)]
    if not any(re.match(r'AGENT_CLIENTS:', l) for l in lines):
        lines.append('AGENT_CLIENTS: []')
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(lines) + '\n')
    return path


def render_tree(src, ref, answers_text, gitdir, tmp, name):
    """Render ref with the answers, store it in the project's objects. Returns (tree, reason)."""
    out = os.path.join(tmp, name)
    data = data_file(answers_text, os.path.join(tmp, name + '.yml'))
    reason = (RENDER or copier_render)(src, ref, data, out)
    if reason:
        return None, reason
    # The rendered answers file holds the template's absolute source path; the record keeps
    # no path of this machine (the project's own answers file is the one that counts).
    for f in os.listdir(out):
        if f.startswith('.copier-answers.') and os.path.isfile(os.path.join(out, f)):
            os.remove(os.path.join(out, f))
    idx = os.path.join(tmp, name + '.index')
    env = {'GIT_DIR': gitdir, 'GIT_WORK_TREE': out, 'GIT_INDEX_FILE': idx}
    git('add', '-A', '--force', '.', env=env, cwd=out)
    return git('write-tree', env=env, cwd=out).strip(), ''


# ── The records ──────────────────────────────────────────────────────────────

def tree_map(treeish):
    out = {}
    if not treeish:
        return out
    for item in git('ls-tree', '-r', '-z', '--full-tree', treeish, check=False).split('\0'):
        if '\t' not in item:
            continue
        meta, path = item.split('\t', 1)
        mode, typ, sha = meta.split()
        if typ == 'blob':
            out[path] = (mode, sha)
    return out


RECORD_TAIL = re.compile(r'^commit: [0-9a-f]{7,64}\nanswers: [0-9a-f]{7,64}$', re.M)
# Git's own namespaces: a branch or tag called 'template' is never a template's record.
GIT_NAMESPACES = {'heads', 'tags', 'remotes', 'notes', 'stash', 'replace', 'bisect', 'worktree',
                  'rewritten', 'prefetch', 'original', 'changes', 'pull', 'merge-requests'}


def is_record(msg):
    """A render record's message ends with its 'commit: ' and 'answers: ' lines."""
    return bool(RECORD_TAIL.search(msg or ''))


def ref_info(ref):
    """The render record at ref, or None where ref is absent or not a render record."""
    sha = verify(ref)
    if not sha:
        return None
    msg = git('log', '-1', '--format=%B', sha)
    if not is_record(msg):
        return None
    info = dict(re.findall(r'^(commit|answers): (\S+)$', msg, re.M))
    info.update(sha=sha, tree=git('rev-parse', sha + '^{tree}').strip(),
                parent=verify(sha + '^'), msg=msg)
    return info


def record_chain(ref):
    """The commits of a chain of renders, newest first, stopping at the first that is not one."""
    out = []
    if not ref or not verify(ref):
        return out
    for chunk in git('log', '--first-parent', '--format=%H%x00%B%x1e', ref).split('\x1e'):
        chunk = chunk.lstrip('\n')
        if '\0' not in chunk:
            continue
        sha, msg = chunk.split('\0', 1)
        if not is_record(msg):
            break
        out.append(sha)
    return out


def history(ref, into=None):
    """Every blob each path has held in a chain of renders: {path: {blob, ...}}. Each tree
    is read whole (no rename detection), and the walk stops at a commit that is no record."""
    seen = into if into is not None else {}
    for sha in record_chain(ref):
        for p, (_, blob) in tree_map(sha).items():
            seen.setdefault(p, set()).add(blob)
    return seen


def union_history(*maps):
    """Several {path: {blob, ...}} maps as one."""
    out = {}
    for m in maps:
        for p, blobs in m.items():
            out.setdefault(p, set()).update(blobs)
    return out


def owner_held(p, yours):
    """True where the owner's committed history, or the tree at the last update, held p."""
    if p in yours:
        return True
    return bool(git('log', '-1', '--format=%H', 'HEAD', '--', ':(literal)' + p, check=False).strip())


def written_blobs(msg):
    """Every blob this script wrote, as a render record lists them: [(path, blob, edited)].
    edited: the file held the owner's edit before the write, so the blob is never the
    template's. An older record's 'settings-blob: ' lines are settings.json's."""
    out = []
    for line in (msg or '').splitlines():
        m = re.fullmatch(r'written-blob: (\S+) ([0-9a-f]{7,64})( edited)?', line)
        if m:
            out.append((m.group(1), m.group(2), bool(m.group(3))))
            continue
        m = re.fullmatch(r'settings-blob: ([0-9a-f]{7,64})', line)
        if m:
            out.append((SETTINGS, m.group(1), False))
    return out


def commit(tree, msg, ref=None, parent=None):
    sha = git('commit-tree', tree, *(['-p', parent] if parent else []), '-m', msg, env=IDENT).strip()
    if ref:
        git('update-ref', ref, sha)
    return sha


def beyond_link(p):
    """True where a folder on the path is a link: such a path is never read or written."""
    parts = p.split('/')[:-1]
    return any(os.path.islink('/'.join(parts[:i + 1])) for i in range(len(parts)))


def worktree(paths):
    """Blob ids of the work-tree files, clean filters applied: {path: blob} (absent: missing)."""
    out, files = {}, []
    for p in paths:
        if beyond_link(p):
            continue
        if os.path.islink(p):
            out[p] = git('hash-object', '-t', 'blob', '--stdin', inp=os.readlink(p)).strip()
        elif os.path.isfile(p):
            files.append(p)
    for i in range(0, len(files), 500):
        chunk = files[i:i + 500]
        shas = git('hash-object', '--stdin-paths', inp='\n'.join(chunk) + '\n').split()
        out.update(zip(chunk, shas))
    return out


def conflicts():
    unmerged = sorted({l.split('\t', 1)[1] for l in git('ls-files', '-u', '-z').split('\0') if '\t' in l})
    rej = []
    for root, dirs, files in os.walk('.', followlinks=False):
        dirs[:] = [d for d in dirs if d != '.git' and not os.path.islink(os.path.join(root, d))]
        rej += [os.path.relpath(os.path.join(root, f)).replace(os.sep, '/') for f in files if f.endswith('.rej')]
    return unmerged, sorted(rej)


def this_update_rej(rej, H, paths):
    """The .rej files this update left: beside a template path (paths: the old and new renders;
    None where neither is known, when a git-ignored one is dropped instead), and new or changed
    since HEAD, so a stale one committed earlier is not reported again."""
    if not rej:
        return []
    now = worktree(rej)
    keep = [r for r in rej if (paths is None or r[:-4] in paths)
            and not (H.get(r) and now.get(r) == H[r][1])]
    if paths is None and keep:
        ignored = set(git('check-ignore', '-z', '--stdin', inp='\0'.join(keep) + '\0', check=False).split('\0'))
        keep = [r for r in keep if r not in ignored]
    return keep


# ── The refresh ──────────────────────────────────────────────────────────────

def refresh_data(src, t):
    """The template's family-refresh.json, or None (missing, unreadable or the wrong shape)."""
    try:
        with open(os.path.join(src, REFRESH_DATA), encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        return None
    except (OSError, ValueError) as err:
        say('%s could not be read (%s): nothing refreshed.' % (REFRESH_DATA, err))
        return None
    settings = data.get('settings', {}) if isinstance(data, dict) else None
    lists = [settings.get('hooks', {}), settings.get('permissions', {})] if isinstance(settings, dict) else []
    shaped = (isinstance(data, dict) and data.get('format') == 1 and data.get('template') == t
              and isinstance(data.get('refresh', []), list)
              and all(isinstance(p, str) for p in data.get('refresh', []))
              and isinstance(settings, dict) and len(lists) == 2
              and all(isinstance(v, dict) and all(isinstance(x, list) for x in v.values()) for v in lists))
    if not shaped:
        say('%s is not format 1 for %s: nothing refreshed.' % (REFRESH_DATA, t))
        return None
    return data


def inside(p, root):
    real = os.path.realpath(p)
    return real == root or real.startswith(root + os.sep)


def is_hook(p):
    return p.startswith('.claude/hooks/') and p.endswith('.sh')


def write_blob(p, mode, sha):
    """Write a blob; a hook (or a file the render made executable) is left mode 755."""
    os.makedirs(os.path.dirname(p) or '.', exist_ok=True)
    data = git('cat-file', 'blob', sha, binary=True)
    with open(p, 'wb') as f:
        f.write(data)
    if is_hook(p) or mode == '100755':
        os.chmod(p, 0o755)
    else:
        os.chmod(p, os.stat(p).st_mode & ~0o111)


def refresh(paths, N, P, H, own, recorded, others, arrive, root, held):
    """Replace each listed shared file the owner had not changed; add each one the owner never
    had. own: every blob a render here held (the refresh test); recorded: the renders this
    template recorded before this run; held(p): the owner's committed history or the tree at
    the last update held p. A file the owner deleted therefore stays deleted, and one an update
    never wrote (a report switched off, a render that failed) arrives with the next full run.
    Returns (refreshed, added, failed), failed as 'path (reason)'."""
    done, added, failed = [], [], []
    for p in paths:
        n = N.get(p)
        if not n or n[0] not in ('100644', '100755') or beyond_link(p) or not inside(os.path.dirname(p) or '.', root):
            continue
        w, h = P.get(p), H.get(p)
        try:
            if w is not None:
                if os.path.islink(p) or not os.path.isfile(p) or w != (h[1] if h else None):
                    continue
                if w != n[1] and w in own.get(p, ()):
                    write_blob(p, n[0], n[1])
                    done.append(p)
            elif arrive and h is None and not os.path.lexists(p) and not recorded.get(p) \
                    and not any(o.get(p) for o in others.values()) and not held(p):
                write_blob(p, n[0], n[1])
                added.append(p)
        except OSError as err:
            failed.append('%s (%s)' % (p, err.strerror or err))
    return done, added, failed


def refresh_notes(t, done, added, failed):
    notes = []
    if done:
        notes.append('▸ %s: refreshed %d shared file%s you had not changed: %s' % (
            t, len(done), '' if len(done) == 1 else 's', ', '.join(done)))
    if added:
        notes.append('▸ %s: added %d shared file%s new in this version: %s' % (
            t, len(added), '' if len(added) == 1 else 's', ', '.join(added)))
    if failed:
        notes.append('▸ %s: could not write %d shared file%s, left as %s: %s' % (
            t, len(failed), '' if len(failed) == 1 else 's', 'it was' if len(failed) == 1 else 'they were',
            ', '.join(failed)))
    return notes


def hook_scripts(entry):
    return {m for h in (entry.get('hooks') or []) if isinstance(h, dict)
            for m in HOOK_SCRIPT.findall(str(h.get('command', '')))}


def has_hook(settings, event, entry):
    want, matcher = hook_scripts(entry), entry.get('matcher', '')
    hooks = settings.get('hooks') if isinstance(settings, dict) else None
    for e in ((hooks if isinstance(hooks, dict) else {}).get(event) or []):
        if isinstance(e, dict) and e.get('matcher', '') == matcher and want <= hook_scripts(e):
            return True
    return False


def is_scalar(v):
    return isinstance(v, (bool, int, float, str))


def same(a, b):
    """JSON equality: false is never 0, and 1 never true (a TOML date compares as its text)."""
    return json.dumps(a, sort_keys=True, default=str) == json.dumps(b, sort_keys=True, default=str)


def has_rule(settings, kind, rule):
    perms = settings.get('permissions') if isinstance(settings, dict) else None
    rules = (perms if isinstance(perms, dict) else {}).get(kind)
    return isinstance(rules, list) and rule in rules


def allow_covers(settings, item):
    """True where an allow rule of the owner's covers a deny or ask entry, which is then
    reported, never added. A deny is covered by the same rule only. An ask is also covered,
    for mcp__S__T, by mcp__S, mcp__S__* or a tool-name glob after mcp__S__ that matches T (the
    server part literal): Claude Code takes the first of deny, ask and allow that matches,
    however specific, so the ask would override that allow."""
    if has_rule(settings, 'allow', item[1]):
        return True
    m = MCP_RULE.fullmatch(item[1]) if item[0] == 'ask' else None
    if not m:
        return False
    server, tool = m.groups()
    perms = settings.get('permissions') if isinstance(settings, dict) else None
    allows = (perms if isinstance(perms, dict) else {}).get('allow')
    prefix = 'mcp__%s__' % server
    for rule in (allows if isinstance(allows, list) else []):
        if not isinstance(rule, str):
            continue
        if rule == 'mcp__' + server or (rule.startswith(prefix) and fnmatch.fnmatchcase(tool, rule[len(prefix):])):
            return True
    return False


def entry_id(item):
    """One line naming a settings entry, as the render record's 'settings:' lines hold it."""
    if item[0] == 'hook':
        _, event, entry = item
        what = ','.join(sorted(hook_scripts(entry))) or json.dumps(entry.get('hooks'), sort_keys=True)
        return 'hook %s %s %s' % (event, json.dumps(entry.get('matcher', '')), what)
    return '%s %s' % (item[0], item[1])


def read_json_blob(tree, path):
    sha = tree.get(path)
    if not sha:
        return {}
    try:
        v = json.loads(git('cat-file', 'blob', sha[1]))
        return v if isinstance(v, dict) else {}
    except ValueError:
        return {}


def committed_ids(items):
    """The ids of the items that any committed .claude/settings.json of HEAD's history held:
    entries the owner had, so one missing now was removed, not never added."""
    found = set()
    for sha in git('log', '--format=%H', 'HEAD', '--', SETTINGS, check=False).split()[:200]:
        try:
            st = json.loads(git('show', '%s:%s' % (sha, SETTINGS), check=False) or 'null')
        except ValueError:
            continue
        if isinstance(st, dict):
            found |= {entry_id(i) for i in items if present(st, i)}
    return found


def present(settings, item):
    if item[0] == 'setting':
        return isinstance(settings, dict) and item[1] in settings
    return has_hook(settings, item[1], item[2]) if item[0] == 'hook' else has_rule(settings, item[0], item[1])


# ── Adding to settings.json, the owner's text kept ──────────────────────────
# The file is parsed once more with every value's span, and each entry is inserted as text
# beside its neighbours, in the indentation and line ending the file already uses. The
# result must parse to exactly the planned settings; if it does not, the file is rewritten
# as JSON in its own key order and indentation, and the report line says so.

_WS = re.compile(r'[ \t\n\r]*')
_DEC = json.JSONDecoder()


def _span(s, i):
    i = _WS.match(s, i).end()
    c = s[i:i + 1]
    if c in ('{', '['):
        node, close = {'t': c, 's': i, 'items': []}, '}' if c == '{' else ']'
        i = _WS.match(s, i + 1).end()
        if s[i:i + 1] == close:
            node['e'] = i + 1
            return node, i + 1
        while True:
            i = _WS.match(s, i).end()
            if c == '{':
                if s[i:i + 1] != '"':
                    raise ValueError('a key expected at %d' % i)
                ks = i
                key, j = json.decoder.scanstring(s, i + 1)
                j = _WS.match(s, j).end()
                if s[j:j + 1] != ':':
                    raise ValueError('a colon expected at %d' % j)
                val, i = _span(s, j + 1)
                node['items'].append((key, val, ks))
            else:
                val, i = _span(s, i)
                node['items'].append(val)
            i = _WS.match(s, i).end()
            if s[i:i + 1] == ',':
                i += 1
                continue
            if s[i:i + 1] == close:
                node['e'] = i + 1
                return node, i + 1
            raise ValueError('a comma or %s expected at %d' % (close, i))
    val, j = _DEC.raw_decode(s, i)
    return {'t': 'v', 's': i, 'e': j}, j


def _member(node, key):
    for k, val, _ in reversed(node['items']):
        if k == key:
            return val
    return None


def _style(s):
    """(indent unit or None for a one-line file, line ending)."""
    nl = '\r\n' if '\r\n' in s else '\n'
    m = re.search(r'\n([ \t]+)\S', s)
    return (m.group(1) if m else None), nl


def _line_indent(s, pos):
    start = s.rfind('\n', 0, pos) + 1
    return re.match(r'[ \t]*', s[start:]).group(0)


def _dump(value, base, unit, nl):
    if unit is None:
        return json.dumps(value, ensure_ascii=False)
    return json.dumps(value, indent=unit, ensure_ascii=False).replace('\n', nl + base)


def _insert(s, node, piece, unit, nl):
    """piece(base) → the text of one new member or element; returns the new text."""
    first = node['items'][0] if node['items'] else None
    if first is not None:
        first_at = first[2] if node['t'] == '{' else first['s']
        lead = s[node['s'] + 1:first_at]
        last = node['items'][-1][1] if node['t'] == '{' else node['items'][-1]
        if '\n' in lead:
            base = lead[lead.rfind('\n') + 1:]
            return s[:last['e']] + ',' + nl + base + piece(base, unit) + s[last['e']:]
        return s[:last['e']] + ', ' + piece('', None) + s[last['e']:]
    if unit is None:
        return s[:node['s'] + 1] + piece('', None) + s[node['e'] - 1:]
    base = _line_indent(s, node['s'])
    return s[:node['s'] + 1] + nl + base + unit + piece(base + unit, unit) + nl + base + s[node['e'] - 1:]


def _add_text(s, path, value, unit, nl):
    """Add value at path (a list of keys; the last a key to create or a list to append to)."""
    root, end = _span(s, 0)
    if s[_WS.match(s, end).end():].strip():
        raise ValueError('text after the JSON value')
    node = root
    for depth, key in enumerate(path):
        if node['t'] != '{':
            raise ValueError('not an object at ' + '.'.join(path[:depth]))
        child = _member(node, key)
        if child is None:
            rest = value
            for k in reversed(path[depth + 1:]):
                rest = {k: rest}
            return _insert(s, node, lambda base, u, k=key, v=rest: json.dumps(k, ensure_ascii=False) + ': ' + _dump(v, base, u, nl), unit, nl)
        node = child
    if node['t'] != '[':
        raise ValueError('not a list at ' + '.'.join(path))
    item = value[0]
    return _insert(s, node, lambda base, u: _dump(item, base, u, nl), unit, nl)


def _add_obj(obj, path, value):
    """A null on the path counts as absent (the text insertion then fails, and the file is
    rewritten as JSON, reported)."""
    for key in path[:-1]:
        if obj.get(key) is None:
            obj[key] = {}
        obj = obj[key]
    if obj.get(path[-1]) is None:
        obj[path[-1]] = []
    obj[path[-1]].extend(json.loads(json.dumps(value)))


def settings_merge(data, N, offered, skip):
    """Add the settings entries the template offers and this project was never offered.

    data: the template's family-refresh.json; N: the new render; offered: the ids recorded as
    offered before (None: no record, so the committed history of settings.json decides).
    Returns (report lines, the ids now offered)."""
    want = data.get('settings') or {}
    new = read_json_blob(N, SETTINGS) if SETTINGS in N else None
    if not want or new is None:
        return [], set(offered or ())
    items = [('hook', event, entry) for event, entries in sorted((want.get('hooks') or {}).items())
             for entry in (entries or []) if isinstance(entry, dict) and has_hook(new, event, entry)]
    items += [(kind, rule) for kind in ('deny', 'ask') for rule in ((want.get('permissions') or {}).get(kind) or [])
              if has_rule(new, kind, rule)]
    items += [('setting', key, value) for key, value in sorted(want.items()) if key not in ('hooks', 'permissions')
              and is_scalar(value) and isinstance(new, dict) and key in new and same(new[key], value)]
    seen = set(offered) if offered is not None else committed_ids(items)
    if offered is not None:
        # A record written by a script older than top-level values never lists them: the
        # committed history then decides, so a key the owner deleted is not added back.
        late = [i for i in items if i[0] == 'setting' and entry_id(i) not in seen]
        seen |= committed_ids(late) if late else set()
    # The history only stops a top-level value being added back; an owner's other value that no
    # record lists as offered is still reported, once.
    history_only = {entry_id(i) for i in items if i[0] == 'setting' and entry_id(i) in seen
                    and entry_id(i) not in (offered or ())}
    pending = [i for i in items if entry_id(i) not in seen or entry_id(i) in history_only]
    # An early return records no history-only value: the first run that can read the file
    # reports it.
    if not pending or SETTINGS in skip or not os.path.lexists(SETTINGS):
        # Nothing new; a conflict in the file (reported there); or the owner has none.
        return [], seen - history_only
    why = ('lies beyond a link' if beyond_link(SETTINGS) else 'is a link' if os.path.islink(SETTINGS)
           else 'is not a regular file' if not os.path.isfile(SETTINGS) else '')
    if why:
        # Never written through a link; offered again once it is a plain file. A link whose
        # target is a file inside the project is read, never written.
        raw = None
        if why == 'is a link' and os.path.isfile(SETTINGS) and inside_project(SETTINGS):
            with open(SETTINGS, 'rb') as f:
                raw = f.read()
        return settings_unwritable('%s %s' % (SETTINGS, why), pending, raw, seen - history_only, history_only)
    with open(SETTINGS, 'rb') as f:
        raw = f.read()
    bom = b'\xef\xbb\xbf' if raw.startswith(b'\xef\xbb\xbf') else b''
    try:
        text = raw[len(bom):].decode('utf-8')
        cur = json.loads(text)
    except ValueError:
        cur = None
    if not isinstance(cur, dict):
        return settings_unwritable('%s is not plain JSON' % SETTINGS, pending, raw, seen - history_only, history_only)
    # A hook entry is added only beside its script: one the owner removed, or that could not be
    # written, is reported and offered again by the next update.
    missing = [i for i in pending if i[0] == 'hook' and not present(cur, i)
               and any(not os.path.isfile('.claude/hooks/' + s) for s in hook_scripts(i[2]))]
    pending = [i for i in pending if i not in missing]
    unwired = ['▸ not added to %s, because its script is not in .claude/hooks/ (it is offered again by the next update): %s' % (
        SETTINGS, '; '.join(describe(i) for i in missing))] if missing else []
    plan, added, allowed, refused, kept = json.loads(text), [], [], [], []
    ops = []
    for i in pending:
        seen.add(entry_id(i))
        if i[0] == 'setting':
            if i[1] in plan:
                if not same(plan[i[1]], i[2]):
                    kept.append(i)
                continue
            if entry_id(i) in history_only:
                continue
            plan[i[1]] = i[2]
            ops.append(([i[1]], i[2]))
            added.append(describe(i))
            continue
        if present(plan, i):
            continue
        if i[0] == 'hook':
            path, value = ['hooks', i[1]], [i[2]]
        elif allow_covers(plan, i):
            allowed.append(describe(i))
            continue
        else:
            path, value = ['permissions', i[0]], [i[1]]
        holder = plan
        ok = True
        for key in path[:-1]:
            holder = holder.get(key) if isinstance(holder, dict) else None
            ok = ok and (holder is None or isinstance(holder, dict))
        last = holder.get(path[-1]) if isinstance(holder, dict) else None
        if not ok or (last is not None and not isinstance(last, list)):
            refused.append(describe(i) + ' (its place in the file is not a list)')
            continue
        _add_obj(plan, path, value)
        ops.append((path, value))
        added.append(describe(i))
    lines = []
    if ops:
        unit, nl = _style(text)
        if unit is None and not cur:
            unit = '  '
        out, how = text, ''
        try:
            for path, value in ops:
                out = _add_text(out, path, value, unit, nl)
            if json.loads(out) != plan:
                raise ValueError('the text did not parse to the plan')
        except (ValueError, IndexError, KeyError):
            out = json.dumps(plan, indent=unit if unit is not None else 2, ensure_ascii=False).replace('\n', nl)
            out += nl if text.endswith(('\n', '\r')) else ''
            how = ' (the file was rewritten as JSON, its key order and indentation kept, because the entries could not be inserted into its text)'
        with open(SETTINGS, 'wb') as f:
            f.write(bom + out.encode('utf-8'))
        lines.append('▸ added to %s%s: %s' % (SETTINGS, how, '; '.join(added)))
    if allowed:
        lines.append('▸ not added to %s, because you allow it: %s' % (SETTINGS, '; '.join(allowed)))
    if refused:
        lines.append('▸ not added to %s: %s' % (SETTINGS, '; '.join(refused)))
    lines += [kept_line(i, plan[i[1]]) for i in kept]
    return lines + unwired, seen


def kept_line(item, value):
    """The one line for an owner's top-level value other than the one offered."""
    return '▸ kept your %s in %s: %s assume %s; set it to %s in %s to use them.' % (
        describe((item[0], item[1], value)), SETTINGS, SETTING_USERS.get(item[1], 'the shared files'),
        json.dumps(item[2]), json.dumps(item[2]), SETTINGS)


def inside_project(p):
    """True where the path resolves to a place inside the project (the working folder)."""
    root = os.path.realpath('.')
    return os.path.realpath(p).startswith(root + os.sep)


def settings_unwritable(what, pending, raw, seen, history_only):
    """settings.json cannot be written (a link, or not plain JSON). What it holds is read where
    it can be, so the 'add by hand' line names only entries really missing, an owner's other
    top-level value is reported once instead, and a value the owner removed is never named.
    raw: the file's bytes, or None where it is not read. Returns (report lines, ids offered)."""
    try:
        text = raw.decode('utf-8-sig') if raw is not None else None
    except ValueError:
        text = None
    try:
        cur = json.loads(text) if text is not None else None
    except ValueError:
        cur = None
    seen, lines, hand = set(seen), [], []
    for i in pending:
        if isinstance(cur, dict) and present(cur, i):
            seen.add(entry_id(i))
            if i[0] == 'setting' and not same(cur[i[1]], i[2]):
                lines.append(kept_line(i, cur[i[1]]))
            continue
        if i[0] == 'setting' and not isinstance(cur, dict) and text is not None:
            # Not plain JSON (comments, say): the key's own value, where one can be found.
            m = re.search(r'"%s"\s*:\s*(true|false|null|-?[0-9][0-9.eE+-]*|"(?:[^"\\]|\\.)*")' % re.escape(i[1]), text)
            if m:
                seen.add(entry_id(i))
                try:
                    v = json.loads(m.group(1))
                except ValueError:
                    v = m.group(1)
                if not same(v, i[2]):
                    lines.append(kept_line(i, v))
                continue
        if entry_id(i) in history_only:
            # The owner removed it: never named for adding; recorded once the file is read.
            if isinstance(cur, dict):
                seen.add(entry_id(i))
            continue
        hand.append(i)
    if hand:
        lines.append('▸ %s, so these entries were not added (add them by hand): %s' % (
            what, '; '.join(describe(i) for i in hand)))
    return lines, seen


def describe(item):
    if item[0] == 'setting':
        return '%s: %s' % (json.dumps(item[1]), json.dumps(item[2], ensure_ascii=False))
    if item[0] == 'hook':
        m = item[2].get('matcher')
        return 'the %s%s hook for %s' % (item[1], ' (%s)' % m if m else '', ', '.join(sorted(hook_scripts(item[2]))) or '?')
    return '%s %s' % item


def offered_ids(msg):
    """The ids a render record's message lists as offered, or None when it lists none."""
    if not msg or not re.search(r'^settings-offered: ', msg, re.M):
        return None
    return {l[len('settings: '):] for l in msg.splitlines() if l.startswith('settings: ')}


def record_tail(to, answers_blob, ids, blobs=(), mcp=None):
    """The record's tail: what it renders, the settings entries and MCP servers offered (mcp:
    {(path, server): hash}, or None where no record of MCP offers exists yet), and every blob
    this script wrote here (carried from record to record): one the owner had not edited
    before the write counts as the template's on a later update, never as the owner's."""
    kept = list(dict.fromkeys((p, b, bool(e)) for p, b, e in blobs))[-50:]
    tail = '\n\ncommit: %s\nanswers: %s\nsettings-offered: %d\n%s' % (
        to, answers_blob, len(ids), ''.join('settings: %s\n' % i for i in sorted(ids)))
    if mcp is not None:
        tail += 'mcp-offered: %d\n%s' % (len(mcp), ''.join(
            'mcp: %s %s %s\n' % (p, s, h) for (p, s), h in sorted(mcp.items())))
    return tail + ''.join('written-blob: %s %s%s\n' % (p, b, ' edited' if e else '') for p, b, e in kept)


def canon(v):
    """JSON (or parsed TOML) compared by meaning: list order ignored."""
    if isinstance(v, dict):
        return {k: canon(x) for k, x in v.items()}
    if isinstance(v, list):
        return sorted((canon(x) for x in v), key=lambda x: json.dumps(x, sort_keys=True, default=str))
    return v


def settings_wrote(lines):
    """The blob of settings.json where the merge just wrote it, else None."""
    if not any(re.match(r'▸ added to ', l) for l in lines):
        return None
    return worktree([SETTINGS]).get(SETTINGS)


# ── MCP servers, added to the owner's own files ─────────────────────────────
# family-refresh.json's "mcp" names the servers and, for each file, the key path that holds
# them. Each server is offered once to each listed file that the new render holds and the
# project already has, with the value the new render holds there; nothing is ever created,
# replaced or removed. JSON is inserted as settings entries are; TOML has the new render's
# tables appended, and is written only where the result parses to exactly the plan.

def _toml():
    import tomllib   # Python 3.11: imported here, so an older Python still reaches its one line
    return tomllib


def mcp_data(data):
    """((servers, {path: key path}), '') from the data file's "mcp"; (None, '') where it has
    none; (None, one line) where it cannot be read, so the lane is skipped, never the run."""
    m = data.get('mcp') if isinstance(data, dict) else None
    if m is None:
        return None, ''
    servers = m.get('servers') if isinstance(m, dict) else None
    files = m.get('files') if isinstance(m, dict) else None
    ok = (isinstance(servers, list) and isinstance(files, dict) and len(set(map(str, servers))) == len(servers)
          and all(isinstance(s, str) and MCP_NAME.fullmatch(s) for s in servers)
          and all(isinstance(p, str) and MCP_PATH.fullmatch(p) and not set(p.split('/')) & {'.', '..'}
                  and isinstance(k, list) and k and all(isinstance(x, str) and x for x in k)
                  for p, k in files.items()))
    if not ok:
        return None, '▸ the "mcp" key of %s is not in the shape this script reads, so no MCP server was offered.' % REFRESH_DATA
    return (list(servers), dict(files)), ''


def offered_mcp(msg):
    """{(path, server): hash} a render record lists as offered, or None where it lists none."""
    if not msg or not re.search(r'^mcp-offered: \d+$', msg, re.M):
        return None
    return {(p, s): h for p, s, h in re.findall(r'^mcp: (\S+) (\S+) ([0-9a-f]{64})$', msg, re.M)}


def value_hash(v):
    return hashlib.sha256(json.dumps(v, sort_keys=True, separators=(',', ':'), ensure_ascii=False,
                                     default=str).encode('utf-8')).hexdigest()


def parse_bytes(path, raw):
    """A JSON or TOML file's value (TOML where the path ends .toml), or None where it does not
    parse. A byte-order mark is ignored."""
    if raw is None:
        return None
    try:
        text = raw.decode('utf-8-sig')
        return _toml().loads(text) if path.endswith('.toml') else json.loads(text)
    except ValueError:   # a decoding, JSON or TOML error
        return None


_PARSED = {}


def blob_value(sha, path):
    """parse_bytes of a blob, read once per run."""
    if (sha, path) not in _PARSED:
        _PARSED[(sha, path)] = parse_bytes(path, git('cat-file', 'blob', sha, check=False, binary=True))
    return _PARSED[(sha, path)]


def servers_at(value, keys):
    """('ok', the object at the key path), ('missing', None) where a key on it is absent (it
    can be created), or ('bad', None) where a node on it is not an object."""
    node = value
    for k in keys:
        if not isinstance(node, dict):
            return 'bad', None
        if k not in node:
            return 'missing', None
        node = node[k]
    return ('ok', node) if isinstance(node, dict) else ('bad', None)


def ignored(p):
    """True where git ignores p (such a file is never read), False where it does not, None
    where git cannot tell."""
    r = subprocess.run(['git', *GITCFG, 'check-ignore', '-q', '--', p], capture_output=True)
    return True if r.returncode == 0 else False if r.returncode == 1 else None


def committed_servers(path, keys, servers):
    """The servers any commit of HEAD's history held at the key path of path: ones the owner
    had, so one missing now was removed, never to be added back."""
    found = set()
    for sha in git('log', '--format=%H', 'HEAD', '--', ':(literal)' + path, check=False).split()[:200]:
        st, node = servers_at(parse_bytes(path, git('show', '%s:%s' % (sha, path), check=False, binary=True)), keys)
        if st == 'ok':
            found |= {s for s in servers if s in node}
        if found >= set(servers):
            break
    return found


def project_asks(N):
    """The ask rules a client file must hold, in its own form, before a server is added there:
    every ask of the new render's settings.json and of the project's as it stands now (which
    the permissions script maps), so a broad allow written in that file before the server
    existed never covers a tool the update brings in, whatever the project's settings.json
    allows or has lost."""
    out = []
    mine = None
    if not beyond_link(SETTINGS) and os.path.isfile(SETTINGS) and (not os.path.islink(SETTINGS) or inside_project(SETTINGS)):
        try:
            with open(SETTINGS, 'rb') as f:
                mine = json.loads(f.read().decode('utf-8-sig'))
        except (OSError, ValueError):
            mine = None
    for v in (read_json_blob(N, SETTINGS), mine):
        perms = v.get('permissions') if isinstance(v, dict) else None
        asks = perms.get('ask') if isinstance(perms, dict) else None
        out += [a.strip() for a in asks if isinstance(a, str)] if isinstance(asks, list) else []
    return list(dict.fromkeys(out))


def missing_forms(path, cur, server, asks):
    """The tools of server whose ask rule, in the form the permissions script writes into
    opencode.json or .gemini/settings.json, the file does not hold yet."""
    tools = [m.group(2) for m in (MCP_RULE.fullmatch(a) for a in asks) if m and m.group(1) == server]
    if path == 'opencode.json':
        rules = cur.get('permissions') if isinstance(cur, dict) else None
        rules = rules if isinstance(rules, list) else []
        return [t for t in tools if not any(
            isinstance(r, dict) and r.get('action') == '%s_%s' % (server, t) and r.get('resource') == '*'
            and r.get('effect') in ('ask', 'deny') for r in rules)]
    if path == '.gemini/settings.json':
        if '_' in server:   # not expressible there, so the permissions script writes nothing
            return []
        tools_key = cur.get('tools') if isinstance(cur, dict) else None
        listed = tools_key.get('confirmationRequired') if isinstance(tools_key, dict) else None
        listed = listed if isinstance(listed, list) else []
        return [t for t in tools if 'mcp_%s_%s' % (server, t) not in listed]
    return []


_TOML_HEADER = re.compile(r'[ \t]*(\[\[?)([^\[\]#]+)\]\]?[ \t]*(?:#.*)?')


def _toml_blocks(text, server):
    """The new render's tables of one server: [mcp_servers.<server>] and every table under
    it, each from its header to the line before the next header, trailing blank lines and
    comments dropped. Returns a list of line lists."""
    tl, out, cur = _toml(), [], None
    for line in text.splitlines():
        m = _TOML_HEADER.fullmatch(line)
        if not m:
            if cur is not None:
                cur.append(line)
            continue
        cur, path = None, []
        if m.group(1) == '[':
            try:
                node = tl.loads('[%s]\n' % m.group(2))
            except ValueError:
                node = None
            while isinstance(node, dict) and len(node) == 1:
                k = next(iter(node))
                path.append(k)
                node = node[k]
        if path[:2] == ['mcp_servers', server]:
            cur = [line]
            out.append(cur)
    for b in out:
        while len(b) > 1 and (not b[-1].strip() or b[-1].lstrip().startswith('#')):
            b.pop()
    return out


def _toml_append(text, blocks, nl):
    """The owner's text, a final line ending added where missing and one blank line, then the
    tables, in the owner's line ending."""
    body = (nl + nl).join(nl.join(b) for b in blocks) + nl
    if not text.strip():
        return text + body
    head = text if text.endswith(('\n', '\r')) else text + nl
    blank = head.splitlines()[-1].strip() == ''
    return head + ('' if blank else nl) + body


def mcp_differs(path, keys, server, value, others, t):
    """The one line for a server the owner holds with another value than the one offered."""
    cmp = 'compare: git diff %s/template -- %s' % (t, q(path))
    for name in sorted(others):
        for b in sorted(others[name].get(path, ())):
            st, node = servers_at(blob_value(b, path), keys)
            if st == 'ok' and server in node and same(node[server], value):
                return "▸ %s holds %s's version of the %s MCP server, which is kept (%s)" % (
                    path, name, json.dumps(server), cmp)
    return "▸ kept your %s MCP server in %s, which differs from the template's (%s)" % (json.dumps(server), path, cmp)


def mcp_merge(spec, N, offered, skip, rendered, others, t):
    """Offer each MCP server to each file, once. spec: (servers, {path: key path}); N: the new
    render; offered: {(path, server): hash} recorded before, or None; skip: paths in conflict;
    rendered: every blob a render here held, by path (where the file still equals one, the
    new render's bytes may be taken); others: the sibling templates' render histories.
    Returns (lines, {(path, server): hash} now offered, [(path, blob before, blob after)]
    written, {path: [server, ...]} held back for their ask rules)."""
    servers, files = spec
    seen, lines, writes, held, asks = dict(offered or {}), [], [], {}, None
    for path, keys in files.items():
        n = N.get(path)
        if not n:
            if os.path.lexists(path):
                lines.append('▸ %s exists but the recorded answers do not name its client, so no MCP server was offered to it' % path)
            continue
        if not os.path.lexists(path) or path in skip:
            continue   # never created; a conflict is in the report and offered again
        st, node = servers_at(blob_value(n[1], path), keys)
        offers = {s: node[s] for s in servers if st == 'ok' and s in node}
        todo = [s for s in servers if s in offers and (path, s) not in seen]
        if not todo:
            continue
        hashes = {s: value_hash(offers[s]) for s in todo}
        hand = 'add them by hand; git show %s/template:%s shows them' % (t, q(path))
        if beyond_link(path):
            lines.append('▸ %s lies beyond a link, so these MCP servers were not added (%s): %s' % (path, hand, ', '.join(todo)))
            continue
        ig = ignored(path)
        if ig is not False:
            if ig:   # never read: the servers are named once, and recorded as offered
                seen.update({(path, s): hashes[s] for s in todo})
            lines.append('▸ %s %s, so it was not read and no MCP server was added to it (%s): %s' % (
                path, 'is ignored by git' if ig else 'could not be checked against the ignore rules', hand, ', '.join(todo)))
            continue
        why, raw = '', None
        if os.path.islink(path):
            why = 'is a link'
            if os.path.isfile(path) and inside_project(path):
                with open(path, 'rb') as f:
                    raw = f.read()
        elif not os.path.isfile(path):
            why = 'is not a regular file'
        else:
            with open(path, 'rb') as f:
                raw = f.read()
        toml = path.endswith('.toml')
        cur = parse_bytes(path, raw)
        if why or not isinstance(cur, dict):
            # Read only (a link inside the project), or not plain JSON or TOML: the servers it
            # plainly holds are recorded; the rest are named, and offered again.
            have = []
            if isinstance(cur, dict):
                cst, cnode = servers_at(cur, keys)
                have = [s for s in todo if cst == 'ok' and s in cnode]
                lines += [mcp_differs(path, keys, s, cnode[s], others, t) for s in have if not same(cnode[s], offers[s])]
            elif raw is not None:
                text = raw.decode('utf-8', 'replace')
                have = [s for s in todo if re.search(
                    r'(^|[{,\s.\[])["\']?%s["\']?\s*(:|=|\]|\.)' % re.escape(s), text, re.M)]
            seen.update({(path, s): hashes[s] for s in have})
            rest = [s for s in todo if s not in have]
            if rest:
                lines.append('▸ %s %s, so these MCP servers were not added (%s): %s' % (
                    path, why or ('is not plain TOML' if toml else 'is not plain JSON'), hand, ', '.join(rest)))
            continue
        cst, cnode = servers_at(cur, keys)
        if cst == 'bad':
            seen.update({(path, s): hashes[s] for s in todo})
            lines.append('▸ not added to %s, because its %s is not an object (%s): %s' % (
                path, '.'.join(keys), hand, ', '.join(todo)))
            continue
        present = [s for s in todo if cst == 'ok' and s in cnode]
        for s in present:
            seen[(path, s)] = hashes[s]
            if not same(cnode[s], offers[s]):
                lines.append(mcp_differs(path, keys, s, cnode[s], others, t))
        absent = [s for s in todo if s not in present]
        gone = committed_servers(path, keys, absent) if absent else set()
        seen.update({(path, s): hashes[s] for s in gone})   # removed by the owner: never re-added
        add = [s for s in absent if s not in gone]
        if add and path in ASK_FORMS:
            if asks is None:
                asks = project_asks(N)
            lacking = [s for s in add if missing_forms(path, cur, s, asks)]
            if lacking:
                held[path] = lacking   # not recorded: offered again once the file holds them
                add = [s for s in add if s not in lacking]
        if not add:
            continue
        plan = copy.deepcopy(cur)
        holder = plan
        for k in keys:
            holder = holder.setdefault(k, {})
        for s in add:
            holder[s] = copy.deepcopy(offers[s])
        before = worktree([path]).get(path)
        bom = b'\xef\xbb\xbf' if raw.startswith(b'\xef\xbb\xbf') else b''
        text = raw[len(bom):].decode('utf-8')
        how = ''
        if before in rendered.get(path, ()) and same(blob_value(n[1], path), plan):
            out = git('cat-file', 'blob', n[1], binary=True)   # unedited: the new render's own bytes
        elif toml:
            nl = '\r\n' if '\r\n' in text else '\n'
            new_text = git('cat-file', 'blob', n[1], binary=True).decode('utf-8-sig')
            blocks = [b for s in add for b in _toml_blocks(new_text, s)]
            result = _toml_append(text, blocks, nl)
            if parse_bytes(path, result.encode('utf-8')) is None or not same(_toml().loads(result), plan):
                seen.update({(path, s): hashes[s] for s in add})
                lines.append('▸ not added to %s, because appending their tables would not leave exactly your file '
                             'plus the servers (an inline or dotted mcp_servers, say; %s): %s' % (path, hand, ', '.join(add)))
                continue
            out = bom + result.encode('utf-8')
        else:
            unit, nl = _style(text)
            if unit is None and not cur:
                unit = '  '
            result = text
            try:
                for s in add:
                    result = _add_text(result, keys + [s], offers[s], unit, nl)
                if json.loads(result) != plan:
                    raise ValueError('the text did not parse to the plan')
            except (ValueError, IndexError, KeyError):
                result = json.dumps(plan, indent=unit if unit is not None else 2, ensure_ascii=False).replace('\n', nl)
                result += nl if text.endswith(('\n', '\r')) else ''
                how = ' (the file was rewritten as JSON, its key order and indentation kept, because the servers could not be inserted into its text)'
            out = bom + result.encode('utf-8')
        try:
            with open(path, 'wb') as f:
                f.write(out)
        except OSError as err:
            lines.append('▸ could not write %s (%s), so these MCP servers were not added: %s' % (
                path, err.strerror or err, ', '.join(add)))
            continue
        writes.append((path, before, worktree([path]).get(path)))
        seen.update({(path, s): hashes[s] for s in add})
        lines.append('▸ added %d MCP server%s to %s%s: %s' % (len(add), '' if len(add) == 1 else 's', path, how, ', '.join(add)))
    return lines, seen, writes, held


def mcp_lane(data, N, offered, skip, rendered, others, t, settings_lines):
    """The MCP lane of one run, with its one line for the permissions script. Returns (lines,
    the offers to record, the writes); without an "mcp" key, the offers recorded before."""
    spec, bad = mcp_data(data)
    if spec is None:
        return ([bad] if bad else []), offered, []
    lines, seen, writes, held = mcp_merge(spec, N, offered, skip, rendered, others, t)
    rules = any(l.startswith('▸ added to %s' % SETTINGS) and re.search(r'\b(ask|deny) mcp__', l) for l in settings_lines)
    have = [p for p in PERMISSION_FILES if os.path.lexists(p)]
    if held or (rules and have):
        files = have or list(held)
        line = '▸ to carry the new ask and deny rules into %s, run: python3 .claude/%s-permissions.py --write' % (
            ' and '.join([', '.join(files[:-1]), files[-1]]) if len(files) > 1 else files[0], t)
        if held:
            line += ('; the next update then adds the MCP servers to each file that holds their ask rules '
                     '(held back now: %s)') % '; '.join(
                '%s %s' % (p, ', '.join(s)) for p, s in held.items())
        lines.append(line)
    return lines, seen, writes


def delivered(N, path):
    """True where the project's file, parsed (JSON, or TOML for .toml), equals the new
    render's, list order apart."""
    if path not in N or os.path.islink(path) or not os.path.isfile(path) or beyond_link(path):
        return False
    try:
        with open(path, 'rb') as f:
            mine = parse_bytes(path, f.read())
    except OSError:
        return False
    theirs = blob_value(N[path][1], path)
    return mine is not None and theirs is not None and same(canon(mine), canon(theirs))


# ── The report ───────────────────────────────────────────────────────────────

def classify(N, O, P, H, own, others, skip):
    g = {k: [] for k in ('edit', 'sibling', 'once', 'new_here', 'not_restored', 'new_absent', 'lost')}
    counts = {'changed': 0, 'delivered': 0, 'merged': 0}
    for p in sorted(set(N) | set(O)):
        if os.path.basename(p).startswith('.copier-answers.') or p.endswith('.rej'):
            continue
        n, o, w, h = N.get(p), O.get(p), P.get(p), H.get(p)
        if (n and o and n[1] == o[1]) or (not n and not o):
            continue
        counts['changed'] += 1
        if p in skip:
            continue
        if n:
            if w == n[1]:
                counts['delivered'] += 1
            elif w is None:
                if h is None:
                    g['not_restored' if o else 'new_absent'].append(p)
            elif h and w != h[1]:
                counts['merged'] += 1
            elif o is None:
                g['new_here'].append(p)
            elif w == o[1] or w in own.get(p, ()):
                g['once'].append(p)
            else:
                sib = next((name for name, hist in sorted(others.items()) if w in hist.get(p, ())), None)
                if sib:
                    g['sibling'].append((p, sib))
                else:
                    g['edit'].append(p)
        elif w is None and h and h[1] != o[1]:
            g['lost'].append(p)
        else:
            counts['delivered'] += 1
    return g, counts


def section(lines, cap, title, entries, cmds):
    if not entries:
        return
    lines += ['', '  %s (%d):' % (title, len(entries))]
    for e in entries[:cap]:
        p = e[0] if isinstance(e, tuple) else e
        lines.append('    ' + p)
        lines += ['        ' + c for c in cmds(p)]
    if len(entries) > cap:
        lines.append('    … and %d more (this report again: see the last line)' % (len(entries) - cap))


def body(t, g, unmerged, rej, deleted_unknown, cap):
    T, Y = t + '/template', t + '/yours'
    L = []
    section(L, cap, 'CONFLICT: both versions are in the file between <<<<<<< and >>>>>>>; resolve it, then git add',
            unmerged, lambda p: ['compare: git diff %s %s -- %s' % (T, Y, q(p)),
                                 'take:    git checkout %s -- %s' % (T, q(p))])
    rej_here = [r[:-4] for r in rej if os.path.lexists(r[:-4])]
    rej_gone = [r[:-4] for r in rej if not os.path.lexists(r[:-4])]
    section(L, cap, "REJECTED HUNKS: the file holds the template's version; your lines are in <file>.rej",
            rej_here, lambda p: ['compare: git diff %s %s -- %s' % (T, Y, q(p)),
                                 'yours:   git restore --source=%s -- %s' % (Y, q(p))])
    restore = lambda p: ['see:     git show %s:%s' % (Y, q(p)), 'restore: git restore --source=%s -- %s' % (Y, q(p))]
    section(L, cap, 'DELETED by this update although you had changed them (the template retired them)',
            g['lost'] + rej_gone, restore)
    section(L, cap, 'DELETED by this update (retired by the template, or by an option you turned off)',
            deleted_unknown, restore)
    take = lambda p: ['compare: git diff %s -- %s' % (T, q(p)), 'take:    git restore --source=%s -- %s' % (T, q(p))]
    section(L, cap, 'NOT UPDATED because you had changed them', g['edit'], take)
    sibs = {}
    for p, s in g['sibling']:
        sibs.setdefault(s, []).append(p)
    for s in sorted(sibs):
        section(L, cap, "NOT UPDATED because the file holds %s's version (a shared file)" % s, sibs[s], take)
    section(L, cap, 'NOT UPDATED because files of this kind are written once: seeds, examples, copy-only',
            g['once'], take)
    section(L, cap, 'NOT UPDATED because it is new in this version and you already had a file there',
            g['new_here'], take)
    show = lambda p: ['see:     git show %s:%s' % (T, q(p)), 'take:    git restore --source=%s -- %s' % (T, q(p))]
    section(L, cap, 'NOT RESTORED because you had deleted them', g['not_restored'], show)
    section(L, cap, 'NOT ADDED: new in this version, and an update never adds files of this kind',
            g['new_absent'], show)
    return L


def build_report(t, frm, to, g, counts, unmerged, rej, notes, extra, cap, full):
    """notes: the refresh lines; extra: (deleted_unknown, headline_override)."""
    deleted_unknown, override = extra
    lines = list(notes)
    head = '▸ %s update report, %s → %s' % (t, frm, to)
    B = body(t, g, unmerged, rej, deleted_unknown, cap)
    if override:
        lines.append(head + ': ' + override)
        lines += B
        return lines + (['', '  These commands work offline until the next update.'] if B else [])
    refreshed, added = counts.get('refreshed', 0), counts.get('added', 0)
    kept = sum(len(g[k]) for k in ('edit', 'sibling', 'once', 'new_here', 'not_restored', 'new_absent'))
    if counts['changed'] == 0 and not B:
        return lines + [head + ': the template did not change.']
    if not B:
        return lines + [head + ': every change was delivered (%d file%s).' % (
            counts['changed'], '' if counts['changed'] == 1 else 's')]
    parts = [('delivered', counts['delivered']), ('merged with your edits', counts['merged']),
             ('refreshed', refreshed), ('added', added), ('kept back', kept),
             ('conflict' + ('' if len(unmerged) + len(rej) == 1 else 's'), len(unmerged) + len(rej)),
             ('deleted although you had changed them', len(g['lost']))]
    lines.append(head)
    lines.append('  The template changed %d file%s here: %s.' % (
        counts['changed'], '' if counts['changed'] == 1 else 's',
        ', '.join('%d %s' % (n, w) for w, n in parts if n)))
    lines.append("  %s changed none of your files. In every compare, '-' lines are the template's and '+' lines are yours." % (
        'Apart from the refresh above, this report' if notes else 'This report'))
    lines += B
    lines += ['', "  These commands work offline until the next update. To see the template's whole change to a file:",
              '  git diff %s/template^ %s/template -- <path>' % (t, t),
              '  This report again, with every entry: git log -1 --format=%%B %s/template' % t]
    return lines


# ── The subcommands ──────────────────────────────────────────────────────────

def template_name(answers):
    m = re.fullmatch(r'\.copier-answers\.(.+)\.yml', os.path.basename(answers))
    return m.group(1) if m else 'template'


def setup(args):
    if git('rev-parse', '--is-inside-work-tree', check=False).strip() != 'true':
        say('not a git repository: nothing recorded.')
        return None
    src, to, answers = args.get('--src'), args.get('--to'), args.get('--answers')
    if git('rev-parse', '--show-prefix').strip():
        data = refresh_data(os.path.abspath(src), template_name(answers)) if src and answers else None
        missing = [p for p in (data or {}).get('refresh', []) if not os.path.lexists(p)]
        say('the project is not at its repository root, so nothing was recorded, no shared file was '
            'refreshed or added and no settings entry or MCP server was offered%s. Run the update in a '
            'project that is its own git repository.' % ((' (missing here: %s)' % ', '.join(missing)) if missing else ''))
        return None
    if not (src and answers and to and re.fullmatch(r'[0-9a-f]{7,64}', to)):
        say('needs --src, --to <commit> and --answers (is the template a git repository?).')
        return None
    rel = os.path.relpath(os.path.abspath(answers)).replace(os.sep, '/')
    return {'src': os.path.abspath(src), 'to': to, 'answers': rel, 't': template_name(rel),
            'gitdir': os.path.abspath(git('rev-parse', '--git-dir').strip()),
            'root': os.path.realpath('.')}


def others_history(t):
    """The render records of every other template here: refs/<name>/template, where <name> is
    no namespace of Git's own and the commit is a render record."""
    out = {}
    for ref in git('for-each-ref', '--format=%(refname)', 'refs/').split():
        m = re.fullmatch(r'refs/([^/]+)/template', ref)
        if m and m.group(1) != t and m.group(1) not in GIT_NAMESPACES and ref_info(ref):
            out[m.group(1)] = history(ref)
    return out


def answers_commits(path, limit):
    """The distinct _commit values in the answers file's history, newest first."""
    out = []
    for sha in git('log', '--format=%H', 'HEAD', '--', path, check=False).split():
        text = git('show', '%s:%s' % (sha, path), check=False)
        m = re.search(r'^_commit:\s*(\S+)', text, re.M)
        if m and m.group(1) not in [v for v, _ in out]:
            out.append((m.group(1), text))
        if len(out) > limit:
            break
    return out


def seed_list(answers, src, from_sha):
    """Up to three earlier versions the answers file's history names, other than from_sha."""
    out = []
    for v, txt in answers_commits(answers, 3):
        sha = verify(v, cwd=src)
        if sha and sha != from_sha and sha not in [s for s, _ in out]:
            out.append((sha, txt))
    return out[:3]


def seed_history(c, tmp, from_sha, old_text, old_ans, chain, seeds):
    """Where no record matches: render the earlier versions (oldest first) and the old one,
    chained as records under chain. Returns (chain, O tree or None, O commit or None)."""
    t, src = c['t'], c['src']
    for i, (sha, txt) in enumerate(reversed(seeds)):
        tree, _ = render_tree(src, sha, txt, c['gitdir'], tmp, 'h%d' % i)
        if tree:
            chain = commit(tree, '%s render, history\n\ncommit: %s\nanswers: %s\n' % (
                t, sha, git('hash-object', '--stdin', inp=txt).strip()), None, chain)
    O_tree, _ = render_tree(src, from_sha, old_text, c['gitdir'], tmp, 'o')
    if not O_tree:
        return chain, None, None
    chain = commit(O_tree, '%s render\n\ncommit: %s\nanswers: %s\n' % (t, from_sha, old_ans), None, chain)
    return chain, O_tree, chain


def cmd_baseline(args):
    c = setup(args)
    if not c or off():
        return
    t, T, src = c['t'], 'refs/%s/template' % c['t'], c['src']
    with open(c['answers'], encoding='utf-8') as f:
        answers_text = f.read()
    cur = ref_info(T)
    head = verify('HEAD')
    with tempfile.TemporaryDirectory() as tmp:
        tree, reason = render_tree(src, c['to'], answers_text, c['gitdir'], tmp, 'n')
        if not tree:
            say('no render recorded (%s); the first update will render it.' % reason)
            return
        chain = cur['sha'] if cur else None
        if not cur and head:
            # A copy over a project an earlier version of this template made (copier recopy, a
            # moving re-adoption) and that has no record: its renders are seeded as an update
            # seeds them, so the shared files the copy kept are refreshed now and later updates
            # know their history.
            head_text = git('show', 'HEAD:' + c['answers'], check=False)
            m = re.search(r'^_commit:\s*(\S+)', head_text, re.M)
            from_sha = verify(m.group(1), cwd=src) if m else ''
            if from_sha and from_sha != verify(c['to'], cwd=src):
                head_ans = git('rev-parse', '-q', '--verify', 'HEAD:' + c['answers'], check=False).strip()
                chain, _, _ = seed_history(c, tmp, from_sha, head_text, head_ans, None,
                                           seed_list(c['answers'], src, from_sha))
    notes = []
    data = refresh_data(src, t)
    N = tree_map(tree)
    offered = offered_ids(cur['msg']) if cur else None
    mcp_offered = offered_mcp(cur['msg']) if cur else None
    blobs = written_blobs(cur['msg']) if cur else []
    own = history(chain) if chain else {}
    for p, b, edited in blobs:
        if not edited:
            own.setdefault(p, set()).add(b)
    others = others_history(t)
    rendered = union_history(own, *others.values())
    lines = []
    if data:
        try:
            if chain and head:
                paths = [p for p in data.get('refresh', []) if p in N]
                done, _, failed = refresh(paths, N, worktree(paths), tree_map('HEAD'), own, own, {},
                                          False, c['root'], lambda p: True)
                notes += refresh_notes(t, done, [], failed)
            # A copy over an existing settings.json keeps the owner's file (a seed): the entries
            # this template offers are added to it, once, as an update would.
            before = worktree([SETTINGS]).get(SETTINGS)
            lines, offered = settings_merge(data, N, offered, set())
            notes += [l.replace('▸ ', '▸ %s: ' % t, 1) for l in lines]
            wrote = settings_wrote(lines)
            if wrote:
                blobs.append((SETTINGS, wrote, not delivered(N, SETTINGS) and before not in rendered.get(SETTINGS, ())))
        except Exception as err:   # report what was done; the record is still written
            notes.append('▸ %s: the refresh stopped (%s).' % (t, err))
        try:
            # A copy keeps an existing .mcp.json and client file (seed, copy-only): the servers
            # this template offers are added to them, once, as an update would.
            ml, mcp_offered, writes = mcp_lane(data, N, mcp_offered, set(), rendered, others, t, lines)
            notes += [l.replace('▸ ', '▸ %s: ' % t, 1) for l in ml]
            blobs += [(p, after, not delivered(N, p) and before not in rendered.get(p, ())) for p, before, after in writes]
        except Exception as err:
            notes.append('▸ %s: the MCP servers stopped (%s).' % (t, err))
    if notes:
        print('\n'.join(notes), flush=True)
    ab = git('hash-object', c['answers']).strip()
    commit(tree, '\n'.join(notes + ['%s render, copied' % t]) + record_tail(c['to'], ab, offered or set(), blobs, mcp_offered),
           T, chain)


def cmd_update(args):
    c = setup(args)
    if not c:
        return
    t, src, to, answers = c['t'], c['src'], c['to'], c['answers']
    T, Y = 'refs/%s/template' % t, 'refs/%s/yours' % t
    frm_raw = os.environ.get('VERSION_FROM', '')
    head = verify('HEAD')
    head_text = git('show', 'HEAD:' + answers, check=False) if head else ''
    if not frm_raw:
        m = re.search(r'^_commit:\s*(\S+)', head_text, re.M)
        frm_raw = m.group(1) if m else ''
    from_sha = verify(frm_raw, cwd=src) if frm_raw else ''
    frm = os.environ.get('VERSION_PEP440_FROM') or frm_raw or '?'
    vto = os.environ.get('VERSION_PEP440_TO') or os.environ.get('VERSION_TO') or to[:10]
    head_ans = git('rev-parse', '-q', '--verify', 'HEAD:' + answers, check=False).strip() if head else ''
    ans_now = git('hash-object', answers).strip()
    with open(answers, encoding='utf-8') as f:
        answers_text = f.read()
    unmerged, rej_all = conflicts()
    H = tree_map('HEAD') if head else {}
    cur = ref_info(T)
    empty = lambda: {k: [] for k in ('edit', 'sibling', 'once', 'new_here', 'not_restored', 'new_absent', 'lost')}

    O_tree = O_commit = N_tree = None
    rerun = False
    if cur and cur.get('commit') == to and cur.get('answers') == ans_now:
        rerun, N_tree = True, cur['tree']
        if from_sha == to:
            O_tree, O_commit = cur['tree'], cur['sha']
        elif cur['parent'] and (ref_info(cur['parent']) or {}).get('commit') == from_sha:
            O_tree, O_commit = git('rev-parse', cur['parent'] + '^{tree}').strip(), cur['parent']
    elif cur and from_sha and cur.get('commit') == from_sha and cur.get('answers') == head_ans:
        O_tree, O_commit = cur['tree'], cur['sha']

    if off():
        O = tree_map(O_tree)
        rej = this_update_rej(rej_all, H, set(O) if O_tree else None)
        skip = set(unmerged) | {r[:-4] for r in rej}
        if O_tree:
            g, _ = classify({}, O, worktree(sorted(O)), H, {}, {}, skip)
            gone = []
        else:
            g = empty()
            gone = [p for p in sorted(H) if not os.path.lexists(p) and p not in skip]
        g = {k: (v if k == 'lost' else []) for k, v in g.items()}
        if head:
            git('update-ref', Y, head)
        print('\n'.join(build_report(t, frm, vto, g, {}, unmerged, rej, [], (gone, 'SYNTEK_UPDATE_REPORT=off, so conflicts and deletions only; no shared file is refreshed or added until an update runs without it.'), MAX_LIST, False)), flush=True)
        return

    with tempfile.TemporaryDirectory() as tmp:
        if N_tree is None:
            N_tree, reason = render_tree(src, to, answers_text, c['gitdir'], tmp, 'n')
            if not N_tree:
                rej = this_update_rej(rej_all, H, None)
                skip = set(unmerged) | {r[:-4] for r in rej}
                gone = [p for p in sorted(H) if not os.path.lexists(p) and p not in skip]
                if head:
                    git('update-ref', Y, head)
                print('\n'.join(build_report(t, frm, vto, empty(), {}, unmerged, rej, [], (gone, 'no report, because %s; no shared file was refreshed or added, so the next update does it.' % reason), MAX_LIST, False)), flush=True)
                return
        chain = cur['sha'] if cur else None
        if O_tree is None and from_sha:
            seeds = seed_list(answers, src, from_sha) if not cur else []
            chain, O_tree, O_commit = seed_history(c, tmp, from_sha, head_text or answers_text,
                                                   head_ans or ans_now, chain, seeds)
            if not O_tree:
                chain = cur['sha'] if cur else chain
        elif O_commit:
            chain = O_commit

    N, O = tree_map(N_tree), tree_map(O_tree)
    rej = this_update_rej(rej_all, H, set(N) | set(O))
    skip = set(unmerged) | {r[:-4] for r in rej}
    P = worktree(sorted(set(N) | set(O)))
    skip |= {p for p in set(N) | set(O) if beyond_link(p)}
    recorded = history(cur['sha']) if cur else {}
    own = history(O_commit or (cur['sha'] if cur else None))
    for p, (_, sha) in O.items():
        own.setdefault(p, set()).add(sha)
    # Every blob this script wrote over a file the owner had not edited counts as the template's.
    blobs = written_blobs(cur['msg']) if cur else []
    for p, b, edited in blobs:
        if not edited:
            own.setdefault(p, set()).add(b)
    others = others_history(t)
    rendered = union_history(own, recorded, *others.values())
    yours = tree_map(Y) if verify(Y) else {}
    notes, counts = [], {}
    offered = offered_ids(cur['msg']) if cur else None
    mcp_offered = offered_mcp(cur['msg']) if cur else None
    data = refresh_data(src, t)
    touched = set()
    lines = []
    if data:
        try:
            paths = [p for p in data.get('refresh', []) if isinstance(p, str)]
            done, added, failed = refresh(paths, N, P, H, own, recorded, others, bool(head), c['root'],
                                          lambda p: owner_held(p, yours))
            touched |= set(done) | set(added)
            counts['refreshed'], counts['added'] = len(done), len(added)
            notes += refresh_notes(t, done, added, failed)
            lines, offered = settings_merge(data, N, offered, skip)
            notes += [l.replace('▸ ', '▸ %s: ' % t, 1) for l in lines]
            wrote = settings_wrote(lines)
            done_settings = SETTINGS not in skip and delivered(N, SETTINGS)
            if wrote:
                # P holds every file as it was before this run wrote it: that is what is classified.
                blobs.append((SETTINGS, wrote, not done_settings and P.get(SETTINGS) not in rendered.get(SETTINGS, ())))
            if done_settings:
                P[SETTINGS] = N[SETTINGS][1]   # the release's settings, its entries added: delivered
        except Exception as err:   # report what was done; the report and the record still follow
            notes.append('▸ %s: the refresh stopped (%s); the report below covers every other file.' % (t, err))
        try:
            ml, mcp_offered, writes = mcp_lane(data, N, mcp_offered, skip, rendered, others, t, lines)
            notes += [l.replace('▸ ', '▸ %s: ' % t, 1) for l in ml]
            for p, before, after in writes:
                done_file = delivered(N, p)
                blobs.append((p, after, not done_file and before not in rendered.get(p, ())))
                if done_file:
                    P[p] = N[p][1]   # the release's file, the servers added: delivered
        except Exception as err:
            notes.append('▸ %s: the MCP servers stopped (%s); the report below covers every other file.' % (t, err))
    g, cnt = classify(N, O, P, H, own, others, skip | touched)
    cnt.update(counts)
    if O_tree:
        override = ''
        deleted_unknown = []
    else:
        g = {k: [] for k in g}
        deleted_unknown = [p for p in sorted(H) if not os.path.lexists(p) and p not in skip]
        override = ('the full report needs version %s, which could not be rendered.' % frm_raw) if not rerun else ''
    printed = build_report(t, frm, vto, g, cnt, unmerged, rej, notes, (deleted_unknown, override), MAX_LIST, False)
    print('\n'.join(printed), flush=True)
    if rerun:
        return
    full = build_report(t, frm, vto, g, cnt, unmerged, rej, notes, (deleted_unknown, override), 10 ** 9, True)
    commit(N_tree, '\n'.join(full) + record_tail(to, ans_now, offered or set(), blobs, mcp_offered), T, chain)
    if head:
        git('update-ref', Y, head)


# ── Self-test ────────────────────────────────────────────────────────────────

def tree_map_in(cwd, ref):
    old = os.getcwd()
    try:
        os.chdir(cwd)
        return tree_map(ref)
    finally:
        os.chdir(old)


def settings_probe(base, check):
    """settings_merge on real files: the owner's text kept, nothing written when nothing is new."""
    hook = {'hooks': [{'type': 'command', 'command': 'bash .claude/hooks/probe-hook.sh', 'timeout': 10}]}
    pre = {'matcher': 'auto', 'hooks': [{'type': 'command', 'command': 'bash .claude/hooks/pre.sh auto'}]}
    data = {'settings': {'autoCompactEnabled': False, 'hooks': {'UserPromptSubmit': [hook], 'PreCompact': [pre]},
                         'permissions': {'deny': ['Edit(build/**)', 'Bash(rm *)'], 'ask': ['Bash(git push *)']}}}
    rendered = {'autoCompactEnabled': False, 'hooks': {'PreCompact': [pre], 'UserPromptSubmit': [hook]},
                'permissions': {'deny': ['Edit(build/**)', 'Bash(rm *)'], 'ask': ['Bash(git push *)']}}
    cases = {
        'tabs': '{\n\t"model": "opus",\n\t"permissions": {\n\t\t"allow": [\n\t\t\t"Bash(rm *)"\n\t\t]\n\t}\n}\n',
        'four': '{\r\n    "permissions": {\r\n        "deny": [\r\n            "Read(.env)"\r\n        ]\r\n    },\r\n    "model": "opus"\r\n}',
        'two': '{\n  "hooks": {\n    "PreCompact": [\n      {\n        "matcher": "manual",\n        "hooks": []\n      }\n    ]\n  },\n  "permissions": {"deny": ["Read(.env)"]}\n}\n',
        'compact': '{"model":"opus"}',
        'empty': '{}\n',
        'bom': '﻿{\n  "model": "opus"\n}\n',
        'jsonc': '{\n  // my settings\n  "model": "opus"\n}\n',
        'odd': '{\n  "permissions": {\n    "deny": "Edit(build/**)"\n  }\n}\n',
        'done': json.dumps(rendered, indent=3) + '\n',
        'null': '{\n  "permissions": null,\n  "hooks": {"PreCompact": null}\n}\n',
    }
    old = os.getcwd()
    for name, text in cases.items():
        d = os.path.join(base, name)
        os.makedirs(os.path.join(d, '.claude'))
        try:
            os.chdir(d)
            git('init', '-q')
            os.makedirs('.claude/hooks')
            for script in ('probe-hook.sh', 'pre.sh'):
                with open('.claude/hooks/' + script, 'w', encoding='utf-8') as f:
                    f.write('exit 0\n')
            with open(SETTINGS, 'w', encoding='utf-8', newline='') as f:
                f.write(text)
            before = open(SETTINGS, 'rb').read()
            st = os.stat(SETTINGS)
            sha = git('hash-object', '-w', '--stdin', inp=json.dumps(rendered, indent=2) + '\n').strip()
            N = {SETTINGS: ('100644', sha)}
            lines, seen = settings_merge(data, N, None, set())
            after = open(SETTINGS, 'rb').read()
            out = '\n'.join(lines)
            if name in ('jsonc',):
                check(after == before and 'not plain JSON' in out, '%s: a file that is not plain JSON is reported and left alone (%r)' % (name, out))
                continue
            if name == 'done':
                check(after == before and os.stat(SETTINGS).st_mtime_ns == st.st_mtime_ns and not lines,
                      '%s: nothing new, so the file is not written (%r)' % (name, out))
                check(len(seen) == 6, '%s: every entry present is recorded as offered (%d)' % (name, len(seen)))
                continue
            if name == 'odd':
                check(b'"deny": "Edit(build/**)"' in after and 'is not a list' in out,
                      '%s: a rule list that is not a list is reported, never replaced (%r)' % (name, out))
                continue
            cur = json.loads(after.decode('utf-8-sig'))
            check(all(present(cur, i) for i in [('hook', 'UserPromptSubmit', hook), ('hook', 'PreCompact', pre),
                                                 ('deny', 'Edit(build/**)'), ('ask', 'Bash(git push *)')])
                  and cur.get('autoCompactEnabled') is False,
                  '%s: every new entry is added (%r)' % (name, out))
            check(('rewritten' in out) == (name == 'null'),
                  '%s: the entries were inserted into the owner\'s text, or a null rewritten and reported (%r)' % (name, out))
            again, _ = settings_merge(data, N, seen, set())
            check(not again and open(SETTINGS, 'rb').read() == after, '%s: a second merge adds nothing' % name)
            check(after.endswith(b'\n') == before.endswith(b'\n'), '%s: the final newline is kept as it was' % name)
            check(after.startswith(b'\xef\xbb\xbf') == before.startswith(b'\xef\xbb\xbf'), '%s: the byte-order mark is kept as it was' % name)
            if name == 'tabs':
                body = after.decode()
                check(all(not re.match(r' ', l) for l in body.splitlines()), 'tabs: every added line is indented with tabs')
                check(body.startswith('{\n\t"model": "opus",\n\t"permissions": {\n\t\t"allow": [\n\t\t\t"Bash(rm *)"\n\t\t]'),
                      'tabs: the owner\'s lines are kept')
                check(not has_rule(cur, 'deny', 'Bash(rm *)') and 'because you allow it: deny Bash(rm *)' in out,
                      'tabs: a rule the owner allows is reported, never added')
                check(list(cur) == ['model', 'permissions', 'hooks', 'autoCompactEnabled'], 'tabs: the owner\'s key order is kept (%r)' % list(cur))
            if name == 'four':
                body = after.decode()
                check('\r\n' in body and '\n' not in body.replace('\r\n', ''), 'four: CRLF line endings are kept')
                check(all(len(re.match(r' *', l).group(0)) % 4 == 0 for l in body.split('\r\n')), 'four: four-space indentation is kept')
                check(list(cur) == ['permissions', 'model', 'hooks', 'autoCompactEnabled'] and cur['permissions']['deny'][0] == 'Read(.env)',
                      'four: the owner\'s order and rules are kept (%r)' % list(cur))
            if name == 'two':
                check(len(cur['hooks']['PreCompact']) == 2 and cur['hooks']['PreCompact'][0]['matcher'] == 'manual',
                      'two: the hook is appended after the owner\'s entry')
                check('"permissions": {"deny": ["Read(.env)", "Edit(build/**)"' in after.decode(),
                      'two: a one-line list stays on one line (%r)' % after.decode())
            if name == 'compact':
                check('\n' not in after.decode(), 'compact: a one-line file stays one line')
        finally:
            os.chdir(old)
    # Never written: a file in conflict, a link, one beyond a linked folder. A hook entry whose
    # script is missing is reported and offered again, its rules still added.
    for name in ('conflict', 'link', 'beyond', 'noscript'):
        d = os.path.join(base, name)
        os.makedirs(d)
        try:
            os.chdir(d)
            git('init', '-q')
            plain = '{\n  "model": "opus"\n}\n'
            if name == 'beyond':
                os.makedirs('real-claude/hooks')
                os.symlink('real-claude', '.claude')
                target = 'real-claude/settings.json'
            else:
                os.makedirs('.claude/hooks')
                target = '.claude/shared.json' if name == 'link' else SETTINGS
            if name != 'noscript':
                for script in ('probe-hook.sh', 'pre.sh'):
                    with open(os.path.join(os.path.dirname(target), 'hooks', script), 'w') as f:
                        f.write('exit 0\n')
            with open(target, 'w', encoding='utf-8') as f:
                f.write(plain)
            if name == 'link':
                os.symlink('shared.json', SETTINGS)
            sha = git('hash-object', '-w', '--stdin', inp=json.dumps(rendered, indent=2) + '\n').strip()
            N = {SETTINGS: ('100644', sha)}
            lines, seen = settings_merge(data, N, None, {SETTINGS} if name == 'conflict' else set())
            out = '\n'.join(lines)
            now = open(target, encoding='utf-8').read()
            if name == 'conflict':
                check(now == plain and not lines, 'conflict: a settings.json in conflict is left alone (%r)' % out)
            elif name in ('link', 'beyond'):
                check(now == plain and ('is a link' if name == 'link' else 'lies beyond a link') in out
                      and 'add them by hand' in out and 'probe-hook.sh' in out,
                      '%s: never written through a link, and the entries are reported (%r)' % (name, out))
                check(not seen, '%s: the entries stay to be offered again (%r)' % (name, seen))
            else:
                cur = json.loads(now)
                check(not cur.get('hooks') and has_rule(cur, 'deny', 'Edit(build/**)')
                      and 'its script is not in .claude/hooks/' in out,
                      'noscript: a hook entry is never added without its script; the rules are (%r)' % out)
                check(not any(x.startswith('hook ') for x in seen), 'noscript: the hook entries are offered again')
        finally:
            os.chdir(old)
    # The rule for an entry missing now: offered before (recorded, or in a committed settings.json)
    # means the owner removed it, so it stays removed; never offered means it is added.
    d = os.path.join(base, 'removed')
    os.makedirs(os.path.join(d, '.claude', 'hooks'))
    try:
        os.chdir(d)
        git('init', '-q')
        for script in ('probe-hook.sh', 'pre.sh'):
            with open('.claude/hooks/' + script, 'w') as f:
                f.write('exit 0\n')
        with open(SETTINGS, 'w', encoding='utf-8') as f:
            f.write(json.dumps({'hooks': {'UserPromptSubmit': [hook]}}, indent=2) + '\n')
        git('add', '-A')
        git('commit', '-q', '-m', 'had it', env=IDENT)
        with open(SETTINGS, 'w', encoding='utf-8') as f:
            f.write('{\n  "model": "opus"\n}\n')
        git('commit', '-q', '-am', 'removed it', env=IDENT)
        sha = git('hash-object', '-w', '--stdin', inp=json.dumps(rendered, indent=2) + '\n').strip()
        N = {SETTINGS: ('100644', sha)}
        lines, seen = settings_merge(data, N, None, set())
        cur = json.loads(open(SETTINGS).read())
        check(not has_hook(cur, 'UserPromptSubmit', hook) and has_hook(cur, 'PreCompact', pre),
              'no record: a hook a committed settings.json held is not re-added; one it never held is')
        with open(SETTINGS, 'w', encoding='utf-8') as f:
            f.write('{\n  "model": "opus"\n}\n')
        lines, _ = settings_merge(data, N, seen, set())
        check(not lines and open(SETTINGS).read() == '{\n  "model": "opus"\n}\n',
              'recorded: entries the owner removed after they were offered are not re-added')
        write_blob('.claude/hooks/probe-hook.sh', '100644', sha)
        check(os.stat('.claude/hooks/probe-hook.sh').st_mode & 0o777 == 0o755, 'a hook the refresh writes is mode 755')
    finally:
        os.chdir(old)
    setting_probe(os.path.join(base, 'top-level'), check)


def setting_probe(base, check):
    """A top-level value (autoCompactEnabled): added only where the key is absent, as text in
    the owner's own format; an owner's other value kept and reported once; offered once."""
    data = {'settings': {'autoCompactEnabled': False}}
    line = 'the handoff hooks assume false; set it to false in .claude/settings.json to use them.'
    added = {
        'two': ('{\n  "model": "opus"\n}\n', '{\n  "model": "opus",\n  "autoCompactEnabled": false\n}\n'),
        'tabs': ('{\n\t"model": "opus"\n}\n', '{\n\t"model": "opus",\n\t"autoCompactEnabled": false\n}\n'),
        'bom-crlf': ('\ufeff{\r\n    "model": "opus"\r\n}',
                     '\ufeff{\r\n    "model": "opus",\r\n    "autoCompactEnabled": false\r\n}'),
        'one-line': ('{"model":"opus"}', '{"model":"opus", "autoCompactEnabled": false}'),
        'empty': ('{}\n', '{\n  "autoCompactEnabled": false\n}\n'),
    }
    kept = {'false': '{\n  "autoCompactEnabled": false\n}\n', 'true': '{\n  "autoCompactEnabled": true\n}\n',
            'zero': '{"autoCompactEnabled": 0}', 'null': '{"model": "opus", "autoCompactEnabled": null}\n'}
    old = os.getcwd()

    def case(name, text, rendered=None, history=()):
        d = os.path.join(base, name)
        os.makedirs(os.path.join(d, '.claude'))
        os.chdir(d)
        git('init', '-q')
        for i, h in enumerate(history):
            with open(SETTINGS, 'w', encoding='utf-8', newline='') as f:
                f.write(h)
            git('add', '-A')
            git('commit', '-q', '-m', 'h%d' % i, env=IDENT)
        with open(SETTINGS, 'w', encoding='utf-8', newline='') as f:
            f.write(text)
        sha = git('hash-object', '-w', '--stdin',
                  inp=json.dumps(rendered or {'model': 'opus', 'autoCompactEnabled': False}, indent=2) + '\n').strip()
        return {SETTINGS: ('100644', sha)}, os.stat(SETTINGS).st_mtime_ns

    try:
        for name, (text, want) in added.items():
            N, _ = case(name, text)
            lines, seen = settings_merge(data, N, None, set())
            got = open(SETTINGS, 'rb').read().decode('utf-8')
            check(got == want, 'top-level %s: the key is inserted in the owner\'s format (%r)' % (name, got))
            check(len(lines) == 1 and lines[0].startswith('▸ added to') and '"autoCompactEnabled": false' in lines[0],
                  'top-level %s: one added line (%r)' % (name, lines))
            check(seen == {'setting autoCompactEnabled'}, 'top-level %s: recorded as offered (%r)' % (name, seen))
            again, _ = settings_merge(data, N, seen, set())
            check(not again and open(SETTINGS, 'rb').read().decode('utf-8') == want, 'top-level %s: added once' % name)
            with open(SETTINGS, 'w', encoding='utf-8', newline='') as f:
                f.write(text)
            again, _ = settings_merge(data, N, seen, set())
            check(not again and open(SETTINGS, 'rb').read().decode('utf-8') == text,
                  'top-level %s: a key the owner deleted after the offer is not re-added' % name)
            os.chdir(old)
        for name, text in kept.items():
            N, mtime = case(name, text)
            lines, seen = settings_merge(data, N, None, set())
            check(open(SETTINGS, 'rb').read().decode('utf-8') == text and os.stat(SETTINGS).st_mtime_ns == mtime,
                  'top-level %s: the owner\'s value is never written' % name)
            if name == 'false':
                check(not lines, 'top-level false: nothing to say (%r)' % lines)
            else:
                check(len(lines) == 1 and lines[0].startswith('▸ kept your "autoCompactEnabled": ') and lines[0].endswith(line),
                      'top-level %s: one line says the hooks assume false (%r)' % (name, lines))
            check(seen == {'setting autoCompactEnabled'}, 'top-level %s: recorded as offered' % name)
            again, _ = settings_merge(data, N, seen, set())
            check(not again, 'top-level %s: reported once, never again (%r)' % (name, again))
            os.chdir(old)
        # No record: a committed settings.json that held the key means the owner removed it.
        N, _ = case('history', '{\n  "model": "opus"\n}\n', history=('{\n  "autoCompactEnabled": false\n}\n',))
        lines, seen = settings_merge(data, N, None, set())
        check(not lines and 'autoCompactEnabled' not in open(SETTINGS).read() and 'setting autoCompactEnabled' in seen,
              'top-level history: a key a committed settings.json held is not re-added (%r)' % lines)
        os.chdir(old)
        N, mtime = case('history-true', '{\n  "autoCompactEnabled": true\n}\n', history=('{\n  "autoCompactEnabled": true\n}\n',))
        lines, seen = settings_merge(data, N, None, set())
        check(len(lines) == 1 and lines[0].endswith(line) and os.stat(SETTINGS).st_mtime_ns == mtime,
              'top-level history-true: an owner\'s committed true is kept and reported once (%r)' % lines)
        again, _ = settings_merge(data, N, seen, set())
        check(not again, 'top-level history-true: the record then keeps it quiet (%r)' % again)
        os.chdir(old)
        N, _ = case('old-record', '{\n  "model": "opus"\n}\n', history=('{\n  "autoCompactEnabled": false\n}\n',))
        lines, seen = settings_merge(data, N, {'deny Edit(build/**)'}, set())
        check(not lines and 'autoCompactEnabled' not in open(SETTINGS).read() and 'setting autoCompactEnabled' in seen,
              'top-level old-record: a record that never listed the key leaves it to the history (%r)' % lines)
        os.chdir(old)
        N, _ = case('old-record-new', '{\n  "model": "opus"\n}\n', history=('{\n  "model": "opus"\n}\n',))
        lines, seen = settings_merge(data, N, {'deny Edit(build/**)'}, set())
        check('autoCompactEnabled": false' in open(SETTINGS).read() and 'setting autoCompactEnabled' in seen,
              'top-level old-record-new: a key no record and no commit held is added (%r)' % lines)
        os.chdir(old)
        # No record and a conflict in settings.json: the committed true is not recorded until a
        # run can read the file, which then reports it exactly once.
        N, _ = case('history-skip', '{\n  "autoCompactEnabled": true\n}\n', history=('{\n  "autoCompactEnabled": true\n}\n',))
        lines, seen = settings_merge(data, N, None, {SETTINGS})
        check(not lines and 'setting autoCompactEnabled' not in seen,
              'top-level history-skip: a conflict records no unreported value (%r, %r)' % (lines, seen))
        lines, seen = settings_merge(data, N, seen, set())
        again, _ = settings_merge(data, N, seen, set())
        check(len(lines) == 1 and lines[0].endswith(line) and not again,
              'top-level history-skip: the next clean run reports it exactly once (%r, %r)' % (lines, again))
        os.chdir(old)
        # A link to a file inside the project is read, never written: a key it holds is never
        # named for adding by hand, an owner's true is reported once, and the next run is quiet.
        N, _ = case('link', '')
        os.remove(SETTINGS)
        with open('.claude/real.json', 'w') as f:
            f.write('{\n  "autoCompactEnabled": true\n}\n')
        os.symlink('real.json', SETTINGS)
        lines, seen = settings_merge(data, N, None, set())
        again, _ = settings_merge(data, N, seen, set())
        check(len(lines) == 1 and lines[0].endswith(line) and 'by hand' not in lines[0] and not again
              and open('.claude/real.json').read() == '{\n  "autoCompactEnabled": true\n}\n',
              'top-level link: a linked true is reported once, never named for adding by hand (%r, %r)' % (lines, again))
        os.remove('.claude/real.json')
        with open('.claude/real.json', 'w') as f:
            f.write('{\n  "model": "opus"\n}\n')
        lines, seen = settings_merge(data, N, None, set())
        again, _ = settings_merge(data, N, seen, set())
        check(len(lines) == 1 and 'by hand' in lines[0] and again == lines,
              'top-level link: a key the linked file lacks is named for adding by hand on every run (%r, %r)' % (lines, again))
        os.chdir(old)
        # Not plain JSON (a comment): a key the text holds is never named for adding by hand.
        N, mtime = case('jsonc', '{\n  // mine\n  "autoCompactEnabled": false\n}\n')
        lines, seen = settings_merge(data, N, None, set())
        check(not lines and 'setting autoCompactEnabled' in seen and os.stat(SETTINGS).st_mtime_ns == mtime,
              'top-level jsonc: a key the text holds is not named for adding by hand (%r)' % lines)
        os.chdir(old)
        # Offered only where the new render holds the same value.
        for name, rendered in (('unrendered', {'model': 'opus'}), ('other-value', {'autoCompactEnabled': True})):
            N, mtime = case(name, '{\n  "model": "opus"\n}\n', rendered)
            lines, seen = settings_merge(data, N, None, set())
            check(not lines and not seen and os.stat(SETTINGS).st_mtime_ns == mtime,
                  'top-level %s: a value the new render does not hold is never offered (%r)' % (name, lines))
            os.chdir(old)
        # A shape this script does not know is ignored, never fatal.
        N, mtime = case('unknown', '{\n  "model": "opus"\n}\n', {'model': 'opus', 'env': {'A': '1'}})
        lines, seen = settings_merge({'settings': {'env': {'A': '1'}, 'nothing': None}}, N, None, set())
        check(not lines and not seen, 'top-level unknown: an object or null value is ignored (%r)' % lines)
    finally:
        os.chdir(old)


PROBE_CRG = {'command': 'uvx', 'args': ['crg==1', 'serve', '--tools', 'a,b'], 'env': {'KEY': ''}}
PROBE_SCR = {'command': 'uvx', 'args': ['--from', 'scr==1', 'scr', 'mcp']}
PROBE_TOML_HEAD = "# The client's settings.\nproject_doc_fallback_filenames = ['CLAUDE.md']\n"
PROBE_TOML = PROBE_TOML_HEAD + (
    "\n[mcp_servers.code-review-graph]\ncommand = 'uvx'\nargs = ['crg==1', 'serve', '--tools', 'a,b']\n"
    "\n[mcp_servers.code-review-graph.env]\nKEY = ''\n"
    '\n[mcp_servers.code-review-graph.tools.apply_refactor_tool]\napproval_mode = "prompt"\n'
    "\n[mcp_servers.scrapling]\ncommand = 'uvx'\nargs = ['--from', 'scr==1', 'scr', 'mcp']\n"
    '\n[mcp_servers.scrapling.tools.fetch]\napproval_mode = "prompt"\n')
PROBE_MCP = {'servers': ['code-review-graph', 'scrapling'],
             'files': {'.agents/mcp_config.json': ['mcpServers'], '.codex/config.toml': ['mcp_servers'],
                       '.gemini/settings.json': ['mcpServers'], '.mcp.json': ['mcpServers'], 'opencode.json': ['mcp', 'servers']}}


def mcp_probe(base, check):
    """The MCP lane on real files: each server offered once, the owner's text kept, nothing
    created, nothing ignored read, nothing written through a link."""
    both = {'code-review-graph': PROBE_CRG, 'scrapling': PROBE_SCR}
    asks = ['mcp__scrapling__fetch', 'mcp__code-review-graph__apply_refactor_tool']
    oc_forms = [{'action': 'scrapling_fetch', 'resource': '*', 'effect': 'ask'},
                {'action': 'code-review-graph_apply_refactor_tool', 'resource': '*', 'effect': 'ask'}]
    gm_forms = ['mcp_scrapling_fetch', 'mcp_code-review-graph_apply_refactor_tool']
    js = lambda v: json.dumps(v, indent=2) + '\n'
    new = {'.mcp.json': js({'mcpServers': both}), '.agents/mcp_config.json': js({'mcpServers': both}),
           '.codex/config.toml': PROBE_TOML,
           '.gemini/settings.json': js({'tools': {'exclude': ['ask_user'], 'confirmationRequired': gm_forms}, 'mcpServers': both}),
           'opencode.json': js({'$schema': 'x', 'mcp': {'servers': {k: {'type': 'local', 'command': [v['command']] + v['args']}
                                                                 for k, v in both.items()}},
                                'permissions': oc_forms + [{'action': 'edit', 'resource': 'build/*', 'effect': 'deny'}]}),
           SETTINGS: js({'permissions': {'ask': asks}})}
    old_mcp, old_agents = '{"mcpServers": {}}\n', '{\n  "mcpServers": {}\n}\n'
    data = {'mcp': PROBE_MCP}
    old = os.getcwd()

    def blob(text):
        return git('hash-object', '-w', '--stdin', inp=text).strip()

    def put(rel, content, mode=None):
        os.makedirs(os.path.dirname(rel) or '.', exist_ok=True)
        with open(rel, 'wb') as f:
            f.write(content if isinstance(content, bytes) else content.encode('utf-8'))
        if mode is not None:
            os.chmod(rel, mode)

    def get(rel):
        with open(rel, 'rb') as f:
            return f.read()

    def project(name, files, commits=(), drop=()):
        d = os.path.join(base, name)
        os.makedirs(d)
        os.chdir(d)
        git('init', '-q')
        for i, snap in enumerate(commits):
            for rel, text in snap.items():
                put(rel, text)
            git('add', '-A')
            git('commit', '-q', '-m', 'c%d' % i, env=IDENT)
        put(SETTINGS, new[SETTINGS])
        for rel, text in files.items():
            put(rel, text)
        return {rel: ('100644', blob(text)) for rel, text in new.items() if rel not in drop}

    def lane(N, offered=None, skip=(), rendered=None, others=None, settings_lines=()):
        return mcp_lane(data, N, offered, set(skip), rendered or {}, others or {}, 'probe', list(settings_lines))

    try:
        # JSON: the unedited one-line seed takes the new render's bytes; a second run is a no-op.
        N = project('fast', {'.mcp.json': old_mcp})
        lines, seen, writes = lane(N, rendered={'.mcp.json': {blob(old_mcp)}})
        check(get('.mcp.json') == new['.mcp.json'].encode() and lines == ['▸ added 2 MCP servers to .mcp.json: code-review-graph, scrapling'],
              'mcp fast: an unedited seed takes the new render\'s bytes (%r)' % lines)
        check(set(seen) == {('.mcp.json', 'code-review-graph'), ('.mcp.json', 'scrapling')} and len(writes) == 1
              and all(re.fullmatch(r'[0-9a-f]{64}', h) for h in seen.values()), 'mcp fast: both offers recorded with their hash (%r)' % seen)
        mtime = os.stat('.mcp.json').st_mtime_ns
        again, seen2, writes2 = lane(N, offered=seen, rendered={'.mcp.json': {blob(old_mcp)}})
        check(not again and not writes2 and seen2 == seen and os.stat('.mcp.json').st_mtime_ns == mtime,
              'mcp fast: a second run changes nothing, mtime included (%r)' % again)
        os.chdir(old)
        # The 23-byte form of another template's copy gains exactly the shared bytes.
        N = project('agents23', {'.agents/mcp_config.json': old_agents})
        lane(N)
        check(get('.agents/mcp_config.json') == new['.agents/mcp_config.json'].encode(),
              'mcp agents23: inserting into the 23-byte file gives the shared bytes exactly')
        os.chdir(old)
        # An edited one-line file stays one line, the owner's server first.
        N = project('one-line', {'.mcp.json': '{"mcpServers": {"mine": {"command": "x"}}}\n'})
        lines, _, _ = lane(N, rendered={'.mcp.json': {blob(old_mcp)}})
        body = get('.mcp.json').decode()
        cur = json.loads(body)
        check(body.count('\n') == 1 and body.endswith('}\n') and list(cur['mcpServers']) == ['mine', 'code-review-graph', 'scrapling']
              and cur['mcpServers']['scrapling'] == PROBE_SCR, 'mcp one-line: stays one line, the owner\'s server first (%r)' % body)
        os.chdir(old)
        # Four spaces, CRLF, a byte-order mark, no final newline: all kept.
        raw = b'\xef\xbb\xbf' + '{\r\n    "mcpServers": {\r\n        "mine": {\r\n            "command": "x"\r\n        }\r\n    }\r\n}'.encode()
        N = project('crlf', {'.mcp.json': raw})
        lines, seen, _ = lane(N)
        after = get('.mcp.json')
        text = after[3:].decode()
        check(after.startswith(b'\xef\xbb\xbf') and '\n' not in text.replace('\r\n', '') and not text.endswith('\n')
              and all(len(re.match(r' *', l).group(0)) % 4 == 0 for l in text.split('\r\n'))
              and list(json.loads(text)['mcpServers']) == ['mine', 'code-review-graph', 'scrapling'] and 'rewritten' not in ''.join(lines),
              'mcp crlf: the mark, CRLF, four spaces, no final newline and the owner\'s order kept (%r)' % text[:120])
        mtime = os.stat('.mcp.json').st_mtime_ns
        again, _, _ = lane(N, offered=seen)
        check(not again and os.stat('.mcp.json').st_mtime_ns == mtime, 'mcp crlf: a second run changes nothing')
        os.chdir(old)
        # Tabs in .gemini/settings.json that already holds its ask rules.
        tabs = ('{\n\t"tools": {\n\t\t"confirmationRequired": [\n\t\t\t"mcp_scrapling_fetch",\n'
                '\t\t\t"mcp_code-review-graph_apply_refactor_tool"\n\t\t]\n\t},\n\t"mcpServers": {}\n}\n')
        N = project('tabs', {'.gemini/settings.json': tabs})
        lines, _, _ = lane(N)
        body = get('.gemini/settings.json').decode()
        check(not any(l.startswith(' ') for l in body.splitlines()) and set(json.loads(body)['mcpServers']) == set(both),
              'mcp tabs: added with tab indentation (%r)' % lines)
        os.chdir(old)
        # opencode.json with no "mcp": mcp.servers is created at its end.
        N = project('oc-new', {'opencode.json': js({'permissions': oc_forms})})
        lines, _, _ = lane(N)
        cur = json.loads(get('opencode.json'))
        check(list(cur) == ['permissions', 'mcp'] and set(cur['mcp']['servers']) == set(both),
              'mcp oc-new: mcp.servers created at the end (%r, %r)' % (list(cur), lines))
        os.chdir(old)
        # A key path that is not an object is refused, never replaced, and said once.
        text = js({'mcp': True, 'permissions': oc_forms})
        N = project('oc-bad', {'opencode.json': text})
        lines, seen, _ = lane(N)
        check(get('opencode.json') == text.encode() and any('mcp.servers is not an object' in l for l in lines)
              and ('opencode.json', 'scrapling') in seen, 'mcp oc-bad: a non-object refused, reported, recorded (%r)' % lines)
        os.chdir(old)
        # JSONC: reported, not written, offered again.
        text = '{\n  // mine\n  "permissions": []\n}\n'
        N = project('jsonc', {'opencode.json': text})
        lines, seen, _ = lane(N)
        again, _, _ = lane(N, offered=seen)
        check(get('opencode.json') == text.encode() and any('is not plain JSON' in l for l in lines)
              and not any(p == 'opencode.json' for p, _ in seen) and again == lines,
              'mcp jsonc: reported, never written, offered again (%r)' % lines)
        os.chdir(old)
        # TOML: an append parses to exactly the new render's servers; the unedited file takes
        # the new render's bytes; no final newline and CRLF are handled.
        for name, text in (('toml-append', PROBE_TOML_HEAD + "model = 'mine'\n"), ('toml-nonl', "model = 'mine'"),
                           ('toml-crlf', "model = 'mine'\r\n"), ('toml-fast', PROBE_TOML_HEAD)):
            N = project(name, {'.codex/config.toml': text})
            lines, seen, _ = lane(N, rendered={'.codex/config.toml': {blob(PROBE_TOML_HEAD)}})
            body = get('.codex/config.toml').decode()
            tree = _toml().loads(body)
            check(tree.get('mcp_servers') == _toml().loads(PROBE_TOML)['mcp_servers'] and body.startswith(text.rstrip('\r\n'))
                  and lines == ['▸ added 2 MCP servers to .codex/config.toml: code-review-graph, scrapling'],
                  'mcp %s: the tables, env and tools included, appended (%r)' % (name, lines))
            if name == 'toml-fast':
                check(body == PROBE_TOML, 'mcp toml-fast: an unedited file takes the new render\'s bytes')
            if name == 'toml-crlf':
                check('\n' not in body.replace('\r\n', ''), 'mcp toml-crlf: CRLF kept')
            if name == 'toml-nonl':
                check(body.startswith("model = 'mine'\n\n[mcp_servers.code-review-graph]\n"), 'mcp toml-nonl: a final newline added (%r)' % body[:60])
            again, _, _ = lane(N, offered=seen)
            check(not again, 'mcp %s: a second run is quiet' % name)
            os.chdir(old)
        # TOML that already declares a server (a table, dotted keys, an inline table) or that
        # cannot be extended: the owner's bytes kept, each said once.
        for name, text, want in (
                ('toml-table', PROBE_TOML_HEAD + "\n[mcp_servers.scrapling]\ncommand = 'mine'\n", 'kept your "scrapling"'),
                ('toml-dotted', "mcp_servers.scrapling.command = 'mine'\n", 'kept your "scrapling"'),
                ('toml-inline', "mcp_servers = { scrapling = { command = 'mine' } }\n", 'would not leave exactly your file'),
                ('toml-inline-other', "mcp_servers = { mine = { command = 'x' } }\n", 'would not leave exactly your file')):
            N = project(name, {'.codex/config.toml': text})
            lines, seen, _ = lane(N)
            body = get('.codex/config.toml').decode()
            check(body.startswith(text) and any(want in l for l in lines) and _toml().loads(body)['mcp_servers'].get('scrapling', {}).get('command') != 'uvx',
                  'mcp %s: the owner\'s server kept and reported (%r)' % (name, lines))
            if name.startswith('toml-inline'):
                check(body == text, 'mcp %s: an inline table is never written' % name)
            again, _, _ = lane(N, offered=seen)
            check(not again, 'mcp %s: said once (%r)' % (name, again))
            os.chdir(old)
        # Appended tables that would not parse to exactly the plan are never written (here the
        # extraction is made to lose a line).
        global _toml_blocks
        real = _toml_blocks
        _toml_blocks = lambda text, server: [b[:-1] if len(b) > 2 else b for b in real(text, server)]
        try:
            text = PROBE_TOML_HEAD + "model = 'mine'\n"
            N = project('toml-verify', {'.codex/config.toml': text})
            lines, seen, writes = lane(N)
        finally:
            _toml_blocks = real
        check(get('.codex/config.toml') == text.encode() and not writes and any('would not leave exactly your file' in l for l in lines),
              'mcp toml-verify: an append that does not parse to the plan is never written (%r)' % lines)
        os.chdir(old)
        # Offers: a server held with another value is kept, said once; a sibling's value is named.
        mine = js({'mcpServers': {'scrapling': {'command': 'mine'}}})
        sib_blob = None
        for name in ('differs', 'sibling'):
            N = project(name, {'.mcp.json': mine})
            others = {}
            if name == 'sibling':
                sib_blob = blob(js({'mcpServers': {'scrapling': {'command': 'mine'}}, 'x': 1}))
                others = {'sibling': {'.mcp.json': {sib_blob}}}
            lines, seen, _ = lane(N, others=others)
            body = get('.mcp.json').decode()
            want = "holds sibling's version of the \"scrapling\" MCP server" if name == 'sibling' else 'kept your "scrapling" MCP server'
            check('"scrapling": {\n      "command": "mine"\n    }' in body and any(want in l and 'compare: git diff probe/template -- .mcp.json' in l for l in lines)
                  and 'code-review-graph' in json.loads(body)['mcpServers'] and ('.mcp.json', 'scrapling') in seen,
                  'mcp %s: kept byte for byte, one line, recorded (%r)' % (name, lines))
            again, _, _ = lane(N, offered=seen, others=others)
            check(not again, 'mcp %s: quiet on the next run' % name)
            os.chdir(old)
        # Removed after the offer: never added back. Removed with no record, the history shows it:
        # never added back. An old record without MCP offers and a clean history: added.
        only = js({'mcpServers': {'code-review-graph': PROBE_CRG}})
        N = project('removed', {'.mcp.json': only})
        lines, seen, _ = lane(N, offered={('.mcp.json', 'scrapling'): '0' * 64})
        check(get('.mcp.json') == only.encode() and not lines and ('.mcp.json', 'code-review-graph') in seen,
              'mcp removed: a server removed after the offer is not re-added (%r)' % lines)
        os.chdir(old)
        N = project('history', {'.mcp.json': only}, commits=({'.mcp.json': new['.mcp.json']}, {'.mcp.json': only}))
        lines, seen, _ = lane(N)
        check(get('.mcp.json') == only.encode() and not lines and ('.mcp.json', 'scrapling') in seen,
              'mcp history: a server the committed history held is not re-added (%r)' % lines)
        os.chdir(old)
        N = project('clean', {'.mcp.json': old_mcp}, commits=({'.mcp.json': old_mcp},))
        lines, _, _ = lane(N)
        check(set(json.loads(get('.mcp.json'))['mcpServers']) == set(both), 'mcp clean: no record, a clean history: added (%r)' % lines)
        os.chdir(old)
        # Guards: the client not named; the file absent; git-ignored at mode 000; a link and a
        # path beyond one; a file in conflict.
        text = js({'permissions': oc_forms})
        N = project('unnamed', {'opencode.json': text}, drop=('opencode.json',))
        lines, seen, _ = lane(N)
        check(get('opencode.json') == text.encode() and not any(p == 'opencode.json' for p, _ in seen)
              and lines == ['▸ opencode.json exists but the recorded answers do not name its client, so no MCP server was offered to it'],
              'mcp unnamed: nothing offered, nothing recorded, one line (%r)' % lines)
        os.chdir(old)
        N = project('absent', {})
        lines, seen, _ = lane(N)
        check(not lines and not seen and not any(os.path.lexists(p) for p in PROBE_MCP['files']),
              'mcp absent: no file is ever created (%r)' % lines)
        os.chdir(old)
        N = project('ignored', {'.gitignore': '.mcp.json\n', '.mcp.json': old_mcp})
        os.chmod('.mcp.json', 0)
        st = os.stat('.mcp.json')
        lines, seen, writes = lane(N, rendered={'.mcp.json': {blob(old_mcp)}})
        st2 = os.stat('.mcp.json')
        again, _, _ = lane(N, offered=seen)
        os.chmod('.mcp.json', 0o644)
        check((st.st_size, st.st_mtime_ns) == (st2.st_size, st2.st_mtime_ns) and not writes and len(lines) == 1
              and 'is ignored by git, so it was not read' in lines[0] and 'git show probe/template:.mcp.json' in lines[0]
              and ('.mcp.json', 'scrapling') in seen and not again, 'mcp ignored: never read or written, said once (%r)' % lines)
        os.chdir(old)
        N = project('link', {'shared/mcp.json': old_mcp, 'real-agents/mcp_config.json': old_agents})
        os.symlink('shared/mcp.json', '.mcp.json')
        os.symlink('real-agents', '.agents')
        lines, seen, writes = lane(N)
        check(get('shared/mcp.json') == old_mcp.encode() and get('real-agents/mcp_config.json') == old_agents.encode() and not writes
              and any(l.startswith('▸ .mcp.json is a link') for l in lines) and any(l.startswith('▸ .agents/mcp_config.json lies beyond a link') for l in lines)
              and not seen, 'mcp link: never written through a link, offered again (%r)' % lines)
        os.chdir(old)
        N = project('conflict', {'.mcp.json': old_mcp})
        lines, seen, writes = lane(N, skip={'.mcp.json'})
        check(get('.mcp.json') == old_mcp.encode() and not lines and not seen and not writes, 'mcp conflict: a file in conflict is untouched')
        os.chdir(old)
        # An owner's catch-all allow in opencode.json covers no tool the update brings in: the
        # servers wait, with the --write line, until the file holds their ask rules.
        catch = js({'permissions': [{'action': '*', 'resource': '*', 'effect': 'allow'}]})
        N = project('catch-all', {'opencode.json': catch})
        lines, seen, writes = lane(N)
        check(get('opencode.json') == catch.encode() and not writes and not any(p == 'opencode.json' for p, _ in seen)
              and len(lines) == 1 and 'python3 .claude/probe-permissions.py --write' in lines[0]
              and 'held back now: opencode.json code-review-graph, scrapling' in lines[0],
              'mcp catch-all: the servers held back with the --write line (%r)' % lines)
        put('opencode.json', js({'permissions': [{'action': '*', 'resource': '*', 'effect': 'allow'}] + oc_forms}))
        lines, seen, _ = lane(N, offered=seen)
        check(set(json.loads(get('opencode.json')).get('mcp', {}).get('servers', {})) == set(both)
              and lines == ['▸ added 2 MCP servers to opencode.json: code-review-graph, scrapling'],
              'mcp catch-all: after --write, the next run adds them (%r)' % lines)
        os.chdir(old)
        # The same where the project's settings.json allows the server, so it holds no ask for
        # it: the new render's asks still decide, and the server waits.
        N = project('catch-all-allowed', {'opencode.json': catch, SETTINGS: js({'permissions': {'allow': ['mcp__scrapling__*']}})})
        lines, seen, writes = lane(N)
        check(get('opencode.json') == catch.encode() and not writes and len(lines) == 1
              and 'held back now: opencode.json code-review-graph, scrapling' in lines[0],
              'mcp catch-all-allowed: an allow in settings.json does not open the file early (%r)' % lines)
        os.chdir(old)
        # The --write line where this run added an mcp__ rule and a client file exists.
        N = project('rules', {'.codex/config.toml': PROBE_TOML})
        lines, _, _ = lane(N, settings_lines=['▸ added to %s: ask mcp__scrapling__fetch' % SETTINGS])
        check(lines == ['▸ to carry the new ask and deny rules into .codex/config.toml, run: python3 .claude/probe-permissions.py --write'],
              'mcp rules: the --write line once (%r)' % lines)
        lines, _, _ = lane(N)
        check(not lines, 'mcp rules: no line where no rule was added (%r)' % lines)
        os.chdir(old)
        # A malformed "mcp": one line, nothing offered, the offers recorded before kept; none: as before.
        rec = {('.mcp.json', 'scrapling'): '1' * 64}
        for bad in ({'servers': 'scrapling', 'files': {}}, {'servers': ['a b'], 'files': {}},
                    {'servers': ['s'], 'files': {'../x.json': ['k']}}, {'servers': ['s'], 'files': {'x.json': []}}):
            got = mcp_lane({'mcp': bad}, {}, rec, set(), {}, {}, 'probe', [])
            check(len(got[0]) == 1 and 'not in the shape' in got[0][0] and got[1] == rec and got[2] == [],
                  'mcp malformed %r: one line, the lane skipped' % bad)
        check(mcp_lane({'settings': {}}, {}, None, set(), {}, {}, 'probe', []) == ([], None, []),
              'mcp none: a data file without "mcp" behaves as before')
    finally:
        os.chdir(old)


def allow_probe(check):
    """An ask the owner allows by server, wildcard or tool glob is reported, never added; a
    deny is covered only by the same rule."""
    deny = 'mcp__code-review-graph__embed_graph_tool'
    asks = ['mcp__scrapling__fetch', 'mcp__scrapling__bulk_fetch', 'mcp__scrapling__open_session',
            'mcp__code-review-graph__apply_refactor_tool']
    data = {'settings': {'permissions': {'deny': [deny], 'ask': asks}}}
    for allows, want_added in ((['mcp__scrapling__*', 'mcp__code-review-graph'], {deny}),
                               (['mcp__scrapling'], {deny, asks[3]}),
                               (['mcp__scrapling__*fetch'], {deny, asks[2], asks[3]}),
                               (['mcp__scrap*', 'mcp__scrapling__open'], set(asks) | {deny})):
        with tempfile.TemporaryDirectory() as d:
            old = os.getcwd()
            try:
                os.chdir(d)
                git('init', '-q')
                os.makedirs('.claude')
                with open(SETTINGS, 'w', encoding='utf-8') as f:
                    f.write(json.dumps({'permissions': {'allow': allows}}, indent=2) + '\n')
                sha = git('hash-object', '-w', '--stdin', inp=json.dumps(data['settings'], indent=2) + '\n').strip()
                lines, _ = settings_merge(data, {SETTINGS: ('100644', sha)}, None, set())
                perms = json.loads(open(SETTINGS).read())['permissions']
                got = set(perms.get('deny', [])) | set(perms.get('ask', []))
                check(got == want_added and (got == set(asks) | {deny} or any('because you allow it' in l for l in lines)),
                      'allow %r: added %r, want %r (%r)' % (allows, sorted(got), sorted(want_added), lines))
            finally:
                os.chdir(old)


def self_test():
    """Builds fake renders by hand (no Copier) and runs update and baseline against them."""
    global RENDER
    fails = []

    def check(cond, what):
        if not cond:
            fails.append(what)

    def write(base, rel, text, mode=None):
        p = os.path.join(base, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'w', encoding='utf-8', newline='\n') as f:
            f.write(text)
        if mode:
            os.chmod(p, mode)

    def read(base, rel):
        try:
            with open(os.path.join(base, rel), encoding='utf-8') as f:
                return f.read()
        except OSError:
            return None

    def run(cwd, *argv, env=None):
        import io
        import contextlib
        old, buf = os.getcwd(), io.StringIO()
        saved = dict(os.environ)
        os.environ.update(env or {})
        try:
            os.chdir(cwd)
            with contextlib.redirect_stdout(buf):
                main(['family-update.py', *argv])
        finally:
            os.chdir(old)
            os.environ.clear()
            os.environ.update(saved)
        return buf.getvalue()

    def sections(out):
        where, cur = {}, None
        for line in out.splitlines():
            m = re.match(r'  ([A-Z][A-Z ]+?)[:( ]', line)
            if m and not line.startswith('    '):
                cur = line.strip()
            elif re.match(r'    \S', line) and cur and not line.startswith('    …'):
                where[line.strip()] = cur
        return where

    G = ['.claude/skills/plain/SKILL.md', '.claude/skills/edited/SKILL.md',
         '.claude/skills/fresh/SKILL.md', '.claude/hooks/fresh-hook.sh']
    hook = {'hooks': [{'type': 'command', 'command': 'bash .claude/hooks/fresh-hook.sh', 'timeout': 10}]}
    releases = {
        'v1': {'README.md': 'readme 1\n', 'owned.md': 'owned 1\n', 'merged.md': 'a\nb\nc\nd\ne\n',
               'conflict.md': 'one\n', 'retired.md': 'retired 1\n', '.gitignore': 'build/\n',
               'example.md': 'example 1\n', 'CONTEXT.md': 'context 1\n',
               G[0]: 'plain 1\n', G[1]: 'edited 1\n',
               SETTINGS: '{\n  "model": "opus"\n}\n'},
    }
    v2 = dict(releases['v1'])
    v2.update({'README.md': 'readme 2\n', 'owned.md': 'owned 2\n', 'merged.md': 'a\nb\nc\nd\nE\n'})
    releases['v2'] = v2
    v3 = dict(v2)
    v3.update({'README.md': 'readme 3\n', 'owned.md': 'owned 3\n', 'merged.md': 'a\nb\nc\nd\nE3\n',
               'conflict.md': 'template three\n', '.gitignore': 'build/\n*.log\n',
               'example.md': 'example 3\n', 'CONTEXT.md': 'context 3\n', 'brand-new.md': 'new 3\n',
               'mine.md': 'template mine 3\n', G[0]: 'plain 3\n', G[1]: 'edited 3\n',
               G[2]: 'fresh 3\n', G[3]: '#!/bin/sh\nexit 0\n',
               SETTINGS: json.dumps({'model': 'opus', 'permissions': {'deny': ['Edit(build/**)', 'Bash(rm *)']},
                                     'hooks': {'UserPromptSubmit': [hook]}}, indent=2) + '\n'})
    del v3['retired.md']
    releases['v3'] = v3
    v4 = dict(v3)
    v4.update({'owned.md': 'owned 4\n', 'merged.md': 'a\nb\nc\nd\nE4\n',
               SETTINGS: json.dumps({'model': 'sonnet', 'hooks': {'UserPromptSubmit': [hook]},
                                     'permissions': {'deny': ['Edit(build/**)', 'Bash(rm *)'],
                                                     'ask': ['Bash(git push *)']}}, indent=2) + '\n'})
    releases['v4'] = v4

    with tempfile.TemporaryDirectory() as tmp:
        src, proj = os.path.join(tmp, 'tpl'), os.path.join(tmp, 'proj')
        os.makedirs(os.path.join(src, 'migrations'))
        write(src, REFRESH_DATA, json.dumps({'format': 1, 'template': 'probe', 'refresh': G, 'settings': {
            'hooks': {'UserPromptSubmit': [hook]},
            'permissions': {'deny': ['Edit(build/**)', 'Bash(rm *)'], 'ask': ['Bash(git push *)']}}}))
        git('init', '-q', src)
        shas = {}
        for v in ('v1', 'v2', 'v3', 'v4'):
            write(src, 'VERSION', v + '\n')
            git('-C', src, 'add', '-A')
            git('-C', src, 'commit', '-q', '-m', v, env=IDENT)
            git('-C', src, 'tag', v)
            shas[v] = verify(v, cwd=src)
        by_sha = {s: v for v, s in shas.items()}
        renders = []

        def fake(src_, ref, data, out):
            v = by_sha.get(verify(ref, cwd=src) or ref)
            if v is None or os.environ.get('PROBE_NO_COPIER'):
                return 'copier could not be run (probe)'
            renders.append(v)
            for rel, text in releases[v].items():
                write(out, rel, text, 0o755 if rel.endswith('.sh') else None)
            write(out, '.copier-answers.probe.yml', '_commit: %s\nNAME: probe\n' % v)
            return ''
        RENDER = fake
        A = '.copier-answers.probe.yml'
        common = ['--src', src, '--answers', A]

        # A copy at v1, its baseline, the owner at work.
        git('init', '-q', proj)
        for rel, text in releases['v1'].items():
            write(proj, rel, text)
        write(proj, A, '_commit: v1\nNAME: probe\n')
        run(proj, 'baseline', '--to', shas['v1'], *common)
        check(verify('refs/probe/template', cwd=proj), 'baseline records refs/probe/template')
        write(proj, '.gitignore', 'build/\nmine/\n')
        write(proj, 'merged.md', 'A\nb\nc\nd\ne\n')
        write(proj, 'conflict.md', 'mine one\n')
        write(proj, 'retired.md', 'retired, edited\n')
        write(proj, G[1], 'edited by the owner\n')
        write(proj, 'mine.md', 'my own file\n')
        write(proj, SETTINGS, '{\n  "model": "opus",\n  "permissions": {\n    "allow": ["Bash(rm *)"]\n  }\n}\n')
        os.remove(os.path.join(proj, 'example.md'))
        git('-C', proj, 'add', '-A')
        git('-C', proj, 'commit', '-q', '-m', 'copied and worked', env=IDENT)

        def copier_update(v_from, v_to, conflict_mode='inline'):
            """What Copier would do: deliver owned files, merge, conflict, delete, keep the rest."""
            new = releases[v_to]
            for rel in ('owned.md',):
                write(proj, rel, new[rel])
            if v_to == 'v2':
                write(proj, 'merged.md', 'A\nb\nc\nd\nE\n')
            else:
                write(proj, 'merged.md', 'A\nb\nc\nd\nE3\n')
                if conflict_mode == 'inline':
                    write(proj, 'conflict.md', '<<<<<<< before updating\nmine one\n=======\ntemplate three\n>>>>>>> after updating\n')
                    base = git('-C', proj, 'hash-object', '-w', '--stdin', inp='one\n').strip()
                    ours = git('-C', proj, 'hash-object', '-w', '--stdin', inp='mine one\n').strip()
                    theirs = git('-C', proj, 'hash-object', '-w', '--stdin', inp='template three\n').strip()
                    git('-C', proj, 'update-index', '--index-info',
                        inp='0 %s\tconflict.md\n100644 %s 1\tconflict.md\n100644 %s 2\tconflict.md\n100644 %s 3\tconflict.md\n'
                        % ('0' * 40, base, ours, theirs))
                else:
                    write(proj, 'conflict.md', 'template three\n')
                    write(proj, 'conflict.md.rej', '@@ -1 +1 @@\n-one\n+mine one\n')
                os.remove(os.path.join(proj, 'retired.md'))
            write(proj, A, '_commit: %s\nNAME: probe\n' % v_to)

        env2 = {'VERSION_FROM': 'v1', 'VERSION_PEP440_FROM': '1', 'VERSION_PEP440_TO': '2'}
        copier_update('v1', 'v2')
        out = run(proj, 'update', '--to', shas['v2'], *common, env=env2)
        s = sections(out)
        check(s.get('README.md', '').startswith('NOT UPDATED because files of this kind'), 'step 1: an unedited seed is written once (%r)' % s.get('README.md'))
        check(s.get('.gitignore') is None, 'step 1: a seed the template did not change is not listed')
        git('-C', proj, 'add', '-A')
        git('-C', proj, 'commit', '-q', '-m', 'updated to v2', env=IDENT)

        # A sibling template's record holds the bytes CONTEXT.md has here.
        sib_tree_dir = os.path.join(tmp, 'sib')
        write(sib_tree_dir, 'CONTEXT.md', 'context of the sibling\n')
        env_sib = {'GIT_DIR': os.path.join(proj, '.git'), 'GIT_WORK_TREE': sib_tree_dir,
                   'GIT_INDEX_FILE': os.path.join(tmp, 'sib.index')}
        git('add', '-A', '--force', '.', env=env_sib, cwd=sib_tree_dir)
        stree = git('write-tree', env=env_sib, cwd=sib_tree_dir).strip()
        os.chdir(proj)
        try:
            commit(stree, 'sibling render\n\ncommit: %s\nanswers: %s\n' % ('a' * 40, 'b' * 40), 'refs/sibling/template')
        finally:
            os.chdir(tmp)
        write(proj, 'CONTEXT.md', 'context of the sibling\n')
        git('-C', proj, 'add', '-A')
        git('-C', proj, 'commit', '-q', '-m', 'sibling copy', env=IDENT)

        before = git('-C', proj, 'rev-parse', 'refs/probe/template').strip()
        rej_proj = os.path.join(tmp, 'proj-rej')
        shutil.copytree(proj, rej_proj, symlinks=True)
        env3 = {'VERSION_FROM': 'v2', 'VERSION_PEP440_FROM': '2', 'VERSION_PEP440_TO': '3'}
        renders.clear()
        copier_update('v2', 'v3')
        out = run(proj, 'update', '--to', shas['v3'], *common, env=env3)
        s = sections(out)
        check(renders == ['v3'], 'B: an update with a matching record renders the new version only (%r)' % renders)
        want = {'conflict.md': 'CONFLICT', 'retired.md': 'DELETED by this update although',
                '.gitignore': 'NOT UPDATED because you had changed', G[1]: 'NOT UPDATED because you had changed',
                'README.md': 'NOT UPDATED because files of this kind', 'CONTEXT.md': "NOT UPDATED because the file holds sibling's",
                'mine.md': 'NOT UPDATED because it is new', 'example.md': 'NOT RESTORED',
                'brand-new.md': 'NOT ADDED'}
        for p, sec in want.items():
            check(s.get(p, '').startswith(sec), 'section of %s: want %r, got %r' % (p, sec, s.get(p)))
        for p in ('owned.md', 'merged.md', G[0], G[2], G[3]):
            check(p not in s, '%s is not listed (delivered, merged or refreshed)' % p)
        check(s.get(SETTINGS, '').startswith('NOT UPDATED because you had changed'), 'the settings the owner changed are listed after the entries are added')
        check(read(proj, G[0]) == 'plain 3\n', 'an unedited shared file is refreshed')
        check(read(proj, G[1]) == 'edited by the owner\n', 'an edited shared file is never overwritten')
        check(read(proj, G[2]) == 'fresh 3\n', 'a new shared file arrives')
        check(os.access(os.path.join(proj, G[3]), os.X_OK), 'a new shared hook arrives executable')
        st = json.loads(read(proj, SETTINGS))
        check(st.get('hooks', {}).get('UserPromptSubmit') == [hook], 'the new hook is wired once')
        check(st['permissions'].get('deny') == ['Edit(build/**)'], 'a new deny rule is added; an allowed one is not')
        check(st['permissions'].get('allow') == ['Bash(rm *)'], 'the owner allow rule is kept')
        check('because you allow it: deny Bash(rm *)' in out, 'the refused deny rule is reported')
        check('refreshed 1 shared file' in out and 'added 2 shared files' in out, 'the refresh lines are printed')
        changed = {l[3:] for l in git('-C', proj, 'status', '--porcelain', '-uall').splitlines()}
        beyond = changed - {'owned.md', 'merged.md', 'conflict.md', 'retired.md', A}
        check(beyond == {G[0], G[2], G[3], SETTINGS},
              'only the shared files and the settings changed beyond the update (%r)' % sorted(beyond))
        rec = git('-C', proj, 'rev-parse', 'refs/probe/template^').strip()
        check(rec == before, 'the new render is chained to the previous one')
        check(git('-C', proj, 'rev-parse', 'refs/probe/yours').strip() == git('-C', proj, 'rev-parse', 'HEAD').strip(),
              'refs/probe/yours is the pre-update HEAD')
        # Every printed command runs, offline, in a copy of the project.
        cmds = [l.split(':', 1)[1].strip() for l in out.splitlines()
                if re.match(r'\s+(compare|take|see|restore|yours):', l)]
        cmds += [l.strip() for l in out.splitlines() if l.strip().startswith('git ') and '<path>' not in l]
        for cmd in cmds:
            trial = os.path.join(tmp, 'trial')
            shutil.rmtree(trial, ignore_errors=True)
            shutil.copytree(proj, trial, symlinks=True)
            r = subprocess.run(shlex.split(cmd), cwd=trial, capture_output=True, text=True)
            check(r.returncode == 0, 'the printed command runs: %s (%s)' % (cmd, r.stderr.strip()[:80]))
        check(len(cmds) >= 12, 'the report printed its commands (%d)' % len(cmds))
        # A rerun at the same versions renders nothing and changes nothing.
        snap = (git('-C', proj, 'status', '--porcelain'), git('-C', proj, 'for-each-ref'))
        renders.clear()
        run(proj, 'update', '--to', shas['v3'], *common, env=env3)
        check(not renders and snap == (git('-C', proj, 'status', '--porcelain'), git('-C', proj, 'for-each-ref')),
              'a rerun renders nothing and changes nothing')
        # The next update at the same version is quiet.
        write(proj, 'conflict.md', 'template three\n')
        git('-C', proj, 'add', '-A')
        git('-C', proj, 'commit', '-q', '-m', 'updated to v3', env=IDENT)
        out = run(proj, 'update', '--to', shas['v3'], *common,
                  env={'VERSION_FROM': 'v3', 'VERSION_PEP440_FROM': '3', 'VERSION_PEP440_TO': '3'})
        check(out.strip().splitlines() == ['▸ probe update report, 3 → 3: the template did not change.'],
              'an update with nothing new is one quiet line (%r)' % out)
        check(not git('-C', proj, 'status', '--porcelain'), 'an update with nothing new changes nothing')

        # Rej mode, in the copy taken before step 2.
        proj_saved, proj = proj, rej_proj
        copier_update('v2', 'v3', 'rej')
        out = run(proj, 'update', '--to', shas['v3'], *common, env=env3)
        check(sections(out).get('conflict.md', '').startswith('REJECTED HUNKS'), 'rej mode: the .rej file is reported (%r)' % sections(out).get('conflict.md'))
        # The opt-out, a missing copier and a missing old version: one line each, exit 0.
        for label, env, prep in (('off', {'SYNTEK_UPDATE_REPORT': 'off'}, None),
                                 ('no copier', {'PROBE_NO_COPIER': '1'}, None),
                                 ('no old version', {'VERSION_FROM': 'v9'}, None)):
            clone = os.path.join(tmp, 'clone-' + label.replace(' ', '-'))
            git('clone', '-q', proj_saved, clone)
            out = run(clone, 'update', '--to', shas['v3'], *common, env={**env3, **env})
            # A clone holds no record: the owner's allow rule is reported once more beside it.
            report = [l for l in out.strip().splitlines() if not l.startswith('▸ probe: not added')]
            check(len(report) == 1, '%s: one line (%r)' % (label, out))
        proj = proj_saved
        # The record keeps no path of this machine: no rendered answers file, no message.
        chain = git('-C', proj, 'rev-list', 'refs/probe/template').split()
        check(not git('-C', proj, 'grep', '-l', '-F', tmp, *chain, check=False).strip()
              and tmp not in git('-C', proj, 'log', '--format=%B', 'refs/probe/template'),
              'the render record holds no absolute path')
        check(all(not p.startswith('.copier-answers.') for p in tree_map_in(proj, 'refs/probe/template')),
              'the render record holds no answers file')
        check(re.search(r'^settings-offered: \d+$', git('-C', proj, 'log', '-1', '--format=%B', 'refs/probe/template'), re.M),
              'the render record lists the settings entries offered')
        # ── Later runs: each guard the refresh and the report rely on, one project each ──
        def fresh(name, v):
            d = os.path.join(tmp, name)
            git('init', '-q', d)
            for rel, text in releases[v].items():
                write(d, rel, text, 0o755 if rel.endswith('.sh') else None)
            write(d, A, '_commit: %s\nNAME: probe\n' % v)
            run(d, 'baseline', '--to', shas[v], *common)
            return d

        def commit_all(d, msg):
            git('-C', d, 'add', '-A')
            git('-C', d, 'commit', '-q', '-m', msg, env=IDENT)

        def sim_update(d, v_to):
            """Copier's update of an unedited project: template files written, retired ones deleted."""
            new = releases[v_to]
            for rel in ('owned.md', 'merged.md', 'conflict.md'):
                write(d, rel, new[rel])
            if 'retired.md' not in new and os.path.exists(os.path.join(d, 'retired.md')):
                os.remove(os.path.join(d, 'retired.md'))
            write(d, A, '_commit: %s\nNAME: probe\n' % v_to)

        def upd(d, v_from, v_to, extra=None):
            return run(d, 'update', '--to', shas[v_to], *common,
                       env={'VERSION_FROM': v_from, 'VERSION_PEP440_FROM': v_from[1:],
                            'VERSION_PEP440_TO': v_to[1:], **(extra or {})})

        # A refresh skipped (the report off, a render that failed): the next full run delivers it.
        for label, extra in (('off', {'SYNTEK_UPDATE_REPORT': 'off'}), ('failed', {'PROBE_NO_COPIER': '1'})):
            d = fresh('late-' + label, 'v2')
            commit_all(d, 'copied')
            sim_update(d, 'v3')
            upd(d, 'v2', 'v3', extra)
            check(read(d, G[2]) is None, '%s: the skipped run writes no shared file' % label)
            os.remove(os.path.join(d, G[0]))
            commit_all(d, 'updated, a shared file deleted')
            sim_update(d, 'v4')
            out = upd(d, 'v3', 'v4')
            check(read(d, G[2]) == 'fresh 3\n' and os.access(os.path.join(d, G[3]), os.X_OK),
                  '%s: the shared files a skipped refresh never wrote arrive with the next update (%r)' % (label, out))
            check(read(d, G[0]) is None, '%s: a shared file the owner deleted stays deleted' % label)
            check(has_hook(json.loads(read(d, SETTINGS)), 'UserPromptSubmit', hook),
                  '%s: the hook entry is wired beside its script' % label)

        # A recopy over a project an earlier version made, with no record: history seeded, refreshed.
        d = os.path.join(tmp, 'recopy')
        git('init', '-q', d)
        for rel, text in releases['v1'].items():
            write(d, rel, text)
        write(d, A, '_commit: v1\nNAME: probe\n')
        commit_all(d, 'copied without tasks')
        for rel, text in releases['v3'].items():
            kept = rel in ('README.md', '.gitignore', 'CONTEXT.md', 'example.md', SETTINGS) \
                or (rel in G and os.path.exists(os.path.join(d, rel)))
            if not kept:
                write(d, rel, text, 0o755 if rel.endswith('.sh') else None)
        os.remove(os.path.join(d, 'retired.md'))
        write(d, A, '_commit: v3\nNAME: probe\n')
        out = run(d, 'baseline', '--to', shas['v3'], *common)
        check(read(d, G[0]) == 'plain 3\n' and read(d, G[1]) == 'edited 3\n',
              'recopy: the unedited shared files the copy kept are refreshed (%r)' % out)
        check(verify('refs/probe/template^', cwd=d), 'recopy: the earlier render is seeded under the copy')
        commit_all(d, 'recopied')
        sim_update(d, 'v4')
        out = upd(d, 'v3', 'v4')
        check('you had changed' not in out, 'recopy: a later update names nothing as changed by the owner (%r)' % out)

        # settings.json changed only by this script: delivered, then the template's, never 'yours'.
        d = fresh('sblob', 'v2')
        commit_all(d, 'copied')
        sim_update(d, 'v3')
        out = upd(d, 'v2', 'v3')
        check(SETTINGS not in sections(out), 'settings: the release\'s entries added count as delivered (%r)' % out)
        commit_all(d, 'updated')
        sim_update(d, 'v4')
        out = upd(d, 'v3', 'v4')
        check(sections(out).get(SETTINGS, '').startswith('NOT UPDATED because files of this kind'),
              'settings: a file only this script changed is written once, not yours (%r)' % sections(out).get(SETTINGS))
        check(has_rule(json.loads(read(d, SETTINGS)), 'ask', 'Bash(git push *)'), 'settings: v4\'s ask rule is added')

        # The record alone knows an entry was offered: the owner removed it before any commit.
        d = fresh('srecord', 'v2')
        commit_all(d, 'copied')
        sim_update(d, 'v3')
        upd(d, 'v2', 'v3')
        st = json.loads(read(d, SETTINGS))
        st.pop('hooks', None)
        write(d, SETTINGS, json.dumps(st, indent=2) + '\n')
        commit_all(d, 'updated, the hook removed')
        sim_update(d, 'v4')
        upd(d, 'v3', 'v4')
        check(not has_hook(json.loads(read(d, SETTINGS)), 'UserPromptSubmit', hook),
              'recorded: a hook the record lists as offered is not added back, though no commit held it')

        # Guards: a branch and a tag called template, a foreign commit at the record's ref, stale
        # and ignored .rej files, an uncommitted change, an unedited retired file.
        d = fresh('probes', 'v2')
        write(d, 'README.md', 'my readme\n')
        write(d, G[0], 'MY OWN SKILL\n')
        write(d, G[1], 'custom\n')
        write(d, 'owned.md.rej', 'stale\n')
        write(d, '.gitignore', 'build/\nvendor/\n')
        write(d, 'vendor/pkg/fix.c', 'x\n')
        write(d, 'vendor/pkg/fix.c.rej', 'y\n')
        commit_all(d, 'worked')
        git('-C', d, 'branch', 'template')
        git('-C', d, 'tag', 'template')
        git('-C', d, 'update-ref', 'refs/probe/template', 'HEAD')
        write(d, G[1], 'edited 1\n')
        sim_update(d, 'v3')
        out = upd(d, 'v2', 'v3')
        s = sections(out)
        check(s.get('README.md', '').startswith('NOT UPDATED because you had changed'),
              'a branch or tag called template is no sibling (%r)' % s.get('README.md'))
        check(read(d, G[0]) == 'MY OWN SKILL\n' and s.get(G[0], '').startswith('NOT UPDATED because you had changed'),
              'a commit at the record\'s ref that is no record is never trusted (%r)' % s.get(G[0]))
        check(all(is_record(git('-C', d, 'log', '-1', '--format=%B', c))
                  for c in git('-C', d, 'rev-list', 'refs/probe/template').split()),
              'the new record is never chained onto a commit that is no record')
        check('REJECTED' not in out and 'owned.md' not in s and 'vendor/pkg/fix.c' not in s,
              'a stale or ignored .rej is no conflict of this update (%r)' % out)
        check(read(d, G[1]) == 'edited 1\n', 'a shared file whose work tree differs from HEAD is never refreshed')
        check('retired.md' not in s, 'an unedited retired file is delivered, not listed (%r)' % s.get('retired.md'))
        os.chdir(d)
        try:
            others = others_history('probe')
            check(not set(others) & {'probe', 'heads', 'tags'}, 'others_history names no own or Git ref (%r)' % sorted(others))
        finally:
            os.chdir(tmp)
        # A renamed path keeps its blob in a chain's history; a commit that is no record ends it.
        d = os.path.join(tmp, 'chain')
        git('init', '-q', d)
        os.chdir(d)
        try:
            write(d, 'zz/before.md', 'renamed\n')
            git('add', 'zz/before.md')
            tail = '\n\ncommit: %s\nanswers: %s\n' % ('c' * 40, 'd' * 40)
            git('commit', '-q', '-m', 'r1' + tail, env=IDENT)
            git('mv', 'zz/before.md', 'zz/after.md')
            git('commit', '-q', '-m', 'r2' + tail, env=IDENT)
            hist = history('HEAD')
            check('zz/after.md' in hist and 'zz/before.md' in hist, 'history keeps both paths of a rename (%r)' % sorted(hist))
            git('commit', '-q', '--allow-empty', '-m', 'not a record', env=IDENT)
            check(not history('HEAD'), 'history stops at a commit that is no record')
        finally:
            os.chdir(tmp)

        # A shared folder that is a link (inside the project, or out of it) is never written through.
        d = fresh('linked', 'v2')
        outside = os.path.join(tmp, 'outside-hooks')
        os.makedirs(outside)
        os.makedirs(os.path.join(d, 'elsewhere', 'fresh'))
        write(d, 'elsewhere/fresh/.keep', '')
        os.symlink('../../elsewhere/fresh', os.path.join(d, '.claude/skills/fresh'))
        os.symlink(outside, os.path.join(d, '.claude/hooks'))
        commit_all(d, 'linked')
        sim_update(d, 'v3')
        upd(d, 'v2', 'v3')
        check(not os.path.exists(os.path.join(d, 'elsewhere/fresh/SKILL.md')) and not os.listdir(outside),
              'a shared folder that is a link is never written through')
        check(not inside(os.path.join(d, '.claude/hooks'), os.path.realpath(d))
              and inside(os.path.join(d, '.claude/skills'), os.path.realpath(d)),
              'inside() tells a folder outside the project from one in it')

        # A shared file that cannot be written: reported, and the report and the record still follow.
        if os.geteuid() != 0:
            d = fresh('readonly', 'v2')
            os.chmod(os.path.join(d, G[0]), 0o444)
            commit_all(d, 'copied')
            sim_update(d, 'v3')
            out = upd(d, 'v2', 'v3')
            msg = git('-C', d, 'log', '-1', '--format=%B', 'refs/probe/template')
            check('could not write 1 shared file' in out and 'update report' in out
                  and ('commit: %s' % shas['v3']) in msg,
                  'an unwritable shared file is reported, and the update is still reported and recorded (%r)' % out)

        # family-refresh.json that does not parse, or has the wrong shape: nothing refreshed, said.
        import io
        import contextlib
        for label, text in (('truncated', '{"format": 1,'),
                            ('list', json.dumps({'format': 1, 'template': 'probe', 'refresh': [], 'settings': []}))):
            bad = os.path.join(tmp, 'bad-' + label)
            write(bad, REFRESH_DATA, text)
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                got = refresh_data(bad, 'probe')
            check(got is None and 'nothing refreshed' in buf.getvalue(),
                  'a %s family-refresh.json refreshes nothing and says so (%r)' % (label, buf.getvalue()))

        settings_probe(os.path.join(tmp, 'settings'), check)
        for probe in (lambda: mcp_probe(os.path.join(tmp, 'mcp'), check), lambda: allow_probe(check)):
            try:
                probe()
            except Exception as err:   # a probe that raises is a failure, never a crash
                check(False, 'a probe raised %s: %s' % (type(err).__name__, err))

        # ── The MCP lane through update and baseline: attribution, the opt-out, the root ──
        msrc = os.path.join(tmp, 'tplm')
        os.makedirs(os.path.join(msrc, 'migrations'))
        write(msrc, REFRESH_DATA, json.dumps({'format': 1, 'template': 'mprobe', 'refresh': [], 'settings': {},
                                              'mcp': {'servers': PROBE_MCP['servers'], 'files': {'.mcp.json': ['mcpServers']}}}))
        git('init', '-q', msrc)
        scr2 = dict(PROBE_SCR, args=['--from', 'scr==2', 'scr', 'mcp'])
        for v, servers in (('m1', {}), ('m2', {'code-review-graph': PROBE_CRG, 'scrapling': PROBE_SCR}),
                           ('m3', {'code-review-graph': PROBE_CRG, 'scrapling': scr2})):
            releases[v] = {'README.md': 'readme %s\n' % v, SETTINGS: '{\n  "model": "opus"\n}\n',
                           '.mcp.json': json.dumps({'mcpServers': servers}, indent=2 if servers else None) + '\n'}
            write(msrc, 'VERSION', v + '\n')
            git('-C', msrc, 'add', '-A')
            git('-C', msrc, 'commit', '-q', '-m', v, env=IDENT)
            shas[v] = verify('HEAD', cwd=msrc)
            by_sha[shas[v]] = v
        MA = '.copier-answers.mprobe.yml'
        mcommon = ['--src', msrc, '--answers', MA]

        def mfresh(name, edit=None):
            d = os.path.join(tmp, name)
            git('init', '-q', d)
            for rel, text in releases['m1'].items():
                write(d, rel, text)
            write(d, MA, '_commit: m1\nNAME: probe\n')
            run(d, 'baseline', '--to', shas['m1'], *mcommon)
            if edit:
                write(d, '.mcp.json', edit)
            commit_all(d, 'copied')
            return d

        def mupd(d, v_from, v_to, extra=None, cwd=None):
            write(d, 'README.md', releases[v_to]['README.md'])
            write(d, MA, '_commit: %s\nNAME: probe\n' % v_to)
            return run(cwd or d, 'update', '--to', shas[v_to], *mcommon,
                       env={'VERSION_FROM': shas[v_from], 'VERSION_PEP440_FROM': v_from, 'VERSION_PEP440_TO': v_to, **(extra or {})})

        def mrecord(d):
            return git('-C', d, 'log', '-1', '--format=%B', 'refs/mprobe/template')

        # Unedited: the lane writes the new render's bytes (delivered); written once on the next update.
        d = mfresh('mcp-unedited')
        out = mupd(d, 'm1', 'm2')
        msg = mrecord(d)
        check(read(d, '.mcp.json') == releases['m2']['.mcp.json'] and '.mcp.json' not in sections(out)
              and 'added 2 MCP servers to .mcp.json' in out, 'mcp flow: an unedited .mcp.json is delivered (%r)' % out)
        check(re.search(r'^mcp-offered: 2$', msg, re.M) and re.search(r'^mcp: \.mcp\.json scrapling [0-9a-f]{64}$', msg, re.M)
              and re.search(r'^written-blob: \.mcp\.json [0-9a-f]{40,64}$', msg, re.M), 'mcp flow: the record lists the offers and the blob (%r)' % msg[-400:])
        check(tmp not in git('-C', d, 'log', '--format=%B', 'refs/mprobe/template'), 'mcp flow: the record holds no absolute path')
        commit_all(d, 'updated')
        out = mupd(d, 'm2', 'm3')
        check(sections(out).get('.mcp.json', '').startswith('NOT UPDATED because files of this kind')
              and read(d, '.mcp.json') == releases['m2']['.mcp.json'] and 'MCP server' not in out,
              'mcp flow: a file only the lane wrote is written once next time, its offers quiet (%r)' % out)
        # Edited by the owner: 'you had changed them' on both updates.
        mine = '{\n    "mcpServers": {\n        "mine": {\n            "command": "x"\n        }\n    }\n}\n'
        d = mfresh('mcp-edited', mine)
        out = mupd(d, 'm1', 'm2')
        check(sections(out).get('.mcp.json', '').startswith('NOT UPDATED because you had changed')
              and list(json.loads(read(d, '.mcp.json'))['mcpServers']) == ['mine', 'code-review-graph', 'scrapling']
              and re.search(r'^written-blob: \.mcp\.json [0-9a-f]+ edited$', mrecord(d), re.M),
              'mcp flow: an owner-edited .mcp.json is yours, the servers added (%r)' % out)
        commit_all(d, 'updated')
        out = mupd(d, 'm2', 'm3')
        check(sections(out).get('.mcp.json', '').startswith('NOT UPDATED because you had changed'),
              'mcp flow: and still yours on the next update (%r)' % sections(out).get('.mcp.json'))
        # Reformatted by the owner, the servers inserted: equal to the new render's once written,
        # so the template's, never 'yours'.
        d = mfresh('mcp-reformatted', '{\n    "mcpServers": {}\n}\n')
        out = mupd(d, 'm1', 'm2')
        check('.mcp.json' not in sections(out) and re.search(r'^written-blob: \.mcp\.json [0-9a-f]+$', mrecord(d), re.M),
              'mcp flow: a write that leaves the file equal to the new render is delivered and the template\'s (%r)' % out)
        commit_all(d, 'updated')
        out = mupd(d, 'm2', 'm3')
        check(sections(out).get('.mcp.json', '').startswith('NOT UPDATED because files of this kind'),
              'mcp flow: and written once on the next update (%r)' % sections(out).get('.mcp.json'))
        # The opt-out: no lane; the next full update delivers it.
        d = mfresh('mcp-off')
        mupd(d, 'm1', 'm2', {'SYNTEK_UPDATE_REPORT': 'off'})
        check(read(d, '.mcp.json') == releases['m1']['.mcp.json'], 'mcp flow: SYNTEK_UPDATE_REPORT=off runs no lane')
        commit_all(d, 'updated, report off')
        mupd(d, 'm2', 'm3')
        check(set(json.loads(read(d, '.mcp.json'))['mcpServers']) == {'code-review-graph', 'scrapling'},
              'mcp flow: the next full update adds the servers')
        # Not at the repository root: the line says no MCP server was offered.
        d = mfresh('mcp-sub')
        os.makedirs(os.path.join(d, 'sub'))
        out = mupd(d, 'm1', 'm2', cwd=os.path.join(d, 'sub'))
        check('no settings entry or MCP server was offered' in out and read(d, '.mcp.json') == releases['m1']['.mcp.json'],
              'mcp flow: not at the root, no MCP server is offered (%r)' % out)
    RENDER = None
    for f in fails:
        print('  ✗ ' + f)
    print('%s family-update.py --self-test: %s' % ('✓' if not fails else '✗',
          'every class, the refresh, the commands, the rerun and the limits hold' if not fails else '%d failure(s)' % len(fails)))
    return 0 if not fails else 1


def main(argv):
    if len(argv) > 1 and argv[1] in ('--help', '-h'):
        print(__doc__)
        return 0
    if len(argv) > 1 and argv[1] == '--self-test':
        return self_test()
    try:
        sub = argv[1] if len(argv) > 1 else ''
        args, rest = {}, argv[2:]
        while rest:
            if rest[0] in ('--src', '--to', '--answers') and len(rest) > 1:
                args[rest[0]] = rest[1]
                rest = rest[2:]
            else:
                say('unknown argument %s; see --help.' % rest[0])
                return 0
        if sub == 'update':
            cmd_update(args)
        elif sub == 'baseline':
            cmd_baseline(args)
        else:
            say('usage: family-update.py update|baseline --src S --to SHA --answers F (or --help).')
    except Exception as err:   # a migration must never fail the update
        say('stopped: %s' % err)
    return 0


if __name__ == '__main__':
    if sys.version_info < (3, 11):
        print('  family-update: needs Python 3.11 or later; nothing reported.')
        sys.exit(0)
    try:   # an output that cannot show a character must never stop the run after a write
        sys.stdout.reconfigure(errors='replace')
    except (AttributeError, ValueError):
        pass
    sys.exit(main(sys.argv))
