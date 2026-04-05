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

Next Session: Useful Operators

---

## April 4, 2026 — Useful Operators

A grab-bag session — `zip()`, `enumerate()`, `in`/`not in`, `is`, and the `random` module. No single big concept, just a set of tools that show up constantly once you're writing real code.

The one worth drilling: `zip()` pairs up items from two or more lists into tuples. The catch is it silently stops at the shortest list — no error, no warning, just dropped items. That's the kind of thing that causes wrong output with no traceback to point at.

`is` vs `==` is subtle but important. `==` checks if two values are equal. `is` checks if they're literally the same object in memory. They'll agree most of the time, but the safe rule: use `==` for comparisons, use `is` only when checking against `None`. Writing `if x is None:` is the idiom — not `if x == None:`.

`random.shuffle()` is another in-place trap. It modifies the list and returns `None` — same pattern as `.sort()`. Assigning the result to a variable gives you `None`, not the shuffled list.

Next Session: List Comprehensions

---

## April 4, 2026 — List Comprehensions

A one-liner for building a list from another iterable. The pattern: `[expression for item in iterable]`. Add a filter: `[expression for item in iterable if condition]`.

The mental model that made it click: it's just a `for` loop where every iteration returns a value and Python collects them into a list automatically. Once I stopped treating the syntax as its own thing and just read it as a compressed loop, it made sense.

Reading order matters: the left side is what you do to each item, the right side is where the items come from. The filter `if` runs before the expression — so it's loop → filter → transform, left to right.

The trap worth remembering: nested list comprehensions exist, but they degrade fast. If it takes more than a second to parse, write the full loop. Readability wins, especially in anything collaborative.

Next Session: Statements Assessment

---

## April 4, 2026 — Statements Assessment

Wrapped up Section 5 with the full statements assessment — conditionals, loops, operators, list comprehensions all in one go.

Two mistakes worth logging because they're the kind that don't throw errors, they just give you wrong output.

First one: FizzBuzz condition order. I had the conditions in the wrong sequence, which meant the FizzBuzz case (divisible by both 3 and 5) never fired correctly. The rule for any chained conditional: most specific case goes first. Divisible by both 3 and 5 is a stricter condition than divisible by just one of them — it has to be checked before either of the individual branches, otherwise Python hits the `elif 3` or `elif 5` branch first and exits. Order isn't cosmetic in conditionals, it's logic.

Second one: `x%3 and x%5 == 0`. Looks reasonable, doesn't work. Python applies `==` before `and`, so this actually evaluates as `x%3 and (x%5 == 0)` — treating `x%3` as truthy or falsy instead of comparing it to zero. A non-zero remainder is truthy, so numbers not divisible by 3 still pass that half of the check. The correct form is `x%3 == 0 and x%5 == 0` — both sides need the explicit comparison.

Section 5 is done. Next up is Section 6: Functions — where reusable, testable code actually begins.

Next Session: Functions

## April 6, 2025 — Functions, Methods, and *args / **kwargs

Two notebooks in one session. Started with the fundamentals of functions and methods, then moved into one of the more practically useful patterns in Python: flexible function signatures with `*args` and `**kwargs`.

---## April 6, 2025 — Functions, Methods, and *args / **kwargs

Two notebooks in one session. Started with the fundamentals of functions and methods, then moved into one of the more practically useful patterns in Python: flexible function signatures with `*args` and `**kwargs`.

---

### What I covered

**Methods vs Functions**
Methods are functions that belong to an object — called with `object.method()`. Functions are standalone and called directly. The difference matters when you're reading someone else's code and trying to figure out what a line is actually doing.

**Functions**
The `def` keyword defines a reusable block of code. The core insight: write a function when you're about to copy-paste the same logic twice. Functions can return values, return tuples (useful for unpacking multiple results), and contain full logic like loops and conditionals inside them.

One pattern worth remembering — the placement of `return` relative to a loop changes behavior completely:
- `return` *inside* the loop exits on the first match
- `return` *outside* the loop (aligned with `for`) waits until all iterations finish

**`*args` — Variable Positional Arguments**
Lets a function accept any number of positional arguments (no labels). Python packs them into a **tuple** inside the function.

```python
def total(*args):
    return sum(args)

total(100, 200, 300)  # → 600
```

Use when you don't know how many values will be passed, but they're all the same *kind* of thing — amounts, scores, IDs.

**`**kwargs` — Variable Keyword Arguments**
Lets a function accept any number of keyword arguments (`name=value` pairs). Python packs them into a **dictionary**.

```python
def show_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

show_info(currency="PHP", region="NCR")
```

Use when you want optional, named metadata that varies per call.

**Order when using both:**
`regular args → *args → **kwargs`

```python
def summary(label, *args, **kwargs):
    ...
```

---

### AHA moment

The bug I wrote first — accessing `kwargs['currency']` directly — *works* until someone doesn't pass `currency`. That's a `KeyError` waiting in production. The fix isn't just a loop; it's understanding that `**kwargs` exists precisely because you *don't* know what's coming in. Hardcoding the keys defeats the whole point.

Number formatting was also a quiet unlock: `{sum(args):,.2f}` — a comma separator and two decimal places — turns raw output into something that looks like a report. One format spec, zero extra code.

---

### Patterns and traps

- `*args` → tuple inside the function. `**kwargs` → dictionary inside the function.
- Accessing `kwargs` keys directly (`kwargs['key']`) will crash if that key wasn't passed. Always loop with `.items()` instead.
- `len(args)` gives you the count. `args` alone prints the raw tuple — not what you want in output.
- Return placement inside vs. outside a loop is not cosmetic. It changes what the function actually does.
- Financial output: always format with `:,.2f`. It's a small habit that reads as professional.

---

### Exercise — `transaction_summary`

Built a fintech batch reporting function combining all three: a required `batch_name`, transaction amounts via `*args`, and optional metadata via `**kwargs`.

```python
def transaction_summary(batch_name, *args, **kwargs):
    print(f"Batch: {batch_name}")
    print(f"Transactions: {len(args)}")
    print(f"Total Amount: {sum(args):,.2f}")

    for key, value in kwargs.items():
        print(f"  {key}: {value}")
```

Called with:
```python
transaction_summary(
    "Batch_Oct01",
    500, 1200, 340, 875,
    currency="PHP",
    region="NCR",
    analyst="JC"
)
```

Output:
```
Batch: Batch_Oct01
Transactions: 4
Total Amount: 2,915.00
  currency: PHP
  region: NCR
  analyst: JC
```

---

*Next session: Lambda functions and map/filter.*

### What I covered

**Methods vs Functions**
Methods are functions that belong to an object — called with `object.method()`. Functions are standalone and called directly. The difference matters when you're reading someone else's code and trying to figure out what a line is actually doing.

**Functions**
The `def` keyword defines a reusable block of code. The core insight: write a function when you're about to copy-paste the same logic twice. Functions can return values, return tuples (useful for unpacking multiple results), and contain full logic like loops and conditionals inside them.

One pattern worth remembering — the placement of `return` relative to a loop changes behavior completely:
- `return` *inside* the loop exits on the first match
- `return` *outside* the loop (aligned with `for`) waits until all iterations finish

**`*args` — Variable Positional Arguments**
Lets a function accept any number of positional arguments (no labels). Python packs them into a **tuple** inside the function.

```python
def total(*args):
    return sum(args)

total(100, 200, 300)  # → 600
```

Use when you don't know how many values will be passed, but they're all the same *kind* of thing — amounts, scores, IDs.

**`**kwargs` — Variable Keyword Arguments**
Lets a function accept any number of keyword arguments (`name=value` pairs). Python packs them into a **dictionary**.

```python
def show_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

show_info(currency="PHP", region="NCR")
```

Use when you want optional, named metadata that varies per call.

**Order when using both:**
`regular args → *args → **kwargs`

```python
def summary(label, *args, **kwargs):
    ...
```

---

### AHA moment

The bug I wrote first — accessing `kwargs['currency']` directly — *works* until someone doesn't pass `currency`. That's a `KeyError` waiting in production. The fix isn't just a loop; it's understanding that `**kwargs` exists precisely because you *don't* know what's coming in. Hardcoding the keys defeats the whole point.

Number formatting was also a quiet unlock: `{sum(args):,.2f}` — a comma separator and two decimal places — turns raw output into something that looks like a report. One format spec, zero extra code.

---

### Patterns and traps

- `*args` → tuple inside the function. `**kwargs` → dictionary inside the function.
- Accessing `kwargs` keys directly (`kwargs['key']`) will crash if that key wasn't passed. Always loop with `.items()` instead.
- `len(args)` gives you the count. `args` alone prints the raw tuple — not what you want in output.
- Return placement inside vs. outside a loop is not cosmetic. It changes what the function actually does.
- Financial output: always format with `:,.2f`. It's a small habit that reads as professional.

---

### Exercise — `transaction_summary`

Built a fintech batch reporting function combining all three: a required `batch_name`, transaction amounts via `*args`, and optional metadata via `**kwargs`.

```python
def transaction_summary(batch_name, *args, **kwargs):
    print(f"Batch: {batch_name}")
    print(f"Transactions: {len(args)}")
    print(f"Total Amount: {sum(args):,.2f}")

    for key, value in kwargs.items():
        print(f"  {key}: {value}")
```

Called with:
```python
transaction_summary(
    "Batch_Oct01",
    500, 1200, 340, 875,
    currency="PHP",
    region="NCR",
    analyst="JC"
)
```

Output:
```
Batch: Batch_Oct01
Transactions: 4
Total Amount: 2,915.00
  currency: PHP
  region: NCR
  analyst: JC
```

---

*Next session: Lambda functions and map/filter.*

## April 6, 2026 — Lambda, map(), and filter()

Three tools that let you do more with less code — once you stop treating the syntax like it's something special.

`lambda` is just a throwaway function. No `def`, no name, no extra lines — you write the logic inline and move on. On its own it's fine, but it's most useful when passed directly into `map()` or `filter()`.

`map()` applies a function to every item in a list and returns the transformed results. `filter()` applies a True/False test to every item and keeps only the ones that pass. The two naturally chain together: filter first to narrow down your data, then map to transform what's left. That filter → transform sequence is a real data pipeline pattern — not just a Python exercise.

The AHA moment: both `map()` and `filter()` return objects, not lists. Wrapping them in `list()` is not optional — it's how you actually get the values out. Easy to miss, causes confusing output when you do.

The other thing worth flagging: floating point noise. `1200 * 1.025` can return `1229.9999999999998` instead of `1230.0`. That's not a bug — it's how Python handles decimal math internally. In real pipelines, round the output: `round(x * 1.025, 2)`.
```python
# lambda — basic structure
lambda argument: expression

# map() — transform every item
list(map(lambda x: x * 1.025, transactions))

# filter() — keep only items that pass a condition
list(filter(lambda x: x > 10000, transactions))

# the real-world pattern: filter → map
flagged = list(filter(lambda x: x > 10000, transactions))
with_hold = list(map(lambda x: x * 1.01, flagged))
```

Common traps:
- Forgetting `list()` — you'll get a map/filter object with no visible values
- Floating point output — always round financial results in production code

Exercise 1 was straightforward: apply a 2.5% processing fee to a list of transaction amounts using `map()` + `lambda`. Worked on the first try, float noise noted.

Exercise 2 was the more realistic one — a GCash risk flagging pipeline. Filter transactions above ₱10,000, then apply a 1% compliance hold to each flagged amount. Output matched exactly: `[12120.0, 45450.0, 11615.0]`. The two-step filter → transform structure is the part worth remembering.

Next Session: Functions deep dive / pandas intro