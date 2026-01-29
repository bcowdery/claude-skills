# Anti-Patterns Reference

This reference catalogs common architectural and design anti-patterns to watch for during brainstorming sessions. Recognizing anti-patterns helps avoid flawed solutions.

---

## What is an Anti-Pattern?

**Definition:** A commonly used solution that appears to solve a problem but actually creates more problems than it solves.

**Characteristics:**
- Seems reasonable at first
- Has short-term appeal
- Creates long-term pain
- Widely recognized as problematic

**Difference from bad practice:**
- Bad practice: Everyone knows it's wrong
- Anti-pattern: Looks right but isn't

---

## Architectural Anti-Patterns

### God Object (God Class)

**Description:** One class or module that knows too much or does too much.

**Symptoms:**
- Class with thousands of lines
- Names like "Manager", "Controller", "Handler", "Utils"
- Touches many different concerns
- Everything depends on it
- Hard to understand, test, modify

**Why it happens:**
- Convenience (everything in one place)
- Poor separation of concerns
- Iterative feature additions without refactoring

**Problems:**
- Violates SRP
- High coupling throughout system
- Bottleneck for changes
- Merge conflicts
- Hard to test in isolation

**Solution:**
- Identify separate responsibilities
- Extract classes with single concerns
- Use composition to reconnect

**Example:**
```
❌ God Object:
   class ApplicationManager {
     authenticate()
     validateInput()
     processPayment()
     sendEmail()
     generateReports()
     manageDatabase()
     handleLogging()
     ... 50 more methods
   }

✅ Better:
   class AuthenticationService
   class ValidationService
   class PaymentProcessor
   class EmailService
   class ReportGenerator
   class DatabaseRepository
   class Logger
```

---

### Big Ball of Mud

**Description:** System with no recognizable architecture or structure. Haphazardly grown spaghetti code.

**Symptoms:**
- No clear modules or layers
- Circular dependencies everywhere
- Can't explain architecture
- "Just make it work" mentality
- Every change risks breaking something

**Why it happens:**
- No initial design
- Deadline pressure
- Lack of refactoring
- No architectural governance

**Problems:**
- Impossible to understand
- Fragile (changes break unexpectedly)
- Can't be modularized or tested
- Knowledge lives in people's heads

**Solution:**
- Identify natural boundaries
- Extract modules incrementally
- Introduce layers
- Document as you go
- Test to prevent regression

---

### Spaghetti Code

**Description:** Code with tangled, convoluted control flow.

**Symptoms:**
- Deeply nested conditionals
- Goto statements (or equivalents)
- Hard to follow execution path
- Tight coupling between distant parts
- No clear entry/exit points

**Why it happens:**
- Iterative patching without refactoring
- No design before coding
- Copy-paste programming

**Problems:**
- Hard to read and understand
- Brittle (fear of changing)
- Bug-prone
- Hard to test

**Solution:**
- Extract methods for clarity
- Use guard clauses to reduce nesting
- Replace conditionals with polymorphism
- Introduce clear abstractions

---

### Lava Flow

**Description:** Dead code and forgotten features left in codebase because no one dares remove them.

**Symptoms:**
- Code no one understands
- "Don't touch that, it might break something"
- Unused imports, methods, classes
- Commented-out code left "just in case"
- Variables with mysterious names

**Why it happens:**
- Fear of breaking things
- Lack of tests
- Poor version control practices
- Developer turnover

**Problems:**
- Confuses maintainers
- Increases cognitive load
- Slows down compilation/deployment
- Makes real code harder to find

**Solution:**
- Use version control (delete with confidence)
- Write tests for existing behavior
- Remove unused code aggressively
- Document why code exists if needed

---

### Cargo Cult Programming

**Description:** Using patterns or practices without understanding why, because "that's how it's done."

**Symptoms:**
- Using patterns inappropriately
- Over-engineering simple problems
- Copy-pasting without understanding
- "We do X because everyone does X"
- Buzzword-driven development

**Why it happens:**
- Following tutorials blindly
- Mimicking other codebases
- Resume-driven development
- Lack of fundamental understanding

**Problems:**
- Unnecessary complexity
- Wrong tool for the job
- Can't adapt when requirements change
- Technical debt from misapplied patterns

**Solution:**
- Understand WHY before HOW
- Question conventions
- Start simple, add complexity when needed (YAGNI)
- Learn the problem patterns solve

---

### Golden Hammer

**Description:** Using favorite solution for every problem ("If all you have is a hammer, everything looks like a nail").

**Symptoms:**
- Same technology for every problem
- "We should use [favorite tool] for this"
- Forcing solutions into preferred paradigm
- Ignoring better alternatives

**Why it happens:**
- Comfort with familiar tools
- Fear of learning new things
- Time pressure
- Organizational inertia

**Problems:**
- Suboptimal solutions
- Over-complexity when simple solution exists
- Missed opportunities for better approaches
- Reduced flexibility

**Solution:**
- Evaluate multiple options
- Choose tool based on problem, not comfort
- Learn new tools and patterns
- Challenge assumptions

---

### Swiss Army Knife

**Description:** Overly complex interface trying to do everything for everyone.

**Symptoms:**
- Methods with 10+ parameters
- Classes with dozens of methods
- "Feature creep" in APIs
- Too many configuration options
- Hard to understand what class actually does

**Why it happens:**
- Trying to please all users
- Adding features incrementally
- Not splitting responsibilities
- Avoiding breaking changes

**Problems:**
- Violates ISP
- Hard to learn and use
- Fragile (changes affect many clients)
- Most users need small subset

**Solution:**
- Apply Interface Segregation
- Create focused, role-based interfaces
- Favor composition over configuration
- Version APIs to allow breaking changes

---

### Abstraction Inversion

**Description:** Providing only high-level operations when users need low-level control, forcing them to recreate low-level operations using high-level ones.

**Symptoms:**
- Can't do simple operations directly
- Must combine complex operations to achieve basic task
- Inefficient workarounds
- Users reimplementing internals

**Why it happens:**
- Over-abstraction
- Hiding too much
- Not considering actual use cases

**Problems:**
- Frustrating for users
- Performance issues
- Duplicated logic
- Defeats purpose of abstraction

**Solution:**
- Provide both high and low-level operations
- Don't hide necessary details
- Test abstractions with real use cases

---

### Stovepipe System

**Description:** System assembled from poorly integrated components that duplicate functionality.

**Symptoms:**
- Multiple components doing same thing
- No shared services
- Copy-paste integration
- Data duplication across systems
- Inconsistent behavior

**Why it happens:**
- Organizational silos
- Lack of coordination
- Legacy system integration
- "Not invented here" syndrome

**Problems:**
- Maintenance nightmare
- Inconsistency
- Wasted effort
- Hard to evolve

**Solution:**
- Identify shared services
- Extract common functionality
- Use APIs for integration
- Centralize shared logic

---

## Design Anti-Patterns

### Poltergeist (Gypsy)

**Description:** Classes with limited responsibility and lifecycle, often just to invoke methods on other classes.

**Symptoms:**
- Class with one or two methods
- Short-lived objects
- "PassThrough" or "Helper" in name
- Just delegates to other classes
- No real state or behavior

**Why it happens:**
- Over-application of patterns
- Premature abstraction
- Misunderstanding of OOP

**Problems:**
- Unnecessary indirection
- Harder to understand
- More classes to maintain
- No real value added

**Solution:**
- Remove middleman
- Merge functionality into caller or callee
- Only abstract when needed

---

### Boat Anchor

**Description:** Code kept around because it might be useful someday, but never is.

**Symptoms:**
- Unused methods and classes
- "Might need this later" comments
- Features no one asked for
- Over-engineered flexibility

**Why it happens:**
- Fear of deleting code
- Speculative generality (YAGNI violation)
- Not reviewing what's actually used

**Problems:**
- Clutters codebase
- Maintenance burden
- Confuses new developers
- Increases complexity

**Solution:**
- Delete unused code
- Trust version control
- Apply YAGNI strictly
- Review and prune regularly

---

### Dead End

**Description:** Class designed as extension point but can't be extended without major changes.

**Symptoms:**
- Private methods everywhere
- Final classes
- No hooks or callbacks
- Hard to subclass
- Violates OCP

**Why it happens:**
- Not designing for extension
- Excessive encapsulation
- Not anticipating variation points

**Problems:**
- Users can't customize
- Must modify original code
- Violates Open/Closed

**Solution:**
- Identify extension points
- Use Template Method or Strategy
- Make appropriate methods protected
- Design with inheritance in mind (or use composition)

---

### Magic Numbers/Strings

**Description:** Unexplained literal values scattered throughout code.

**Symptoms:**
- Numeric literals with no explanation
- Hard-coded strings
- Same value repeated in multiple places
- Can't tell what value represents

**Why it happens:**
- Quick and dirty coding
- Not refactoring
- Lack of constants

**Problems:**
- Hard to understand
- Error-prone to change
- Duplication
- No semantic meaning

**Solution:**
- Extract named constants
- Use enums for related values
- Centralize configuration
- Document meaning

**Example:**
```
❌ Magic numbers:
   if (status == 42) { ... }
   timeout = 3600
   price = amount * 1.08

✅ Named constants:
   if (status == STATUS_COMPLETED) { ... }
   timeout = ONE_HOUR_IN_SECONDS
   price = amount * TAX_RATE
```

---

### Copy-Paste Programming

**Description:** Copying existing code and modifying it instead of abstracting common functionality.

**Symptoms:**
- Nearly identical code in multiple places
- Same bugs in multiple locations
- Changes must be made in many places
- High duplication percentage

**Why it happens:**
- Laziness or time pressure
- Not understanding abstraction
- Fear of breaking existing code
- Lack of refactoring

**Problems:**
- Violates DRY
- Bug fixes must be repeated
- Inconsistency creeps in
- Hard to maintain

**Solution:**
- Extract common functionality
- Use functions, classes, or modules
- Apply Rule of Three (refactor on third duplication)
- Write reusable code from start

---

### Error Hiding (Catch-All)

**Description:** Catching all exceptions and ignoring or hiding them.

**Symptoms:**
- Empty catch blocks
- Generic exception catching
- Swallowing errors
- Returning null/default on error

**Why it happens:**
- Making errors "go away"
- Not knowing how to handle
- Lazy error handling
- Deadline pressure

**Problems:**
- Silent failures
- Hard to debug
- Corrupted state
- Lost error information

**Solution:**
- Handle specific exceptions only
- Log errors before swallowing
- Let exceptions propagate when appropriate
- Fail fast and loud

**Example:**
```
❌ Error hiding:
   try {
     riskyOperation()
   } catch (Exception e) {
     // Ignore
   }

✅ Proper handling:
   try {
     riskyOperation()
   } catch (SpecificException e) {
     log.error("Failed because: " + e.getMessage())
     throw new ApplicationException("Operation failed", e)
   }
```

---

### Premature Optimization

**Description:** Optimizing code before knowing if it's actually a bottleneck.

**Symptoms:**
- Complex, unreadable code for performance
- Micro-optimizations everywhere
- Trading clarity for speed
- No profiling data to justify

**Why it happens:**
- Assumptions about performance
- Fear of slowness
- Premature focus on efficiency
- "This might be slow" thinking

**Problems:**
- Harder to understand and maintain
- Wasted effort on non-bottlenecks
- May not actually be faster
- Prevents more important work

**Solution:**
- Make it work first
- Make it right second
- Make it fast third (if needed)
- Profile before optimizing
- Optimize only proven bottlenecks

**Famous quote:**
> "Premature optimization is the root of all evil" - Donald Knuth

---

### Sequential Coupling

**Description:** Methods must be called in specific order, but nothing enforces that order.

**Symptoms:**
- init() must be called before use
- Methods depend on previous calls
- State machine hidden in method calls
- Bugs from wrong call order

**Why it happens:**
- Multi-step initialization
- Poor encapsulation
- Stateful designs

**Problems:**
- Easy to misuse
- Hard to discover correct order
- Fragile
- Testing is complicated

**Solution:**
- Enforce order through types (Builder pattern)
- Make objects always valid (no init() needed)
- Use constructor for setup
- State machine pattern if truly needed

**Example:**
```
❌ Sequential coupling:
   connection = new Connection()
   connection.setHost("localhost")
   connection.setPort(5432)
   connection.connect()  // Must be called after setters

✅ Enforced order:
   connection = new ConnectionBuilder()
     .host("localhost")
     .port(5432)
     .build()  // Returns connected connection
```

---

## Database Anti-Patterns

### Database as IPC

**Description:** Using database as message queue or communication channel between processes.

**Symptoms:**
- Polling database for changes
- Status columns to coordinate processes
- Row-level locking for coordination
- Database as global state

**Why it happens:**
- Don't know about message queues
- Database already available
- Seems simple

**Problems:**
- Performance issues
- Polling overhead
- Not designed for this use case
- Better tools exist

**Solution:**
- Use message queue (RabbitMQ, Kafka, etc.)
- Use pub/sub pattern
- Use proper IPC mechanisms
- Reserve database for persistent storage

---

### God Table

**Description:** Table storing many different types of entities or attributes.

**Symptoms:**
- Many nullable columns
- Columns used differently for different entity types
- Generic names (data1, data2, value, attribute)
- Type column to distinguish entity types

**Why it happens:**
- Trying to be flexible
- Avoiding schema changes
- Misunderstanding normalization

**Problems:**
- Inefficient queries
- Confusing schema
- Integrity issues
- Can't use type-specific constraints

**Solution:**
- Separate tables for separate entities
- Proper normalization
- Use inheritance mappings if needed
- Specific schemas for specific data

---

### Implicit Columns

**Description:** Using column values to store metadata that should be explicit.

**Symptoms:**
- Encoding multiple values in one column
- Parsing column values
- Conventions instead of constraints
- Status encoded in combinations of values

**Why it happens:**
- Trying to save columns
- Schema evolution without migration
- Lack of database knowledge

**Problems:**
- Complex queries
- Can't enforce constraints
- Error-prone parsing
- Loss of type safety

**Solution:**
- One value per column
- Explicit columns for metadata
- Use proper data types
- Leverage database constraints

---

## Concurrency Anti-Patterns

### Race Condition

**Description:** Behavior depends on timing of uncontrollable events.

**Symptoms:**
- Bugs that happen randomly
- Works in development, fails in production
- Issues under load
- Non-deterministic failures

**Why it happens:**
- Shared mutable state
- Missing synchronization
- Assumptions about ordering

**Problems:**
- Hard to reproduce
- Intermittent failures
- Data corruption
- Frustrated developers and users

**Solution:**
- Proper synchronization (locks, mutexes)
- Immutable data structures
- Message passing instead of shared state
- Atomic operations

---

### Deadlock

**Description:** Two or more threads waiting on each other, none can proceed.

**Symptoms:**
- Application hangs
- Threads blocked indefinitely
- Can't reproduce consistently
- Requires process restart

**Why it happens:**
- Acquiring multiple locks
- Different lock order in different places
- Nested locks
- Not releasing locks

**Problems:**
- Complete halt of functionality
- Data locked indefinitely
- Wasted resources
- Hard to debug

**Solution:**
- Acquire locks in consistent order
- Use timeout on lock acquisition
- Avoid nested locks
- Use higher-level concurrency primitives
- Consider lock-free data structures

---

## Anti-Pattern Recognition During Brainstorming

### Warning Signs

When designing, watch for:

1. **"Just in case" thinking** → YAGNI violation
2. **"We might need flexibility for..."** → Premature abstraction
3. **"Let's make everything configurable"** → Swiss Army Knife
4. **"We always use [technology]"** → Golden Hammer
5. **"Let's do it like [other project]"** → Cargo Cult
6. **"It's better to have and not need..."** → Boat Anchor
7. **"Users can just call methods in order"** → Sequential Coupling
8. **"One class to handle it all"** → God Object

### Questions to Ask

**Simplicity check:**
- Is this the simplest solution that works?
- Are we over-engineering?
- Can we remove any moving parts?

**Responsibility check:**
- Does each component have clear, single responsibility?
- Are concerns properly separated?
- Any God Objects forming?

**Flexibility check:**
- Do we actually need this flexibility?
- Is this future-proofing or over-engineering?
- What variation do we have NOW?

**Duplication check:**
- Is this duplication real or coincidental?
- Are we copying knowledge or just code?
- Should we abstract yet?

---

## Escaping Anti-Patterns

### Step 1: Recognize

- Use this reference to identify anti-patterns
- Watch for symptoms
- Be honest about current state

### Step 2: Analyze Impact

- How much pain is it causing?
- Will it get worse over time?
- Is it worth fixing now?

### Step 3: Plan Refactoring

- Identify target pattern or structure
- Create tests if missing
- Plan incremental improvements
- Don't try to fix everything at once

### Step 4: Refactor

- Make small, safe changes
- Keep tests passing
- Review and iterate
- Document why changes were made

### Step 5: Prevent Recurrence

- Share learnings with team
- Update guidelines
- Code review for anti-patterns
- Refactor early when patterns emerge

---

## Key Takeaway

**Anti-patterns are teaching opportunities.** Recognizing them helps you understand *why* certain designs fail and *what* makes good design. Use this knowledge to avoid pitfalls and guide architectural discussions toward better solutions.

When brainstorming, ask: **"Does this resemble any known anti-pattern?"** If yes, dig deeper before proceeding.
