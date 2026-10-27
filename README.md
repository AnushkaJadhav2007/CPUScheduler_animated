#  MINION CPU ARENA — Interactive Round Robin Scheduling Simulator

A desktop application designed for college Operating Systems mini-projects and demonstrations. **Minion CPU Arena** visualizes CPU process scheduling as an educational game using custom Java2D vector animations and Java Swing.

---

## 🌟 Key Features

1. **Deterministic Round Robin Engine**:
   - Independent pure-Java scheduling engine completely separated from GUI code.
   - Handles process arrivals during execution, arrivals exactly at quantum boundaries, early process completions (without wasting unused quantum), and CPU idle intervals.
   - Deterministic tie-breaking: new arrivals at time $t$ enter the ready queue *before* preempted processes are re-enqueued.
   - Rigorously verified with 55 automated regression and edge-case unit tests.

2. **Game-Inspired Visual CPU Arena (100% Vector Java2D)**:
   - **Central Cartoon CPU**: Metal chassis with gold contact pins, glowing holographic reactor core, and real-time LED marquee status display.
   - **Procedural Minion Characters**: Yellow capsule bodies, denim overalls, goggles, expressive eyes, and chest badges displaying `PID` and `Remaining BT`. 
   - **Zero External Assets**: All graphics are procedurally rendered with anti-aliased Java2D paths and gradients. Guaranteed to run on any machine without missing `.png` image errors.
   - **Animated Conveyor Belt**: Visual FIFO ready queue with hazard stripes moving into the CPU.
   - **Celebration Lounge**: Completed Minions celebrate with party hats and confetti.

3. **Gantt Chart Timeline**:
   - Real-time colored horizontal timeline showing exact process intervals $[t_{start}, t_{end}]$.
   - Hatched diagonal stripes for CPU `IDLE` periods.
   - Precise numeric boundary time stamps ($0, 1, 2, ...$).

4. **Results Table & Performance Analytics**:
   - JTable listing: Process ID, Arrival Time (AT), Burst Time (BT), Completion Time (CT), Turnaround Time (TAT), and Waiting Time (WT).
   - Live KPI summary cards:
     - **Average Turnaround Time ($\bar{TAT}$)**: $\frac{\sum TAT}{N}$
     - **Average Waiting Time ($\bar{WT}$)**: $\frac{\sum WT}{N}$
     - **CPU Utilization**: $\frac{\text{Busy Time}}{\text{Total Time}} \times 100\%$
   - Labeled as **Provisional** during simulation and **Final Verified Results** upon completion.

5. **Modern 3D Interactive Controls**:
   - **Start / Play (▶)**: Vibrant emerald green with subtle 3D highlight and drop shadow.
   - **Pause (⏸)**: Deep royal blue with high-contrast cyan border and white text.
   - **Resume (▶)**: Bright cyan/teal, visually distinct from Pause.
   - **Single Step (⏭)**: Electric purple button for stepping through each time tick ($t \to t+1$).
   - **Reset (↺)**: Coral red accent button restoring initial state cleanly.
   - **Add Process (+)**: Bright sky cyan button with high readability.
   - **Secondary Actions**: Sleek slate "Remove Selected" and ruby red "Clear All" with distinct borders.
   - **Tactile Click Feedback**: Subtle 1px depression upon click, top specular highlight, and hover illumination.
   - **Speed Slider**: Controls animation rate from 150ms/tick (fast) to 1500ms/tick (slow-motion).

6. **Interactive Process Setup & Presets**:
   - Add custom processes with PID, Arrival Time ($\ge 0$), and Burst Time ($> 0$).
   - User-defined Time Quantum ($q \ge 1$).
   - Input validation alerts with user-friendly error dialogs.
   - 5 Built-in Presets:
     1. *Official College Regression Test* ($P1: 0/5, P2: 1/3, P3: 2/1, Q=2$)
     2. *Idle Gap Demo* ($P1: 2/3, P2: 7/2, Q=2$)
     3. *Simultaneous Arrivals at $t=0$* ($P1-P4, Q=2$)
     4. *Heavy Preemption Stress* ($Q=1$)
     5. *Large Quantum / FCFS Comparison* ($Q=8$)

---

## 🏗️ Project Architecture & Design

The project strictly follows the **Model-View-Controller (MVC)** architectural pattern:

```text
MinionCPUArena/
├── src/
│   ├── model/
│   │   ├── ProcessModel.java        # Process entity (PID, AT, BT, CT, TAT, WT, Theme)
│   │   ├── GanttBlock.java          # Continuous time interval (PID/IDLE, start, end)
│   │   └── SimulationMetrics.java   # Aggregated performance statistics
│   │
│   ├── engine/
│   │   ├── RoundRobinScheduler.java # Pure algorithm engine (zero GUI dependencies)
│   │   └── SimulationState.java     # Immutable snapshot of the system at time tick t
│   │
│   ├── ui/
│   │   ├── MainWindow.java          # Master JFrame (laptop-optimized: 1260x740)
│   │   ├── ArenaCanvas.java         # Animated Java2D arena (CPU, conveyor, minions)
│   │   ├── MinionDrawer.java        # Procedural vector artist for Minions
│   │   ├── Modern3DButton.java      # Reusable modern 3D tactile button component
│   │   ├── GanttChartPanel.java     # Visual horizontal Gantt chart
│   │   ├── ResultsTablePanel.java   # JTable and KPI cards
│   │   ├── ProcessInputPanel.java   # Presets, Quantum, and Add/Remove forms
│   │   └── ControlPanel.java        # Buttons (Play, Pause, Step, Reset) & Speed slider
│   │
│   ├── controller/
│   │   └── SimulationController.java# Orchestrates Engine, Swing Timer & GUI on EDT
│   │
│   ├── test/
│   │   ├── RoundRobinSchedulerTest.java # 55 automated unit & regression tests
│   │   ├── ButtonInteractiveTest.java   # Button rendering & state verification
│   │   └── GuiSmokeTest.java            # Offscreen Java2D smoke test
│   │
│   └── Main.java                    # Application entry point
├── bin/                             # Compiled bytecode (.class)
├── run.bat                          # One-click Windows runner
├── run_tests.bat                    # One-click test suite runner
└── README.md                        # Documentation
```

---

## 📊 Data Structures Used & Rationale

| Data Structure | Implementation | Why Chosen |
| :--- | :--- | :--- |
| **FIFO Ready Queue** | `java.util.ArrayDeque<ProcessModel>` | Round Robin requires strict First-In-First-Out ordering. `ArrayDeque` delivers optimal $O(1)$ amortized `offer()` and `poll()` with low memory overhead. |
| **Process Registry** | `java.util.ArrayList<ProcessModel>` | Provides $O(1)$ indexed access for `JTable` rendering, dynamic addition/removal, and cloning for simulation resets. |
| **Gantt History** | `java.util.ArrayList<GanttBlock>` | Chronologically records execution blocks, enabling continuous timeline painting and automatic adjacent slice merging. |
| **Incoming Pool** | `java.util.List<ProcessModel>` | Sorted primarily by Arrival Time ($AT$) and secondarily by insertion index to guarantee deterministic tie-breaking. |

---

## 🧮 Mathematical Formulas & Tie-Breaking Rules

1. **Turnaround Time (TAT)**:
   $$\text{TAT} = \text{Completion Time (CT)} - \text{Arrival Time (AT)}$$
2. **Waiting Time (WT)**:
   $$\text{WT} = \text{Turnaround Time (TAT)} - \text{Burst Time (BT)}$$
3. **Response Time (RT)**:
   $$\text{RT} = \text{Time CPU First Allocated} - \text{Arrival Time (AT)}$$
4. **CPU Utilization**:
   $$\text{CPU Utilization} = \left(\frac{\text{Total Busy Time}}{\text{Total Elapsed Time}}\right) \times 100\%$$
5. **Tie-Breaking Rule at Quantum Expiration**:
   When a running process finishes its time slice at time $t$ and has remaining burst time $> 0$:
   - Any processes arriving at or before time $t$ are admitted to the Ready Queue **first**.
   - The preempted process is appended to the tail of the Ready Queue **after** the new arrivals.

---

## 🧪 Verification & Regression Test

The application has been verified against the official college regression test:
* **Inputs**: $P1 (AT=0, BT=5)$, $P2 (AT=1, BT=3)$, $P3 (AT=2, BT=1)$, $\text{Quantum} = 2$.
* **Gantt Intervals**:
  * $P1: [0, 2]$
  * $P2: [2, 4]$
  * $P3: [4, 5]$ *(Early completion, quantum not wasted!)*
  * $P1: [5, 7]$
  * $P2: [7, 8]$
  * $P1: [8, 9]$
* **Results**:
  * $P1$: $\text{CT} = 9$, $\text{TAT} = 9$, $\text{WT} = 4$
  * $P2$: $\text{CT} = 8$, $\text{TAT} = 7$, $\text{WT} = 4$
  * $P3$: $\text{CT} = 5$, $\text{TAT} = 3$, $\text{WT} = 2$
  * $\text{Average TAT} = \frac{9 + 7 + 3}{3} = \mathbf{6.33}$
  * $\text{Average WT} = \frac{4 + 4 + 2}{3} = \mathbf{3.33}$
  * $\text{CPU Utilization} = \mathbf{100.0\%}$

---

## 🚀 How to Run

### Method 1: Double-Click (Windows)
Double-click **`run.bat`** to start the application directly.

### Method 2: Command Line (PowerShell / Command Prompt)
1. Open PowerShell or Command Prompt in the `MinionCPUArena` directory:
2. Compile:
   ```cmd
   javac -d bin src\model\*.java src\engine\*.java src\ui\*.java src\controller\*.java src\test\*.java src\Main.java
   ```
3. Run the GUI:
   ```cmd
   java -cp bin Main
   ```
4. Run the Automated Tests:
   ```cmd
   java -cp bin test.RoundRobinSchedulerTest
   ```

### Method 3: Browser / GitHub Pages Web Simulator
Double-click **`index.html`** to run the complete animated simulator in any modern browser (Chrome, Edge, Firefox, Safari) offline without any build steps or web servers. You can also deploy this file directly to **GitHub Pages**.
