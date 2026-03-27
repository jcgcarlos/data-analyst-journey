# My Python Learning Log

A running journal of what I'm working through, what's clicking, and what I still need to sit with. This isn't a textbook — it's just me tracking my own progress honestly.

---

## March 15, 2026 — Data Types (Numbers, Strings, Lists, Tuples, Dictionaries, Sets & Booleans)

Heavy first session — covered all the core data types in one go. A lot to absorb, but the thread running through all of them was mutability. Lists, dictionaries, and sets can be changed after creation. Strings and tuples can't — they're immutable. You can create new ones from operations on existing ones, but you can't modify them in place. Once I had that dividing line, the rest fell into place more easily.

The string gotcha that bit me early: string methods don't change the original. `x.upper()` returns an uppercase copy but `x` stays unchanged. Same trap with lists — `.sort()` modifies the list in place and returns `None`. So `sorted_list = my_list.sort()` gives you `None`, not a sorted list. Two fixes: either just reference `my_list` directly after `.sort()`, or use the built-in `sorted(my_list)` which returns a new sorted copy without touching the original.

For numbers: division always returns a float. `24 / 2` gives `12.0`, not `12`. Use `//` (floor division) when you need an integer. And exponents use `**`, not `^` — `^` is bitwise XOR in Python, completely different from Excel.

Dictionaries: `KeyError` is the main trap. If the key doesn't exist, it crashes. Safer to use `.get('key', default)` — returns the default instead of raising an error. And the empty set gotcha: `x = {}` creates a dictionary, not a set. Have to use `x = set()`.

Next Session: File I/O

---

## March 17, 2026 — File I/O

Short session on reading and writing files. The main pattern: always use `with open()` — it handles closing automatically even if something goes wrong.

Mode matters a lot. `'r'` reads, `'w'` writes (and silently overwrites any existing content), `'a'` appends. The dangerous one is `'w'` — if you run it on a file that already has content, that content is gone with no warning. I now double-check whether I mean `'w'` (replace everything) or `'a'` (add to the end) before writing.

The cursor behavior was unexpected. After calling `.read()`, the cursor sits at the end of the file. Calling `.read()` again just returns an empty string — there's nothing left to read from. You have to call `.seek(0)` to reset back to the start. The `with` statement sidesteps this cleanly since every open starts fresh.

Next Session: Comparison Operators & if / elif / else

---

## March 18, 2026 — Comparison Operators & if / elif / else

Two related topics in one session — comparison operators feed directly into conditionals, so they made sense together.

Comparison operators (`==`, `!=`, `<`, `>`, `<=`, `>=`) return `True` or `False`. The `=` vs `==` mix-up is the classic trap — `=` is assignment, `==` is comparison. Python throws a `SyntaxError` if you use `=` inside a condition, which is actually more helpful than languages that let it slide silently.

Chaining comparisons was a nice find — `1 < x < 10` is valid Python and reads naturally. Most languages don't have that.

For conditionals: only the first True branch runs. Even if multiple conditions would be True, Python stops at the first match. Order of `elif` branches matters — more specific conditions should come before more general ones. And indentation is non-negotiable. Python uses whitespace to define code blocks, not curly braces. Four spaces is the standard.

Truthy/Falsy is also useful — empty string `''`, `0`, `None`, and `[]` are all falsy, which lets you write clean `if result:` checks instead of `if result is not None:`.

Next Session: For Loops & While Loops

---

## March 25, 2026 — For Loops & While Loops

For loops iterate over a known sequence. While loops run until a condition flips to False. The mental model: use `for` when you know what you're iterating; use `while` when you're waiting for something to *change*.

`range()` is zero-indexed and the stop value is exclusive. `range(5)` gives `0, 1, 2, 3, 4`. If you want 1 through 5, it's `range(1, 6)`. That off-by-one is easy to forget.

`enumerate()` was immediately useful — gives you both the index and the value without managing a counter manually. `for i, item in enumerate(my_list, start=1)` is cleaner than tracking `i` yourself. For dictionaries, `for key in d:` gives keys only — to get both, use `for key, value in d.items():`. Forgetting `.items()` is a loop mistake I already made.

The while loop infinite loop risk is real. Before writing any while loop, I now immediately write the line that changes the condition. Forgetting `x += 1` inside `while x < 10:` means it runs forever — in Jupyter, that means interrupting the kernel.

The `continue` + counter order was the trickiest part. Inside a while loop, the counter increment has to come *before* the `continue` — otherwise you skip the increment, get stuck on the same element, and create an infinite loop.

Next Session: Functions
