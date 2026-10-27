# Target Verification Script for CPU Arena Mascot
$ErrorActionPreference = 'Stop'

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " CPU ARENA MASCOT - TARGETED ACCEPTANCE VERIFICATION " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

$passed = 0
$total = 0

function Assert-Check($desc, $condition) {
    $script:total++
    if ($condition) {
        $script:passed++
        Write-Host "  [PASS] $desc" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $desc" -ForegroundColor Red
    }
}

$indexContent = [System.IO.File]::ReadAllText('index.html')
$resultsContent = [System.IO.File]::ReadAllText('results.html')

# 1. No banana emojis or banana symbols
$bananaEmoji = [char]0xD83C + [char]0xDF4C
$hasBananaEmoji = $indexContent.Contains($bananaEmoji) -or $resultsContent.Contains($bananaEmoji) -or ($indexContent -match 'banana') -or ($resultsContent -match 'banana')
Assert-Check "Zero banana emojis or banana symbols in interface" (-not $hasBananaEmoji)

# 2. No Preset Scenario dropdown
$hasPresetScenario = ($indexContent -match 'Preset Scenario')
Assert-Check "No 'Preset Scenario' dropdown or preset scenario options" (-not $hasPresetScenario)

# 3. Exactly one Time Quantum setting, on RR only
$hasQuantumRow = ($indexContent -match 'id="quantumRow"')
$quantumToggle = ($indexContent -match 'key === .rr. \? .flex. : .none.')
Assert-Check "Time Quantum input row exists with id='quantumRow'" $hasQuantumRow
Assert-Check "Time Quantum is strictly toggled (displayed ONLY on RR)" $quantumToggle

# 4. Equal character container sizes
$hasDash120 = ($indexContent -match '\.mascot-container-dashboard\s*\{[^}]*width:\s*120px[^}]*height:\s*120px')
$hasSim140 = ($indexContent -match '\.mascot-container-simulator\s*\{[^}]*width:\s*140px[^}]*height:\s*140px')
Assert-Check "Dashboard mascot container is strictly 120x120px" $hasDash120
Assert-Check "Simulator mascot container is strictly 140x140px" $hasSim140

# 5. Four Algorithms and Mascots
$hasDoraemon = ($indexContent -match 'Doraemon') -and ($indexContent -match 'fcfs')
$hasKirby = ($indexContent -match 'Kirby') -and ($indexContent -match 'sjf')
$hasPikachu = ($indexContent -match 'Pikachu') -and ($indexContent -match 'srtf')
$hasMinions = ($indexContent -match 'Minions') -and ($indexContent -match 'rr')
Assert-Check "FCFS with Doraemon configured" $hasDoraemon
Assert-Check "SJF with Kirby configured" $hasKirby
Assert-Check "SRTF with Pikachu configured" $hasPikachu
Assert-Check "RR with Minions configured" $hasMinions

# 6. Schedulers implementation
$hasFcfsSched = ($indexContent -match 'class FCFSScheduler')
$hasSjfSched = ($indexContent -match 'class SJFScheduler')
$hasSrtfSched = ($indexContent -match 'class SRTFScheduler')
$hasRrSched = ($indexContent -match 'class RoundRobinScheduler')
Assert-Check "FCFSScheduler class implemented" $hasFcfsSched
Assert-Check "SJFScheduler class implemented" $hasSjfSched
Assert-Check "SRTFScheduler class implemented" $hasSrtfSched
Assert-Check "RoundRobinScheduler class implemented" $hasRrSched

# 7. Exact Theory Texts
$fcfsTheory = "First Come, First Served (FCFS) is a non-preemptive CPU scheduling algorithm in which processes are executed in the order they arrive in the ready queue. Once a process gets the CPU, it continues until it finishes. FCFS is simple and easy to implement, but a long process can make shorter processes wait for a long time. This problem is called the convoy effect."
$sjfTheory = "Shortest Job First (SJF) is a non-preemptive CPU scheduling algorithm that selects the available process with the smallest burst time whenever the CPU becomes free. The selected process runs until completion. SJF can reduce average waiting time when burst times are known, but long processes may wait for a long time. It may also be difficult to predict exact burst times in real systems."
$srtfTheory = "Shortest Remaining Time First (SRTF) is a preemptive CPU scheduling algorithm in which the process with the smallest remaining execution time gets the CPU. If a new process arrives with a shorter remaining time than the running process, the CPU switches to the new process. SRTF can reduce average waiting time, but it requires frequent scheduling decisions and may cause long processes to starve."
$rrTheory = "Round Robin (RR) is a preemptive CPU scheduling algorithm in which each process gets the CPU for a fixed amount of time called the time quantum. The processes are maintained in a ready queue and are executed one after another in circular order. If a process finishes within its time quantum, it moves to the completed state; otherwise, it is preempted and placed at the end of the ready queue to wait for its next turn. Round Robin provides fair CPU access and good responsiveness, especially in time-sharing systems. However, a very small time quantum can cause excessive context switching, while a very large time quantum makes the algorithm behave more like First Come, First Served scheduling."

Assert-Check "FCFS exact theory text present" ($indexContent.Contains($fcfsTheory))
Assert-Check "SJF exact theory text present" ($indexContent.Contains($sjfTheory))
Assert-Check "SRTF exact theory text present" ($indexContent.Contains($srtfTheory))
Assert-Check "RR exact theory text present" ($indexContent.Contains($rrTheory))

# 8. Results Page & Table Columns
$hasViewTable = ($indexContent -match 'id="btnViewTable"')
$hasPidCol = ($indexContent -match 'Process ID')
$hasAtCol = ($indexContent -match 'Arrival Time \(AT\)')
$hasBtCol = ($indexContent -match 'Burst Time \(BT\)')
$hasCtCol = ($indexContent -match 'Completion Time \(CT\)')
$hasTatCol = ($indexContent -match 'Turnaround Time \(TAT\)')
$hasWtCol = ($indexContent -match 'Waiting Time \(WT\)')
Assert-Check "View Table navigation button exists" $hasViewTable
Assert-Check "Exact 6 columns present in table (PID, AT, BT, CT, TAT, WT)" ($hasPidCol -and $hasAtCol -and $hasBtCol -and $hasCtCol -and $hasTatCol -and $hasWtCol)

# 9. Interactive Quiz with 11 Curriculum Topics
$has11Questions = ($indexContent -match 'Completed \(\$\{\s*this\.questions\.length\s*\}\s*of\s*11\)') -or ($indexContent -match 'Grand CPU Architect \(11/11\)')
$hasFullFormsQ = ($indexContent -match 'full forms of the four primary CPU scheduling algorithms')
$hasPreemptiveQ = ($indexContent -match 'Preemptive and Non-Preemptive scheduling')
$hasTimeQuantumQ = ($indexContent -match 'role and significance of the Time Quantum')
$hasAtBtQ = ($indexContent -match 'Arrival Time \(AT\) and Burst Time \(BT\) denote')
$hasCtQ = ($indexContent -match 'Completion Time \(CT\) in CPU scheduling')
$hasTatQ = ($indexContent -match 'calculates Turnaround Time \(TAT\)')
$hasWtQ = ($indexContent -match 'Waiting Time \(WT\) calculated')
$hasGanttQ = ($indexContent -match 'Gantt Chart in CPU scheduling')
$hasStarvationQ = ($indexContent -match 'Process Starvation')
$hasConvoyQ = ($indexContent -match 'Convoy Effect')
$hasCpuUtilQ = ($indexContent -match 'CPU Utilization mathematically defined')

$allQuizTopics = $has11Questions -and $hasFullFormsQ -and $hasPreemptiveQ -and $hasTimeQuantumQ -and $hasAtBtQ -and $hasCtQ -and $hasTatQ -and $hasWtQ -and $hasGanttQ -and $hasStarvationQ -and $hasConvoyQ -and $hasCpuUtilQ
Assert-Check "Interactive Quiz covers all 11 required topics with 11 questions" $allQuizTopics

# 10. Dashboard and Home Navigation
$hasHomeDashboard = ($indexContent -match 'id="dashboardView"')
$hasBackToDashboard = ($indexContent -match 'id="btnBackToDashboard"')
Assert-Check "Home Dashboard view implemented" $hasHomeDashboard
Assert-Check "Back to Dashboard button implemented" $hasBackToDashboard

$resColor = if ($passed -eq $total) { "Green" } else { "Yellow" }
Write-Host " RESULT: $passed / $total Checks Passed" -ForegroundColor $resColor
Write-Host "=====================================================" -ForegroundColor Cyan
