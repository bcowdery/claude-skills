# Other Software Design Principles

This reference covers key design principles beyond SOLID: TDD, DRY, YAGNI, and related concepts. Use these to guide architectural decisions during brainstorming sessions.

---

## Test-Driven Development (TDD)

**Definition:** Write tests before writing the implementation code.

### The TDD Cycle (Red-Green-Refactor)

1. **Red**: Write a failing test that defines desired behavior
2. **Green**: Write minimal code to make the test pass
3. **Refactor**: Improve code while keeping tests green
4. **Repeat**: For next piece of functionality

### Core Principles

**Tests as specification:**
- Tests document intended behavior
- Tests define the interface before implementation
- Tests capture requirements in executable form

**Incremental development:**
- Work in small steps
- One test at a time
- Continuous validation

**Design feedback:**
- Hard-to-test code is poorly designed
- TDD encourages better architecture
- Forces thinking about testability upfront

### When to Apply TDD

**Good candidates for TDD:**
- ✅ Business logic with clear requirements
- ✅ Algorithms and data transformations
- ✅ Complex conditional logic
- ✅ APIs and public interfaces
- ✅ Bug fixes (write test that exposes bug, then fix)
- ✅ Refactoring (tests as safety net)

**Less suitable for TDD:**
- ❌ Exploratory/spike work (requirements unclear)
- ❌ UI layout and styling (visual, subjective)
- ❌ Integrations with external systems (test doubles complex)
- ❌ Performance optimization (need profiling, not tests)
- ❌ Simple CRUD operations (overhead > value)

### Benefits

- ✅ **Confidence**: Know your code works
- ✅ **Design**: Forces decoupling and testability
- ✅ **Documentation**: Tests show how to use code
- ✅ **Regression prevention**: Catch breaks early
- ✅ **Faster debugging**: Failures pinpoint issues
- ✅ **Fearless refactoring**: Tests catch mistakes

### Trade-offs

- ❌ **Time investment**: Writing tests takes time upfront
- ❌ **Learning curve**: Requires practice and discipline
- ❌ **Test maintenance**: Tests need updates when requirements change
- ❌ **Over-testing**: Can lead to brittle, over-specified tests
- ❌ **False confidence**: Bad tests give false positives

### Common Mistakes

**Testing implementation details:**
```
❌ WRONG: Testing internal methods, private state
✅ RIGHT: Testing public behavior, outcomes
```

**Writing tests after:**
```
❌ WRONG: Write code first, then add tests
✅ RIGHT: Write test first, it drives design
```

**Large test steps:**
```
❌ WRONG: Write complete feature then test
✅ RIGHT: Tiny increments, test each step
```

**Not refactoring:**
```
❌ WRONG: Get to green, move to next test
✅ RIGHT: Get to green, THEN refactor
```

**Testing frameworks instead of logic:**
```
❌ WRONG: Testing that database framework saves data
✅ RIGHT: Testing business rules around data
```

### Test Pyramid

```
        /\
       /  \  E2E (Few)
      /____\
     /      \
    / Integration \ (Some)
   /______________\
  /                \
 /   Unit Tests     \ (Many)
/____________________\
```

**Unit tests (many):**
- Test single units in isolation
- Fast, focused, abundant
- Foundation of test suite

**Integration tests (some):**
- Test units working together
- Slower, broader scope
- Verify components integrate correctly

**End-to-end tests (few):**
- Test complete user workflows
- Slowest, most brittle
- Critical paths only

### TDD Variants

**Classic TDD (Detroit School):**
- Test behavior through public interfaces
- Allow internal collaboration
- Minimal mocking

**Mockist TDD (London School):**
- Test units in complete isolation
- Mock all dependencies
- More coupling to implementation

### Key Insight

**TDD is a design discipline, not just testing.** The main value is not the tests themselves (though valuable), but the design improvements TDD forces.

---

## Don't Repeat Yourself (DRY)

**Definition:** Every piece of knowledge should have a single, unambiguous, authoritative representation within a system.

### What it Really Means

DRY is often misunderstood as "don't duplicate code." It's actually about not duplicating *knowledge* or *intent*.

**Not just about code duplication:**
- ❌ Same code in two places → might be coincidental
- ✅ Same knowledge in two places → definitely DRY violation

**About knowledge:**
- Business rules
- Algorithms
- Data structures
- Configuration
- Documentation

### Recognizing DRY Violations

**Code duplication:**
```
❌ VIOLATION:
   calculateShippingCost() { /* formula */ }
   displayShippingEstimate() { /* same formula */ }

Same knowledge (shipping formula) in two places
```

**Documentation duplication:**
```
❌ VIOLATION:
   - API docs describe validation rules
   - Code comments describe same rules
   - Validation code implements rules
   - User docs describe rules

Same knowledge in four places
```

**Data schema duplication:**
```
❌ VIOLATION:
   - Database schema defines User fields
   - ORM model defines User fields
   - API contract defines User fields
   - Frontend type defines User fields

Same knowledge in four places
```

### How to Apply DRY

1. **Extract to single location**: Put knowledge in one place
2. **Generate from source**: Derive representations from canonical source
3. **Share across boundaries**: APIs, config files, schemas
4. **Use code generation**: Generate boilerplate from specifications
5. **Centralize configuration**: Single source of truth for settings

### Example: Applying DRY

```
❌ BEFORE (WET - Write Everything Twice):
   class OrderService {
     createOrder(order) {
       if (!order.email) throw Error("Email required")
       if (!/@/.test(order.email)) throw Error("Invalid email")
       ...
     }
   }

   class UserService {
     createUser(user) {
       if (!user.email) throw Error("Email required")
       if (!/@/.test(user.email)) throw Error("Invalid email")
       ...
     }
   }

✅ AFTER (DRY):
   class EmailValidator {
     validate(email) {
       if (!email) throw Error("Email required")
       if (!/@/.test(email)) throw Error("Invalid email")
     }
   }

   // Both services use EmailValidator
```

### When NOT to DRY

**Coincidental duplication:**
```
✅ OK to duplicate:
   calculateTax() { return price * 0.08 }
   calculateDiscount() { return price * 0.08 }

Different concepts that happen to share formula NOW.
May diverge later (tax rate vs discount rate).
```

**Premature abstraction:**
```
❌ WRONG: Extract after seeing code twice
✅ RIGHT: Extract after third occurrence (Rule of Three)

Wait until you understand the true commonality
```

**Coupling concerns:**
```
❌ WRONG: Share code between unrelated domains to avoid duplication
✅ RIGHT: Allow duplication to maintain domain boundaries

Prefer duplication over wrong abstraction
```

**Performance critical:**
```
✅ OK to duplicate:
   Inline hot path code instead of function call
   Duplicate small helpers to avoid overhead
```

### Benefits

- ✅ **Single source of truth**: Changes happen in one place
- ✅ **Consistency**: Same logic everywhere
- ✅ **Maintainability**: Fix once, fixed everywhere
- ✅ **Clarity**: Intent explicit and centralized

### Trade-offs

- ❌ **Coupling**: Shared code creates dependencies
- ❌ **Over-abstraction**: Wrong abstraction worse than duplication
- ❌ **Premature**: Extracting too early can be costly
- ❌ **Complexity**: Shared code can become complicated to satisfy all needs

### Related Concepts

**Rule of Three:**
- First time: Write it
- Second time: Wince at duplication but tolerate
- Third time: Refactor and extract

**AHA Programming (Avoid Hasty Abstractions):**
- Prefer duplication over wrong abstraction
- Wait for patterns to emerge
- Optimize for change, not initial code reduction

### Key Insight

**Prefer duplication to the wrong abstraction.** If you're not sure whether duplication represents the same knowledge or coincidence, leave it duplicated until the pattern becomes clear.

---

## You Aren't Gonna Need It (YAGNI)

**Definition:** Don't implement functionality until you actually need it.

### Core Principle

Build what's needed NOW, not what you MIGHT need LATER.

**Focus on:**
- ✅ Current requirements
- ✅ Known use cases
- ✅ Actual problems

**Avoid:**
- ❌ Speculative features
- ❌ "What if..." scenarios
- ❌ Future-proofing for unknown futures

### Examples of YAGNI Violations

**Over-engineered flexibility:**
```
❌ VIOLATION:
   "Let's make it configurable so we can support
    multiple databases, even though we only use Postgres"

Build Postgres support. Add others when actually needed.
```

**Premature optimization:**
```
❌ VIOLATION:
   "Let's add caching, load balancing, and sharding
    before we have any users"

Build simple version. Optimize when you have real data.
```

**Speculative features:**
```
❌ VIOLATION:
   "Let's add support for multiple currencies
    even though we only operate in USD"

Add USD support. Add others when expanding internationally.
```

**Over-abstraction:**
```
❌ VIOLATION:
   "Let's create a plugin system so we can add features
    later, even though we don't know what features yet"

Build the features you need. Extract plugin system if pattern emerges.
```

### When to Apply YAGNI

**Almost always.** YAGNI is one of the most universally applicable principles.

**Especially important when:**
- Starting new projects (avoid over-engineering)
- Under time pressure (focus on essentials)
- Requirements are unclear (don't guess)
- Building MVPs or prototypes (prove value first)

### When NOT to Apply YAGNI

**Exception 1: Known upcoming requirement**
```
✅ OK to build:
   Feature is scheduled for next sprint
   Contract specifies requirement
   Legal/compliance mandates it
```

**Exception 2: Architectural foundation**
```
✅ OK to build:
   Core abstractions that are expensive to change later
   Security/auth infrastructure
   Data migration paths
   Database schema design
```

**Exception 3: High cost of change**
```
✅ OK to build:
   API contracts (breaking changes hurt users)
   Database schemas (migrations are expensive)
   Public interfaces (backward compatibility)
```

**Exception 4: Safety and correctness**
```
✅ OK to build:
   Input validation
   Error handling
   Logging/monitoring
   Security measures
```

### Benefits

- ✅ **Faster delivery**: Less code to write
- ✅ **Simpler codebase**: Less to understand and maintain
- ✅ **Lower cost**: Don't waste time on unused features
- ✅ **Better design**: Build based on real needs, not guesses
- ✅ **Easier to change**: Less code to refactor

### Trade-offs

- ❌ **Refactoring needed**: May need to restructure when requirements grow
- ❌ **Harder to change later**: Some decisions are expensive to reverse
- ❌ **Risk of technical debt**: Quick solutions may need rework
- ❌ **Tension with flexibility**: Too rigid for changing requirements

### YAGNI in Practice

**Instead of:**
```
❌ "Let's design a fully flexible system that can handle
    any possible future requirement"
```

**Do:**
```
✅ "Let's build what we need now with clean, simple code
    that will be easy to change when requirements evolve"
```

### Balancing YAGNI with Other Principles

**YAGNI vs. DRY:**
- DRY says eliminate duplication
- YAGNI says don't build what you don't need
- **Balance**: Extract commonality when you see it (Rule of Three), not before

**YAGNI vs. SOLID:**
- SOLID says design for flexibility
- YAGNI says don't over-engineer
- **Balance**: Apply SOLID where you have variability NOW, not where you MIGHT have it

**YAGNI vs. TDD:**
- TDD says write tests first
- YAGNI says don't build what you don't need
- **Balance**: Test what you're building, not speculative features

### Common Justifications (Red Flags)

🚩 **"We might need it later"**
- Then build it later

🚩 **"It's easy to add now"**
- It'll be easy to add later too

🚩 **"It would be cool to have"**
- Cool ≠ necessary

🚩 **"Everyone else does it this way"**
- Do you have the same needs?

🚩 **"Future-proofing"**
- Can't predict future accurately

🚩 **"Best practice"**
- Best practice FOR WHAT? Context matters.

### Key Insight

**The best code is the code you don't write.** Every line of code is a liability: it must be written, tested, debugged, maintained, and eventually changed or deleted. Minimize code by building only what you need.

---

## Related Principles

### KISS (Keep It Simple, Stupid)

**Definition:** Systems work best when kept simple rather than complex.

**Application:**
- Simplest solution that works
- Avoid unnecessary complexity
- Clear > clever
- Explicit > implicit

**Overlap with YAGNI:**
- YAGNI: Don't add features you don't need
- KISS: Make the features you do build simple

---

### Separation of Concerns (SoC)

**Definition:** Separate program into distinct sections, each addressing a separate concern.

**Examples:**
- MVC: Model, View, Controller
- Layers: Presentation, Business, Data
- Microservices: Separate services by domain

**Overlap with SRP:**
- SRP: Class has one reason to change
- SoC: System partitioned by concern
- SoC is architectural; SRP is class-level

---

### Law of Demeter (Principle of Least Knowledge)

**Definition:** Object should only talk to its immediate neighbors, not reach through them.

**The rule:**
- ❌ Don't: `object.getA().getB().getC().doSomething()`
- ✅ Do: `object.doSomething()`

**Why it matters:**
- Reduces coupling
- Hides implementation
- Easier to change internals

**Example:**
```
❌ WRONG:
   customer.getWallet().getMoney().getAmount()

✅ RIGHT:
   customer.getMoneyAmount()
```

---

### Composition Over Inheritance

**Definition:** Favor object composition over class inheritance.

**Why:**
- Inheritance is rigid and couples subclass to parent
- Composition is flexible and loosely coupled
- Easier to test, change, and understand

**When to use inheritance:**
- True "is-a" relationship
- Subclass will always behave as parent
- Shared implementation is substantial

**When to use composition:**
- "Has-a" or "uses-a" relationship
- Want to mix behaviors dynamically
- Need flexibility to change implementations

---

### Convention Over Configuration

**Definition:** Provide sensible defaults so configuration is only needed for non-standard scenarios.

**Benefits:**
- Less boilerplate
- Faster setup
- Consistent patterns

**Trade-off:**
- Less explicit (magic)
- Must learn conventions

**Example:**
```
❌ Configuration-heavy:
   db.setHost("localhost")
   db.setPort(5432)
   db.setUsername("user")
   db.setTable("users")

✅ Convention:
   db.connect()  // Defaults to localhost:5432, current user, inferred table
```

---

### Principle of Least Astonishment

**Definition:** Design should behave in a way that least surprises users.

**Application:**
- Follow established patterns
- Meet user expectations
- Avoid surprising behavior
- Make common cases easy

**Example:**
```
❌ SURPRISING:
   delete(user)  // Returns the deleted user

✅ EXPECTED:
   delete(user)  // Returns void or success boolean
```

---

## Applying Principles: A Balanced Approach

### Don't Be Dogmatic

**Principles are guidelines, not laws.**
- Context matters
- Balance competing concerns
- Pragmatism over purity
- Optimize for your situation

### Start Simple, Add Complexity When Needed

1. **Start**: Simple, straightforward code
2. **Pain emerges**: Duplication, rigidity, fragility
3. **Apply principle**: DRY, SOLID, patterns
4. **Reevaluate**: Did it help?

### Warning Signs

**Under-application:**
- Lots of duplication
- Hard to change code
- Bugs in multiple places
- Tight coupling

**Over-application:**
- Too many abstractions
- Hard to understand code flow
- Lots of indirection
- Classes with no clear purpose

### The Goal

**Maintainable, understandable, changeable code.**

Not:
- Most patterns
- Most abstractions
- Most adherence to principles
- Fewest lines of code

But:
- Easy to understand
- Easy to change
- Easy to test
- Solves the actual problem

---

## Principle Priority During Brainstorming

When designing architecture, consider principles in this order:

### 1. YAGNI (First filter)
**Question:** Do we actually need this?
- Eliminates speculative complexity
- Keeps scope focused

### 2. KISS (Design approach)
**Question:** What's the simplest solution?
- Drives toward minimal complexity
- Baseline for comparison

### 3. SRP (Structure)
**Question:** What are the responsibilities?
- Defines component boundaries
- Identifies cohesion

### 4. DRY (Duplication check)
**Question:** Is there duplicated knowledge?
- After structure is clear
- Only for true knowledge duplication

### 5. SOLID (Flexibility)
**Question:** Where do we need flexibility?
- Apply to variation points
- Don't over-abstract

### 6. TDD (Validation)
**Question:** How will we know it works?
- Ensures testability
- Validates design choices

---

## Key Takeaway

**All principles aim for the same goal: code that's easy to change.**

- **TDD**: Gives confidence to change
- **DRY**: Changes happen in one place
- **YAGNI**: Less code to change
- **SOLID**: Isolates changes
- **KISS**: Changes are simpler

When principles conflict, ask: **"Which choice makes future changes easier?"**
